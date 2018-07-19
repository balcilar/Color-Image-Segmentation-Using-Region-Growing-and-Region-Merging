function ImgSeg = SpatialSeg(JI, RS, wi)

[m, n] = size(JI);
ImgSeg = zeros(m,n);
Sno = 0;
% figure;
for r = 1:max(RS(:)),    
    % one region to multiple 
    Region = zeros(m,n);
    Region(:, :) = NaN;
    temp = [];
    xy = find(RS == r);
    Region(xy) = JI(xy);
    temp = [temp JI(xy)];
    u = sum(temp)/length(xy);
    s = std(temp);
    
    Region = ValleyD(Region,  wi, u, s);
    sq = find(Region ~=0);
    Region(sq) = Region(sq) + Sno;
    ImgSeg = ImgSeg + Region;
    Sno = max(ImgSeg(:)); 
% %     fprintf('%d\n', Sno);
% %     imshow(ImgSeg);
% %     hold on;
% %     pause(2)
end

ImgSeg = ValleyG1(JI, ImgSeg);


