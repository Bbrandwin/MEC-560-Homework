function [ xa ] = XofT(ta)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
A = [0 1;-3 -4];
xa = expm(ta*A);



end

