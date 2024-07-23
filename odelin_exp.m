function dydt=odelin_exp(t,x,f)
load exp_dis
load exp_vel
f0 = f(1);    %Resonant frequency
w0 = 2*pi*f0;
nn = f(2);    %Damping ratio
n = floor(t/0.0001)+1;
dydt = zeros(2,1);
dydt(1) = x(2);
dydt(2) = w0*w0*(f_x(n)-x(1))+2*nn*w0*(f_xd(n)-x(2));
end