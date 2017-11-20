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

stiffnessFrontSuspension = leverageRatioFront * FSAE_Race_Car.suspension_front.k;
stiffnessRearSuspension = leverageRatioRear * FSAE_Race_Car.suspension_rear.k;

wheelFrontStiffness = FSAE_Race_Car.wheel_front.k;
wheelRearStiffness = FSAE_Race_Car.wheel_rear.k;

chassisLength = (FSAE_Race_Car.chassis.wheelbase)/12;
front_CG = get_cg(FSAE_Race_Car);
rear_CG = chassisLength - front_CG;


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
    K(1,1) = (stiffnessFrontSuspension + stiffnessRearSuspension)*12;
    K(1,2) = (-(stiffnessFrontSuspension * front_CG) + (stiffnessRearSuspension * rear_CG))*12;
    K(2,1) = (-(stiffnessFrontSuspension * front_CG) + (stiffnessRearSuspension * rear_CG))*12;
    K(2,2) = ((stiffnessFrontSuspension * (front_CG^2)) + (stiffnessRearSuspension * (rear_CG^2)))*12;

% All outputs in units of lb/ft for linear spring stiffnesses and ft*lb/rad for angular spring stiffnesses
elseif strcmp(vibration_model, 'half_car_4_DOF') == 1
    K(1,1) = (stiffnessFrontSuspension + stiffnessRearSuspension)*12;
    K(1,2) = (-(stiffnessFrontSuspension * front_CG) + (stiffnessRearSuspension * rear_CG))*12;
    K(1,3) = (-stiffnessFrontSuspension)*12;
    K(1,4) = (-stiffnessRearSuspension)*12;
    K(2,1) = (-(stiffnessFrontSuspension * front_CG) + (stiffnessRearSuspension * rear_CG))*12;
    K(2,2) = ((stiffnessFrontSuspension * (front_CG^2)) + (stiffnessRearSuspension * (rear_CG^2)))*12;
    K(2,3) = (stiffnessFrontSuspension * front_CG)*12;
    K(2,4) = (-(stiffnessRearSuspension * rear_CG))*12;
    K(3,1) = (-stiffnessFrontSuspension)*12;
    K(3,2) = (stiffnessFrontSuspension * front_CG)*12;
    K(3,3) = (stiffnessFrontSuspension + wheelFrontStiffness)*12;
    K(3,4) = 0;
    K(4,1) = (-stiffnessRearSuspension)*12;
    K(4,2) = (-(stiffnessRearSuspension * rear_CG))*12;
    K(4,3) = 0;
    K(4,4) = (stiffnessRearSuspension + wheelRearStiffness)*12;
    
else
	error('Not a valid string to input');
end

end


