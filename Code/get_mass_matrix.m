function [ M ] = get_mass_matrix( vibration_model, FSAE_Race_Car )
%
% GET_MASS_MATRIX
%
% This function returns an appropriate mass matrix for the 
% specified vibration_model on the specified car
%
% Inputs: 
%   vibration_model   is a string with addmissible values that includes
%                    'quarter_car_1_DOF' and 'quarter_car_2_DOF'
%   FSAE_Race_Car    is a struct containing data for the car and driver
%
% Output: 
%   M               the mass matrix 
%
% What the mass matrix contains
%   The mass is the quarter of the mass of the pilot, chassis, and motor returned in slugs
%   The mass of the wheel is the mass of the front wheel averaged with the mass of the rear wheel
%
%   The mass of the half car contains the mass of the pilot, chassis, and
%   motor divided by 2. It also contains the moment of inertia for the half car. The 4 DOF
%   model also contains the mass of the front and back wheel converted to
%   slugs

% Test for valid inputs.

if ~ischar(vibration_model) 
	error('Argument for the vibration_model was not a string');
end

if ~isstruct(FSAE_Race_Car)
	error('The car that was input was not a FSAE_Race_Car');
end

if nargin ~= 2
	error('There was not 2 inputs into the function');
end

massOfPilot = FSAE_Race_Car.pilot.weight / 32.174; %gravity in ft/s^2, unit is lbf / ft*s^2 which is a slug.
massOfChassis = FSAE_Race_Car.chassis.weight / 32.174;
massOfMotor = FSAE_Race_Car.power_plant.weight / 32.174;
quarterMass = .25 * (massOfPilot + massOfChassis + massOfMotor);

%Average of the front and rear wheels and then divide by gravity in order to get the mass.
massOfOneWheel = ((FSAE_Race_Car.wheel_front.weight + FSAE_Race_Car.wheel_rear.weight) / 2) / 32.174; % times gravity to put in units of slugs

momentOfInertia = get_Jy(FSAE_Race_Car);
% Outpus mass matrix in units of slugs
if strcmp(vibration_model, 'quarter_car_1_DOF') == 1
	%mass of the wheel assembly is not included in matrix.
	M = quarterMass;

elseif strcmp(vibration_model, 'quarter_car_2_DOF') == 1
	%mass of the wheel assembly needs to be added to the mass matrix
	M(1,1) = quarterMass;
	M(2,2) = massOfOneWheel;
elseif strcmp(vibration_model, 'half_car_2_DOF') == 1
    M(1,1) = 2 * quarterMass;
    M(2,2) = momentOfInertia/2;

elseif strcmp(vibration_model, 'half_car_4_DOF') == 1
    M(1,1) = 2 * quarterMass;
    M(2,2) = momentOfInertia/2; 
    M(3,3) = FSAE_Race_Car.wheel_front.weight/32.174; %converts to slugs
    M(4,4) = FSAE_Race_Car.wheel_rear.weight/32.174; %converts to slugs
else
	error('The input string was not valid');
end

end
