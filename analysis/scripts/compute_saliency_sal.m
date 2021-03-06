%% Use Saliency Toolbox to compute pixel-level saliency

% Add SUN's toolbox
addpath('C:\Users\Javier\Documents\MATLAB\SaliencyToolbox')

% Set where the images are and where we want the output.
obj_path = '..\..\ECOS_database\objects\';
out_path = '..\outputs\';

% List files in the directory
temp=dir([obj_path, '*.png']);
for cIm=1:length(temp)
    
    % Get names
    names{cIm}=temp(cIm).name;
    
    % Get folder
    folders{cIm}=temp(cIm).folder;
    
end

% Read one image to get the dimmensions right
im = imread([folders{1},'\',names{1}]);
im_size = size(im);


% Pre-allocate
sal_mat=zeros(im_size(1:2));

% Loop through names
for cIm=1:length(names)
    
    % Echo
    sprintf('Computing saliency for image %d out of %d', cIm, length(names))
    
    % Get saliency map
    img=initializeImage([folders{cIm},'\',names{cIm}]);
    params = defaultSaliencyParams;
    sal_out = makeSaliencyMap(img,params);
    big_map = imresize(sal_out.data,img.size(1:2));
    
    % Store it into a X by Y by Image matrix in its original size
    sal_mat(:,:,cIm)= big_map;
    
end

% Save saliency matrix that contains all the images
save([out_path, 'sal_saliency_maps.mat'], 'sal_mat')