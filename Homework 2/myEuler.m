function [ t, x ] = myEuler(sys, dt, Tspan, x0)
%Euler Difference solver

x = zeros(length(x0), Tspan/dt);
x(:,1) = x0;
t = zeros(1, Tspan/dt);

k = 1;

for i = 0:dt:Tspan-dt
    t(:,k+1) = i + dt;
    x(:,k+1) = x(:,k) + dt*sys(t(:,k),x(:,k));
    k = k+1;
end;




end

