function res = mtimes(A,x)
% A should behave like an m*n vector
if A.adjoint == 0 %A*x
%     y = reshape(x, [A.J, A.J]);
%     res = radon(idct2(y), A.angles);
%     res_size = size(res)
%     res = res(:);
    y = reshape(x, [A.J(1), A.J(1)]);
    res = radon(idct2(y), A.angles);
    res = res(:);

else %At*x
%     x_size = size(x);
%     sz = size(x, 1);
%     y = reshape(x, [A.m sz/A.m]); 
%     res = iradon(y, A.angles, 'linear', A.J);
%     res_size_2 = size(res)
%     res = dct2(res);
%     res = res(:);
    y = reshape(x, [A.m/A.J(2) A.J(2)]);
    res = iradon(y, A.angles, 'linear', 'ram-lak', A.J(1));
    res = dct2(res);
    res = res(:);
end


