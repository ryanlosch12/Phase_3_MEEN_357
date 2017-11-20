function [ cg ] = get_cg(FSAE_Race_Car)
%GET_CG 
%   This function returns the center of gravity from the front axel of the race
%   car in units of ft. It takes into account the motor, chassis and driver when
%   computing the center of gravity.
%
%   Inputs:
%	FSAE_Race_Car - This is a struct containing the particular cars data
%
%   Outputs:
%	cg - The center of gravity of the car in ft

if ~isstruct(FSAE_Race_Car)
	error('The car that was input was not a FSAE_Race_Car');
end

%Find the indpendent centers of gravity for the Chassis, Driver, and the Motor
chassisCenterOfGravity = FSAE_Race_Car.chassis.cg_X; %in
%chassisLength = FSAE_Race_Car.chassis.length; %in
chassisWeight = FSAE_Race_Car.chassis.weight; %lb 

motorCenterOfGravity = FSAE_Race_Car.chassis.motor_X; %in
%motorDiameter = FSAE_Race_Car.power_plant.diameter; %in
motorWeight = FSAE_Race_Car.power_plant.weight; %lb

driverCenteredLocation = FSAE_Race_Car.chassis.seat_X; %in
driverRadius = FSAE_Race_Car.pilot.girth / (2*pi); %in

%Driver legs 
legLength = FSAE_Race_Car.pilot.height * .6; %in
legWeight = FSAE_Race_Car.pilot.weight * .4; %lb

%Driver upper body
%upperBodyLength = driverRadius * 2; %in
upperBodyWeight = FSAE_Race_Car.pilot.weight * .6; %lb

totalWeight = chassisWeight + motorWeight + legWeight + upperBodyWeight;

%Weight will be acting in center of gravity of compenents need to find that for legs and torso of driver
legCenter = driverCenteredLocation - (legLength / 2); %in
%Driver centered will act center of torso ?? need to check on this

totalMoment = (chassisWeight * chassisCenterOfGravity) + (motorWeight * motorCenterOfGravity)...
	      + (legWeight * legCenter) + (upperBodyWeight * (driverCenteredLocation-driverRadius));

cg = (totalMoment / totalWeight) / 12; %convert from inches to feet





end
