%This is a struct file that contains the forcing function information needed to drive the cars.
%Each year will have 4 files with the difference being the model field

field57 = 't_prev';
field58 = 'X_prev';
field59 = 'car';
field60 = 'model';
field61 = 'trajectory';
field62 = 't_in';
field63 = 't_out';
field64 = 'V_in';
field65 = 'V_out';
field66 = 'N';
field67 = 'roadway_d';
field68 = 'X_enter_d';
field69 = 'roadway_p';
field70 = 'X_enter_p';

%Load data needed to input values for the struct
car_2016

carsPathway = @(t, X, h, t_in, t_out, V_in, V_out, FSAE_Race_Car)...
	trajectory(t, X, h, t_in, t_out, V_in, V_out, FSAE_Race_Car);

timeIn = 0;
timeOut = 1;
velocityIn = 60;
velocityOut = 60;
N = 2500;

pathD = @(wheelbase, X_enter, X, V)...
	tar_strip(wheelbase, X_enter, X, V);

pathP = @(wheelbase, X_enter, X, V)...
	tar_strip(wheelbase, X_enter, X, V);

%values to fill the fields

value57 = 0; 
value58 = 0;
value59 = FSAE_Race_Car;
value60 = 'full_car_7_DOF';
value61 = carsPathway;
value62 = timeIn;
value63 = timeOut;
value64 = velocityIn;
value65 = velocityOut;
value66 = N; 
value67 = pathD;
value68 = 1;
value69 = pathP;
value70 = 1.5;

ff_data = struct(field57, value57, field58, value58, field59, value59, field60, value60,...
		 field61, value61, field62, value62, field63, value63, field64, value64,...
		 field65, value65, field66, value66, field67, value67, field68, value68,...
		 field69, value69, field70, value70);


