function DrawLine(SegI)
% input: SegI   --- Segments with segment labels
% output: ImgS  --- Segments with line boundaries

[m, n] = size(SegI);
ImgS = zeros(m, n);
% RGB = label2rgb(SegI);
% figure; imshow(RGB);
% hold on;
BRegion = imdilate(SegI, [0 1 0; 1 1 1; 0 1 0]);
Boundary = BRegion & ~SegI;


for i = 1:max(SegI(:)),
    S = zeros(m, n);
    [x, y] = find(SegI == i);
    for j = 1:length(x),
        S(x(j), y(j)) = 1;
    end
    [B,L] = bwboundaries(S,'noholes');
    for k = 1:length(B)
        boundary = B{k};
        plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 1);
    end
    ImgS = ImgS + S;
end

