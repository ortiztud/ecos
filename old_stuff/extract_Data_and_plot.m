clear all
load objectsCat.mat
labels = {'beach','desert','mountain','road','savannah','seabed','stadium'};
f1 = figure('Color',[1 1 1]);

%% for each scene, compute the relatedness with its group of objects
for s = 1:7
    scenes(1,:,s) = squeeze(mean(obj.beach(:,s,:),1));
    scenes(2,:,s) = squeeze(mean(obj.desert(:,s,:),1));
    scenes(3,:,s) = squeeze(mean(obj.mountain(:,s,:),1));
    scenes(4,:,s) = squeeze(mean(obj.road(:,s,:),1));
    scenes(5,:,s) = squeeze(mean(obj.savannah(:,s,:),1));
    scenes(6,:,s) = squeeze(mean(obj.seabed(:,s,:),1));
    scenes(7,:,s) = squeeze(mean(obj.stadium(:,s,:),1));
    
    subplot(2,4,s)
    barwitherr(std(scenes(:,:,s),[],2),mean(scenes(:,:,s),2))
    title(labels{s})
    ylabel('relatedness')
    ylim([-105 105])
    xlim([0.5 7.5])
    xticks([1:7])
    xticklabels(labels)
    xtickangle(45)
   
    
end

% plot item-spcific relatedness
figure('Color',[1 1 1]);
for o = 1:9
    beach_objs(o,:) = mean(obj.beach(o,:,:),3);
    subplot(9,1,o)
    bar(beach_objs(o,:))
    if o == 1
    title('beach objects')
    end
    if o ~= 9
        xticks([])
        xticklabels([])
    else
        xticks([1:7])
        xticklabels(labels)
        xtickangle(45)

    end
end

figure('Color',[1 1 1]);
for o = 1:13
    desert_objs(o,:) = mean(obj.desert(o,:,:),3);
    subplot(13,1,o)
    bar(desert_objs(o,:))
    if o == 1
    title('desert objects')
    end
    if o ~= 13
        xticks([])
        xticklabels([])
    else
        xticks([1:7])
        xticklabels(labels)
        xtickangle(45)

    end
end

figure('Color',[1 1 1]);
for o = 1:14
    mountain_objs(o,:) = mean(obj.mountain(o,:,:),3);
    subplot(14,1,o)
    bar(mountain_objs(o,:))
    if o == 1
    title('mountain objects')
    end
    if o ~= 14
        xticks([])
        xticklabels([])
    else
        xticks([1:7])
        xticklabels(labels)
        xtickangle(45)

    end
end

figure('Color',[1 1 1]);
for o = 1:11
    road_objs(o,:) = mean(obj.road(o,:,:),3);
    subplot(11,1,o)
    bar(road_objs(o,:))
    if o == 1
    title('roads objects')
    end
    if o ~= 11
        xticks([])
        xticklabels([])
    else
        xticks([1:7])
        xticklabels(labels)
        xtickangle(45)

    end
end

figure('Color',[1 1 1]);
for o = 1:19
    savannah_objs(o,:) = mean(obj.savannah(o,:,:),3);
    subplot(19,1,o)
    bar(savannah_objs(o,:))
    if o == 1
    title('savannah objects')
    end
    if o ~= 19
        xticks([])
        xticklabels([])
    else
        xticks([1:7])
        xticklabels(labels)
        xtickangle(45)

    end
end

figure('Color',[1 1 1]);
for o = 1:13
    seabed_objs(o,:) = mean(obj.seabed(o,:,:),3);
    subplot(13,1,o)
    bar(seabed_objs(o,:))
    if o == 1
    title('seabed objects')
    end
    if o ~= 13
        xticks([])
        xticklabels([])
    else
        xticks([1:7])
        xticklabels(labels)
        xtickangle(45)

    end
end

figure('Color',[1 1 1]);
for o = 1:13
    stadium_objs(o,:) = mean(obj.stadium(o,:,:),3);
    subplot(13,1,o)
    bar(stadium_objs(o,:))
    if o == 1
    title('stadium objects')
    end
    if o ~= 13
        xticks([])
        xticklabels([])
    else
        xticks([1:7])
        xticklabels(labels)
        xtickangle(45)

    end
end

objs = [beach_objs; desert_objs; mountain_objs; road_objs; savannah_objs; seabed_objs; stadium_objs];


    
