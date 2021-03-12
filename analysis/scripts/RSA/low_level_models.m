%% Create RDMs from low-level features

% Set where the images are and where we want the output.
maps_path = '..\outputs\';
out_path = '..\outputs\';

%% Saliency (SUN)

% Load saliency maps
load([maps_path, 'sun_saliency_maps.mat']);

% Compute RDM
RDM=compute_RDM_low(sal_mat);

% Let's plot it
subplot(1,3,1), imagesc(RDM);title('SUN saliency')

% Store RDM
low_level.sun_RDM=RDM;

%% Saliency (Saliency Toolbox)

% Load saliency maps
load([maps_path, 'sal_saliency_maps.mat']);

% Compute RDM
RDM=compute_RDM_low(sal_mat);

% Let's plot it
subplot(1,3,2), imagesc(RDM);title('SAL saliency')

% Store RDM
low_level.sal_RDM=RDM;

%% Color

% Load saliency maps
load([maps_path, 'color_maps.mat']);

% Compute RDM
RDM=compute_RDM_low(col_mat);

% Let's plot it
subplot(1,3,3), imagesc(RDM);title('Color')

% Store RDM
low_level.col_RDM=RDM;

%% Save output
save([out_path, 'low_level_RDMs.mat'], 'low_level')

%% Functions
function RDM=compute_RDM_low(data_mat)

    % Pre-allocate
    vec_mat=zeros(size(data_mat,3),size(data_mat,1)*size(data_mat,2));

    % Vectorize saliency maps
    for cIm=1:size(data_mat,3)

        % Select one map
        temp=data_mat(:,:,cIm);

        % Turn it into a vector
        temp=temp(:);

        % Store it
        vec_mat(cIm,:)=temp';

    end

    % Compute RDM
    temp=pdist(vec_mat, 'correlation');
    RDM=squareform(temp);

end