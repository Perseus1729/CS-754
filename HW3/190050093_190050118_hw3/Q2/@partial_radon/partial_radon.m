function  res = partialDCT(n,m,J, angles)

res.adjoint = 0;
res.angles = angles;
res.n = n;
res.m = m;
res.J = J;

% Register this variable as a partialDCT class
res = class(res,'partial_radon');
