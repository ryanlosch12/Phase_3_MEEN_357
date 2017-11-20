%This is the data structure for the 2014 car.

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

%load the files to access the structs needed for the 2014 car.
driver_sally;
wheel_front_2014;
wheel_rear_2014;
chassis_2014;
motor_2014;
suspension_front_2014;
suspension_rear_2014;

%The following values pretain to the 2014 car.
value46 = 'Aggie Team';
value47 = 2014;
value48 = 62; %mph
value49 = (pi * 3.4)/acos((62-120)/62); 
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
