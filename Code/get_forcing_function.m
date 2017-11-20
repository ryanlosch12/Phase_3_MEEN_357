function [ FF, ff_data ] = get_forcing_function(t, ff_data)
%GET_FORCING_FUNCTION
%   This function returns the right side of the differential equations 
%   for a particular model. After this function is called the differential
%   equation that will be used to plot the functions is complete.
%
%   Inputs:
%	t - time 
%	ff_data - a struct that contains data needed for the forcing function
%   Outputs:
%	FF - the forcing function for a particular model
%	ff_data - the dynamically updated struct.

[t, X, V] = ff_data.trajectory(ff_data.t_prev, ff_data.X_prev, (ff_data.t_out - ff_data.t_in) / ff_data.N,...
			       ff_data.t_in, ff_data.t_out, ff_data.V_in, ff_data.V_out, ff_data.car);

%driver
[R_f_d, R_r_d, dRdt_f_d, dRdt_r_d] = ff_data.roadway_d(ff_data.car.chassis.wheelbase/12, ff_data.X_enter_d, X, V);

%passenger not needed in this phase.
%[R_f_p, R_r_p, dRdt_f_p, dRdt_r_p] = ff_data.roadway_d(ff_data.car.chassis.wheelbase/12, ff_data.X_enter_p, X, V);

%Get data for the forcing function, C and K values
carWeight = ff_data.car.chassis.weight + ff_data.car.pilot.weight + ff_data.car.power_plant.weight;

frontWheelWeight = ff_data.car.wheel_front.weight;
rearWheelWeight = ff_data.car.wheel_rear.weight;
averageWheelWeight = (frontWheelWeight + rearWheelWeight) / 2;

frontWheelDamping = ff_data.car.wheel_front.c * 12; %convert to ft for all units
frontWheelStiffness = ff_data.car.wheel_front.k * 12;

rearWheelDamping = ff_data.car.wheel_rear.c * 12;
rearWheelStiffness = ff_data.car.wheel_rear.k * 12;

averageWheelDamping = (frontWheelDamping + rearWheelDamping) / 2;
averageWheelStiffness = (frontWheelStiffness + rearWheelStiffness) / 2;

%Get the suspension data
leverageRatioFront = get_leverage_ratio('front', ff_data.car);
leverageRatioRear = get_leverage_ratio('rear', ff_data.car);

suspensionFrontDamping = leverageRatioFront * ff_data.car.suspension_front.c * 12;
suspensionFrontStiffness = leverageRatioFront * ff_data.car.suspension_front.k * 12;

suspensionRearDamping = leverageRatioRear * ff_data.car.suspension_rear.c * 12;
suspensionRearStiffness = leverageRatioRear * ff_data.car.suspension_rear.k * 12;

averageStiffness = (suspensionFrontStiffness + suspensionRearStiffness) / 2;
averageDamping = (suspensionFrontDamping + suspensionRearDamping) / 2;

lf = get_cg(ff_data.car);
lr = (ff_data.car.chassis.wheelbase / 12) - lf;

%Now construct forcing function when data has been given.
if strcmp(ff_data.model,'quarter_car_1_DOF') == 1
	FF = (.25 * carWeight) - (averageDamping*dRdt_f_d) - (averageStiffness*R_f_d);
elseif strcmp(ff_data.model, 'quarter_car_2_DOF') == 1
	FF(1,1) = (.25 * carWeight);
	FF(2,1) = averageWheelWeight - (averageWheelDamping*dRdt_f_d) - (averageWheelStiffness*R_f_d);
elseif strcmp(ff_data.model, 'half_car_2_DOF') == 1
	FF(1,1) = (.5 *carWeight) - (suspensionFrontDamping*dRdt_f_d) - (suspensionRearDamping*dRdt_r_d)...
		  - (suspensionFrontStiffness*R_f_d) - (suspensionRearStiffness*R_r_d);

	FF(2,1) = (suspensionFrontDamping*lf*dRdt_f_d) - (suspensionRearDamping*lr*dRdt_r_d)...
		  + (suspensionFrontStiffness*lf*R_f_d) - (suspensionRearStiffness*lr*R_r_d);
elseif strcmp(ff_data.model, 'half_car_4_DOF') == 1
	FF(1,1) = (.5 * carWeight);
	FF(2,1) = 0;
	FF(3,1) = frontWheelWeight - (frontWheelDamping*dRdt_f_d) - (frontWheelStiffness*R_f_d);
	FF(4,1) = rearWheelWeight - (rearWheelDamping*dRdt_r_d) - (rearWheelStiffness*R_r_d);
else
	error('The model selected is not valid');
end

%update the values in the structure.
ff_data.t_prev = t;
ff_data.X_prev = X;
end

