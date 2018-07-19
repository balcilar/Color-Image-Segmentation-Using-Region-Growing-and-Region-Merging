

function Score = LiuYang(Im, CMap)

% image property
[Ih, Iw, d] = size(Im);
% segmentation no.
Rn = max(CMap(:));

% within cluster
Rmean = zeros(Rn, d);
color_err = zeros(1, Rn);
% for each region
for i = 1:Rn,
    sqerr = 0;
    sq = find(CMap == i);
    Si = length(sq);
    for dim = 1:d,
        Ri = zeros(Ih, Iw);
        Aver_id = zeros(Ih, Iw);
        temp1 = Im(:,:,dim);
        Ri(sq) = temp1(sq);
        % Aver_id -- average value
        Aver_id(sq) = sum(Ri(:))/Si;
        Rmean(i,dim) = sum(Ri(:))/Si;
        % squared color error
        sqerr = sqerr + sum(sum((Ri - Aver_id).^2));
    end
    color_err(i) = sqerr / sqrt(Si); 
end
within_err = sum(color_err)/(sqrt(Rn));

% % between cluster
% between_err = sum(pdist(Rmean, 'euclidean')); 

Score = within_err;

