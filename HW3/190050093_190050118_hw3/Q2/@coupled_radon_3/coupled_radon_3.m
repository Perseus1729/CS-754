function  res = partialDCT(n,m,J, angles1, angles2, angles3)

res.adjoint = 0;
res.angles1 = angles1;
res.angles2 = angles2;
res.angles3 = angles3;
res.n = n;
res.m = m;
res.J = J;

% Register this variable as a partialDCT class
res = class(res,'coupled_radon_3');
