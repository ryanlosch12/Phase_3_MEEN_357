clc
clear all;
close all;

ff_2017_1;
D = ff_data;
FN = @(t,D)get_forcing_function(t,D);
X0 = get_static_deflection(D.model,D.car);
DOF = size(X0,1);
V0 = zeros(DOF,1);
A0 = zeros(DOF,1);
M = get_mass_matrix(D.model,D.car);
C = get_damping_matrix(D.model,D.car);
K = get_stiffness_matrix(D.model,D.car);
[T1,X1,V1,A1] = Newmark(X0,V0,A0,M,C,K,FN,D);

ff_2017_2;
D = ff_data;
FN = @(t,D)get_forcing_function(t,D);
X0 = get_static_deflection(D.model,D.car);
DOF = size(X0,1);
V0 = zeros(DOF,1);
A0 = zeros(DOF,1);
M = get_mass_matrix(D.model,D.car);
C = get_damping_matrix(D.model,D.car);
K = get_stiffness_matrix(D.model,D.car);
[T2,X2,V2,A2] = Newmark(X0,V0,A0,M,C,K,FN,D);

ff_2017_3;
D = ff_data;
FN = @(t,D)get_forcing_function(t,D);
X0 = get_static_deflection(D.model,D.car);
DOF = size(X0,1);
V0 = zeros(DOF,1);
A0 = zeros(DOF,1);
M = get_mass_matrix(D.model,D.car);
C = get_damping_matrix(D.model,D.car);
K = get_stiffness_matrix(D.model,D.car);
[T3,X3,V3,A3] = Newmark(X0,V0,A0,M,C,K,FN,D);

ff_2017_4;
D = ff_data;
FN = @(t,D)get_forcing_function(t,D);
X0 = get_static_deflection(D.model,D.car);
DOF = size(X0,1);
V0 = zeros(DOF,1);
A0 = zeros(DOF,1);
M = get_mass_matrix(D.model,D.car);
C = get_damping_matrix(D.model,D.car);
K = get_stiffness_matrix(D.model,D.car);
[T4,X4,V4,A4] = Newmark(X0,V0,A0,M,C,K,FN,D);

%Heave
figure(1)
subplot(3,1,1)
hold on
plot(T1,X1(:,1),'k')
plot(T2,X2(:,1),'r')
plot(T3,X3(:,1),'b')
plot(T4,X4(:,1),'g')
xlabel('Time (s)')
ylabel('Displacement (ft)')
title('Heave Displacement')
legend('1/4 Car 1 DOF','1/4 Car 2 DOF','1/2 Car 2 DOF','1/2 Car 4 DOF',...
'location','eastoutside')
hold off

subplot(3,1,2)
hold on
plot(T1,V1(:,1),'k')
plot(T2,V2(:,1),'r')
plot(T3,V3(:,1),'b')
plot(T4,V4(:,1),'g')
xlabel('Time (s)')
ylabel('Velocity (ft/s)')
title('Heave Velocity')
legend('1/4 Car 1 DOF','1/4 Car 2 DOF','1/2 Car 2 DOF','1/2 Car 4 DOF',...
'location','eastoutside')
hold off

subplot(3,1,3)
hold on
plot(T1,A1(:,1),'k')
plot(T2,A2(:,1),'r')
plot(T3,A3(:,1),'b')
plot(T4,A4(:,1),'g')
xlabel('Time (s)')
ylabel('Acceleration (ft/s/s)')
title('Heave Acceleration')
legend('1/4 Car 1 DOF','1/4 Car 2 DOF','1/2 Car 2 DOF','1/2 Car 4 DOF',...
'location','eastoutside')
hold off


%Pitch
figure(2)
Convert = 180/pi;
subplot(3,1,1)
hold on
plot(T3,X3(:,2)*Convert,'b')
plot(T4,X4(:,2)*Convert,'g')
xlabel('Time (s)')
ylabel('Displacement (Degrees)')
title('Pitch Displacement')
legend('1/2 Car 2 DOF','1/2 Car 4 DOF','location','eastoutside')
hold off

subplot(3,1,2)
hold on
plot(T3,V3(:,2)*Convert,'b')
plot(T4,V4(:,2)*Convert,'g')
xlabel('Time (s)')
ylabel('Velocity (Degrees/s)')
title('Pitch Velocity')
legend('1/2 Car 2 DOF','1/2 Car 4 DOF','location','eastoutside')
hold off

subplot(3,1,3)
hold on
plot(T3,A3(:,2)*Convert,'b')
plot(T4,A4(:,2)*Convert,'g')
xlabel('Time (s)')
ylabel('Acceleration (Degrees/s/s)')
title('Pitch Acceleration')
legend('1/2 Car 2 DOF','1/2 Car 4 DOF','location','eastoutside')
hold off

%Front Axle
figure(3)
subplot(3,1,1)
hold on
plot(T2,X2(:,2),'r')
plot(T4,X4(:,3),'g')
xlabel('Time (s)')
ylabel('Displacement (ft)')
title('Front Axle Displacement')
legend('1/4 Car 2 DOF','1/2 Car 4 DOF','location','eastoutside')
hold off

subplot(3,1,2)
hold on
plot(T2,V2(:,2),'r')
plot(T4,V4(:,3),'g')
xlabel('Time (s)')
ylabel('Velocity (ft/s)')
title('Front Axle Velocity')
legend('1/4 Car 2 DOF','1/2 Car 4 DOF','location','eastoutside')
hold off

subplot(3,1,3)
hold on
plot(T2,A2(:,2),'r')
plot(T4,A4(:,3),'g')
xlabel('Time (s)')
ylabel('Acceleration (ft/s/s)')
title('Front Axle Acceleration')
legend('1/4 Car 2 DOF','1/2 Car 4 DOF','location','eastoutside')
hold off

%Real Axle
figure(4)
subplot(3,1,1)
hold on
plot(T4,X4(:,4),'g')
xlabel('Time (s)')
ylabel('Displacement (ft)')
title('Rear Axle Displacement')
legend('1/2 Car 4 DOF','location','eastoutside')
hold off

subplot(3,1,2)
hold on
plot(T4,V4(:,4),'g')
xlabel('Time (s)')
ylabel('Velocity (ft/s)')
title('Rear Axle Velocity')
legend('1/2 Car 4 DOF','location','eastoutside')
hold off

subplot(3,1,3)
hold on
plot(T4,A4(:,4),'g')
xlabel('Time (s)')
ylabel('Acceleration (ft/s/s)')
title('Rear Axle Acceleration')
legend('1/2 Car 4 DOF','location','eastoutside')
hold off
