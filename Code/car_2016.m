%This is the data structure for the 2016 car.

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

%load the files to access the structs needed for the 2016 car.
driver_harry;
wheel_front_2016;
wheel_rear_2016;
chassis_2016;
motor_2016;
suspension_front_2016;
suspension_rear_2016;

%The following values pretain to the 2016 car.
value46 = 'Aggie Team';
value47 = 2016;
value48 = 175; %mph
value49 = (pi * 2.1)/acos((175-120)/175);
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
