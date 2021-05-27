rng(21);

img1 = zeros(217, 217);
img1(18:198,1:217) = double(imread("slice_50.png"));
img2 = zeros(217, 217);
img2(18:198,:) = double(imread("slice_51.png"));
img3 = zeros(217, 217);
img3(18:198, :) = double(imread("slice_52.png"));
angles = 180*rand([18 1]);
%% Filtered backprojection using ram-lak
p1 = radon(img1, angles);
p2 = radon(img2, angles);

r1 = iradon(p1, angles, 'linear');
r2 = iradon(p2, angles, 'linear');

A = figure;
subplot(2,2,1);
imshow(uint8(img1));
title("Original slice 1");
subplot(2,2,2);
imshow(uint8(r1));
title("Reconstructed slice 1");
subplot(2,2,3);
imshow(uint8(img2));
title("Original slice 2");
subplot(2,2,4);
imshow(uint8(r2));
title("Reconstructed Slice 2");
%% Indepedent CS reconstruction
s = 217;
J = [s 18];
lambda = 2;
rel_tol = 0.01;

p1 = radon(img1, angles);
p1 = p1(:);
t = size(p1,1);
A = partial_radon(s^2, t, J, angles);
At = A';
 
[x1, status] = l1_ls(A, At, t, s^2, p1, lambda, rel_tol);
x1 = reshape(x1, [s s]);
x1 = uint8(idct2(x1));

p2 = radon(img2, angles);
p2 = p2(:);
t = size(p2,1);
 A = partial_radon(s^2, t, J, angles);
At = A';

[x2, status] = l1_ls(A, At, t, s^2, p2, lambda, rel_tol);
x2 = reshape(x2, [s s]);
x2 = uint8(idct2(x2)); 

A = figure;
subplot(2,2,1);
imshow(uint8(img1));
title("Original slice 1");
subplot(2,2,2);
imshow(x1);
title("Reconstructed slice 1");
subplot(2,2,3);
imshow(uint8(img2));
title("Original slice 2");
subplot(2,2,4);
imshow(x2);
title("Reconstructed Slice 2");
%% Coupled CS reconstruction for 2 slices

% angles1 = 180*rand([18 1]);
% angles2 = 180*rand([18 1]);
angles1 = 1:10:180;
angles2 = 2:10:180;
p1 = radon(img1, angles1);
p2 = radon(img2, angles2);
J = [s size(p1, 1) 18];
p1 = p1(:); p2 = p2(:);
t = size(p1,1) + size(p2,1);

n = 2*(s^2);
A = coupled_radon(n, t, J, angles1, angles2);
At = A';

lambda = 0.01;
rel_tol = 1200;

[x, status] = l1_ls(A, At, t, n, [p1; p2], lambda, rel_tol);
x1 = reshape(x(1:s^2), [s s]);
x2 = reshape(x(s^2 + 1: n), [s s]);
res1 = uint8(idct2(x1)); res2 = uint8(idct2(x1 + x2));

A = figure;
subplot(2,2,1);
imshow(uint8(img1));
title("Original slice 1");
subplot(2,2,2);
imshow(res1);
title("Reconstructed slice 1");
subplot(2,2,3);
imshow(uint8(img2));
title("Original slice 2");
subplot(2,2,4);
imshow(res2);
title("Reconstructed Slice 2");
%% Coupled CS reconstruction for 3 slices

angles1 = 180*rand([18 1]);
angles2 = 180*rand([18 1]);
angles3 = 180*rand([18 1]);

p1 = radon(img1, angles1);
p2 = radon(img2, angles2);
p3 = radon(img3, angles3);
J = [s size(p1, 1) 18];
p1 = p1(:); p2 = p2(:); p3 = p3(:);
t = 3*size(p1,1);

n = 3*(s^2);
A = coupled_radon_3(n, t, J, angles1, angles2, angles3);
At = A';

lambda = 0.01;
rel_tol = 120;

[x, status] = l1_ls(A, At, t, n, [p1; p2; p3], lambda, rel_tol);
x1 = reshape(x(1:s^2), [s s]);
x2 = reshape(x(s^2 + 1 : 2*(s^2)), [s s]);
x3 = reshape(x(2*(s^2) + 1 : n), [s s]);
res1 = uint8(idct2(x1)); res2 = uint8(idct2(x1 + x2)); res3 = uint8(double(res2) + idct2(x3));
A = figure;
subplot(3,2,1);
imshow(uint8(img1));
title("Original slice 1");
subplot(3,2,2);
imshow(res1);
title("Reconstructed slice 1");
subplot(3,2,3);
imshow(uint8(img2));
title("Original slice 2");
subplot(3,2,4);
imshow(res2);
title("Reconstructed Slice 2");
subplot(3,2,5);
imshow(uint8(img3));
title("Original slice 3");
subplot(3,2,6);
imshow(res3);
title("Reconstructed Slice 3");

