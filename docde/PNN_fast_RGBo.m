function T = PNN_fast_RGBo(Iseg,IRGB,nseg)

segnum = max(Iseg(:));
n= segnum;
conn = diag(ones(1,segnum));

%get boundary conn
[row,col] = size(Iseg);
diffx = diff(Iseg,1,2);
diffy = diff(Iseg,1,1);
sq1 = find(diffx);
sq2 = find(diffy);
for t = 1:length(sq1)
    v1 = Iseg(sq1(t));
    v2 = Iseg(sq1(t)+ row);
    conn(v1,v2) = 1;
    conn(v2,v1) = 1;
end
for t = 1:length(sq2)
    v1 = Iseg(sq2(t));
    v2 = Iseg(sq2(t)+ 1);
    conn(v1,v2) = 1;
    conn(v2,v1) = 1;
end

histnum = zeros(1,segnum);
histval = zeros(3,segnum);
for r= 1:row
    for c = 1:col
        segind = Iseg(r,c);
        histnum(segind) = histnum(segind) +1;
        tmp = IRGB(r,c,:);
        tmp = tmp(:);
        histval(:,segind) = histval(:,segind) +tmp;
    end
end
histval = histval./repmat(histnum,3,1);
qlv = 3;




% %dist between phist
% distv = pdist(histval','euclidean');%probably KL distance is a better choice, use method in the paper here.
% %also, original image's mean RGB value can be considered.
% distv = distv.^2;
% distv = squareform(distv);
distv = sqdist(histval, histval);
Y = distv;
Y(conn==0)= inf;

minY_col = zeros(1,n);
minY_colsq = zeros(1,n);
for i = 1:n
    j1 = 1:(i-1);
    j2 = (i+1):n;
    jtmp = [j1 j2];
    ytmp = Y(i,jtmp);
    [tmp1,tmp2] = min(ytmp);
    minY_col(i) = tmp1;
    minY_colsq(i) = jtmp(tmp2);
end

R = 1:n;%n: number of vector
Z = zeros(n-1,3); % allocate the output matrix.
% during updating clusters, cluster index is constantly changing, R is
% a index vector mapping the original index to the current (row, column)
% index in Y.  N denotes how many points are contained in each cluster.
N = zeros(1,2*n-1);
N(1:n) = histnum;
centers = zeros(2*n-1,qlv);
centers(1:n,:) = histval';

for s = 1:(n-1)
    %    [v, k] = min(Y);
    ncur = length(minY_col);
    [v, k] = min(minY_col);
    ctmp = k;
    rtmp = minY_colsq(k);

    Z(s,:) = [R(rtmp) R(ctmp) v]; % update one more row to the output matrix A
    if s<n-1        
        % Update Y.
        i = min([rtmp ctmp]);
        j = max([rtmp ctmp]);
        I1 = 1:(i-1);
        I2 = (i+1):(j-1);
        I3 = (j+1):ncur; % these are temp variables
        U = [I1 I2 I3];
        n1 = N(R(i));
        n2 = N(R(j));
        %updata conn
        t1 = conn(i,:);
        t2 = conn(j,:);
        t = t1|t2;
        conn(i,:) = t;
        conn(:,i) = t;
        tmp = conn(ncur,:);
        conn(j,:) = tmp;
        conn(:,j) = tmp;
        centers(n+s, :) = (n1*centers(R(i),:)+ n2*centers(R(j),:))/ (n1+n2);
        dtmp = (centers(R(U),:)-  repmat(centers(n+s,:),length(U),1));
        tmpY = sum(dtmp.^2,2);%merge min dist for two centriod?   
        tmpY(conn(i,U)==0) = inf;
        
        Y(i,i) = 0;
        Y(i,U) = tmpY;
        Y(U,i) = tmpY;
        tmp = Y(ncur,1:ncur);
        Y(j,1:ncur) = tmp;
        Y(1:ncur,j) = tmp;
        
        [mintmpY,mintmpYsq] = min(tmpY);
        %    minY_col(j)= minY_col(end);
        %    minY_colsq(j)=minY_colsq(end);
        minY_col(i) = mintmpY;
        minY_colsq(i) = U(mintmpYsq);
              
        for sq = 1:length(tmpY)
            coltmp = U(sq);
            if (minY_colsq(coltmp)~=i)&&(minY_colsq(coltmp)~=j)
                if (tmpY(sq)<minY_col(coltmp))
                    minY_col(coltmp) = tmpY(sq);
                    minY_colsq(coltmp) = i;
                end
            else
                %must update
                n1 = ncur-1;
                if coltmp==ncur
%                     tmpY2 = Deall(1:n1,j)./DRall(1:n1,j);
                    i0 = 1:(j-1);
                    j0 = (j+1):n1;
                    u0 = [i0 j0];
                    tmpY2 = Y(u0,j);
                else
                    i0 = 1:(coltmp-1);
                    j0 = (coltmp+1):n1;
                    u0 = [i0 j0];
                    tmpY2 = Y(u0,coltmp);
%                      tmpY2 = Deall(1:n1,coltmp)./DRall(1:n1,coltmp);
                end
                [mintmp1,mintmp1sq]=min(tmpY2);
                mintmp1sq = u0(mintmp1sq);
                minY_col(coltmp) = mintmp1;
                minY_colsq(coltmp) =mintmp1sq;                
            end
        end     
        minY_colsq(minY_colsq==ncur) = j;
        minY_col(j) = minY_col(end);
        minY_colsq(j) = minY_colsq(end);
        minY_col(end) = [];
        minY_colsq(end) = [];
        N(n+s) = N(R(i)) + N(R(j));
        R(i) = n+s;
        R(j) = R(end);
        R(end) = [];
    end
end

T = cluster(Z,'maxclust',nseg );
