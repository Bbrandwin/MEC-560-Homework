
t_track(1) = 0;

V_track = 1.5;
for i_pts = 2:size(newPath,1),
    
    d_mov = sqrt((newPath(i_pts,1)-newPath(i_pts-1,1))^2 + ...
                  (newPath(i_pts,2)-newPath(i_pts-1,2))^2);  
    t_track(i_pts) = t_track(i_pts-1) + d_mov/V_track;
    
    
end

pp_X = spline(t_track,newPath(:,1));
pp_Y = spline(t_track,newPath(:,2));