function [Er,M, nb, P] = kmeansO(X,T,kmax,dyn,bs, killing, pl)

Er=[]; TEr=[];              % error monitorring

[n,d]     = size(X);
P = zeros(n,1);

THRESHOLD = 1e-4;   % relative change in error that is regarded as convergence
nb        = 0;  

% initialize 
if dyn==1            % greedy insertion, possible at all points
  k      = 1;
  M      = mean(X);
  K      = sqdist(X',X');
  L      = X;
elseif dyn==2        % use kd-tree results as means
  k      = kmax;
  M      = kdtree(X,[1:n]',[],1.5*n/k); 
  nb     = size(M,1);
  dyn    = 0;
elseif dyn==3
  L      = kdtree(X,[1:n]',[],1.5*n/bs);  
  nb     = size(L,1);
  k      = 1;
  M      = mean(X);
  K      = sqdist(X',L');
elseif dyn==4
  k      = 1;
  M      = mean(X);
  K      = sqdist(X',X');
  L      = X;
else                 % use random subset of data as means
  k      = kmax;
  tmp    = randperm(n);
  M      = X(tmp(1:k),:); 
end

Wold = realmax;

while k <= kmax
  kill = [];

  % squared Euclidean distances to means; Dist (k x n)
  Dist = sqdist(M',X');  

  % Voronoi partitioning
  [Dwin,Iwin] = min(Dist',[],2);
  P = Iwin;
  
  % error measures and mean updates
  Wnew = sum(Dwin);
 
  % update VQ's
  for i=1:size(M,1)
    I = find(Iwin==i);
    if size(I,1)>d
      M(i,:) = mean(X(I,:));
  elseif killing==1
      kill = [kill; i];
    end
  end

 if 1-Wnew/Wold < THRESHOLD*(10-9*(k==kmax))
    if dyn & k < kmax
   
      if dyn == 4
        best_Er = Wnew; 

        for i=1:n;
    	  Wold = Inf;
       	  Wtmp = Wnew;
          Mtmp = [M; X(i,:)];
          while (1-Wtmp/Wold) > THRESHOLD*10; 
	    Wold = Wtmp;
            Dist = sqdist(Mtmp',X');  
            [Dwin,Iwin] = min(Dist',[],2);
            Wtmp = sum(Dwin);
            for i = 1 : size(Mtmp,1)
              I = find(Iwin==i);
              if size(I,1)>d; Mtmp(i,:) = mean(X(I,:)); end
            end
          end
          if Wtmp < best_Er;   best_M = Mtmp; best_Er = Wtmp; end
        end

        M = best_M;
        Wnew = best_Er;
        if ~isempty(T); tmp=sqdist(T',M'); TEr=[TEr; sum(min(tmp,[],2))];end;
        Er=[Er; Wnew];
        k = k+1;

      else 
        % try to add a new cluster on some point x_i
        [tmp,new] = max(sum(max(repmat(Dwin,1,size(K,2))-K,0)));
        k = k+1;
        M = [M; L(new,:)+eps];
        if pl;        fprintf( 'new cluster, k=%d\n', k);      end
        [Dwin,Iwin] = min(Dist',[],2);
	Wnew        = sum(Dwin);Er=[Er; Wnew];
        if ~isempty(T); tmp=sqdist(T',M'); TEr=[TEr; sum(min(tmp,[],2))];end;
      end
    else
      k = kmax+1;
    end  
  end
  Wold = Wnew;
  if pl
    figure(1); plot(X(:,1),X(:,2),'g.',M(:,1),M(:,2),'k.',M(:,1),M(:,2),'k+');
    drawnow;
  end
end

 Er=[Er; Wnew];
 if ~isempty(T); tmp=sqdist(T',M'); TEr=[TEr; sum(min(tmp,[],2))]; Er=[Er TEr];end;
M(kill,:)=[];

