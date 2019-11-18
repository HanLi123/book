clear all;
close all;
load data2
k=10;
delta=0.001;
v=0.00000001;
L=5;
s=data(1:1500,:);
[m,n]=size(s);
s1=s(1:end-1,:)';
s2=s(2:end,:);
A=s2'*s1'*pinv(s1*s1');
m=length(s);
K=1/(m-1)*((s2'-A*s1)*(s2'-A*s1)');
G1=cov(s);

count=0;
G2=G1;
G2=A*G2*A'+K;
[R,p] = chol(G2);
while(p>0)
count=count+1;
 G2=G2-delta*(G2-A*G2*A'-K) ;
 disp(count);   
[R,p] = chol(G2);    
end
beta=norm(G1-G2);
G=G2;
x = sdpvar(n,1);
A2=x'*A*G*A'*x;
B=x'*G*x;

F = [sum(x) == 1, 1>=x>=0];
F = F + [nnz(x) <= k];
optimize(F,-A2/B)
x=value(x);
y=s*x;
z=x'*A*G*A'*x/(x'*G*x);
figure(1)
plot(y);

