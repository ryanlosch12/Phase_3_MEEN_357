%This is the data structure for the 2017 car.

%The following fields are common among all cars.

field46 = 'team';
field47 = 'year';
field48 = 'top_speed';
field49 = 't2top_speed';
field50 = 'pilot';
field51 = 'chassis';
field52 = 'power_plant';
field53 = 'suspension_front';
field54 = 'suspension_rear';
field55 = 'wheel_front';
field56 = 'wheel_rear';

%load the files to access the structs needed for the 2017 car.
driver_tom;
wheel_front_2017;
wheel_rear_2017;
chassis_2017;
motor_2017;
suspension_front_2017;
suspension_rear_2017;

%The following values pretain to the 2017 car.
value46 = 'Aggie Team';
value47 = 2017;
value48 = 80; %mph
value49 = (pi * 3)/acos((80-120)/80);
value50 = pilot;
value51 = chassis;
value52 = power_plant;
value53 = suspension_front;
value54 = suspension_rear;
value55 = wheel_front;
value56 = wheel_rear;

FSAE_Race_Car = struct(field46, value46, field47, value47, field48, value48, ...
		       field49, value49, field50, value50, field51, value51, ...
		       field52, value52, field53, value53, field54, value54, ...
		       field55, value55, field56, value56);
