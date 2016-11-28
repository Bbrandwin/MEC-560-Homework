function phaseout = acrobatContinuous(input)


th1_all   = input.phase.state(:,1);
th2_all  = input.phase.state(:,2);
th3_all  = input.phase.state(:,3);
dth1_all  = input.phase.state(:,4);
dth2_all = input.phase.state(:,5);
dth3_all = input.phase.state(:,6);
u_th1_all   = input.phase.control(:,1);
u_th2_all   = input.phase.control(:,2);

dq_all = get_dynamics(th1_all,th2_all,th3_all,dth1_all,dth2_all,dth3_all,u_th1_all,u_th2_all);


phaseout.dynamics  = dq_all;
phaseout.integrand = (u_th1_all.^2 + u_th2_all.^2);