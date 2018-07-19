% 

function SegI = ValleyG2(JI, Region)


[m, n] = size(JI);
SegI = zeros(m,n);

% Initial Heap list, find the initial boudnaries
BRegion = imdilate(Region, [0 1 0; 1 1 1; 0 1 0]);


Boundary = BRegion & ~Region;
% locations of the boundaries: sq = m*(j-1)+i, jth column, ith row
sq = find(Boundary);
% J value of the boundary pixels
Jvalue = JI(sq);
% build heap
[hp, hpid] = build_heap(Jvalue,sq);

x_direction = [-1, 0, 1, 0];
y_direction = [ 0, 1, 0, -1];

while (~isempty(hp)),
    % take the first out from heap: with the minimum J value
    [hp,hpid,minval,pos] = heap_pop(hp,hpid); 

    posy = fix((pos-1)/m)+1;
    posx = pos - m*(posy-1);
    if ~Region(posx,posy)
        curval = BRegion(posx,posy);
        Region(posx,posy) =curval;
        
        % 4-neighbours
        for k = 1:4,
            x = posx + x_direction(k);
            y = posy + y_direction(k);
            if x> 0 && x<=m && y > 0 && y <=n,
                
                if BRegion(x, y) == 0,
                    P = x + m*(y-1);
                    J = JI(x,y);
                    [hp,hpid] = heap_add(hp,hpid,J,P);
                    BRegion(x,y) = curval;
                    %             else
                    %                 Region(pos) = Region(P);
                end
            end
        end
    end
    
    
    
    
% %     [B,L] = bwboundaries(imdilate(Region, [0 1 0; 1 1 1; 0 1 0]), 'noholes');
% % 
% %      for k = 1:length(B),
% %         boundary = B{k};
% %         % J value on outer boundaries
% %         Jb = [];
% %         for b = 1:size(boundary,1),
% %             Jb = [Jb JI(boundary(b,1), boundary(b,2))];
% %         end
% %         [v, id] = min(Jb);
% %         %the pixel with minimum J value
% %         Jbmin = boundary(id, :);
% %         % assgign to the adjacent segment, values from 4-connectivity neighbour
% %         temp = [];
% %         x_direction = [-1, 0, 1, 0];
% %         y_direction = [ 0, 1, 0, -1];
% %         for k = 1:4,
% %             x = Jbmin(1) + x_direction(k);
% %             y = Jbmin(2) + y_direction(k);
% %             temp = [temp Region(x, y)];
% %         end
% %         if length(unique(temp(find(temp ~= 0)))) == 1,
% %             Region(Jbmin(1), Jbmin(2)) = unique(temp(find(temp ~=0)));
% %         else
% %             break;
% %         end
% %      end
end

SegI = Region;

% ShowSegs(SegI);










