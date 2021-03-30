%% Script for sorting objects based on ratings
clear
close all

%% Load data
dat=readtable('../../validation_data/group_task-validation_ratings.csv');
which_sub=unique(dat.id);

%% Arrange raw data
% We will loop through all the subjects and arrange their data into an 
% objects X scenes x subjects matrix

% Pre-allocate
mat = zeros(512,7,numel(which_sub));
for c_sub = 1:length(which_sub)
    
    % Get this subjects data
    t = dat(dat.id==c_sub,:);
    
    % Loop through trials
    for c_trial = 1:length(t.id)
        % Whic object
        ob=dat.obj_id(c_trial);%ob=num2str(dat(i,2));ob=[ob(2) ob(3)];ob=str2double(ob);
        
        % Which scene
        sc=num2str(dat.scn_id(c_trial));sc=sc(1);sc=str2double(sc);
        
        % Fill the matrix
        mat(ob,sc,c_sub)=dat.rating(c_trial);
    end
end

% Get rid of the cells coding for non-existing objects
c=1;
for i=1:size(mat,1)
    if mat(i,1,1)~=0
        matGood(c,:,:)=mat(i,:,:);
        c=c+1;
    end
end

% Get indexes for non-existing objects by scene category
h=find(mat(:,1,1)~=0);
c=1;d=1;
for i=1:length(h)
    if h(i)<100*(c+1)
        indx(d,c)=h(i);
        d=d+1;
    else
        c=c+1;
        d=1;
        indx(d,c)=h(i);
        d=d+1;
    end
end

% Select objects based on indexes. Object scores for each of the 7 categs
c=1;
for i=1:size(indx,1)
    if indx(i,1)~=0
       obj.beach(c,:,:)= mat(indx(i,1),:,:);
       c=c+1;
    end
end
c=1;
for i=1:size(indx,1)
    if indx(i,2)~=0
       obj.desert(c,:,:)= mat(indx(i,2),:,:);
       c=c+1;
    end
end
c=1;
for i=1:size(indx,1)
    if indx(i,3)~=0
       obj.mountain(c,:,:)= mat(indx(i,3),:,:);
       c=c+1;
    end
end
c=1;
for i=1:size(indx,1)
    if indx(i,4)~=0
       obj.road(c,:,:)= mat(indx(i,4),:,:);
       c=c+1;
    end
end
c=1;
for i=1:size(indx,1)
    if indx(i,5)~=0
       obj.savannah(c,:,:)= mat(indx(i,5),:,:);
       c=c+1;
    end
end
c=1;
for i=1:size(indx,1)
    if indx(i,6)~=0
       obj.seabed(c,:,:)= mat(indx(i,6),:,:);
       c=c+1;
    end
end
c=1;
for i=1:size(indx,1)
    if indx(i,7)~=0
       obj.stadium(c,:,:)= mat(indx(i,7),:,:);
       c=c+1;
    end
end

%% Get objects names for each categ

obj.beachOb=indx(indx(:,1)~=0,1);
obj.desertOb=indx(indx(:,2)~=0,2);
obj.mountainOb=indx(indx(:,3)~=0,3);
obj.roadOb=indx(indx(:,4)~=0,4);
obj.savanahOb=indx(indx(:,5)~=0,5);
obj.seabedOb=indx(indx(:,6)~=0,6);
obj.stadiumOb=indx(indx(:,7)~=0,7);

%% Get ratings by scene

% New and more elegant (and including all objects) way
scn.beach=mean(matGood(:,1,:),3);
scn.desert=mean(matGood(:,2,:),3);
scn.mountain=mean(matGood(:,3,:),3);
scn.road=mean(matGood(:,4,:),3);
scn.savannah=mean(matGood(:,5,:),3);
scn.seabed=mean(matGood(:,6,:),3);
scn.stadium=mean(matGood(:,7,:),3);

save('../../outputs/ratings_by_cat.mat','obj', 'scn')