rng(213);
n = 128;
M = [40,50,64,80,100,120];
alpha = 3;
RMSE = zeros(6, 'double');

lambda = diag(linspace(1,n,n).^(-alpha));
% calculate C_x
[U,~,~] = svd(rand(n));
C_x = U*lambda*U';
inv_C = inv(C_x);

% Iterate over M's
for i=1:size(M, 2)
    m = M(i);
    phi = normrnd(0, 1/m, [m,n]);
    X = mvnrnd(zeros(1,n), C_x, 10)';
    sigma = 0.01*mean(mean(abs(phi*X)));
    for j=1:size(X,2)
        x = X(:,j);        
        noise = mvnrnd(zeros(1, m), (sigma^2)*eye(m), 1)';
        y = phi*x + noise;
        x_hat = (phi'*phi + inv_C.*sigma^2)\(phi'*y);
        RMSE(i) = RMSE(i) + sqrt(mean((x_hat-x).^2));
    end
end

RMSE = RMSE/10;
A = figure;
plot(M,RMSE);
title("alpha = 3");
xlabel('m');
ylabel('rmse');
hold off;

alpha = 0;
RMSE2 = zeros(6, 'double');

lambda = diag(linspace(1,n,n).^(-alpha));
[U,~,~] = svd(rand(n));
C_x = U*lambda*U';
inv_C = inv(C_x);

% Iterate over M's
for i=1:size(M, 2)
    m = M(i);
    phi = normrnd(0, 1/m, [m,n]);
    X = mvnrnd(zeros(1,n), C_x, 10)';
    sigma = 0.01*mean(mean(abs(phi*X)));
    for j=1:size(X,2)
        x = X(:,j);        
        noise = mvnrnd(zeros(1, m), (sigma^2)*eye(m), 1)';
        y = phi*x + noise;
        x_hat = (phi'*phi + inv_C.*sigma^2)\(phi'*y);
        RMSE2(i) = RMSE2(i) + sqrt(mean((x_hat-x).^2));
    end
end


RMSE2 = RMSE2/10;
F = figure;
plot(M,RMSE2);
title("alpha = 0");
xlabel('m');
ylabel('rmse');

F = figure;
semilogy(M,RMSE);
hold on;
semilogy(M,RMSE2);
title("Combined Plot");
xlabel('m');
ylabel('rmse');


