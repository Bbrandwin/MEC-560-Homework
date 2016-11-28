% Position of mass 1

q = [th1;th2;th3];
dq = [dth1;dth2;dth3];


% Position of mass 1
P_1 = [ l1/2*sin(th1);
    (l1+l2+l3-l1/2*cos(th1))];
% Position of joint 1
J_1 = [ l1*sin(th1);
    (l1+l2+l3-l1*cos(th1))];

% Position of mass 2
P_2 = [ (J_1(1,1) + l2/2*sin(th1 + th2));
    J_1(2,1) - l2/2*cos(th1+th2)];
%Position of joint 2
J_2 = [ (J_1(1,1) + l2*sin(th1 + th2));
    J_1(2,1) - l2*cos(th1+th2)];

%Position of mass 3
P_3 = [(J_2(1,1) + l3/2*sin(th1+th2+th3));
    (J_2(2,1) - l3/2*cos(th1+th2+th3))];

J_3 = [(J_2(1,1) + l3*sin(th1+th2+th3));
    (J_2(2,1) - l3*cos(th1+th2+th3))];


write_kin = 1;
if write_kin == 1;
    write_file(P_1,'P_1.m',vars); % Writing KE
    write_file(P_2,'P_2.m',vars); % Writing PE
    write_file(P_3,'P_3.m',vars); % Writing PE
    write_file(J_1,'J_1.m',vars); % Writing KE
    write_file(J_2,'J_2.m',vars); % Writing PE
    write_file(J_3,'J_3.m',vars); % Writing PE
end
