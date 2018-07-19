function ValleyI = ValleyD(JI, scale, uj, sj)

[m, n] = size(JI);
a = [-0.6, -0.4, -0.2, 0, 0.2, 0,4];
% valley size has to be larger than minsize under scale 1-4.
minsize = [32, 128, 512, 2048];
% try a value one by one to find the value gives the most number of valleys
scale = minsize(scale);
MaxVSize = 0;
ValleyI = zeros(m,n);
for i = 1:length(a),
    TJ = uj + a(i)*sj;
    % candidate valley point (< TJ) == 1;
    VP = false(m,n);
    VP(JI <= TJ) = 1;
    % 4-connectivity => candidate valley (large size segments with low J
    % value
    VP_lab = bwlabel(VP,4);
    VPlab_hist = histc(VP_lab(:),1:max(VP_lab(:)));
    sq = find(VPlab_hist>=scale);
    VSize = length(sq);
    if length(sq)>MaxVSize
        ValleyI = zeros(m, n);
        for  k = 1:length(sq)
            ValleyI(VP_lab==sq(k))=k;
        end
        MaxVSize = VSize;
    end   
end


% 
% 
% 
% [m, n] = size(JI);
% % valley size has to be larger than minsize under scale 1-4.
% minsize = [32, 128, 512, 2048];
% % threshold UJ+a*SJ;
% % try a value one by one to find the value gives the most number of valleys
% VP = zeros(m, n);
% scale = minsize(scale);
% % maximum valley size with different a value
% MaxVSize = 0;
% ValleyI = zeros(m,n);
% for i = 1:length(a),
%     SI = zeros(m, n);
%     TJ = uj + a(i)*sj;
%     % candidate valley point (< TJ) == 1;
%     [x, y] = find(JI <= TJ);
%     for j = 1:length(x),
%         VP(x(j), y(j)) = 1;
%     end
%     % 4-connectivity => candidate valley (large size segments with low J
%     % value
%     SI = SeedGrowing(VP,x,y, scale);
%     VSize = max(SI(:));
%     if VSize > MaxVSize,
%         ValleyI = SI;
%         MaxVSize = VSize;
%     end       
% end





