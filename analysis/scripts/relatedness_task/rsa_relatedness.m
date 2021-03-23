clear
close all

load ../../outputs/ratings_by_cat.mat
labels = {'beach','desert','mountain','road','savannah','seabed','stadium'};

% Combine into a 3D matrix
all_obj = [obj.beach;obj.desert;obj.mountain;obj.road;obj.savannah;obj.seabed;obj.stadium];

% Average across subjects
all_obj = mean(all_obj, 3);

% Compute RDM
RDMs = squareform(pdist(all_obj,'euclidean'));
figure; imagesc(RDMs);

% MDS
[Y,stress]= mdscale(RDMs,3); % perform multidimensional scaling (2-dimension solution)
figure;scatter(Y(1:9,1),Y(1:9,2),30,[0 0 1],'filled'); hold on % beach
scatter(Y(10:22,1),Y(10:22,2),30,[0 0.8 1],'filled'); hold on % desert
scatter(Y(23:36,1),Y(23:36,2),30,[0 1 0],'filled'); hold on % mountain
scatter(Y(37:47,1),Y(37:47,2),30,[0.8 1 0],'filled'); hold on % road
scatter(Y(48:66,1),Y(48:66,2),30,[0.7 0 0],'filled'); hold on % savannah
scatter(Y(67:79,1),Y(67:79,2),30,[0.7 0.5 0.5],'filled'); hold on % seabed
scatter(Y(80:92,1),Y(80:92,2),30,[0.7 0 1],'filled'); hold on % stadium
legend(labels)

figure;scatter(Y(1:9,3),Y(1:9,2),30,[0 0 1],'filled'); hold on % beach
scatter(Y(10:22,3),Y(10:22,2),30,[0 0.8 1],'filled'); hold on % desert
scatter(Y(23:36,3),Y(23:36,2),30,[0 1 0],'filled'); hold on % mountain
scatter(Y(37:47,3),Y(37:47,2),30,[0.8 1 0],'filled'); hold on % road
scatter(Y(48:66,3),Y(48:66,2),30,[0.7 0 0],'filled'); hold on % savannah
scatter(Y(67:79,3),Y(67:79,2),30,[0.7 0.5 0.5],'filled'); hold on % seabed
scatter(Y(80:92,3),Y(80:92,2),30,[0.7 0 1],'filled'); hold on % stadium
legend(labels)

figure;scatter(Y(1:9,3),Y(1:9,2),30,[0 0 1],'filled'); hold on % beach
scatter(Y(10:22,3),Y(10:22,1),30,[0 0.8 1],'filled'); hold on % desert
scatter(Y(23:36,3),Y(23:36,1),30,[0 1 0],'filled'); hold on % mountain
scatter(Y(37:47,3),Y(37:47,1),30,[0.8 1 0],'filled'); hold on % road
scatter(Y(48:66,3),Y(48:66,1),30,[0.7 0 0],'filled'); hold on % savannah
scatter(Y(67:79,3),Y(67:79,1),30,[0.7 0.5 0.5],'filled'); hold on % seabed
scatter(Y(80:92,3),Y(80:92,1),30,[0.7 0 1],'filled'); hold on % stadium
legend(labels)


% 3D plot
col = {[0 0 1], [0 0.8 1], [0 1 0], [0.8 1 0], [0.7 0 0], [0.7 0.5 0.5],[0.7 0 1]};
figure;c=1
for i=1:7
    
    x = Y(c:c+8,:);
    
   scatter3(x(:,1),x(:,2),x(:,3),20,col{i},'filled');hold on
   c=c+8;
end

    scatter(Y(1:9,1),Y(1:9,2),Y(1:9,3),30,'red','filled'); hold on % beach
scatter(Y(10:22,1),Y(10:22,2),Y(10:22,3),30,[0 0.8 1],'filled'); hold on % desert
scatter(Y(23:36,1),Y(23:36,2),Y(23:36,3),30,[0 1 0],'filled'); hold on % mountain
scatter(Y(37:47,1),Y(37:47,2),Y(37:47,3),30,[0.8 1 0],'filled'); hold on % road
scatter(Y(48:66,1),Y(48:66,2),Y(48:66,3),30,[0.7 0 0],'filled'); hold on % savannah
scatter(Y(67:79,1),Y(67:79,2),Y(67:79,3),30,[0.7 0.5 0.5],'filled'); hold on % seabed
scatter(Y(80:92,1),Y(80:92,2),Y(80:92,3),30,[0.7 0 1],'filled'); hold on % stadium
legend(labels)