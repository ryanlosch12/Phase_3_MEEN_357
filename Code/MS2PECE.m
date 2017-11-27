function [ T, X, V, A ] = MS2PECE(X0, V0, A0, M, C, K, FN, D)
%MS2PECE
%   Detailed explanation goes here

dof = size(X0, 1);

h = (D.t_out - D.t_in)/D.N;

T = zeros(D.N+1,1);
X = zeros(D.N+1,dof);
V = zeros(D.N+1,dof);
A = zeros(D.N+1,dof);

% Assign initial conditions to the output fields.
T(1) = D.t_in;
for ii=1:dof
   X(1,ii) = X0(ii);
   V(1,ii) = V0(ii);
   A(1,ii) = A0(ii);
end

for n = 1:dof
	x_1p(n,1) = X0(n) + h*V0(n) + (h^2/2)*A0(n);
	v_1p(n,1) = V0(n) + h*A0(n);
end

a_1p = inv(M) * (FN(D.t_in, D) - C*v_1p - K*x_1p);

%Maybe need to refine the interval? need to ask what the tolerance is.

%while tol > .1
%	x_1 = X(1,1) + (h/2)*()
%end

for i = 1:D.N
	T(i+1) = T(i) + h;

	
end

