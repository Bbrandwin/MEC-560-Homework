time = t_track(end);

dt = time/1000;
t = 0:dt:time;

A_2 = [0 1 0 0 0 0 0;
    0 0 exp(-5*dt) 0 0 0 0;
    0 0 -5 0 0 0 0;
    0 0 0 0 1 0 0;
    0 0 0 0 0 exp(-5*dt) 0;
    0 0 0 0 0 -5 0
    0 0 0 0 0 0 -5];
B_2 = [0 0;((1-exp(-5*dt))/5) 0; 1 0;0 0;0 ((1-exp(-5*dt))/5); 0 1;.4 .4];
C_2 = [1 0 0 0 0 0 0;
    0 1 0 0 0 0 0;
    0 0 0 1 0 0 0;
    0 0 0 0 1 0 0;
    0 0 0 0 0 0 1];

p_2 = [-40,-45,-50,-55,-60,-65,-70];
pp_2 = [-2;-3;-4;-5;-6;-7;-8];

L_t_2 = place(A_2',C_2',p_2);

K_2 = place(A_2,B_2,pp_2);
L_2 = L_t_2';


X_des_2 = ppval(pX,t);
Y_des_2 = ppval(pY,t);

dX_des_2 = diff(X_des_2)/dt;
dY_des_2 = diff(Y_des_2)/dt;



X_2(:,1) = [0;1;0;0;1;0;0];
yreal_2(:,1) = C_2*X_2;

X_hat_2(:,1) = [0;1;0;0;1;0;0];
y_hat_2(:,1) = C_2*X_hat_2;
u_2(:,1) = [0;0];

%filename = ['Observer_Avoidance_F'  '.gif'];
i_move = 1;
figure(8)
axis([0,10,0,10])
hold on;
for i = 1:size(obs_locs,1)
    patch( [obs_locs(i,1) obs_locs(i,1)  obs_locs(i,3) obs_locs(i,3)  ], ...
        [obs_locs(i,2) obs_locs(i,4)  obs_locs(i,4) obs_locs(i,2)  ],'black' );
    
end

for i = 1:size(xy_all)
    plot(xy_all(i,1),xy_all(i,2),'bx')
    plot(xy_all(i,1),xy_all(i,2),'b*')
end

for i = 2:length(t)
    u_2(:,i) = -K_2*([X_hat_2(1,i-1);X_hat_2(2,i-1)-X_des_2(i-1);X_hat_2(3,i-1)-dX_des_2(i-1);X_hat_2(4,i-1);X_hat_2(5,i-1)-Y_des_2(i-1);X_hat_2(6,i-1)-dY_des_2(i-1);X_hat_2(7,i-1) - 2]);
    
    X_2(:,i) = X_2(:,i-1)  +dt * (A_2*X_2(:,i-1) + B_2*u_2(:,i) - [X_des_2(i-1);0;0;Y_des_2(i-1);0;0;0]);
    yreal_2(:,i) = C_2*X_2(:,i) ;
    %     X(2,i-1)= min(2,X(2,i-1));
    
    X_hat_2(:,i) = X_hat_2(:,i-1)  +dt * (A_2*X_hat_2(:,i-1) + B_2*u_2(:,i) +L_2*(yreal_2(:,i-1)-y_hat_2(:,i-1))- [X_des_2(i-1);0;0;Y_des_2(i-1);0;0;0]);
    
    y_hat_2(:,i) = C_2*X_hat_2(:,i) ;
    
    h(1) = plot(X_hat_2(2,i),X_hat_2(5,i),'-o',...
        'MarkerFaceColor','green',...
        'MarkerEdgeColor', 'green');
    hold on
    h(2) = plot(X_2(2,:),X_2(5,:),'--','MarkerFaceColor', 'red');
    hold on
    %frame = getframe(3);
     %   im = frame2im(frame);
     %   [imind,cm] = rgb2ind(im,256);
     %   if i_move == 1;
     %       imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',.1);
     %   else
     %       imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',.1);
     %   end
     %   i_move = i_move+1;
end

%figure;



legend(h([1 2]),{'estimate','actual'},'Location','northwest')
title('States and observer estimates')
ylabel('Position')

figure(9)
plot(t,X_2(7,:))
title('Actuator Command')

%figure(10)
%plot(t,X_2(7,:))
%legend('Actuator Command')

figure(11)
plot(t,sqrt(X_2(3,:).^2+X_2(6,:).^2))
legend('absolute velocity')
title('Absolute Velocity')