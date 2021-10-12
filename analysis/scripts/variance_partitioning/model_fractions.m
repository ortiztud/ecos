%% Variation partitioning
% < DESCRIPTION >

clear;close all
addpath('../_functions/')
%% Load necessary info
% Load the models
load ../../outputs/mid_level_RDMs.mat
load ../../outputs/low_level_RDMs.mat
load ../../outputs/high_level_RDMs.mat

% Load the data
load ../../outputs/relatedness_RDMs.mat


%% Compute fractions
% Define what to model
predictand = relat;
predictors = {low_level.col_RDM, low_level.sal_RDM, low_level.sun_RDM,...
    mid_level.ani_RDM, mid_level.nat_RDM,...
    high_level.cat_RDM};

% Run variance partitioning
[fractions, prob] = varpart_2funcs(predictand, predictors, 5000, 1);

% Draw barplot
data = [ones(1,length(fractions))/length(fractions);fractions];
subplot(1,2,1),bar(data,'stacked');ylim([0 1])
subplot(1,2,2),bar(data,'stacked');ylim([0 0.01])
