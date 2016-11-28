q_v = [th1;
    th2;
    th3];
dq_v = [dth1;
    dth2;
    dth3];

dq = get_vel(q_v,q_v,dq_v);


% Velocity of the mass 1
v_1 = get_vel(P_1,q_v,dq_v); 
v_1 = simplify(v_1);

KE_1 = 1/2*m1*(v_1.'*v_1) + 1/2*m1*l1^2*dth1^2;
PE_1 =  m1*g*P_1(2);

% Velocity of the mass 2
v_2 = get_vel(P_2,q_v,dq_v);
v_2 = simplify(v_2);

o_dist2 = P_2(1)^2 + P_2(2)^2;
KE_2 = 1/2*m2*(v_2.'*v_2) + 1/2*m2*l2^2*dth2^2 + 1/2*m2*o_dist2*dth1^2;
PE_2 =  m2*g*P_2(2);

% Velocity of the mass 3
v_3 = get_vel(P_3,q_v,dq_v);
v_3 = simplify(v_3);

o_dist3_1 = (P_1(1) - P_3(1))^2 + (P_1(2) - P_3(2))^2;
o_dist3_2 = P_3(1)^2 + P_3(2)^2;
KE_3 = 1/2*m3*(v_3.'*v_3)+ 1/2*m3*l3^2*dth3^2 + 1/2*m3*o_dist3_1*dth2^2 ...
    + 1/2*m3*o_dist3_2*dth1^2;
PE_3 =  m3*g*P_3(2);



KE_total = KE_1 + KE_2 + KE_3;
PE_total = PE_1 + PE_2 + PE_3;

[Mr,Cr,Gr] = get_mat(KE_total,PE_total,q_v,dq_v);
U = [u_th1;u_th2;0];

ff = U - Cr*dq_v - Gr;



write_kin = 1;
if write_kin == 1;
    write_file(ff,'ff_acrobat.m',vars); % Writing FF
    write_file(Mr,'M_acrobat.m',vars); % Writing M
    
    write_file(KE_total,'KE_acrobat.m',vars); % Writing KE
    write_file(PE_total,'PE_acrobat.m',vars); % Writing PE
end


