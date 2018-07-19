


function Seg = SeedGrowing(BI,seed_x,seed_y, minsize)

[m,n] = size(BI);
% output segments 
Seg = zeros(m, n);
NumV = 0;
% flag image (find which pixel is processed)
J = ones(m, n);

% 3 is the neighbour size
x_direction = [-1, 0, 1, 0];
y_direction = [ 0, 1, 0, -1];

for i = 1:length(seed_x)
   if(J(seed_x(i), seed_y(i))==0)
       continue;
   else
       seedx = zeros(m*n, 1);
       seedy = zeros(m*n, 1);       
       nStart = 1;
       nEnd = 1;
       seedx(1) = seed_x(i);
       seedy(1) = seed_y(i);
       J(seed_x(i),seed_y(i)) = 0;
       while(nStart <= nEnd),
           current_x = seedx(nStart);
           current_y = seedy(nStart);
           for k = 1:4,          
              current_xx = current_x + x_direction(k);
              current_yy = current_y + y_direction(k);
              if (current_xx > 0 && current_xx < m ...
                && current_yy > 0 && current_yy < n )
                  if(BI(current_xx, current_yy) == 1 && J(current_xx, current_yy) ==1)
                      J(current_xx, current_yy) = 0;
                      nEnd = nEnd + 1;
                      seedx(nEnd) = current_xx;
                      seedy(nEnd) = current_yy;
                  end
              end
           end
           nStart = nStart + 1;
       end
   end
   
% %  draw the segments dynamically
% temp = zeros(m,n);
%         for i = 1:length(seedx),
%             if(seedx(i)~=0 && seedy(i) ~=0)
%                 temp(seedx(i), seedy(i)) = 255;
%             end
%         end
%         imshow(temp);
%         hold on;
%         pause(2)

   if nEnd > minsize,
       NumV = NumV + 1;
        for i = 1:length(seedx),
            if(seedx(i)~=0 && seedy(i) ~=0)
                Seg(seedx(i), seedy(i)) = NumV;
            end
        end
   end
end



