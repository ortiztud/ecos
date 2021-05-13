%% Variance partitioning
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


%% Low-level
% Define what to model
predictand = relat;
predictors = {low_level.col_RDM, low_level.sal_RDM};

% Run variance partitioning
varpart(predictand, predictors, 999, 1)
[pred_1,shared,pred_2,residual,Probabc,~,~,p_pred_1,p_pred_2]=DistanceVariationPartition(predictand, predictors{1}, predictors{2}, 1000,0);
[TotalVariation,TotalVariationAdj,Fractions,FractionsAdj,Prob]=PartitionRDATwoDataMatrices(predictand, predictors{1}, predictors{2}, 1000,1);
PartitionRDATwoDataMatrices
[TotalVariation,TotalVariationAdj,Fractions,FractionsAdj,Prob]=PartitionRDATwoDataMatrices(Y,X1,X2,NumberPermutations,ShowResultTable)
% Store result
unique_var.col = pred_1;
unique_var.col_pval = p_pred_1;
unique_var.sal = pred_2;
unique_var.sal_pval = p_pred_2;

% Draw venn
figure
[H,S]=venn([unique_var.col, unique_var.sal], shared, 'FaceColor', {[1,.5,0.1];[.5,0,.5]});

%% Mid-level
% Define what to model
predictand = relat;
predictors = {mid_level.ani_RDM, mid_level.nat_RDM};

% Run variance partitioning
[pred_1,shared,pred_2,residual,Probabc,~,~,p_pred_1,p_pred_2]=DistanceVariationPartition(predictand, predictors{1}, predictors{2}, 1000,0);

% Store result
unique_var.ani = pred_1;
unique_var.ani_pval = p_pred_1;
unique_var.nat = pred_2;
unique_var.nat_pval = p_pred_2;

figure
[H,S]=venn([unique_var.ani, unique_var.nat], shared, 'FaceColor', {[1,.5,0.1];[.5,0,.5]});

%% High-level
% Define what to model
predictand = relat;
predictors = {high_level.cat_RDM, mid_level.nat_RDM};

% Run variance partitioning
[pred_1,shared,pred_2,residual,Probabc,~,~,p_pred_1,p_pred_2]=DistanceVariationPartition(predictand, predictors{1}, predictors{2}, 1000,0);

% Store result
unique_var.cat = pred_1;
unique_var.cat_pval = p_pred_1;
unique_var.nat2 = pred_2;
unique_var.nat2_pval = p_pred_2;


% Draw venn
figure
[H,S]=venn([unique_var.cat, unique_var.nat2], shared, 'FaceColor', {[1,.5,0.1];[.5,0,.5]});
i= 1
text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), num2str(round(unique_var.cat_pval,3)))




