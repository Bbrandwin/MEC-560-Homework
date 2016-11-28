clear all
close all
clc

addpath Screws;
addpath fcn_support;
addpath fcn_models;


display('Defining symbols')
define_syms;

display('Deriving kinematics')
get_kinematics_acrobat;

display('Deriving EOMs')
get_EOMs_acrobat_w_rotation;

%display('Linearizing EOMs')
%linearize_EOM_cart;