


function SegI = ValleyG1(JI, ValleyI)
% valley growing: new regions grow from the valleys
% RemainI: 0 means processed; non-0 means remaining
%% revise by Minjie
[m, n] = size(ValleyI);

% step1. remove the holes

ValleyI = imfill(ValleyI, 'holes');
SegI = ValleyI;

% step2. for the remaining unsegmented part
sq_remain = find(ValleyI == 0);
JIhigh = JI(sq_remain);
u = mean(JIhigh);
sq_medth = sq_remain(JIhigh<u);


% dilation on the ValleyI
se1 = strel('diamond',1);
bw_ValleyI = imdilate(ValleyI, se1);
% GArea = zeros(m,n);

GArea= false(m,n);
GArea(sq_medth) = 1;
bw_GArea = bwlabel(logical(GArea),4);
for t = 1:max(bw_GArea(:)),
    sq = find(bw_GArea == t);
    Areaval = bw_ValleyI(sq);
    tmp = unique(Areaval);
    numnnz = nnz(tmp);
    if numnnz==1
        tmp = tmp(tmp>0);
        SegI(sq) = tmp;
    end
end

%%
% [m, n] = size(ValleyI);
% 
% % step1. remove the holes by morphological filtering
% se = strel('square',3);
% ValleyI = imclose(ValleyI, se);
% 
% SegI = ValleyI;
% 
% % step2. for the remaining unsegmented part
% sq_remain = find(ValleyI == 0);
% JIhigh = JI(sq_remain);
% u = mean(JIhigh);
% sq_medth = sq_remain(JIhigh<u);
% 
% bw_ValleyI = bwlabel(logical(ValleyI),4);
% % dilation on the ValleyI
% se1 = strel('diamond',1);
% bw_ValleyI = imdilate(bw_ValleyI, se1);
% % GArea = zeros(m,n);
% 
% GArea= false(m,n);
% GArea(sq_medth) = 1;
% bw_GArea = bwlabel(logical(GArea),4);
% for t = 1:max(bw_GArea(:)),
% %     tmp = [];
% %     RemainI = zeros(m,n);
%     sq = find(bw_GArea == t);
%     Areaval = bw_ValleyI(sq);
%     numnnz = nnz(unique(Areaval));
%     if numnnz==1
%         SegI(sq) = 1;
%     end
%     
% %     for l = 1:length(gx),
% %         temp = ValleyI(gx(l), gy(l));
% %         tmp = [tmp temp];
% %         RemainI(gx(l), gy(l)) = 1;
% %     end
% %     if (length(unique(tmp(find(tmp ~= 0)))) == 1)
% %         for s = 1:length(gx),
% %             SegI(gx(s), gy(s)) = unique(tmp(find(tmp ~= 0)));
% %         end  
% %     else
% %         if length(gx) > minsize,
% %             for s = 1:length(gx),
% %                 RemainI(gx(s), gy(s)) = RemainI(gx(s), gy(s)) + max(SegI(:));
% %             end
% %             SegI = SegI + RemainI;
% %         end
% %     end
% end
% 
% 
% % RemainI = zeros(m,n);  
% % [x, y] = find(ValleyI == 0);
% % for i = 1:length(x),
% %     RemainI(x(i), y(i)) = JI(x(i), y(i));
% % end
% 
% % u = sum(RemainI(:))/length(x);
% 
% % get the image part under u in the remaining part, region grow
% 
% 
% % region grow
% % GArea = SeedGrowing(GArea, gx, gy, 1);
% % bw_GArea = bwlabel(logical(GArea),4);
% % % dilation on the ValleyI
% % se1 = strel('diamond',1);
% % bw_GAread = imdilate(bw_GArea, se1);
% 
% 
% 
% 
% 
% 
% 



