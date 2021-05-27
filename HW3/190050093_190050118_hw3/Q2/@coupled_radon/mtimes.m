function res = mtimes(A,x)
% A should behave like an m*n matrix
if A.adjoint == 0 %A*x
    % A.J(1) is the side length of image
    t = A.J(1)*A.J(1);
    x1 = reshape(x(1:t), [A.J(1) A.J(1)]);
    x2 = reshape(x(t + 1: A.n), [A.J(1) A.J(1)]);
    % x3 is the first image
    x3 = idct2(x1);
    % res1 is the projection with angles1 of first image
    res1 = radon(x3, A.angles1);    
    % x3 + idct2(x2) gives the 2nd image
    % res2 = radon(x3, A.angles2) + radon(idct2(x2), A.angles2);
    res2 = radon(x3 + idct2(x2), A.angles2);
    % res2 is projection with angles2 of 2nd image.
    res = [res1(:); res2(:)];
%     res_size = size(res(:))   

else %At*x
    % A.J(2) is the size of projection A.J(3) is the number of angles
    t = A.J(2)*A.J(3);
    % y1 is the projections of angles1 of first image
    y1 = reshape(x(1: t), [A.J(2) A.J(3)]);
    % y2 is the projections of angles2 of 2nd image
    y2 = reshape(x(t + 1: A.m), [A.J(2) A.J(3)]);
    % x1 is the image with angles1 back-filtered
    x1 = iradon(y1, A.angles1, 'Ram-Lak', A.J(1));
    % x2 is the image with angles 2 back-filtered
    x2 = iradon(y2, A.angles2, 'Ram-Lak', A.J(1));
    % del b is x2 - x1
    x3 = x2 - x1;
    % convert to dct
    x1 = dct2(x1); 
    x3 = dct2(x3);
    x1 = x1(:); x3 = x3(:);
    res = [x1; x3];
%     res_Sz2 = size(res) 
end


