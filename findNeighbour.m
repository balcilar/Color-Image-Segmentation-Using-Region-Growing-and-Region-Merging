function [N Con]=findNeighbour(Region,mnadj)

%% Written by Muhammet Balcilar, France
% all rights reverved

n=length(unique(Region(:)));
N=zeros(n,n);
Con=[];

for i=1:size(Region,1)-1
    for j=1:size(Region,2)-1
        tmp=Region(i:i+1,j:j+1);
        I=unique(tmp(:));
        if length(I)>1
            
            if N(I(1),I(2))==mnadj-1
                Con=[Con;min(I(1),I(2)) max(I(1),I(2)) ];
            end
            N(I(1),I(2))=N(I(1),I(2))+1;
            N(I(2),I(1))=N(I(2),I(1))+1;
        end
    end
end
            
