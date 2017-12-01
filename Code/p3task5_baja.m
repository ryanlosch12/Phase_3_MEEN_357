clc
clear all;
close all;

ff_baja_1;
D = ff_data;
FN = @(t,D)get_forcing_function(t,D);
X0 = get_static_deflection(D.model,D.car);
DOF = size(X0,1);
V0 = zeros(DOF,1);
A0 = zeros(DOF,1);
M = get_mass_matrix(D.model,D.car);
C = get_damping_matrix(D.model,D.car);
K = get_stiffness_matrix(D.model,D.car);
[T1,X1,V1,A1] = MS2PECE(X0,V0,A0,M,C,K,FN,D);

ff_baja_2;
D = ff_data;
FN = @(t,D)get_forcing_function(t,D);
X0 = get_static_deflection(D.model,D.car);
DOF = size(X0,1);
V0 = zeros(DOF,1);
A0 = zeros(DOF,1);
M = get_mass_matrix(D.model,D.car);
C = get_damping_matrix(D.model,D.car);
K = get_stiffness_matrix(D.model,D.car);
[T2,X2,V2,A2] = MS2PECE(X0,V0,A0,M,C,K,FN,D);

ff_baja_3;
D = ff_data;
FN = @(t,D)get_forcing_function(t,D);
X0 = get_static_deflection(D.model,D.car);
DOF = size(X0,1);
V0 = zeros(DOF,1);
A0 = zeros(DOF,1);
M = get_mass_matrix(D.model,D.car);
C = get_damping_matrix(D.model,D.car);
K = get_stiffness_matrix(D.model,D.car);
[T3,X3,V3,A3] = MS2PECE(X0,V0,A0,M,C,K,FN,D);

ff_baja_4;
D = ff_data;
FN = @(t,D)get_forcing_function(t,D);
X0 = get_static_deflection(D.model,D.car);
DOF = size(X0,1);
V0 = zeros(DOF,1);
A0 = zeros(DOF,1);
M = get_mass_matrix(D.model,D.car);
C = get_damping_matrix(D.model,D.car);
K = get_stiffness_matrix(D.model,D.car);
[T4,X4,V4,A4] = MS2PECE(X0,V0,A0,M,C,K,FN,D);

ff_baja_5;
D = ff_data;
FN = @(t,D)get_forcing_function(t,D);
X0 = get_static_deflection(D.model,D.car);
DOF = size(X0,1);
V0 = zeros(DOF,1);
A0 = zeros(DOF,1);
M = get_mass_matrix(D.model,D.car);
C = get_damping_matrix(D.model,D.car);
K = get_stiffness_matrix(D.model,D.car);
[T5,X5,V5,A5] = MS2PECE(X0,V0,A0,M,C,K,FN,D);

ff_baja_6;
D = ff_data;
FN = @(t,D)get_forcing_function(t,D);
X0 = get_static_deflection(D.model,D.car);
DOF = size(X0,1);
V0 = zeros(DOF,1);
A0 = zeros(DOF,1);
M = get_mass_matrix(D.model,D.car);
C = get_damping_matrix(D.model,D.car);
K = get_stiffness_matrix(D.model,D.car);
[T6,X6,V6,A6] = MS2PECE(X0,V0,A0,M,C,K,FN,D);

%Heave
figure(1)
subplot(3,1,1)
hold on
plot(T1,X1(:,1),'k')
plot(T2,X2(:,1),'r')
plot(T3,X3(:,1),'b')
plot(T4,X4(:,1),'g')
plot(T5,X5(:,1),'c')
plot(T6,X6(:,1),'m')
xlabel('Time (s)')
ylabel('Displacement (ft)')
title('Heave Displacement')
legend('1/4 Car 1 DOF','1/4 Car 2 DOF','1/2 Car 2 DOF','1/2 Car 4 DOF',...
'Full Car 3 DOF','Full Car 7 DOF','location','eastoutside')
hold off

subplot(3,1,2)
hold on
plot(T1,V1(:,1),'k')
plot(T2,V2(:,1),'r')
plot(T3,V3(:,1),'b')
plot(T4,V4(:,1),'g')
plot(T5,V5(:,1),'c')
plot(T6,V6(:,1),'m')
xlabel('Time (s)')
ylabel('Velocity (ft/s)')
title('Heave Velocity')
legend('1/4 Car 1 DOF','1/4 Car 2 DOF','1/2 Car 2 DOF','1/2 Car 4 DOF',...
'Full Car 3 DOF','Full Car 7 DOF','location','eastoutside')
hold off

subplot(3,1,3)
hold on
plot(T1,A1(:,1),'k')
plot(T2,A2(:,1),'r')
plot(T3,A3(:,1),'b')
plot(T4,A4(:,1),'g')
plot(T5,A5(:,1),'c')
plot(T6,A6(:,1),'m')
xlabel('Time (s)')
ylabel('Acceleration (ft/s/s)')
title('Heave Acceleration')
legend('1/4 Car 1 DOF','1/4 Car 2 DOF','1/2 Car 2 DOF','1/2 Car 4 DOF',...
'Full Car 3 DOF','Full Car 7 DOF','location','eastoutside')
hold off

%Pitch
figure(2)
Convert = 180/pi;
subplot(3,1,1)
hold on
plot(T3,X3(:,2)*Convert,'b')
plot(T4,X4(:,2)*Convert,'g')
plot(T5,X5(:,2)*Convert,'c')
plot(T6,X6(:,2)*Convert,'m')
xlabel('Time (s)')
ylabel('Displacement (Degrees)')
title('Pitch Displacement')
legend('1/2 Car 2 DOF','1/2 Car 4 DOF','Full Car 3 DOF','Full Car 7 DOF'...
,'location','eastoutside')
hold off

subplot(3,1,2)
hold on
plot(T3,V3(:,2)*Convert,'b')
plot(T4,V4(:,2)*Convert,'g')
plot(T5,V5(:,2)*Convert,'c')
plot(T6,V6(:,2)*Convert,'m')
xlabel('Time (s)')
ylabel('Velocity (Degrees/s)')
title('Pitch Velocity')
legend('1/2 Car 2 DOF','1/2 Car 4 DOF','Full Car 3 DOF','Full Car 7 DOF'...
,'location','eastoutside')
hold off

subplot(3,1,3)
hold on
plot(T3,A3(:,2)*Convert,'b')
plot(T4,A4(:,2)*Convert,'g')
plot(T5,A5(:,2)*Convert,'c')
plot(T6,A6(:,2)*Convert,'m')
xlabel('Time (s)')
ylabel('Acceleration (Degrees/s/s)')
title('Pitch Acceleration')
legend('1/2 Car 2 DOF','1/2 Car 4 DOF','Full Car 3 DOF','Full Car 7 DOF'...
,'location','eastoutside')
hold off

%Roll
figure(3)
subplot(3,1,1)
hold on
plot(T5,X5(:,3)*Convert,'c')
plot(T6,X6(:,3)*Convert,'m')
xlabel('Time (s)')
ylabel('Displacement (Degrees)')
title('Roll Displacement')
legend('Full Car 3 DOF','Full Car 7 DOF','location','eastoutside')
hold off

subplot(3,1,2)
hold on
plot(T5,V5(:,3)*Convert,'c')
plot(T6,V6(:,3)*Convert,'m')
xlabel('Time (s)')
ylabel('Velocity (Degrees/s)')
title('Roll Velocity')
legend('Full Car 3 DOF','Full Car 7 DOF','location','eastoutside')
hold off

subplot(3,1,3)
hold on
plot(T5,A5(:,3)*Convert,'c')
plot(T6,A6(:,3)*Convert,'m')
xlabel('Time (s)')
ylabel('Acceleration (Degrees/s/s)')
title('Roll Acceleration')
legend('Full Car 3 DOF','Full Car 7 DOF','location','eastoutside')
hold off

%Axle Plane
%Assemble Matrix
chassislength = (D.car.chassis.wheelbase)/12;
lf = get_cg(D.car);
lr = chassislength - lf;
L = lf + lr;

rf = (D.car.chassis.radius_f)/12;
rr = (D.car.chassis.radius_r)/12;
W = rf + rr;

Mat = [lr/(2*L) lr/(2*L) lf/(2*L) lf/(2*L);
    -1/(2*L) -1/(2*L) 1/(2*L) 1/(2*L);
    -1/(2*W) 1/(2*W) 1/(2*W) -1/(2*W);
    -rr/W rr/W -rf/W rf/W];

X6_Axle = Mat * (X6(:,4:7))';
X6_Axle = X6_Axle';

%Axle vs Chassis

figure(4)
%Heave
subplot(2,2,1)
hold on
plot(T6,X6_Axle(:,1),'r')
plot(T6,X6(:,1),'b')

%Pitch
subplot(2,2,2)
hold on
plot(T6,X6_Axle(:,2)*Convert,'r')
plot(T6,X6(:,2)*Convert,'b')

%Roll
subplot(2,2,3)
hold on
plot(T6,X6_Axle(:,3)*Convert,'r')
plot(T6,X6(:,3)*Convert,'b')

%Warp
subplot(2,2,4)
hold on
plot(T6,X6_Axle(:,4)*Convert,'r')