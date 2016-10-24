function [pp_X, pp_Y, t] = generateSpline(path, velocity )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
t_track(1) = 0;

V_track = velocity;
for i_pts = 2:size(path,1),
    
    d_mov = sqrt((path(i_pts,1)-path(i_pts-1,1))^2 + ...
                  (path(i_pts,2)-path(i_pts-1,2))^2);  
    t_track(i_pts) = t_track(i_pts-1) + d_mov/V_track;
    
    
end

pp_X = spline(t_track,path(:,1));
pp_Y = spline(t_track,path(:,2));
t = t_track;


end

