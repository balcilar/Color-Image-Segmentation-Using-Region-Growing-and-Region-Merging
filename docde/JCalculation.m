function J = JCalculation(class_map, M, St);


[m, n] = size(class_map);
N = m*n;
Sw = 0;

for l = 1: max(class_map(:)),
    [x,y] = find(class_map == l);
    % mean vector of the vectors with class label l
    if isempty(x) 
        continue;
    end
    m_l = [mean(x), mean(y)];
%     m_l = [median(x), median(y)];
    m1 = repmat(m_l, length(x), 1);    
    xy = [x, y];
    Dist1 = sum(diag(sqdist(xy', m1')));   
    Sw = Sw + Dist1;
end

J = (St-Sw)/Sw;


        
