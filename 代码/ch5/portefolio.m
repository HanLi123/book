clear all;
close all;
load data2
data=log(data(:,1:10));
[m,n]=size(data);
ret=data(2:end,:)-data(1:end-1,:);%计算对数收益率序列
S = cov(ret); % 协方差矩阵
mu  = mean(ret,1)*252;  % 期望年化收益
w = sdpvar(n,1);
mutarget = mean(mu);
F = [sum(w) == 1, w>=0, mu*w == mutarget];
optimize(F,w'*S*w)
x=value(w)
%%
F = [sum(w) == 1, w>=0];
F = F + [w'*S*w < sum(sum(S))/n^2];
optimize(F,-mu*w)
x=value(w)
%%

w = sdpvar(n,1);
F = [sum(w) == 1, w>=0];
optimize(F,w'*S*w)
x=value(w)


%%
mutarget = mean(mu);
F = [sum(w) == 1, 1>=w>=0, mu*w == mutarget];
F = F + [nnz(w) <= 4];
optimize(F,w'*S*w)
x=value(w)
%%
w = semivar(n,1);     
F = [0.1 <= w <= 0.8]; 
F = [F, sum(w) == 1, mu*w == mutarget];
optimize(F,w'*S*w)
x=value(w)
%%
w = sdpvar(n,1);
sdpvar mutarget
F = [sum(w) == 1, w>=0, mu*w == mutarget];
Portfolio = optimizer(F,w'*S*w,sdpsettings('verbose',0),mutarget,[w'*S*w;w]);
targets = linspace(min(mu),max(mu),100);
solutions = Portfolio{targets};
plot(solutions(1,:),targets)