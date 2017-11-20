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

dampingFrontSuspension = (leverageRatioFront * FSAE_Race_Car.suspension_front.c) *12;
dampingRearSuspension = (leverageRatioRear * FSAE_Race_Car.suspension_rear.c) * 12;

%Average the damping for the front and rear suspension
averageSuspensionDamping = ((dampingFrontSuspension + dampingRearSuspension) / 2); %to get in lb / (ft / s)

wheelFrontDamping = FSAE_Race_Car.wheel_front.c * 12;
wheelRearDamping = FSAE_Race_Car.wheel_rear.c * 12;

averageWheelDamping = ((wheelFrontDamping + wheelRearDamping) / 2); %unit lb / (ft / s)

% CG calculations
front_CG = get_cg(FSAE_Race_Car);
rear_CG = FSAE_Race_Car.chassis.wheelbase/12 - front_CG;

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
    C(1,1) = dampingFrontSuspension + dampingRearSuspension;
    C(1,2) = -dampingFrontSuspension * front_CG + dampingRearSuspension * rear_CG;
    C(2,1) = -dampingFrontSuspension * front_CG + dampingRearSuspension * rear_CG;
    C(2,2) = dampingFrontSuspension * (front_CG)^2 + dampingRearSuspension * (rear_CG)^2;
elseif strcmp(vibration_model, 'half_car_4_DOF') == 1
    C(1,1) = dampingFrontSuspension  + dampingRearSuspension; 
    C(1,2) = -dampingFrontSuspension * front_CG + dampingRearSuspension * rear_CG; 
    C(1,3) = -dampingFrontSuspension;
    C(1,4) = -dampingRearSuspension;
    C(2,1) = C(1,2); 
    C(2,2) = dampingFrontSuspension * (front_CG)^2 + dampingRearSuspension * (rear_CG)^2; 
    C(2,3) = dampingFrontSuspension * front_CG;
    C(2,4) = -dampingRearSuspension * rear_CG; 
    C(3,1) = C(1,3);
    C(3,2) = C(2,3);
    C(3,3) = dampingFrontSuspension + wheelFrontDamping; 
    C(3,4) = 0;
    C(4,1) = C(1,4);
    C(4,2) = C(2,4);
    C(4,3) = 0;
    C(4,4) = dampingRearSuspension  + wheelRearDamping; 
    
else
	error('Not a valid string to input for the vibration_model');
end

end

