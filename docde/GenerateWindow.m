function W = GenerateWindow(scale);

window = ones(65, 65);
% left up block of the window
lu = ones(32,32); 
% left bottom
lb = ones(32,32);
% right up
ru = ones(32,32);
% right bottom
rb = ones(32,32);

% left up
j = 1;
for i = 24:-2:10,
    lu(j,1:i) = 0;
    lu(1:i,j) = 0;
    j = j + 1;
end

% 90 degree counterclockwise rotation of matrix
lb = rot90(lu);
rb = rot90(lb);
ru = rot90(rb);
window(1:32, 1:32) = lu;
window(1:32, 34:65) = ru;
window(34:65, 1:32) = lb;
window(34:65, 34:65) = rb;

w4 = window;
w3 = w4(1:2:end, 1:2:end);
w2 = w3(1:2:end, 1:2:end);
w1 = w2(1:2:end, 1:2:end);

if scale == 4, 
    W = w4;
elseif scale == 3,
    W = w3;
elseif scale == 2,
    W = w2;
else scale == 1,
    W = w1;
end
