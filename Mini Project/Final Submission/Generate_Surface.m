figure(2);
V = 100000*ones(size(Act));
gam = .9;
%filename = ['Value_growth' num2str(i) '.gif'];

changed = 1;
i_V = 1;
while changed == 1
    changed = 0;
    V_old = V;
    for i_x = 1:length(x)
        for i_y = 1:length(y)
            
            if (i_x == ix_goal) &(i_y == iy_goal)
                if V(i_x,i_y) > 0
                    changed = 1;
                    V(i_x,i_y) = 0;
                end
            end
            
            if Act(i_x,i_y) ~= 1000;
                iv_x = [1 -1 0 0 1 -1 1  -1];
                iv_y = [0 0 -1 1  1 -1 -1 1];
                V_new = [];
                for i_v = 1:8,
                    val = check_ind(i_x+iv_x(i_v),i_y+iv_y(i_v));
                    if val == 1
                        V_new  = V(i_x+iv_x(i_v),i_y+iv_y(i_v)) + 10*sqrt(iv_x(i_v)^2+iv_y(i_v)^2);
                        
                        if V_new< V(i_x,i_y)
                            V(i_x,i_y) = V_new;
                            changed = 1;
                            
                        end
                    end
                end
                
                
            else
                V(i_x,i_y) = 100000;
            end
            
            
            
            
            
        end
    end
    
    
    surf(yy,xx,V_old);xlabel('X');ylabel('Y');zlabel('Value')
    title(['Value after ' num2str(i_V) ' iterations.'])
    axis([0 10 0 10 -200 210000])
    view(i_V*3,30);
    %frame = getframe(2);
    %im = frame2im(frame);
    %[imind,cm] = rgb2ind(im,256);
    %if i_V == 1;
    %    imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',.1);
    %else
    %    imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',.1);
    %end
    i_V = i_V+1;
end


for i = i_V:i_V+60
    surf(yy,xx,V);xlabel('X');ylabel('Y');zlabel('Value')
    title(['Value after ' num2str(i) ' iterations (Converged).'])
    axis([0 10 0 10 -200 210000])
    view(i*3,30);
    %frame = getframe(2);
    %im = frame2im(frame);
    %[imind,cm] = rgb2ind(im,256);
    %imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',.1);
    
end