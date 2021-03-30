%% Read in raw data and sort objects based on ratings
% We will load participants ratings on the semantic relatedness task and
% perform some aggregation to make data easier to handle.

clear
close all

%% Read in data
% Set where the data is and where we want the output.
val_path = '..\validation_data\';
out_path = '..\outputs\';

% Load data
dat = readtable([val_path, 'group_task-validation_ratings.csv']);

%% Go through all the data and separate them into subjects 
a=1;
for i=1:length(dat)%sub=1:40
    %     for i=1+657*(sub-1):658+657*(sub-1)
    if dat(i,1)==a
        ob=dat(i,2);%ob=num2str(dat(i,2));ob=[ob(2) ob(3)];ob=str2double(ob);
        sc=num2str(dat(i,3));sc=sc(1);sc=str2double(sc);
        mat(ob,sc,a)=dat(i,5);
    else
        a=a+1;
        ob=dat(i,2);%ob=num2str(dat(i,2));ob=[ob(2) ob(3)];ob=str2double(ob);
        sc=num2str(dat(i,3));sc=sc(1);sc=str2double(sc);
        mat(ob,sc,a)=dat(i,5);
    end
end

% Get rid of the anoying zeros
c=1;
for i=1:size(mat,1)
    if mat(i,1,1)~=0
        matGood(c,:,:)=mat(i,:,:);
        c=c+1;
    end
end

% Get indexes
b=mat(:,1,1);
h=find(b~=0);
c=1;
d=1;
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


save('objectsCat.mat','obj')
%% Get ratings by scene
% Old way (only considers 10 objects per category)
% mat2=[];
% for i=1:7
%     mat2=[mat2;mat(1+100*i:10+i*100,:,:)];
% end
% avMat=mean(mat2,3);
% beach=avMat(:,1);
% desert=avMat(:,2);
% mountain=avMat(:,3);
% road=avMat(:,4);
% savanah=avMat(:,5);
% seabed=avMat(:,6);
% stadium=avMat(:,7);

% c=1
% for j=1:7
%     for i=1:10
%         stim(c)=100*j+i;
%         c=c+1;
%     end
% end

% New and more elegant (and including all objects) way
scn.beach=mean(matGood(:,1,:),3);
scn.desert=mean(matGood(:,2,:),3);
scn.mountain=mean(matGood(:,3,:),3);
scn.road=mean(matGood(:,4,:),3);
scn.savannah=mean(matGood(:,5,:),3);
scn.seabed=mean(matGood(:,6,:),3);
scn.stadium=mean(matGood(:,7,:),3);

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

% Let's make it discrete
scn_mat(scn_mat>60)=10000;
scn_mat(scn_mat<-60)=-10000;
scn_mat(scn_mat<60 & scn_mat>-60)=-0;
for i=1:7
    scn_mat(:,i)=sort(scn_mat(:,i));
end
subplot(2,4,8), imagesc(scn_mat)
xticks(1:7);xticklabels({'beach';'desert';'mountain';'savannah';'road';'seabed';'stadium'})
xtickangle(45)

% Get numbers
selected_scn=[1:7];
for i=selected_scn
    scn_nb(i,1)=sum(scn_mat(:,i)==10000);
%     scn_nb(i,2)=sum(scn_mat(:,i)~=-10000 & scn_mat(:,i)~=10000);
     scn_nb(i,2)=sum(scn_mat(:,i)==0);
    scn_nb(i,3)=sum(scn_mat(:,i)==-10000);
end


%% Select unique objects for three scenes
% Let's try to select 7 objects for each scene for each cogruity condition.
scn_mat=[scn.beach, scn.desert, scn.mountain,scn.savannah,scn.road,scn.seabed,scn.stadium];
obj_names_mat=[obj.beachOb; obj.desertOb; obj.mountainOb;obj.savanahOb;obj.roadOb;obj.seabedOb;obj.stadiumOb];

for cScn=1:7
    con_obj=[];inc_obj=[];neu_obj=[];
    try
        %%%Congruent
        % Get relational values
        relat_values=scn_mat(scn_mat(:,cScn)>60);
        
        % Sort relational values
        [a,ind]=sort(relat_values, 'Descend');
        
        % Sort objects
        sort_obj=obj_names_mat(ind);
        
        % Select the top 7 objects and their relational values
        con_obj=sort_obj(1:7);
        con_relat=relat_values(ind(1:7));
        find(obj_names_mat,con_obj)
        %%%Incongruent
        % Get relational values
        relat_values=scn_mat(scn_mat(:,cScn)<-60);
        
        % Sort relational values
        [a,ind]=sort(relat_values, 'Ascend');
        
        % Sort objects
        sort_obj=obj_names_mat(ind);
        
        % Select the top 7 objects and their relational values
        inc_obj=sort_obj(1:7);
        inc_relat=relat_values(ind(1:7));
        
        %%%Neutral
        % Get relational values
        relat_values=scn_mat(scn_mat(:,cScn)<60 & scn_mat(:,1)>-60);
        
        % Sort relational values
        [a,ind]=sort(abs(relat_values), 'Ascend');
        
        % Sort objects
        sort_obj=obj_names_mat(ind);
        
        % Select the top 7 objects and their relational values
        neu_obj=sort_obj(1:7);
        neu_relat=relat_values(ind(1:7));
        
        % Store objects
        set{cScn}=[con_obj,neu_obj,inc_obj];
    catch
        ['Scene ' num2str(cScn) ' does not have enough objects']
    end
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
    im=imread(['../cosas a subir a ECOS web/objects/' num2str(beachOr(j,2)) '.png']);
    subplot(2,4,1),imagesc([j j+2], [beachOr(j,1)+10 beachOr(j,1)], im);
end
axis([0 100 -100 110])
set(gcf, 'InvertHardcopy', 'off')
print('../results/beach','-dpng')

% figure
subplot(2,4,2),plot(desertOr(:,1))
title('desert')
hold on
for j=1:length(stim)
    if desertOr(j,2)<300 && desertOr(j,2)>150
        subplot(2,4,2),imagesc([j-.5 j+2.5], [desertOr(j,1)+10.5 desertOr(j,1)-.5], hL);
    end
    im=imread(['../cosas a subir a ECOS web/objects/' num2str(desertOr(j,2)) '.png']);
    subplot(2,4,2),imagesc([j j+2], [desertOr(j,1)+10 desertOr(j,1)], im);
end
axis([0 100 -100 110])
set(gcf, 'InvertHardcopy', 'off')
print('../results/desert','-dpng')

% figure
subplot(2,4,3),plot(mountainOr(:,1))
title('mountain')
hold on
for j=1:length(stim)
    if mountainOr(j,2)<400 && mountainOr(j,2)>250
        subplot(2,4,3),imagesc([j-.5 j+2.5], [mountainOr(j,1)+10.5 mountainOr(j,1)-.5], hL);
    end
    im=imread(['../cosas a subir a ECOS web/objects/' num2str(mountainOr(j,2)) '.png']);
    subplot(2,4,3),imagesc([j j+2], [mountainOr(j,1)+10 mountainOr(j,1)], im);
end
axis([0 100 -100 110])
set(gcf, 'InvertHardcopy', 'off')
print('../results/mount','-dpng')

% figure
subplot(2,4,4),plot(savanahOr(:,1))
title('savanah')
hold on
for j=1:length(stim)
    if savanahOr(j,2)<600 && savanahOr(j,2)>450
        subplot(2,4,4),imagesc([j-.5 j+2.5], [savanahOr(j,1)+10.5 savanahOr(j,1)-.5], hL);
    end
    im=imread(['../cosas a subir a ECOS web/objects/' num2str(savanahOr(j,2)) '.png']);
    subplot(2,4,4),imagesc([j j+2], [savanahOr(j,1)+10 savanahOr(j,1)], im);
end
axis([0 100 -100 110])
set(gcf, 'InvertHardcopy', 'off')
print('../results/savanah','-dpng')

% figure
subplot(2,4,5),plot(roadOr(:,1))
title('road')
hold on
for j=1:length(stim)
    if roadOr(j,2)<500 && roadOr(j,2)>350
        subplot(2,4,5),imagesc([j-.5 j+2.5], [roadOr(j,1)+10.5 roadOr(j,1)-.5], hL);
    end
    im=imread(['../cosas a subir a ECOS web/objects/' num2str(roadOr(j,2)) '.png']);
    subplot(2,4,5),imagesc([j j+2], [roadOr(j,1)+10 roadOr(j,1)], im);
end
axis([0 100 -100 110])
set(gcf, 'InvertHardcopy', 'off')
print('../results/road','-dpng')

% figure
subplot(2,4,6),plot(seabedOr(:,1))
title('seabed')
hold on
for j=1:length(stim)
    if seabedOr(j,2)<700 && seabedOr(j,2)>550
        subplot(2,4,6),imagesc([j-.5 j+2.5], [seabedOr(j,1)+10.5 seabedOr(j,1)-.5], hL);
    end
    im=imread(['../cosas a subir a ECOS web/objects/' num2str(seabedOr(j,2)) '.png']);
    subplot(2,4,6),imagesc([j j+2], [seabedOr(j,1)+10 seabedOr(j,1)], im);
end
axis([0 100 -100 110])
set(gcf, 'InvertHardcopy', 'off')
print('../results/seabed','-dpng')

% figure
 subplot(2,4,7),plot(stadiumOr(:,1))
title('stadium ')
hold on
for j=1:length(stim)
    if stadiumOr(j,2)<800 && stadiumOr(j,2)>650
         subplot(2,4,7),imagesc([j-.5 j+2.5], [stadiumOr(j,1)+10.5 stadiumOr(j,1)-.5], hL);
    end
    im=imread(['../cosas a subir a ECOS web/objects/' num2str(stadiumOr(j,2)) '.png']);
     subplot(2,4,7),imagesc([j j+2], [stadiumOr(j,1)+10 stadiumOr(j,1)], im);
end
axis([0 100 -100 110])
set(gcf, 'InvertHardcopy', 'off')
print('../results/stadium','-dpng')

keep beachOr desertOr mountainOr savanahOr roadOr seabedOr stadiumOr