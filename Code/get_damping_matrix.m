function [ C ] = get_damping_matrix(vibration_model, FSAE_Race_Car)
%
% GET_DAMPING_MATRIX
%
% This function returns the damping matrix for a specified vibration of a
% specified race car.
%
% Inputs:
%   vibration_model  is a string with addmissible values that includes
%                    'quarter_car_1_DOF' and 'quarter_car_2_DOF'
%   FSAE_Race_Car    is a struct containing data for the car and driver
%
% Output:
%   C                the damping matrix
%
% What the damping matrix contains
%   For the quarter car model:
%   The damping for the suspension is just the leverage ratios
%   multiplied by the damping coefficient of the suspension for the front
%   and rear averaged together
%   The average wheel damping is the average of the damping for the front
%   and rear wheels
%
%   For the half car model:
%   These models can manage the different damping coefficients of the
%   front and rear suspension units and wheels. The distances from the
%   front and rear to the center of gravity are taken into account because
%   the center of gravtity is not in the geometric center of the car.
%
%

% Test for valid input
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

c1 = (leverageRatioFront * FSAE_Race_Car.suspension_front.c) *12;
c2 = c1;
c3 = (leverageRatioRear * FSAE_Race_Car.suspension_rear.c) * 12;
c4 = c3;

%Average the damping for the front and rear suspension
averageSuspensionDamping = ((c1 + c3) / 2); %to get in lb / (ft / s)

wheelFrontDamping = FSAE_Race_Car.wheel_front.c * 12;
wheelRearDamping = FSAE_Race_Car.wheel_rear.c * 12;

averageWheelDamping = ((wheelFrontDamping + wheelRearDamping) / 2); %unit lb / (ft / s)

% CG calculations Y axis
lf = get_cg(FSAE_Race_Car);
lr = FSAE_Race_Car.chassis.wheelbase/12 - lf;

rf = FSAE_Race_Car.chassis.radius_f;
rr = FSAE_Race_Car.chassis.radius_r;

% Outputs in units of lb / (ft/s^2) for linear damers and ft * lb / (rad/s) for angular
% dampers
if strcmp(vibration_model, 'quarter_car_1_DOF') == 1
	C = averageSuspensionDamping;
elseif strcmp(vibration_model, 'quarter_car_2_DOF') == 1
	C(1,1) = averageSuspensionDamping;
	C(1,2) = -averageSuspensionDamping;
	C(2,1) = -averageSuspensionDamping;
	C(2,2) = averageSuspensionDamping + averageWheelDamping; %Wheel damping 0 in 1 DOF systems
elseif strcmp(vibration_model, 'half_car_2_DOF') == 1
    C(1,1) = c1 + c3;
    C(1,2) = -c1 * lf + c3 * lr;
    C(2,1) = -c1 * lf + c3 * lr;
    C(2,2) = c1 * (lf)^2 + c3 * (lr)^2;
elseif strcmp(vibration_model, 'half_car_4_DOF') == 1
    C(1,1) = c1  + c3;
    C(1,2) = -c1 * lf + c3 * lr;
    C(1,3) = -c1;
    C(1,4) = -c3;
    C(2,1) = C(1,2);
    C(2,2) = c1 * (lf)^2 + c3 * (lr)^2;
    C(2,3) = c1 * lf;
    C(2,4) = -c3 * lr;
    C(3,1) = C(1,3);
    C(3,2) = C(2,3);
    C(3,3) = c1 + wheelFrontDamping;
    C(3,4) = 0;
    C(4,1) = C(1,4);
    C(4,2) = C(2,4);
    C(4,3) = 0;
    C(4,4) = c3  + wheelRearDamping;
elseif strcmp(vibration_model, 'full_car_3_DOF')
    C(1,1) = c1 + c2 + c3 + c4;
    C(1,2) = -(c1+c2)*lf + (c3+c4)*lr;
    C(1,3) = -(c1-c2)*rf + (c3-c4)*rr;
    C(2,1) = C(1,2);
    C(2,2) = (c1+c2)*lf^2 + (c3+c4)*lr^2;
    C(2,3) = (c1-c2)*lf*rf + (c3-c4)*lr*rr;
    C(3,1) = -(c1-c2)*rf + (c3-c4)*rr;
    C(3,2) = C(2,3);
    C(3,3) = (c1+c2)*rf^2 + (c3+c3)*rr^2;
elseif strcmp(vibration_model, 'full_car_7_DOF')
    C(1,1) = c1 + c2 + c3 + c4;
    C(1,2) = -(c1+c2)*lf + (c3+c4)*lr;
    C(1,3) = -(c1-c2)*rf + (c3-c4)*rr;
    C(1,4) = -c1;
    C(1,5) = -c2;
    C(1,6) = -c3;
    C(1,7) = -c4;
    C(2,1) = C(1,2);
    C(2,2) = (c1+c2)*lf^2 + (c3+c4)*lr^2;
    C(2,3) = (c1-c2)*lf*rf + (c3-c4)*lr*rr;
    C(2,4) = c1*lf;
    C(2,5) = c2*lf;
    C(2,6) = -c3*lr;
    C(2,7) = -c4*lr;
    C(3,1) = -(c1-c2)*rf + (c3-c4)*rr;
    C(3,2) = C(2,3);
    C(3,3) = (c1+c2)*rf^2 + (c3+c3)*rr^2;
    C(3,4) = c1*rf;
    C(3,5) = -c2*rf;
    C(3,6) = -c3*rr;
    C(3,7) = c4*rr;
    C(4,1) = -c1;
    C(4,2) = c1*lf;
    C(4,3) = c1*rf;
    C(4,4) = c1 + wheelFrontDamping;
    C(4,5) = 0;
    C(4,6) = 0;
    C(4,7) = 0;
    C(5,1) = -c2;
    C(5,2) = c2*lf;
    C(5,3) = -c3*rf;
    C(5,4) = 0;
    C(5,5) = c2 + wheelFrontDamping;
    C(5,6) = 0;
    C(5,7) = 0;
    C(6,1) = -c3;
    C(6,2) = -c3*lr;
    C(6,3) = -c3*rr;
    C(6,4) = 0;
    C(6,5) = 0;
    C(6,6) = c3 + wheelRearDamping;
    C(6,7) = 0;
    C(7,1) = -c4;
    C(7,2) = -c4*lr;
    C(7,3) = c4*rr;
    C(7,4) = 0;
    C(7,5) = 0;
    C(7,6) = 0;
    C(7,7) = c4 + wheelRearDamping;
else
	error('Not a valid string to input for the vibration_model');
end

end
