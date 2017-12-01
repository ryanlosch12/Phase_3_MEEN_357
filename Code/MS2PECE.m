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
T(2) = T(1) + h;
for ii=1:dof
   X(1,ii) = X0(ii);
   V(1,ii) = V0(ii);
   A(1,ii) = A0(ii);
end

[f, D] = FN(T(1), D);

x_1p = X0 + h.*V0 + (h^2/2).*A0;
v_1p = V0 + h.*A0;
a_1p = M\(f - C*v_1p - K*x_1p);

%Maybe need to refine the interval? need to ask what the tolerance is.
%See in document that PE(CE)^m where m is supposed to be 2

for m = 1:2
	x_1p = X0 + (h/2).*(v_1p + V0 - (h^2/12).*(a_1p - A0));
	v_1p = V0 + (h/2).*(a_1p + A0);
	a_1p = M\(f - C*v_1p - K*x_1p);
end

%Assign 1st predicted value into vectors?
X(2,:) = x_1p;
V(2,:) = v_1p;
A(2,:) = a_1p;

for nn = 2:D.N-1
	T(nn+1) = T(nn) + h;

	[f, D] = FN(T(nn+1), D);

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

