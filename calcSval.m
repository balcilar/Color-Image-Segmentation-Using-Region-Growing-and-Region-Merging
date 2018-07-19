function Sval=calcSval(Stat,Con)

%% Written by Muhammet Balcilar, France
% all rights reverved


Sval=zeros(size(Con,1),1);

for itr=1:size(Con,1)
    muA =Stat{Con(itr,1)}.mean';    
    muB =Stat{Con(itr,2)}.mean';
    covA=Stat{Con(itr,1)}.cov;    
    covB=Stat{Con(itr,2)}.cov;   
    
    Sval(itr)=(muA-muB)'*inv(covA+covB)*(muA-muB);
end

