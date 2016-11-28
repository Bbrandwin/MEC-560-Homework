function output = acrobatEndpoint(input)
% input.auxdata.dynamics;


intg = input.phase.integral;
tf_d = input.phase.finaltime;

gamma = input.auxdata.gamma;


output.objective = tf_d+gamma*intg;