% Quick and dirty script for creating a figure with all the models

% Load the models
load ..\outputs\mid_level_RDMs.mat
load ..\outputs\low_level_RDMs.mat
% load ..\outputs\high_level_RDMs.mat % PENDING

%% Plot them
missing_RDM=zeros(size(low_level.sun_RDM));
subplot(3,3,1), imagesc(low_level.sun_RDM);title('Salience (SUN)');
subplot(3,3,2), imagesc(low_level.sal_RDM);title('Salience (Sal. Toolbox)');
subplot(3,3,3), imagesc(low_level.col_RDM);title('Color');
subplot(3,3,4), imagesc(mid_level.ani_RDM);title('Animacy');
subplot(3,3,5), imagesc(mid_level.nat_RDM);title('Natural');
subplot(3,3,7), imagesc(missing_RDM);title('Context category (MISSING)');

