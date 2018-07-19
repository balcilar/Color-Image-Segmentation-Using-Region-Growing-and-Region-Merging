

function [Einter, Eintra, Score] = Fratio(Im, CMap)

% image property
[Ih, Iw, d] = size(Im);
% segmentation no.
Rn = max(CMap(:));
% image average
for dd = 1:d,
    Channel = Im(:,:,dd);
    Imean(1,dd) = mean(Channel(:));
end

% segmented image with average color of that region
Seg = zeros(Ih, Iw, d);
Einter = 0;
% for each region
for i = 1:Rn,
    sq = find(CMap == i);
    Si = length(sq);   
    for dim = 1:d,
        Aver_id = zeros(Ih, Iw);
        Ri = zeros(Ih, Iw);
        temp1 = Im(:,:,dim);
        Ri(sq) = temp1(sq);
        Aver_id(sq) = sum(Ri(:))/Si;
        Rmean(1,dim) = sum(Ri(:))/Si;
        Ri(sq) = Aver_id(sq);        
        Seg(:,:,dim) = Seg(:,:,dim) + Ri;
    end
    dist = sum((Rmean-Imean).^2) *Si;
    Einter = Einter + dist;
end
Einter = Einter/(Ih*Iw);

% intra-region error
Diff = zeros(Ih, Iw, d);
Diff = double(Im) - Seg;
Diff = Diff(:,:,1).^2 + Diff(:,:,2).^2 + Diff(:,:,3).^2;

Eintra = sum(Diff(:))/(Ih*Iw);

Score = Rn*Eintra/Einter;




