function [ wall ] = Wall(start_X,start_Y, length, direction)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

start = [start_X, start_Y];
if strcmp(direction,'left')
    wall(1,1) = start(1,1)-length;
    wall(1,2) = start(1,2) - 0.125;
    wall(1,3) = start(1,1);
    wall(1,4) = start(1,2) + 0.125;
end

if strcmp(direction,'right')
    wall(1,1) = start(1,1);
    wall(1,2) = start(1,2) - 0.125;
    wall(1,3) = start(1,1)+length;
    wall(1,4) = start(1,2) + 0.125;
end

if strcmp(direction,'up')
    wall(1,1) = start(1,1)-.0125;
    wall(1,2) = start(1,2);
    wall(1,3) = start(1,1)+ 0.125;
    wall(1,4) = start(1,2) + length;
end

if strcmp(direction,'down')
    wall(1,1) = start(1,1)-.0125;
    wall(1,2) = start(1,2) - length;
    wall(1,3) = start(1,1)+ 0.125;
    wall(1,4) = start(1,2);
end


end

