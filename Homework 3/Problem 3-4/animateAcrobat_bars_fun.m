% Plot Cartpole
close all
model_params

time = solution.phase.time;
states = solution.phase.state;
controls = solution.phase.control;


pp_th1 = spline(time,states(:,1));
pp_th2 = spline(time,states(:,2));
pp_th3 = spline(time,states(:,3));
pp_dth1 = spline(time,states(:,4));
pp_dth2 = spline(time,states(:,5));
pp_dth3 = spline(time,states(:,6));
pp_u1 = spline(time,controls(:,1));
pp_u2 = spline(time,controls(:,2));

pp_states.th1 = pp_th1;
pp_states.th2 = pp_th2;
pp_states.th3 = pp_th3;
pp_states.dth1 = pp_dth1;
pp_states.dth2 = pp_dth2;
pp_states.dth3 = pp_dth3;
pp_controls.u1 = pp_u1;
pp_controls.u2 = pp_u2;







dt_sim = .01;
tf = time(end);
N_sim = tf/dt_sim;

t_new = (0:1/(N_sim-1):1)*tf;

filename = ['Acrobat_bars_fun' num2str(gamma) '.gif'];

figure;
for i = 1:1:length(t_new)
    
    th1_st = ppval(t_new(i),pp_states.th1);
    th2_st = ppval(t_new(i),pp_states.th2);
    th3_st = ppval(t_new(i),pp_states.th3);
    dth1_st = ppval(t_new(i),pp_states.dth1);
    dth2_st = ppval(t_new(i),pp_states.dth2);
    dth3_st = ppval(t_new(i),pp_states.dth3);
    l1 = 1;
    l2 = .8;
    l3 = .3;
    
    plot(0,l1+l2+l3,'ko','color','blue')
    hold on
    line([-2 2],[l1+l2+l3 l1+l2+l3],'color','black')
    axis([-5 5 -4 6])
    
    u_th1 = 0;
    u_th2 = 0;% set 0 for now, as control doesnt come in eqn for state.
    p_1 = J_1(m1,l1,th1_st,dth1_st,m2,l2,th2_st,dth2_st,m3,l3,th3_st,dth3_st,u_th1,u_th2,g);
    p_2 = J_2(m1,l1,th1_st,dth1_st,m2,l2,th2_st,dth2_st,m3,l3,th3_st,dth3_st,u_th1,u_th2,g);
    p_3 = J_3(m1,l1,th1_st,dth1_st,m2,l2,th2_st,dth2_st,m3,l3,th3_st,dth3_st,u_th1,u_th2,g);
    
    plot(p_1(1),p_1(2),'ko','color','blue')
    plot(p_2(1),p_2(2),'ko','color','blue')
    plot(p_3(1),p_3(2),'ko','color','blue')
    xlabel('X')
    ylabel('Y')
    %title(['Cost = t_f + ' num2str(gamma) ' \times U^2' ])
    %text(.5,2.5,['t = ' num2str(t_new(i))] )
    
    line([0 p_1(1)],[l1+l2+l3 p_1(2)])
    line([ p_1(1) p_2(1)],[p_1(2) p_2(2)])
    line([ p_2(1) p_3(1)],[p_2(2) p_3(2)])
    %p1 = [th1_st .5];
    %dp = [.5 .5];    
%     quiver(p1(1),p1(2),0,dp(2),0)
%     axis equal
    hold off
    
    

    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if i  == 1;
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',.01);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',.01);
    end
    
    pause(.1)
end


