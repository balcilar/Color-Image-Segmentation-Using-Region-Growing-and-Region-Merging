function JI = JImage(I, W);

[m, n] = size(I);
% window size
ws = size(W, 1);
if ws == 9,
    d = 1;
elseif ws == 17,
    d = 2;
elseif ws == 33;
    d = 4;
elseif ws == 65,
    d = 8;
end
wswidth = floor(ws/2);

% % calculate total variance, for window 9*9, it's 1080
% [z1 z2]= find(map1);
% z = [z1,z2];
% for i = 1:length(z1),
%     MM = mean(z);
%     m2 = repmat(MM, length(z), 1);
%     St = sum(diag(sqdist(z', m2')));
% end

% truncate the border area of the original class map image
% J-image
JI = zeros(m,n);
% for each pixel inside, calculate its J value in the window size
for i = 1:m,
    for j = 1:n,
        x1 = i-wswidth;
        x2 = i+wswidth;
        y1 = j-wswidth;
        y2 = j+wswidth;
        if x1<1, 
            x1 = 1;
        end
        if x2>m,
            x2 = m;
        end
        if y1<1,
            y1 = 1;
        end
        if y2>n,
            y2 = n;
        end
        wid = x2-x1+1;
        hei = y2-y1+1;
        if wid == ws && hei == ws,
            % median of the window, because of sampling, M won't change, neither St
            St = 1080;
            M = [5, 5]; 
        else
            reg = ones(wid, hei);
            reg = reg(1:d:end, 1:d:end);
            [wid, hei] = size(reg);
            M = [mean(1:wid), mean(1:hei)];
            [z1, z2] = find(reg);
            z = [z1, z2];
            St = sum(sqdist(z', M'));
        end
        block = zeros(ws, ws);
        block = I(x1:x2, y1:y2);
        Jvalue = JCalculation(block(1:d:end, 1:d:end), M, St);
        JI(i,j) = Jvalue; 
    end
end







