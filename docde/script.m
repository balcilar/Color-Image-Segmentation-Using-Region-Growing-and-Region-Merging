clear all
clc


filename = ['124084.jpg'];
image_org = imread(filename);
[m,n,d] = size(image_org);
% figure; imshow(image_org);



X = reshape(double(image_org), m*n,d);
[tmp,M,tmp2,P] = kmeansO(X,[],16,0,0,0,0);
map = reshape(P, m, n);



    for w = 1:4,
        W = GenerateWindow(w);
        JI = JImage(map, W);
        save([num2str(w) '.mat'], 'JI');
        imwrite(JI, ['JImage' num2str(w) '.jpg']);
    end


 load('4.mat');
 JI4 = JI;
 load('3.mat');
 JI3 = JI;
 load('2.mat');
 JI2 = JI;
 load('1.mat');
 JI1 = JI;
%


ImgQ = class2Img(map, image_org);

Region = zeros(m, n);


u = mean(JI4(:));
s = std(JI4(:));
Region = ValleyD(JI4,  4, u, s); % 4.1 Valley Determination
Region = ValleyG1(JI4, Region);  % 4.2.2 Growing
Region = ValleyG1(JI3, Region);  % 4.2.3 Growing at next smaller scale
Region = ValleyG2(JI1, Region);  % 4.2.4 remaining pixels at the smallest scale
Region4 = Region;
fprintf('scale4: %d\n', max(Region(:)));

figure; imshow(uint8(ImgQ));
hold on;
DrawLine(Region);
hold off;

w = 3;
    Region = SpatialSeg(JI3, Region, w);
    
    Region = ValleyG1(JI2, Region);
    
    Region = ValleyG2(JI1, Region);
    Region3 = Region;
    fprintf('scale3: %d\n', max(Region(:)));
figure; imshow(uint8(ImgQ));
hold on;
DrawLine(Region);
hold off;


w = 2;
    Region = SpatialSeg(JI2, Region, w);
    
    Region = ValleyG1(JI1, Region);
    
    Region = ValleyG2(JI1, Region);
    Region2 = Region;
    fprintf('scale2: %d\n', max(Region(:)));
figure; imshow(uint8(ImgQ));
hold on;
DrawLine(Region);
hold off;


w = 1;
    Region = SpatialSeg(JI1, Region, w);
    Region = ValleyG2(JI1, Region);
    Region1 = Region;
    fprintf('scale1: %d\n', max(Region(:))); 
figure; imshow(uint8(ImgQ));
hold on;
DrawLine(Region);
hold off;



Region0 = RegionMerge_RGB(image_org,map,  Region, 9);
figure; imshow(uint8(ImgQ));
hold on;
DrawLine(Region0);
hold off;


