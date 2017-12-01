function [ Jx ] = get_Jx(FSAE_Race_Car)
%GET_JX
%   Detailed explanation goes here

if ~isstruct(FSAE_Race_Car)
	error('The car that was input was not a FSAE_Race_Car');
end

massOfChassis = FSAE_Race_Car.chassis.weight / 32.174; %Divide weight by g to get mass.
massOfMotor = FSAE_Race_Car.power_plant.weight / 32.174;
massOfDriverLegs = (FSAE_Race_Car.pilot.weight * .4) / 32.174;
massOfDriverUpperBody = (FSAE_Race_Car.pilot.weight * .6) / 32.174;

%radius and lengths of Driver
radiusOfDriver = FSAE_Race_Car.pilot.girth / (2*pi);

torsoLength = FSAE_Race_Car.pilot.height * .4;

%Need to find the distance from the center of gravity
chassisDistance = FSAE_Race_Car.chassis.cg_Z;
motorDistance = FSAE_Race_Car.chassis.motor_Z;
legDistance = FSAE_Race_Car.chassis.seat_Z + radiusOfDriver; 
torsoDistance = FSAE_Race_Car.chassis.seat_Z + (radiusOfDriver*2) + (FSAE_Race_Car.pilot.height/5);

%calculate moment of inertias for each object.
radiusOfChassis = FSAE_Race_Car.chassis.diameter / 2;

inertiaOfChassis =  massOfChassis * ((radiusOfChassis^2));

radiusOfMotor = FSAE_Race_Car.power_plant.diameter / 2;
inertiaOfMotor = (2/5) * massOfMotor * radiusOfMotor^2;

inertiaOfLegs = (1/2) * massOfDriverLegs * ((radiusOfDriver^2));
inertiaOfUpperBody = (1/12) * massOfDriverUpperBody * ((3*radiusOfDriver^2) + torsoLength^2);

%Calculate the (I + md^2) terms
jFromChassis = (inertiaOfChassis + (massOfChassis * chassisDistance^2)) / 144;
jFromMotor = (inertiaOfMotor + (massOfMotor * motorDistance^2)) / 144;
jFromLegs = (inertiaOfLegs + (massOfDriverLegs * legDistance^2)) /144;
jFromTorso = (inertiaOfUpperBody + (massOfDriverUpperBody * torsoDistance^2)) / 144;

%Sum the terms
Jx = jFromChassis + jFromMotor + jFromLegs + jFromTorso;

end

