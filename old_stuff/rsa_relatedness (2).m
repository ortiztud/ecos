clear all
load objectsCat.mat
labels = {'beach','desert','mountain','road','savannah','seabed','stadium'};

all_obj = [obj.beach;obj.desert;obj.mountain;obj.road;obj.savannah;obj.seabed;obj.stadium];

for s = 1:7
    current = squeeze((all_obj(:,s,:)));
    RDMs(:,:,s) = squareform(pdist(current,'correlation'));
    figure; imagesc(RDMs(:,:,s));
    
    [Y,stress]= mdscale(RDMs(:,:,s),2); % perform multidimensional scaling (2-dimension solution)
    figure;scatter(Y(1:9,1),Y(1:9,2),30,[0 0 1],'filled'); hold on % beach
    scatter(Y(10:22,1),Y(10:22,2),30,[0 0.8 1],'filled'); hold on % desert
    scatter(Y(23:36,1),Y(23:36,2),30,[0 1 0],'filled'); hold on % mountain
    scatter(Y(37:47,1),Y(37:47,2),30,[0.8 1 0],'filled'); hold on % road
    scatter(Y(48:66,1),Y(48:66,2),30,[0.7 0 0],'filled'); hold on % savannah
    scatter(Y(67:79,1),Y(67:79,2),30,[0.7 0.5 0.5],'filled'); hold on % seabed
    scatter(Y(80:92,1),Y(80:92,2),30,[0.7 0 1],'filled'); hold on % stadium
    legend(labels)
end
    
%% 2nd order RSA

for s = 1:7
    secondorder(:,s) = reshape(RDMs(:,:,s),[],1,1);
end

RDM2 = squareform(pdist(secondorder','spearman'));
figure; imagesc(RDM2);
[Y,stress]= mdscale(RDM2,2);
figure('Color',[1 1 1]);
scatter(Y(1,1),Y(1,2),80,[0 0 1],'filled'); hold on % beach
scatter(Y(2,1),Y(2,2),80,[0 0.8 1],'filled'); hold on % desert
scatter(Y(3,1),Y(3,2),80,[0 1 0],'filled'); hold on % mountain
scatter(Y(4,1),Y(4,2),80,[0.8 1 0],'filled'); hold on % road
scatter(Y(5,1),Y(5,2),80,[0.7 0 0],'filled'); hold on % savannah
scatter(Y(6,1),Y(6,2),80,[0.7 0.5 0.5],'filled'); hold on % seabed
scatter(Y(7,1),Y(7,2),80,[0.7 0 1],'filled'); hold on % stadium
legend(labels)