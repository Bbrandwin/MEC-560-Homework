A = [0 1 0 0 0 0 0;
    0 0 1 0 0 0 0;
    0 0 0 0 0 0 0;
    0 0 0 0 1 0 0;
    0 0 0 0 0 1 0;
    0 0 0 0 0 0 0
    0 0 0 0 0 0 -5];
B = [0 0;0 0; 1 0;0 0;0 0; 0 1;.5 .5];
C = [1 0 0 0 0 0 0;
    0 1 0 0 0 0 0;
    0 0 0 1 0 0 0;
    0 0 0 0 1 0 0;
    0 0 0 0 0 0 1];

p = [-40,-45,-50,-55,-60,-65,-70];
pp = [-2;-3;-4;-5;-6;-7;-8];

L_t = place(A',C',p);

K = place(A,B,pp);
L = L_t';
time = t_track(end);

dt = time/1000;
t = 0:dt:time;

X_des = ppval(pX,t);
Y_des = ppval(pY,t);

dX_des = diff(X_des)/dt;
dY_des = diff(Y_des)/dt;



X(:,1) = [0;1;0;0;1;0;0];
yreal(:,1) = C*X;

X_hat(:,1) = [0;1;0;0;1;0;0];
y_hat(:,1) = C*X_hat;
u(:,1) = [0;0];

%filename = ['Observer_Avoidance'  '.gif'];
i_move = 1;
figure(4)
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
    u(:,i) = -K*([X_hat(1,i-1);X_hat(2,i-1)-X_des(i-1);X_hat(3,i-1)-dX_des(i-1);X_hat(4,i-1);X_hat(5,i-1)-Y_des(i-1);X_hat(6,i-1)-dY_des(i-1);X_hat(7,i-1) - 2]);
    
    X(:,i) = X(:,i-1)  +dt * (A*X(:,i-1) + B*u(:,i) - [X_des(i-1);0;0;Y_des(i-1);0;0;0]);
    yreal(:,i) = C*X(:,i) ;
    %     X(2,i-1)= min(2,X(2,i-1));
    
    X_hat(:,i) = X_hat(:,i-1)  +dt * (A*X_hat(:,i-1) + B*u(:,i) +L*(yreal(:,i-1)-y_hat(:,i-1))- [X_des(i-1);0;0;Y_des(i-1);0;0;0]);
    
    y_hat(:,i) = C*X_hat(:,i) ;
    h(1) = plot(X_hat(2,i),X_hat(5,i),'-o',...
        'MarkerFaceColor','green',...
        'MarkerEdgeColor', 'green');
    hold on
    h(2) = plot(X(2,:),X(5,:),'--','MarkerFaceColor', 'red');
    hold on
    %frame = getframe(3);
    %    im = frame2im(frame);
    %   [imind,cm] = rgb2ind(im,256);
    %   if i_move == 1;
    %        imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',.1);
    %    else
    %        imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',.1);
    %    end
    %    i_move = i_move+1;
end

%figure;



legend(h([1 2]),{'estimate','actual'},'Location','northwest')
title('States and observer estimates')
ylabel('Position')

figure(5)
plot(t,X(7,:))
title('Actuator Command')

%figure(6)
%plot(t,X(7,:))
%legend('Actuator Command')

figure(7)
plot(t,sqrt(X(3,:).^2+X(6,:).^2))
legend('absolute velocity')
title('Absolute Velocity')