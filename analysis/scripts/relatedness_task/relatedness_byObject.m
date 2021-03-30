% Get MDS for objects according to how they were rated for each scene.
clear
close all

% Load stuff
load ../../outputs/ratings_by_cat.mat
labels = {'beach','desert','mountain','road','savannah','seabed','stadium'};

% Put them together and assess the mean across subjects
all_obj = [obj.beach;obj.desert;obj.mountain;obj.road;obj.savannah;obj.seabed;obj.stadium];
mean_obj=mean(all_obj,3);
all_obj_names=[objNames.beachOb;objNames.dessertOb;objNames.mountainOb;...
    objNames.roadOb;objNames.savanahOb;objNames.seabedOb;objNames.stadiumOb];

% Get the RDMS
RDMs = squareform(pdist(mean_obj,'correlation'));
figure; imagesc(RDMs);

% MDS time, baby
[Y,stress]= mdscale(RDMs,2); % perform multidimensional scaling (2-dimension solution)
Y=Y*10000;
figure;scatter(Y(1:9,1),Y(1:9,2),30,[0 0 1],'filled'); hold on % beach
scatter(Y(10:22,1),Y(10:22,2),30,[0 0.8 1],'filled'); hold on % desert
scatter(Y(23:36,1),Y(23:36,2),30,[0 1 0],'filled'); hold on % mountain
scatter(Y(37:47,1),Y(37:47,2),30,[0.8 1 0],'filled'); hold on % road
scatter(Y(48:66,1),Y(48:66,2),30,[0.7 0 0],'filled'); hold on % savannah
scatter(Y(67:79,1),Y(67:79,2),30,[0.7 0.5 0.5],'filled'); hold on % seabed
scatter(Y(80:92,1),Y(80:92,2),30,[0.7 0 1],'filled'); hold on % stadium
legend(labels)
% set(gca,'Color','k')

% Load objects to display them on the MDS plott
for i=1:length(Y)
    % Load
    [temp,~,alpha]=imread(['objects/' num2str(all_obj_names(i)) '.png']);
    
    % Resize object
    temp=imresize(temp,.1);
    temp=flip(temp,1);
    
    % Plot
    image(Y(i,1),Y(i,2),temp)
    hold on
end
close all
Y = pdist(mean_obj);
Z = linkage(Y);
dendrogram(Z)
hold on
for i=1:length(Z)
    
       % Load
    [temp,~,alpha]=imread(['objects/' num2str(all_obj_names(i)) '.png']);
    
    % Resize object
    temp=imresize(temp,.1);
%     temp=flip(temp,1);
    
     % Plot
    image([i-1.5 i+1],[0 -20],temp)
    
end