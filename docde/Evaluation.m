% clear all
clc

filename = ['124084'];
image_org = imread(filename);
[m,n,d] = size(image_org);
% figure; imshow(image_org);

% class_map from clustering algorithms
pa_filename = ['woman6.pa'];
PA = load(pa_filename);
if length(PA) == m*n %&& length(find(PA==0))~=0,
    map = reshape(PA, m, n);
    map = map+1;
else
    fprintf('something wrong!!\n');
end

% % generate J images
    for w = 1:4,
        W = GenerateWindow(w);
        JI = JImage(map, W);
        save([num2str(w) '.mat'], 'JI');
%         imwrite(JI, ['JImage' num2str(w) '.jpg']);
    end

    
load('4.mat');
JI4 = JI;
load('3.mat');
JI3 = JI;
load('2.mat');
JI2 = JI;
load('1.mat');
JI1 = JI;

% quantized image 
ImgQ = class2Img(map, image_org);

Region = zeros(m, n);
% --------------------scale 4--------------------
% scale 4
u = mean(JI4(:));
s = std(JI4(:));
Region = ValleyD(JI4,  4, u, s); % 4.1 Valley Determination
Region = ValleyG1(JI4, Region);  % 4.2.2 Growing
Region = ValleyG1(JI3, Region);  % 4.2.3 Growing at next smaller scale
Region = ValleyG2(JI1, Region);  % 4.2.4 remaining pixels at the smallest scale
Region4 = Region;
fprintf('scale4: %d\n', max(Region(:)));
% draw segments
figure; imshow(uint8(ImgQ));
hold on;
DrawLine(Region);
hold off;
% --------------------scale 3--------------------
w = 3;
    Region = SpatialSeg(JI3, Region, w);
    % Valley Growing at the next smaller scale level
    Region = ValleyG1(JI2, Region);
    % Valley Growing at the smallest scale level
    Region = ValleyG2(JI1, Region);
    Region3 = Region;
    fprintf('scale3: %d\n', max(Region(:)));
figure; imshow(uint8(ImgQ));
hold on;
DrawLine(Region);
hold off;
% --------------------scale 2--------------------
% SpatialSeg includes one ValleyD and ValleyG1 at current scale level
w = 2;
    Region = SpatialSeg(JI2, Region, w);
    % Valley Growing at the next smaller scale level
    Region = ValleyG1(JI1, Region);
    % Valley Growing at the smallest scale level
    Region = ValleyG2(JI1, Region);
    Region2 = Region;
    fprintf('scale2: %d\n', max(Region(:)));
figure; imshow(uint8(ImgQ));
hold on;
DrawLine(Region);
hold off;

% % % % % % --------------------scale 1--------------------
w = 1;
    Region = SpatialSeg(JI1, Region, w);
    Region = ValleyG2(JI1, Region);
    Region1 = Region;
    fprintf('scale1: %d\n', max(Region(:))); 
figure; imshow(uint8(ImgQ));
hold on;
DrawLine(Region);
hold off;

% determining the number of segments
index = [];
for t = 2:10,
    Region0 = RegionMerge_RGB(image_org, map,  Region, t);
    [Einter, Eintra, Score] = Fratio(image_org, Region0);
    index = [index; Score];
end

% plot the "optimal" segmentation
[seg_no index_value] = min[index];
seg_no = seg_no + 1;
Region0 = RegionMerge_RGB(image_org, map,  Region, seg_no);
figure; imshow(uint8(ImgQ));
hold on;
DrawLine(Region0);
hold off;

