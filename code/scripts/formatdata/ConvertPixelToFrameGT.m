
pixelgtfile = '../../../data/input/groundtruth/Avenue/01_gt_pixel.mat';
framegtfile = strrep(pixelgtfile,'pixel','frame');

load(pixelgtfile)
for i = 1:size(volLabel)
    
