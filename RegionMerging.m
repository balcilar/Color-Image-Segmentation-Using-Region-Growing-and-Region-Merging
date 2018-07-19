function RegionResult=RegionMerging(image,Region,mnadj,RMThresh)
%% Written by Muhammet Balcilar, France
% all rights reverved



%% main bloc of algorithm

% find which rregions are connected to each other
[N Con]=findNeighbour(Region,mnadj);

% find every regions sttistci which means means and covariances
Stat=findStatistic(Region,image);

% calculate initial regions S similarity values
Sval=calcSval(Stat,Con);

% separate R,G, and B channel of image
R=image(:,:,1);
G=image(:,:,2);
B=image(:,:,3);
R=double(R(:));
G=double(G(:));
B=double(B(:));

% while minimum similarity of connected regions are still less than given
% certain threshold continue the process
while min(Sval)<RMThresh
    % find two region which are connected and has minimum S value
    [a b]=min(Sval);
    % take the region which will be alive
    i=Con(b,1);
    % take the region number which will be dead
    j=Con(b,2);
    % remove this connection and s value since this two region are no
    % longer separate regions they will merge to each other
    Con(b,:)=[];
    Sval(b)=[];
    % make all j th region pixel as ith region
    Region(Region==j)=i;
    % find all pixel which assigned new merged ith region
    I=find(Region==i);
    
    % calculate new merged ith regions statistics
    tmp=[R(I) G(I) B(I)];
    Stat{i}.mean=mean(tmp);
    Stat{i}.cov=cov(tmp);
    
    % make all jth class name as ith since jth class no longer alive
    Con(Con==j)=i;
    % find new merged ith region connections
    I=find(Con(:,1)==i | Con(:,2)==i);
    % calculate new similartiy between the new merged ith class and its
    % neighbourhood
    for itr=1:length(I)
        muA =Stat{Con(I(itr),1)}.mean';
        muB =Stat{Con(I(itr),2)}.mean';
        covA=Stat{Con(I(itr),1)}.cov;
        covB=Stat{Con(I(itr),2)}.cov;        
        Sval(I(itr))=(muA-muB)'*inv(covA+covB)*(muA-muB);
    end
    
end
% rename all region name from 1 to the end ascendend
I=unique(Region(:));
tmp=Region;
for i=1:length(I)
    tmp(Region==I(i))=i;
end
RegionResult=tmp;















