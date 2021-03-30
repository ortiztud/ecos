%% Read in raw data and aggregate
% We will load participants ratings on the semantic relatedness task and
% perform some restructuring to make data easier to handle.

clear
close all

%% Read in data
% Set where the data is and where we want the output.
val_path = '..\..\validation_data\';
out_path = '..\outputs\';

% Load data
raw_data = readtable([val_path, 'group_task-validation_ratings.csv']);
which_sub=unique(raw_data.id);

%% Arrange raw data
% We will loop through all the subjects and arrange their data into an
% objects X scenes x subjects matrix

% Pre-allocate
% mat = zeros(512,7,numel(which_sub)-1);
c=1;
for c_sub = 1:length(which_sub)
    
    if c_sub~=20
        % Get this subjects data
        t = raw_data(raw_data.id==c_sub,:);

        % Loop through trials
        for c_trial = 1:length(t.id)
            % Whic object
            ob=t.obj_id(c_trial);%ob=num2str(dat(i,2));ob=[ob(2) ob(3)];ob=str2double(ob);

            % Which scene
            sc=num2str(t.scn_id(c_trial));sc=sc(1);sc=str2double(sc);
            
            % Fill the matrix
            mat(ob,sc,c)=t.rating(c_trial);
        end
        c=c+1;
    end
end

% Get rid of the cells coding for non-existing objects
non_zero = mean(mat(:,1,:),3)~=0;
matGood = mat(non_zero,:,:);

% Get indices for non-existing objects by scene category
h=find(non_zero);
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

%% Select objects based on indexes. Object scores for each of the 7 categs
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

% Get scene names in the same order as we have them here
obj.scene_names= {'beach','desert','mountain','road','savannah','seabed','stadium'};

%% Get ratings by scene

% New and more elegant (and including all objects) way
scn.beach=matGood(:,1,:);
scn.desert=matGood(:,2,:);
scn.mountain=matGood(:,3,:);
scn.road=matGood(:,4,:);
scn.savannah=matGood(:,5,:);
scn.seabed=matGood(:,6,:);
scn.stadium=matGood(:,7,:);

% Get object names in the same order as we have them here
scn.object_names = reshape(indx, size(indx,1)*size(indx,2),1);
scn.object_names = scn.object_names(scn.object_names~=0);

%% Save
save('../../outputs/ratings_by_cat.mat','obj', 'scn')