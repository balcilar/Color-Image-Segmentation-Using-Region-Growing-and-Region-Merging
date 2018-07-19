

function Score = Borsotti(Im, CMap)
% image property
[Ih, Iw, d] = size(Im);
SI = Ih*Iw;
% segmentation no.
Rn = max(CMap(:));

% within cluster
Rmean = zeros(Rn, d);
color_err = zeros(1, Rn);
Area = zeros(1, Rn);
for j = 1:Rn,
    Area(j) = length(find(CMap == j));
end
% N(x) -- the number of regions have area x (stupid way to calculate)
for x = 1:Rn,
    Nx(x) = length(find(Area == Area(x)));
end

% for each region
for i = 1:Rn,
    sqerr = 0;
    sq = find(CMap == i);
    Si = Area(i);
    
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
    color_err(i) = sqerr / (1+log(Si)) + (Nx(i)/Si)^2; 
end
within_err = 1/(1000*SI)*sqrt(Rn)*sum(color_err);

Score = within_err;

