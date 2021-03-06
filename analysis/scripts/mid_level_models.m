%% Create model RDMs from natural and animacy categories

% Set where the images are and where we want the output.
table_path = '..\..\';
out_path = '..\outputs\';

% List files in the directory
db_info=readtable([table_path, 'ecos_summary_table.xlsx'], 'Sheet', 'Object');

%% Natural vs artificial

% Pre-allocate
nat_RDM=zeros(size(db_info,1));

% Loop through objects
for cIm=1:size(db_info,1)
    
    % Echo
    sprintf('Building RDM for image %d out of %d', cIm, size(db_info,1))
    
    for cIm2=1:size(db_info,1)
        
        if db_info.natural(cIm)==db_info.natural(cIm2)
            nat_RDM(cIm,cIm2)=1;
        else
            nat_RDM(cIm,cIm2)=0;
        end
    end
end

% Store RDM
mid_level.nat_RDM=nat_RDM;

%% Animated vs innanimated

% Pre-allocate
ani_RDM=zeros(size(db_info,1));

% Loop through objects
for cIm=1:size(db_info,1)
    
    % Echo
    sprintf('Building RDM for image %d out of %d', cIm, size(db_info,1))
    
    for cIm2=1:size(db_info,1)
        
        if db_info.animate(cIm)==db_info.animate(cIm2)
            ani_RDM(cIm,cIm2)=1;
        else
            ani_RDM(cIm,cIm2)=0;
        end
    end
end

% Store RDM
mid_level.ani_RDM=ani_RDM;

%% Save output
save([out_path, 'mid_level_RDMs.mat'], 'mid_level')