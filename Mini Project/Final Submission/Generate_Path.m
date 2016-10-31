filename = ['Obs_Avoidance' num2str(i) '.gif'];

figure(3);
%plot(xx,yy,'k.')
axis([0,10,0,10])
hold on;
for i = 1:size(obs_locs,1)
    patch( [obs_locs(i,1) obs_locs(i,1)  obs_locs(i,3) obs_locs(i,3)  ], ...
        [obs_locs(i,2) obs_locs(i,4)  obs_locs(i,4) obs_locs(i,2)  ],'black' );
    
end

Va = [];
x_all = [];
y_all = [];
hold on;
i_move = 1;
for i = 1:length(x_agent)
    [i_x,i_y]= xy_to_indices(x_agent(i),y_agent(i));
    stop_mov = 0;
    while stop_mov == 0
        iv_x = [1 -1 0 0 1 -1 1  -1];
        iv_y = [0 0 -1 1  1 -1 -1 1];
        for i_v = 1:8,
            Va(i_v) = V(i_x+iv_x(i_v),i_y+iv_y(i_v)) + 10*sqrt(iv_x(i_v)^2+iv_y(i_v)^2);
        end
        
        [V_min , i_vmin]= min(Va);
        x_agent(i) = x( i_x+iv_x(i_vmin));
        y_agent(i) = y( i_y+iv_y(i_vmin));
        j(1) = plot(x_agent(i),y_agent(i),'bx');
        j(2) = plot(x_agent(i),y_agent(i),'b*');
        x_all = [x_all ; x_agent(i)];
        y_all = [y_all ; y_agent(i)];
        
        if (i_x==ix_goal)&(i_y==iy_goal)
            stop_mov = 1;
        end
        
        frame = getframe(3);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
        if i_move == 1;
            imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',.1);
        else
            imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',.1);
        end
        i_move = i_move+1;
        
        
        [i_x,i_y]= xy_to_indices(x_agent(i),y_agent(i));
        
        
        pause(0.01);
    end
end