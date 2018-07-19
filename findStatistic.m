function Stat=findStatistic(Region,image)
%% Written by Muhammet Balcilar, France
% all rights reverved
n=length(unique(Region(:)));

R=image(:,:,1);
G=image(:,:,2);
B=image(:,:,3);

R=double(R(:));
G=double(G(:));
B=double(B(:));

region=Region(:);

for i=1:n
    I=find(region==i);
    tmp=[R(I) G(I) B(I)];
    Stat{i}.mean=mean(tmp);
    Stat{i}.cov=cov(tmp);
end
    






