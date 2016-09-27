function [t, x] = myRungeKutta4(sys, dt, Tspan, x0)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
x = zeros(length(x0), Tspan/dt);
x(:,1) = x0;
t = zeros(1, Tspan/dt);

k = 1;

for i = 0:dt:Tspan-dt
    t(:,k+1) = i + dt;
    c1 = sys(t(:,k),x(:,k));
    c2 = sys(t(:,k)+dt/2, x(:,k) + c1*dt/2);
    c3 = sys(t(:,k)+dt/2, x(:,k) + c2*dt/2);
    c4 = sys(t(:,k)+dt, x(:,k) + c3*dt);
    
    x(:,k+1)= x(:,k) + (c1 + 2*c2 + 2*c3 + c4)*dt/6;
    
    k = k+1;
end
    

end

