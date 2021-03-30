%% Script for sorting objects based on ratings
clear
close all

%% Folders
db_folder = '../../../ECOS_database/';
fig_folder = '../../figures/';

%% Load data
load('../../outputs/ratings_by_cat.mat');

% Concatenate all the objects
stim=[obj.beachOb;obj.desertOb;obj.mountainOb;obj.roadOb;...
    obj.savanahOb;obj.seabedOb;obj.stadiumOb]';

% Create variables for each category. Rows=Objects; Col1=Score;
% Col2=ObjectName.
beachOr=[scn.beach stim'];desertOr=[scn.desert stim'];
mountainOr=[scn.mountain stim'];savanahOr=[scn.savannah stim'];
roadOr=[scn.road stim'];seabedOr=[scn.seabed stim'];stadiumOr=[scn.stadium stim'];
beachOr=sortrows(beachOr);desertOr=sortrows(desertOr);mountainOr=sortrows(mountainOr);
savanahOr=sortrows(savanahOr);roadOr=sortrows(roadOr);seabedOr=sortrows(seabedOr);
stadiumOr=sortrows(stadiumOr);

%% Create a summary matrix
scn_mat=[scn.beach, scn.desert, scn.mountain,scn.savannah,scn.road,scn.seabed,scn.stadium];

% Let's make it discrete. 1 = congruent;0 = neutral; -1 = incongruent;
scn_mat(scn_mat<60 & scn_mat>-60)=0;
scn_mat(scn_mat>60)=1;
scn_mat(scn_mat<-60)=-1;

for i=1:7
    scn_mat(:,i)=sort(scn_mat(:,i));
end
subplot(2,4,8), imagesc(scn_mat)
xticks(1:7);xticklabels({'beach';'desert';'mountain';'savannah';'road';'seabed';'stadium'})
xtickangle(45)

% Get numbers
selected_scn=[1:7];
for i=selected_scn
    scn_nb(i,1)=sum(scn_mat(:,i)==1);
%     scn_nb(i,2)=sum(scn_mat(:,i)~=-10000 & scn_mat(:,i)~=10000);
     scn_nb(i,2)=sum(scn_mat(:,i)==0);
    scn_nb(i,3)=sum(scn_mat(:,i)==-1);
end

%% Plots
set(0,'defaultfigurecolor',[0 0 0])
whitebg([0 0 0])
hL(:,:,1) = ones(20,20)*255;hL(:,:,2) = ones(20,20)*255;hL(:,:,3) = ones(20,20)*0;


subplot(2,4,1),plot(beachOr(:,1))
title('beach')
hold on
for j=1:length(stim)
    if beachOr(j,2)<200
        subplot(2,4,1),imagesc([j-.5 j+2.5], [beachOr(j,1)+10.5 beachOr(j,1)-.5], hL);
    end
    im=imread([db_folder, 'objects/' num2str(beachOr(j,2)) '.png']);
    subplot(2,4,1),imagesc([j j+2], [beachOr(j,1)+10 beachOr(j,1)], im);
end
axis([0 100 -100 110])
% set(gcf, 'InvertHardcopy', 'off')
% print([fig_folder, 'beach'],'-dpng')

% figure
subplot(2,4,2),plot(desertOr(:,1))
title('desert')
hold on
for j=1:length(stim)
    if desertOr(j,2)<300 && desertOr(j,2)>150
        subplot(2,4,2),imagesc([j-.5 j+2.5], [desertOr(j,1)+10.5 desertOr(j,1)-.5], hL);
    end
    im=imread([db_folder, 'objects/' num2str(desertOr(j,2)) '.png']);
    subplot(2,4,2),imagesc([j j+2], [desertOr(j,1)+10 desertOr(j,1)], im);
end
axis([0 100 -100 110])
% set(gcf, 'InvertHardcopy', 'off')
% print([fig_folder, 'desert'],'-dpng')

% figure
subplot(2,4,3),plot(mountainOr(:,1))
title('mountain')
hold on
for j=1:length(stim)
    if mountainOr(j,2)<400 && mountainOr(j,2)>250
        subplot(2,4,3),imagesc([j-.5 j+2.5], [mountainOr(j,1)+10.5 mountainOr(j,1)-.5], hL);
    end
    im=imread([db_folder, 'objects/' num2str(mountainOr(j,2)) '.png']);
    subplot(2,4,3),imagesc([j j+2], [mountainOr(j,1)+10 mountainOr(j,1)], im);
end
axis([0 100 -100 110])
% set(gcf, 'InvertHardcopy', 'off')
% print([fig_folder, 'mount'],'-dpng')

% figure
subplot(2,4,4),plot(savanahOr(:,1))
title('savanah')
hold on
for j=1:length(stim)
    if savanahOr(j,2)<600 && savanahOr(j,2)>450
        subplot(2,4,4),imagesc([j-.5 j+2.5], [savanahOr(j,1)+10.5 savanahOr(j,1)-.5], hL);
    end
    im=imread([db_folder, 'objects/' num2str(savanahOr(j,2)) '.png']);
    subplot(2,4,4),imagesc([j j+2], [savanahOr(j,1)+10 savanahOr(j,1)], im);
end
axis([0 100 -100 110])
% set(gcf, 'InvertHardcopy', 'off')
% print([fig_folder, 'savanah'],'-dpng')

% figure
subplot(2,4,5),plot(roadOr(:,1))
title('road')
hold on
for j=1:length(stim)
    if roadOr(j,2)<500 && roadOr(j,2)>350
        subplot(2,4,5),imagesc([j-.5 j+2.5], [roadOr(j,1)+10.5 roadOr(j,1)-.5], hL);
    end
    im=imread([db_folder, 'objects/' num2str(roadOr(j,2)) '.png']);
    subplot(2,4,5),imagesc([j j+2], [roadOr(j,1)+10 roadOr(j,1)], im);
end
axis([0 100 -100 110])
% set(gcf, 'InvertHardcopy', 'off')
% print([fig_folder, 'road'],'-dpng')

% figure
subplot(2,4,6),plot(seabedOr(:,1))
title('seabed')
hold on
for j=1:length(stim)
    if seabedOr(j,2)<700 && seabedOr(j,2)>550
        subplot(2,4,6),imagesc([j-.5 j+2.5], [seabedOr(j,1)+10.5 seabedOr(j,1)-.5], hL);
    end
    im=imread([db_folder, 'objects/' num2str(seabedOr(j,2)) '.png']);
    subplot(2,4,6),imagesc([j j+2], [seabedOr(j,1)+10 seabedOr(j,1)], im);
end
axis([0 100 -100 110])
% set(gcf, 'InvertHardcopy', 'off')
% print([fig_folder, 'seabed'],'-dpng')

% figure
 subplot(2,4,7),plot(stadiumOr(:,1))
title('stadium ')
hold on
for j=1:length(stim)
    if stadiumOr(j,2)<800 && stadiumOr(j,2)>650
         subplot(2,4,7),imagesc([j-.5 j+2.5], [stadiumOr(j,1)+10.5 stadiumOr(j,1)-.5], hL);
    end
    im=imread([db_folder, 'objects/' num2str(stadiumOr(j,2)) '.png']);
     subplot(2,4,7),imagesc([j j+2], [stadiumOr(j,1)+10 stadiumOr(j,1)], im);
end
axis([0 100 -100 110])
set(gcf, 'InvertHardcopy', 'off')
print([fig_folder, 'summary'],'-dpng')
