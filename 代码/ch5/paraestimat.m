clear all;
close all;
% clc;
load data2
delta=0.001;
v=0.00000001;
L=5;
sss=data;
s=data(1:1500,:);
ss=data(1501:2000,:);
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
theta=ones(n,1)/n;
fval=-1e10;
fval_old=0;
count=0;
while abs(fval_old-fval)>=0.01&&count<=10000
    count=count+1;
     fval_old=fval;
     theta_old=theta;
     theta=theta./sum(abs(theta));
lbs=-1*ones(1,n);
ubs=ones(1,n);
 b=theta;
 problem = createOptimProblem('fmincon',...
                    'objective',@(x)mtheta(x,A,G,v),...
                     'lb',lbs,'ub',ubs,'x0',b,'options',...
                    optimoptions(@fmincon,'Algorithm','interior-point','Display','off'));
                % [x,fval] = fmincon(problem);
                gs = GlobalSearch('Display','off');
                [theta,fval] = run(gs,problem);
   disp(count);
   disp(fval);
end
theta=theta./sum(abs(theta));

y=s*theta;
y2=ss*theta;
figure(1)
plot(y)
figure(2)
plot(y2)
figure(3)
plot(sss*theta)


y3=(y2-mean(y))/std(y);
figure(4)
plot(y3)
figure(5)
plot((y-mean(y))/std(y))

% k=20;
% v=0.1;
% X=sdpvar(n,n,'symmetric');
% 
% A=A*G*A';
% B=G;
% 
% a = [trace(X)==1]; % 等式约束
% b = [trace(B*X)>=v]; %不等式约束
% c = [X>=0]; % LMI约束
% c = [norm(X,1)<=k]; % LMI约束
% obj = trace(A*X);
% constraint = [a,b,c];
% options = sdpsettings('solver', 'sedumi', 'sedumi.eps', 1e-8, ...
%                 'sedumi.cg.qprec', 1, 'sedumi.cg.maxiter', 49, ...
%                 'sedumi.stepdif', 2);
% sol=optimize(constraint,obj,options);
% disp(sol.problem)
% optobj = value(obj);
% optx = value(X);
% 
% [V,D] = eig(optx);
% theta=V(:,n);
% theta=theta./sum(abs(theta));
% y=s*theta;
% y2=ss*theta;
% figure(1)
% plot(y)
% figure(2)
% plot(y2)
% figure(3)
% plot(sss*theta)
