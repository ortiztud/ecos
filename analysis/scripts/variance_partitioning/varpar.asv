%% Variance partitioning
% < DESCRIPTION >

clear;close all
addpath('..\_functions\')
%% Load necessary info
% Load the models
load ..\..\outputs\mid_level_RDMs.mat
load ..\..\outputs\low_level_RDMs.mat
load ..\..\outputs\high_level_RDMs.mat

% Load the data
load ..\..\outputs\relatedness_RDMs.mat


%% Low-level
% Define what to model
predictand = relat;
predictors = {low_level.col_RDM, low_level.sal_RDM};

% Run variance partitioning
[pred_1,shared,pred_2,residual,Probabc,~,~,p_pred_1,p_pred_2]=DistanceVariationPartition(predictand, predictors{1}, predictors{2}, 1000,0);

% Store result
unique_var.col = pred_1;
unique_var.col_pval = p_pred_1;
unique_var.sal = pred_2;
unique_var.sal_pval = p_pred_2;


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





% % Include labels in the plot
% draw_venn=0;
% if draw_venn
%     [H,S]=venn([a,c,b], 'FaceColor', {[1,.5,0.1];[.5,0,.5]});
%     
%     for i = 1:3
%         if i==1
%             t=a;
%         elseif i==2
%             t=c;
%         elseif i==3
%             t=b;
%         end
%         
%         text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), num2str(round(t,3)))
%     end
% end


