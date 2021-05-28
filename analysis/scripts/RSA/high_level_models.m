%% Create model RDMs from natural and animacy categories

% Set where the images are and where we want the output.
table_path = '../../../';
out_path = '../../outputs/';

% List files in the directory
db_info=readtable([table_path, 'ecos_summary_table.xlsx'], 'Sheet', 'Object');

%% Natural vs artificial

% Pre-allocate
cat_RDM=zeros(size(db_info,1));

% Loop through objects
for cIm=1:size(db_info,1)
    
    % Echo
    sprintf('Building RDM for image %d out of %d', cIm, size(db_info,1))
    
    for cIm2=1:size(db_info,1)
        
        if db_info.category_num(cIm)==db_info.category_num(cIm2)
            cat_RDM(cIm,cIm2)=1;
        else
            cat_RDM(cIm,cIm2)=0;
        end
    end
end

% Store RDM
high_level.cat_RDM=cat_RDM;

%% Save output
save([out_path, 'high_level_RDMs.mat'], 'high_level')