function Region = RegionMerge(IRGB,Imap, ImgS, outseg)

IRGB = double(IRGB);
segnum = max(ImgS(:));
qlv =  max(Imap(:));

nhist = zeros(qlv,segnum);
[row,col] = size(ImgS);
for r = 1:row
    for j = 1:col
        rgind = ImgS(r,j);
        mapind = Imap(r,j);
        nhist(mapind,rgind) = nhist(mapind,rgind)+1;
    end
end

LUT = PNN_fast(ImgS,nhist, outseg);
% LUT = PNN_fast_RGBo(ImgS,IRGB, outseg);

Region = LUT(ImgS);








% 
% 
% 
% [m, n, d] = size(Iq);
% Iq = uint8(Iq);
% % quantized color value and number
% QCvalue = zeros(d, Cno);
% for dd = 1:d, 
%     if(length(unique(Iq(:,:,dd))) == Cno),
%         QCvalue(dd, :) = unique(Iq(:,:,dd));
%     else
%         zvalue = zeros(1, Cno-length(unique(Iq(:,:,dd))));
%         QCvalue(dd, :) = [zvalue'; unique(Iq(:,:,dd))];
%     end
% end
% Cno = Cno*d;
% 
% % region number
% Rno = max(ImgS(:));
% % region color information data
% %  RC -- the histogram data Rno*Cno for clustering input
% RC = zeros(Rno, Cno);
% for i = 1:max(ImgS(:)),
%     Hist = zeros(d, Cno/d);
%     Color = zeros(m, n, d);
%     sq = find(ImgS == i);
%     Color(sq) = Iq(sq);
%     for dim = 1:d,
%         Channel = Color(:,:,dim);
%         a = hist(Channel(:), QCvalue(dim, :));
%         Hist(dim, :) = a;
%     end
%     Hist = reshape(Hist, 1, Cno);
%     RC(i, :) = Hist;
% end
% 
% % calculate distances between regions
% % d channels, sqrt(Dist1+Dist2+Distd)
% 
% ADist = zeros(1, Rno*(Rno-1)/2);
% for dim = 1:d,
%     % each channel: Rno*Cno
%     RCd = RC(:,dim:d:end);
%     Dist = pdist(RCd);
%     ADist = ADist + power(Dist, 2);  
% end
% ADist = sqrt(ADist);
% 
% % single linkage clustering, merge two
% Z = linkage(ADist);
% T = cluster(Z,'maxclust',threshold ); 
% 
% Channel = ImgS;
% for t = 1:Rno,
%     xy = find(Channel == t);
%     ImgS(xy) = T(t);
% end
% 
% I = ImgS;
% % fprintf('%d\n', max(I(:)));
% 
% 
% 



