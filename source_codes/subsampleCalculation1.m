% Supplementary material for the paper:
% Adam Czajka, Daniel Moreira, Kevin W. Bowyer, Patrick J. Flynn, 
% "Domain-Specific Human-Inspired Binarized Statistical Image Features for 
% Iris Recognition," WACV 2019, Hawaii, 2019
% 
% Pre-print available at: https://arxiv.org/abs/1807.05248
% 
% Please follow the instructions at https://cvrl.nd.edu/projects/data/ 
% to get a copy of the test database.
%
% This example code demonstrates how to calculate and match binary iris 
% codes using domain-specific filters. One can easily replace 
% domain-specific filters with standard BSIF filters, if needed. In this 
% example we use an example filter set derived from eyetracker-based iris 
% image patches.

clear all

ent = subsampleCalc(43);

disp([43 ent])