%% Written by Muhammet Balcilar, France
% all rights reverved

clear all
clc
addpath('docde')


filename = 'Inputs/124084.jpg';
image = imread(filename);

%% Region Growing method
[Region1 Region2 Region3 Region4]=RegionGrowing(image);

figure; imshow(uint8(image));
hold on;
DrawLine(Region1);
hold off;
title('Scale 1');

figure; imshow(uint8(image));
hold on;
DrawLine(Region2);
hold off;
title('Scale 2');

figure; imshow(uint8(image));
hold on;
DrawLine(Region3);
hold off;
title('Scale 3');

figure; imshow(uint8(image));
hold on;
DrawLine(Region4);
hold off;
title('Scale 4');


%% Region merging method 
% method has two parameters minimum adjacent pixel which means connected
% regions has at least this number of pixel connected
mnadj=10;
% threshold value to make decision to merge two region or nor
RMThresh=3.5;

RegionResult=RegionMerging(image,Region1,mnadj,RMThresh);

% figure results
figure; imshow(uint8(image));
hold on;
DrawLine(RegionResult);
hold off;
title('Final segmentation');
