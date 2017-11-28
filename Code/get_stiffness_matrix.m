function [ K ] = get_stiffness_matrix(vibration_model, FSAE_Race_Car)
%
% GET_STIFFNESS_MATRIX
%
% This function returns the stiffness matrix for a specified vibration
% model of a specified race car.
%
% Inputs:
%   vibration_model  is a string with addmissible values that includes
%                    'quarter_car_1_DOF' and 'quarter_car_2_DOF'
%   FSAE_Race_Car    is a struct containing data for the car and driver
%
% Output:
%   K                the stiffness matrix
%
% What the stiffness matrix contains
%   For the quarter car model:
%   The stiffness for the suspension is just the leverage ratios
%   multiplied by the stiffness of the suspension for the front and rear
%   averaged together
%   The average wheel stiffness is the average of the stiffness for the
%   front and rear wheels
%
%   For the half car model:
%   These models can manage the different stiffnesses of the
%   front and rear suspension units and wheels. The distances from the
%   front and rear to the center of gravity are taken into account because
%   the center of gravtity is not in the geometric center of the car.
%
%

if ~ischar(vibration_model)
	error('Argument for the vibration_model was not a string');
end

if ~isstruct(FSAE_Race_Car)
	error('The car that was input was not a FSAE_Race_Car');
end

if nargin ~= 2
	error('There was not 2 inputs into the function');
end

leverageRatioFront = get_leverage_ratio('front', FSAE_Race_Car);
leverageRatioRear = get_leverage_ratio('rear', FSAE_Race_Car);

k1 = leverageRatioFront * FSAE_Race_Car.suspension_front.k * 12;
k2 = k1;
k3 = leverageRatioRear * FSAE_Race_Car.suspension_rear.k * 12;
k4 = k3;

wheelFrontStiffness = FSAE_Race_Car.wheel_front.k * 12;
wheelRearStiffness = FSAE_Race_Car.wheel_rear.k * 12;

chassisLength = (FSAE_Race_Car.chassis.wheelbase)/12;
lf = get_cg(FSAE_Race_Car);
lr = chassisLength - lf;

rf = FSAE_Race_Car.chassis.radius_f;
rr = FSAE_Race_Car.chassis.radius_r;

if strcmp(vibration_model, 'quarter_car_1_DOF') == 1
    averageSuspensionStiffness = ((stiffnessFrontSuspension + stiffnessRearSuspension) / 2) * 12; %units of lb/ft

    K = averageSuspensionStiffness;

elseif strcmp(vibration_model, 'quarter_car_2_DOF') == 1
    averageSuspensionStiffness = ((stiffnessFrontSuspension + stiffnessRearSuspension) / 2) * 12; %units of lb/ft
    averageWheelStiffness = ((wheelFrontStiffness + wheelRearStiffness) / 2) * 12; %units in lb / ft

		K(1,1) = averageSuspensionStiffness;
		K(1,2) = -averageSuspensionStiffness;
		K(2,1) = -averageSuspensionStiffness;
		K(2,2) = averageSuspensionStiffness + averageWheelStiffness;

% All outputs in units of lb/ft for linear spring stiffnesses and ft*lb/rad for angular spring stiffnesses
elseif strcmp(vibration_model, 'half_car_2_DOF') == 1
    K(1,1) = k1 + k3;
    K(1,2) = -k1 * lf + k3 * lr;
    K(2,1) = -(k1 * lf) + (k3 * lr);
    K(2,2) = (k1 * lf^2) + (k3 * lr^2);

% All outputs in units of lb/ft for linear spring stiffnesses and ft*lb/rad for angular spring stiffnesses
elseif strcmp(vibration_model, 'half_car_4_DOF') == 1
    K(1,1) = k1 + k3;
    K(1,2) = -(k1 * lf) + (k3 * lr);
    K(1,3) = -k1;
    K(1,4) = -k3;
    K(2,1) = -(k1 * lf) + (k3 * lr);
    K(2,2) = (k1 * lf^2) + (k3 * lr^2);
    K(2,3) = k1 * lf;
    K(2,4) = -(k3 * lr);
    K(3,1) = -k1;
    K(3,2) = k1 * lf;
    K(3,3) = k1 + wheelFrontStiffness;
    K(3,4) = 0;
    K(4,1) = -k3;
    K(4,2) = -(k3 * lr);
    K(4,3) = 0;
    K(4,4) = (k3 + wheelRearStiffness);
elseif strcmp(vibration_model, 'full_car_3_DOF')
		K(1,1) = k1 + k2 + k3 + k4;
		K(1,2) = -(k1+k2)*lf + (k3+k4)*lr;
		K(1,3) = -(k1-k2)*rf + (k3-k4)*rr;
		K(2,1) = K(1,2);
		K(2,2) = (k1+k2)*lf^2 + (k3+k4)*lr^2;
		K(2,3) = (k1-k2)*lf*rf + (k3-k4)*lr*rr;
		K(3,1) = -(k1-k2)*rf + (k3-k4)*rr;
		K(3,2) = K(2,3);
		K(3,3) = (k1+k2)*rf^2 + (k3+k4)*rr^2;
elseif strcmp(vibration_model, 'full_car_7_DOF')
		K(1,1) = k1 + k2 + k3 + k4;
		K(1,2) = -(k1+k2)*lf + (k3+k4)*lr;
		K(1,3) = -(k1-k2)*rf + (k3-k4)*rr;
		K(1,4) = -k1;
		K(1,5) = -k2;
		K(1,6) = -k3;
		K(1,7) = -k4;
		K(2,1) = K(1,2);
		K(2,2) = (k1+k2)*lf^2 + (k3+k4)*lr^2;
		K(2,3) = (k1-k2)*lf*rf + (k3-k4)*lr*rr;
		K(2,4) = k1*lf;
		K(2,5) = k2*lf;
		K(2,6) = -k3*lr;
		K(2,7) = -k4*lr;
		K(3,1) = -(k1-k2)*rf + (k3-k4)*rr;
		K(3,2) = K(2,3);
		K(3,3) = (k1+k2)*rf^2 + (k3+k3)*rr^2;
		K(3,4) = k1*rf;
		K(3,5) = -k2*rf;
		K(3,6) = -k3*rr;
		K(3,7) = k4*rr;
		K(4,1) = -k1;
		K(4,2) = k1*lf;
		K(4,3) = k1*rf;
		K(4,4) = k1 + wheelFrontStiffness;
		K(4,5) = 0;
		K(4,6) = 0;
		K(4,7) = 0;
		K(5,1) = -k2;
		K(5,2) = k2*lf;
		K(5,3) = -k3*rf;
		K(5,4) = 0;
		K(5,5) = k2 + wheelFrontStiffness;
		K(5,6) = 0;
		K(5,7) = 0;
		K(6,1) = -k3;
		K(6,2) = -k3*lr;
		K(6,3) = -k3*rr;
		K(6,4) = 0;
		K(6,5) = 0;
		K(6,6) = k3 + wheelRearStiffness;
		K(6,7) = 0;
		K(7,1) = -k4;
		K(7,2) = -k4*lr;
		K(7,3) = k4*rr;
		K(7,4) = 0;
		K(7,5) = 0;
		K(7,6) = 0;
		K(7,7) = k4 + wheelRearStiffness;
else
	error('Not a valid string to input');
end

end
