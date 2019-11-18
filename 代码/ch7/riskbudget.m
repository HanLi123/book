clear all;
close all;
load data2
data=log(data(:,1:2));
[m,n]=size(data);
ret=data(2:end,:)-data(1:end-1,:);%计算对数收益率序列
S = cov(ret); % 协方差矩阵
mu  = mean(ret,1)*252;  % 期望年化收益
w = sdpvar(n,1);
mutarget = mean(mu);
F = [sum(w) == 1, w>=0];
optimize(F,abs(w(1)*(w(1)*S(1)+w(2)*S(2))*4-w(2)*(w(2)*S(4)+w(1)*S(3))))
x=value(w)



