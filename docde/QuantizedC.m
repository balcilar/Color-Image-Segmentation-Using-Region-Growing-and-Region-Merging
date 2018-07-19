function qc = QuantizedC(class_map, OrI)
% input: class_map  -- the segment label for each pixel
%        OrI        -- original image
% output: Img       -- segmented image (quantized/average)
%         qc        -- quantized color

[m, n, d] = size(OrI);
k = max(class_map);
qc = zeros(k, d);

for i = 1:max(class_map(:)),
    sq = find(class_map == i);
    Channel = zeros(m,n);
    for j = 1:d,         
        Channel = OrI(:,:, j);
        u = mean(Channel(sq));
        Channel = zeros(m,n);
        Channel(sq) = u;
        qc(i,j) = u;
    end
end

