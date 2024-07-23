% Copyright MSVCLAB @ HNU
% Exp_data.xlsx documents the dynamic experiments of the MCM
% exp_dis.mat records the vibration source signals used in the experiment
% exp_vel.mat records the vibration velocity signals used in the experiment
%==========================================================================
clear
Exp = xlsread('Exp_data.xlsx');
t_11 = Exp(1:end,1)/1000; %Time, Unit: s
x_11 = Exp(1:end,2);      %Response motion, Unit: mm
t_12 = t_11;
x_12 = Exp(1:end,3);      %Base motion, Unit: mm
x_A = max(x_12);
t_13 = t_11;
x_13 = x_12-x_11;         %Relative motion, Unit: mm
%================================================
%Solving the motion equations by using the Runge-Kutta method
t_jl = 5;
f_t = 0:1/640:t_jl;      %Time(Theory), Unit: s
w0 = 9;                  %Resonant frequency, Unit: Hz
nn = 0.1;                %Damping ratio
f = [w0,nn];
tspan = [0 t_jl];
x10 = [0 0];
load exp_dis
load exp_vel
[t4,x4] = ode45(@(t,x) odelin_exp(t,x,f),tspan,x10);
%Interpolation
x_res = interp1(t4,x4(:,1),f_t);       %Response motion, Unit: mm
f_x = interp1((0:0.0001:t_jl),f_x,f_t);%Base motion, Unit: mm
x_re = f_x-x_res;                      %Relative motion, Unit: mm
%Theoretical results visualization
subplot(2,1,1)
plot(f_t,f_x,'k','LineWidth',1.5);
hold on
plot(f_t,x_res,'--b','LineWidth',2)
hold on
xlabel('Time(s)','FontSize',32);
ylabel('Displacement(mm)','FontSize',32);
legend('Base motion(theory)','Response motion(theory)');
set(gca,'FontSize',22);
subplot(2,1,2)
plot(f_t,f_x,'k','LineWidth',1.5);
hold on
plot(f_t,x_re,'--r','LineWidth',2);
hold on
xlabel('Time(s)','FontSize',32);
ylabel('Displacement(mm)','FontSize',32);
legend('Base motion(theory)','Relative motion(theory)');
set(gca,'FontSize',22);
%Experimental data visualization
figure(2)
subplot(2,1,1)
plot(t_12,x_12,'k','LineWidth',1.5);
hold on
plot(t_11,x_11,'--b','LineWidth',2)
hold on
xlabel('Time(s)','FontSize',32);
ylabel('Displacement(mm)','FontSize',32);
legend('Base motion(experiment)','Response motion(experiment)');
set(gca,'FontSize',22);
subplot(2,1,2)
plot(t_12,x_12,'k','LineWidth',1.5);
hold on
plot(t_13,x_13,'--r','LineWidth',2);
hold on
xlabel('Time(s)','FontSize',32);
ylabel('Displacement(mm)','FontSize',32);
legend('Base motion(experiment)','Relative motion(experiment)');
set(gca,'FontSize',22);
%Comparison of experimental results and theoretical calculations
figure(3)
n_exp = 640;%Sampling frequency (experiment)
t1_exp = t_11((length(t_11)-n_exp):end)-2.19844;
x1_exp = x_11((length(t_11)-n_exp):end);
t2_exp = t_12((length(t_11)-n_exp):end)-2.19844;
x2_exp = x_12((length(t_11)-n_exp):end);
t3_exp = t_13((length(t_11)-n_exp):end)-2.19844;
x3_exp = x_13((length(t_11)-n_exp):end);
n_sim = 640;%Sampling frequency (theory)
t1_sim = f_t(((t_jl-1)*n_sim+1):end)'-4;
x1_sim = x_res(((t_jl-1)*n_sim+1):end)';
t2_sim = f_t(((t_jl-1)*n_sim+1):end)'-4;
x2_sim = f_x(((t_jl-1)*n_sim+1):end)';
t3_sim = f_t(((t_jl-1)*n_sim+1):end)'-4;
x3_sim = x_re(((t_jl-1)*n_sim+1):end)';
subplot(2,1,1)
plot(t2_exp,x2_exp,'k');
hold on
plot(t3_sim,x3_sim,'--b','LineWidth',2)
hold on
plot(t3_exp,x3_exp,'--r','LineWidth',2);
hold on
xlabel('Time(s)','FontSize',32);
ylabel('Displacement(mm)','FontSize',32);
legend('Base motion(experiment)','Relative motion(theory)','Relative motion(experiment)');
set(gca,'FontSize',22);
subplot(2,1,2)
err_sim = (x2_exp-x3_sim)/max(x2_exp);
err_exp = (x2_exp-x3_exp)/max(x2_exp);
plot(t3_sim,err_sim*100,'--b','LineWidth',2);
hold on
plot(t3_exp,err_exp*100,'--r','LineWidth',2);
hold on
xlabel('Time(s)','FontSize',32);
ylabel('Error','FontSize',32);
ytickformat('percentage');
legend('Theory','Experiment');
set(gca,'FontSize',22);