function [ z0 ] = get_static_deflection(vibration_model, FSAE_Race_Car)
%
% GET_STATIC_DEFLECTION
%
% This function returns the static deflection for the 
% specified vibration_model on the specified car
%
% Inputs: 
%   vibration_model   is a string with addmissible values that includes
%                    'quarter_car_1_DOF' and 'quarter_car_2_DOF'
%   FSAE_Race_Car    is a struct containing data for the car and driver
%
% Output: 
%   z0               the static deflection of the car 
%
% What the static deflection is 
%   The static deflection is the initial condition of the car which can be calculated using the stiffness
%   of the springs and the weight of the car.

%   For the quarter car:
%   For 1 DOF z0 can be calculated by dividing the weight by the stiffness of the sprig found in the
%   get_stiffness_matrix function
%   For 2 DOF a linear system can be solved with matlab using the weight of the wheels and the stiffness matrix
%
%   For the half car:
%   The 2 DOF static deflection is calculated by using the weight of the chassis, power plant, and pilot and the
%   stiffness matrix.
%   The 2 DOF static deflection is calculated by using the stiffness matrix and the weight of the chassis, power
%   plant, and pilot along with the weights' of the fornt and rear wheel.
%   

%Test input values

if ~ischar(vibration_model) 
	error('Argument for the vibration_model was not a string');
end

if ~isstruct(FSAE_Race_Car)
	error('The car that was input was not a FSAE_Race_Car');
end

if nargin ~= 2
	error('There was not 2 inputs into the function');
end


K = get_stiffness_matrix(vibration_model, FSAE_Race_Car);
M = get_mass_matrix(vibration_model, FSAE_Race_Car);

% Displacement vector output is in units of ft or rad
if strcmp(vibration_model, 'quarter_car_1_DOF') 
    W = M * 32.174;
    
    z0 = W/K;
elseif strcmp(vibration_model, 'quarter_car_2_DOF') 
    W(1,1) = M(1,1) * 32.174;
    W(2,1) = M(2,2) * 32.174;
    
    z0 = K \ W;
elseif strcmp(vibration_model, 'half_car_2_DOF') 
    W(1,1) = M(1,1) * 32.174;
    W(2,1) = M(2,1) * 32.174;

    z0 = K \ W;
elseif strcmp(vibration_model, 'half_car_4_DOF') 
    W(1,1) = M(1,1) * 32.174;
    W(2,1) = 0;
    W(3,1) = M(3,3) * 32.174;
    W(4,1) = M(4,4) * 32.174;

    z0 = K \ W;
elseif strcmp(vibration_model, 'full_car_3_DOF')
    W(1,1) = M(1,1) * 32.174;
    W(2,1) = 0;
    W(3,1) = 0;

    z0 = K \ W;
elseif strcmp(vibration_model, 'full_car_7_DOF')
    W(1,1) = M(1,1) * 32.174;
    W(2,1) = 0;
    W(3,1) = 0;
    W(4,1) = M(4,4) * 32.174;
    W(5,1) = M(5,5) * 32.174;
    W(6,1) = M(6,6) * 32.174;
    W(7,1) = M(7,7) * 32.174;

    z0 = K \ W;
else
	error('Invalid string for vibration_model was input');
end

end

