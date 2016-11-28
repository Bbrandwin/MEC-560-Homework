function dq_all = get_dynamics(th1_all,th2_all,th3_all,dth1_all,dth2_all,dth3_all,u_th1_all,u_th2_all)


model_params;

for i = 1:length(th1_all);
    
    th1_d = th1_all(i);    
    th2_d = th2_all(i);    
    th3_d = th3_all(i);    
    dth1_d = dth1_all(i);
    dth2_d = dth2_all(i);
    dth3_d = dth3_all(i);
    u_th1_d = u_th1_all(i);
    u_th2_d = u_th2_all(i);

    ff = ff_acrobat(m1,l1,th1_d,dth1_d, ...
    m2,l2,th2_d,dth2_d, ...
    m3,l3,th3_d,dth3_d, ...
    u_th1_d,u_th2_d,g);

    M = M_acrobat(m1,l1,th1_d,dth1_d, ...
    m2,l2,th2_d,dth2_d, ...
    m3,l3,th3_d,dth3_d, ...
    u_th1_d,u_th2_d,g);


    ddq = M\ff;
    
    dq_all(i,:) = [dth1_d dth2_d dth3_d ddq'];
end