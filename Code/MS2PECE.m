function [ T, X, V, A ] = MS2PECE(X0, V0, A0, M, C, K, FN, D)
%
% MS2PECE
%
% Implements MS2PECE solver for integrating the second-order ODE
%
%       d^2{x}       d{x}
%   [M] ------ + [C] ---- + [K]{x} = {FF}(t,D)
%        dt^2         dt
%
% whose passed parameters are:
%   X0  is a vector containing the initial condition for displacement
%   V0  is a vector containing the initial condition for velocity
%       needed if more than 1 trajectory is to be imposed, size DOFx1
%   A0  is a vector containing the initial condition for acceleration 
%       needed if more than 1 trajectory is to be imposed, size DOFx1
%   M   is a mass matrix
%   C   is a damping matrix
%   K   is a stiffness matrix 
%   FN  is a handle to an arbitrary forcing function with an interface of
%          function [FF,D] = someForcingFunction(t,D)
%       that can be called by
%          [FF,D] = FN(t,D)
%       whose returned vector FF has the same dimension as X and
%       whose data structure D contains data needed to solve FN for FF
%   D   is a data structure needed to solve FN(t,D)
%
% The lower limit of integration comes from D.t_in.
% The upper limit of integration comes from D.t_out.
% The number of integration steps come from D.N.
%
% Vector X0 is a column vector of size 'DOF'.
% Matrices M, C and K are square and symmetric of size 'DOFxDOF'. 
% 'DOF' is the dimension of the problem: the degrees of freedom.
%
% The returned fields contain a vector and three matrices
%   T   is a vector of times at solution    of dimension  D.N+1
%   X   is a vector of position vectors     of dimension (D.N+1)xDOF
%   V   is a vector of velocity vectors     of dimension (D.N+1)xDOF
%   A   is a vector of acceleration vectors of dimension (D.N+1)xDOF
%

% Check the inputs for admissibility.

if ~isstruct(D)
   Error('D, the forcing function data structure, must be a struct.');
end
if D.t_out <= D.t_in
   Error('The final time TN must be greater than the initial time T0.');
end
if D.N < 1
   Error('The number of integration steps must exceed zero.');
end
dof = size(X0,1);
if size(V0,1) ~= dof
   Error('The length of vectors X0 and V0 must be the same.');
end
if size(A0,1) ~= dof
   Error('The length of vectors X0, V0 and A0 must be the same.');
end
[rows, cols] = size(M);
if (rows ~= dof) || (cols ~= dof)
   Error('The mass matrix must have dimension DOFxDOF.');
end
[rows, cols] = size(C);
if (rows ~= dof) || (cols ~= dof)
   Error('The damping matrix must have dimension DOFxDOF.');
end
[rows, cols] = size(K);
if (rows ~= dof) || (cols ~= dof)
   Error('The stiffness matrix must have dimension DOFxDOF.');
end

dof = size(X0, 1);

h = (D.t_out - D.t_in)/D.N;

T = zeros(D.N+1,1);
X = zeros(D.N+1,dof);
V = zeros(D.N+1,dof);
A = zeros(D.N+1,dof);

% Assign initial conditions to the output fields.
T(1) = D.t_in;
T(2) = T(1) + h;
for ii=1:dof
   X(1,ii) = X0(ii);
   V(1,ii) = V0(ii);
   A(1,ii) = A0(ii);
end

[f, D] = FN(T(1), D);

%Predict
x_1p = X0 + h.*V0 + (h^2/2).*A0;
v_1p = V0 + h.*A0;

%Evaluate
a_1p = M\(f - C*v_1p - K*x_1p);

for m = 1:2
	%Correct
	x_1p = X0 + (h/2).*(v_1p + V0 - (h^2/12).*(a_1p - A0));
	v_1p = V0 + (h/2).*(a_1p + A0);

	%Evaluate
	a_1p = M\(f - C*v_1p - K*x_1p);
end

%Assign 1st predicted value into vectors?
X(2,:) = transpose(x_1p);
V(2,:) = transpose(v_1p);
A(2,:) = transpose(a_1p);

for nn = 2:D.N
	T(nn+1) = T(nn) + h;

	[f, D] = FN(T(nn), D);

	%predict
	x_p = (1/3).*(4.*X(nn,:) - X(nn-1,:)) + (h/6).*(3.*V(nn,:) - V(nn-1,:)) + (h^2/36).*(31.*A(nn,:) - A(nn-1,:));
	v_p = (1/3).*(4.*V(nn,:) - V(nn-1,:)) + (2*h/3).*(2.*A(nn,:) - A(nn-1,:));
	a_p = transpose(M\(f - C*transpose(v_p) - K*transpose(x_p)));

	%Correct the predictions
	for mm = 1:2
		x_p = (1/3).*(4.*X(nn,:) - X(nn-1,:)) + (h/24).*(v_p + 14.*V(nn,:) + V(nn-1, :)) + (h^2/72).*(10.*a_p + 51.*A(nn,:) - A(nn-1,:));
		v_p = (1/3).*(4.*V(nn,:) - V(nn-1,:)) + (2*h/3).*a_p;
		a_p = transpose(M\(f - C*transpose(v_p) - K*transpose(x_p)));
	end

	%update the vectors to prepare for next step
	X(nn+1,:) = x_p;
	V(nn+1,:) = v_p;
	A(nn+1,:) = a_p;
	
end

