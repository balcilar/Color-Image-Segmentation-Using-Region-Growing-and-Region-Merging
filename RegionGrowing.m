function [Region1 Region2 Region3 Region4]=RegionGrowing(image_org)

%% Written by Muhammet Balcilar, France
% all rights reverved


[m,n,d] = size(image_org);


X = reshape(double(image_org), m*n,d);
[tmp,M,tmp2,P] = kmeansO(X,[],16,0,0,0,0);
map = reshape(P, m, n);

for w = 1:4
    W = GenerateWindow(w);
    JI{w} = JImage(map, W);    
end


ImgQ = class2Img(map, image_org);
Region = zeros(m, n);

u = mean(JI{4}(:));
s = std(JI{4}(:));
Region = ValleyD(JI{4},  4, u, s); 
Region = ValleyG1(JI{4}, Region);  
Region = ValleyG1(JI{3}, Region);  
Region = ValleyG2(JI{1}, Region);  
Region4 = Region;


w = 3;
Region = SpatialSeg(JI{3}, Region, w);
Region = ValleyG1(JI{2}, Region);
Region = ValleyG2(JI{1}, Region);
Region3 = Region;

w = 2;
Region = SpatialSeg(JI{2}, Region, w);
Region = ValleyG1(JI{1}, Region);
Region = ValleyG2(JI{1}, Region);
Region2 = Region;

w = 1;
Region = SpatialSeg(JI{1}, Region, w);
Region = ValleyG2(JI{1}, Region);
Region1 = Region;




