function [ matrix ] = Stitch( img1_src, img2_src )
%STITCH Summary of this function goes here
%   Detailed explanation goes here
    img1 = imread(img1_src); 
    img2 = imread(img2_src); 
    [img_res, matrix] = imMosaic(img1, img2);
    figure; 
    imshow(img_res);
end

