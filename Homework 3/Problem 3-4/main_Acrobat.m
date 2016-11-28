%-------------------------- Cart-pole Problem -----------------------%
%--------------------------------------------------------------------%
main_DeriveEOM_Acrobat

clear all
close all
clc

addpath fcn_models

th10 = 0;
th1f = 0;
th20 = 0;
th2f = 0;
th30 = 0;
th3f = pi;
dth10 = 0;
dth1f = 0;
dth20 = 0;
dth2f = 0;
dth30 = 0;
dth3f = 0;

% Auxillary data:
%-------------------------------------------------------------------%
%-------------------- Data Required by Problem ---------------------%
%-------------------------------------------------------------------%
% Some model related constants
gamma = .0001;
auxdata.gamma = gamma ;


% Parameters:
%-------------------------------------------------------------------%
%-------------------- Data Required by Problem ---------------------%
%-------------------------------------------------------------------%
% Some model related constants
ndof     = 3;
nstates  = 2*ndof;
joints   = {'Theta_1' 'Theta_2' 'Theta_3'};
njoints  = size(joints,2);

dofnames = {'Theta_1','Theta_2','Theta_3'};
N  = nstates;        % number of state variables in model
Nu = 2;         % number of controls

%-------------------------------------------------------------------%
%----------------------------- Bounds ------------------------------%
%-------------------------------------------------------------------%

%-------------------------------------------------------------------%
t0  = 0;
tf  = 10;

xMin = [-2*pi/9 -2*pi/9 -2*pi -100 -100 -100];       %minimum of coordinates
xMax = [2*pi/3 2*pi/3 2*pi 100 100 100];       %maximum of coordinates

uMin = [-1000 -1000]; %minimum of torques
uMax = [1000 1000]; %maximum of torques

% setting up bounds
bounds.phase.initialtime.lower  = 0;
bounds.phase.initialtime.upper  = 0;
bounds.phase.finaltime.lower    = tf; 
bounds.phase.finaltime.upper    = tf;
bounds.phase.initialstate.lower = [th10 th20 th30 dth10 dth20 dth30];
bounds.phase.initialstate.upper = [th10 th20 th30 dth10 dth20 dth30];
bounds.phase.state.lower        = xMin;
bounds.phase.state.upper        = xMax;
bounds.phase.finalstate.lower   = [th1f th2f th3f dth1f dth2f dth3f];
bounds.phase.finalstate.upper   = [th1f th2f th3f dth1f dth2f dth3f];
bounds.phase.control.lower      = uMin; 
bounds.phase.control.upper      = uMax; 
bounds.phase.integral.lower     = 0;
bounds.phase.integral.upper     = 10000;



%-------------------------------------------------------------------%
%--------------------------- Initial Guess -------------------------%
%-------------------------------------------------------------------%
rng(0);

th1Guess = [th10;th1f]; 
th2Guess = [th20;th2f]; 
th3Guess = [th30;th3f]; 
dth1Guess = [dth10;dth1f]; 
dth2Guess = [dth20;dth2f];
dth3Guess = [dth30;dth3f];
u1Guess = [0;0];
u2Guess = [0;0];
tGuess = [0;tf]; 

guess.phase.time  = tGuess;
guess.phase.state = [th1Guess,th2Guess,th3Guess, dth1Guess,dth2Guess,dth3Guess];
guess.phase.control        = [u1Guess, u2Guess];
guess.phase.integral         = 0;

% 
% load solution.mat
% guess  = solution

%-------------------------------------------------------------------%
%--------------------------- Problem Setup -------------------------%
%-------------------------------------------------------------------%
setup.name                        = 'acrobat-Problem';
setup.functions.continuous        = @acrobatContinuous;
setup.functions.endpoint          = @acrobatEndpoint;
setup.bounds                      = bounds;
setup.auxdata                     = auxdata;
setup.functions.report            = @report;
setup.guess                       = guess;
setup.nlp.solver                  = 'ipopt';
setup.derivatives.supplier        = 'sparseCD';
setup.derivatives.derivativelevel = 'first';
setup.scales.method               = 'none';
setup.derivatives.dependencies    = 'full';
setup.mesh.method                 = 'hp-PattersonRao';
setup.mesh.tolerance              = 1e-1;
setup.method                      = 'RPM-Integration';

%-------------------------------------------------------------------%
%------------------- Solve Problem Using GPOPS2 --------------------%
%-------------------------------------------------------------------%
output = gpops2(setup);
output.result.nlptime
solution = output.result.solution;

%-------------------------------------------------------------------%
%--------------------------- Plot Solution -------------------------%
%-------------------------------------------------------------------%

animateAcrobat;













