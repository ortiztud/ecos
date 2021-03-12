%% Create a color distribution for each object image
% We are splitting each image into its color channel and concatenating them
% acros the horizontal axis so that we end up with a rows by cols*3 by
% image matrix

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
col_mat=zeros(im_size(1), im_size(2)*3, length(names));

% Loop through names
for cIm=1:length(names)
    
    % Echo
    sprintf('Getting colors for image %d out of %d', cIm, length(names))
    
    % Read-in image
    im = imread([folders{cIm},'\',names{cIm}]);
    
    % Get saliency map
    col_map=[im(:,:,1),im(:,:,2),im(:,:,3)];
    
    % Store it into a X by Y by Image matrix
    col_mat(:,:,cIm)=col_map;
    
end

% Save color matrix that contains all the images
save([out_path, 'color_maps.mat'], 'col_mat')