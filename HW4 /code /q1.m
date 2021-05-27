% Assignment4-Q1
% Rollno: 190050093, 190050118
rng(13);
clear all;
f =zeros(256,1);
s=[5,10,15,20,25,30,35,40];%number of sparse elements per signal
% sigma = 0.01× average value of f1 + f2 .
sigma=[0,0.01,0.02,0.03,0.04,0.05,0.06];

%The inverse discrete Fourier transform matrix is
D1 = conj(dctmtx(256))/256;
%identity matrix
D2=eye(256); 
% Result Info
avg=0;
Error_1=zeros(size(s,2),size(sigma,2));
Error_2=zeros(size(s,2),size(sigma,2));

for i=1:size(s,2)
    indices=randi([1,256],1,s(i));
    values=randi([1,100],1,s(i));
    f1=D1(:,indices)*values';
    
    indices=randi([1,256],1,s(i));
    values=randi([1,100],1,s(i));
    f2=D2(:,indices)*values';
    
    ft = f1 + f2;
    % calculate mean of f1 + f2
    avg = int32(mean(ft));
    for j=1:size(sigma,2)
        %Finding s(i) sparse matrices for f1 and f2
        stdev=double(sigma(j)*avg);
        noise=randn(256,1)*stdev;
        f = ft + noise;
        % Using alternate min. technique to find coeffs   
        t=s(i);
        [f1_actual,f2_actual] = Divide( f,D1,D2,t );
        Error_1(i,j)=rmse(f1,f1_actual);
        Error_2(i,j)=rmse(f2,f2_actual);
     
    end
end
k=[2,4,6,8,10];
for i=1:size(k,2)
        j=2;
         %Finding s(i) sparse matrices for f1 and f2
        avg= int32(sigma(j)*100);
        indices=randi([1,256],1,s(1));
        values=randi([1,2*avg],1,s(1));
        f1=D1(:,indices)*values';
        
        
        indices=randi([1,256],1,s(1));
        values=randi([1,2*avg*k(i)],1,s(1));
        f2=D2(:,indices)*values';
        
        stdev=double(0.01*avg*(k(i)+1));
        noise=randn(256,1)*stdev;
        f=f1+f2+noise;
        % Using alternate min. technique to find coeffs   
        t=s(i);
        [f1_actual,f2_actual] = Divide( f,D1,D2,t );
        kError_1(i)=rmse(f1,f1_actual);
        kError_2(i)=rmse(f2,f2_actual);
end

%Plotting s, with varying sigma and sparsity;
fig = figure('name','fig');
x = s'; c = {'g','m','b','r','k','c','y'};
for j = 1:size(Error_2, 2)
    y = Error_2(:,j);
    plot(x,y,strcat('*--',c{j})),hold on      
end
title('\fontsize{10}{\color{black} F2 RMS Error}');
grid on;
xlabel('Sparsity');
ylabel('Error/RMSE in f2');
legend('std=0','std=0.01','std=0.02','std=0.03','std=0.04','std=0.05','std=0.06','Location','northwest');saveas(fig,'../images/f2_rmse.jpg');
saveas(fig,'../images/f2_rmse.jpg');
hold off;

fig = figure('name','fig');
x = s'; c = {'g','m','b','r','k','c','y'};
for j = 1:size(Error_1,2)
    y = Error_1(:,j);
    plot(x,y,strcat('*--',c{j})),hold on      
end
title('\fontsize{10}{\color{black} F1 RMS Error}');
grid on;
xlabel('Sparsity');
ylabel('Error/RMSE in f1');
legend('std=0','std=0.01','std=0.02','std=0.03','std=0.04','std=0.05','std=0.06','Location','northwest');
saveas(fig,'../images/f1_rmse.jpg');
hold off;

%Plotting RMSE for different 'k' with sparsity =s(1), sigma =sigma(2)
fig4=figure;
f2_err=kError_2(:);
plot(k,f2_err);
title('Plot of RMSE value in f2 v/s k');
xlabel(' k ');
ylabel('Error/RMSE in f2');
saveas(fig4,'../images/f2_varying_k.jpg');
fig5=figure;
f1_err=kError_1(:);
plot(k,f1_err);
title('Plot of RMSE value in f1 v/s k')
xlabel(' k ');
ylabel('Error/RMSE in f1');
saveas(fig5,'../images/f1_varying_k.jpg');