function [ Jy ] = get_Jy(FSAE_Race_Car)
%GET_JY
%   This function returns the moment of inertia of the particular
%   race car. The motor, chassis, and driver are taken into account
%   and the parallel axis theorem is used to calculate the moment
%   of inertia.
%
%   Inputs:
%	FSAE_Race_Car - The data struct for the particular car.
%
%   Outputs:
%	Jy - The moment of inertia of the particular race car.

if ~isstruct(FSAE_Race_Car)
	error('The car that was input was not a FSAE_Race_Car');
end

centerOfGravity = get_cg(FSAE_Race_Car) * 12; %convert to inches

massOfChassis = FSAE_Race_Car.chassis.weight / 32.174; %Divide weight by g to get mass.
massOfMotor = FSAE_Race_Car.power_plant.weight / 32.174;
massOfDriverLegs = (FSAE_Race_Car.pilot.weight * .4) / 32.174;
massOfDriverUpperBody = (FSAE_Race_Car.pilot.weight * .6) / 32.174;

%radius and lengths of Driver
radiusOfDriver = FSAE_Race_Car.pilot.girth / (2*pi);
legLength = FSAE_Race_Car.pilot.height * .6;
torsoLength = FSAE_Race_Car.pilot.height * .4;

%Need to find the distance from the center of gravity
chassisDistance = centerOfGravity - FSAE_Race_Car.chassis.cg_X;
motorDistance = centerOfGravity - FSAE_Race_Car.chassis.motor_X;
legDistance = centerOfGravity - (FSAE_Race_Car.chassis.seat_X - (legLength / 2)); 
torsoDistance = centerOfGravity - (FSAE_Race_Car.chassis.seat_X - radiusOfDriver);

%calculate moment of inertias for each object.
radiusOfChassis = FSAE_Race_Car.chassis.diameter / 2;
lengthOfChassis = FSAE_Race_Car.chassis.length;
inertiaOfChassis = (1/12) * massOfChassis * ((6*radiusOfChassis^2) + lengthOfChassis^2);

radiusOfMotor = FSAE_Race_Car.power_plant.diameter / 2;
inertiaOfMotor = (2/5) * massOfMotor * radiusOfMotor^2;

inertiaOfLegs = (1/12) * massOfDriverLegs * ((3*radiusOfDriver^2) + legLength^2);
inertiaOfUpperBody = (1/12) * massOfDriverUpperBody * ((3*radiusOfDriver^2) + torsoLength^2);

%Calculate the (I + md^2) terms
jFromChassis = (inertiaOfChassis + (massOfChassis * chassisDistance^2)) / 144;
jFromMotor = (inertiaOfMotor + (massOfMotor * motorDistance^2)) / 144;
jFromLegs = (inertiaOfLegs + (massOfDriverLegs * legDistance^2)) / 144;
jFromTorso = (inertiaOfUpperBody + (massOfDriverUpperBody * torsoDistance^2)) / 144;

%Sum the terms
Jy = jFromChassis + jFromMotor + jFromLegs + jFromTorso;


end

