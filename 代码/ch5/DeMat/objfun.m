%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function:         S_MSE= objfun(FVr_temp, S_struct)
% Author:           Rainer Storn
% Description:      Implements the cost function to be minimized.
% Parameters:       FVr_temp     (I)    Paramter vector
%                   S_Struct     (I)    Contains a variety of parameters.
%                                       For details see Rundeopt.m
% Return value:     S_MSE.I_nc   (O)    Number of constraints
%                   S_MSE.FVr_ca (O)    Constraint values. 0 means the constraints
%                                       are met. Values > 0 measure the distance
%                                       to a particular constraint.
%                   S_MSE.I_no   (O)    Number of objectives.
%                   S_MSE.FVr_oa (O)    Objective function values.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function S_MSE= objfun(FVr_temp, S_struct)


% model=garch(1,1);
% h = estimate(model,r);
r=S_struct.r;
g1=FVr_temp(8);
g2=FVr_temp(9)-FVr_temp(10);
g3=FVr_temp(10);
g4=FVr_temp(7);
g5=FVr_temp(9);
g6=FVr_temp(2);
if(g1<=0||g2<0||g3<0||g4<0||g5>=1||g6<0)
    F_cost=10000;
else
t=length(r);
mu=FVr_temp(1);
omega=FVr_temp(2);
alpha=FVr_temp(3);
alphaj=FVr_temp(4);
alphaa=FVr_temp(5);
alphaaj=FVr_temp(6);
beta=FVr_temp(7);
lamda0=FVr_temp(8);
rho=FVr_temp(9);
gama=FVr_temp(10);
theta=FVr_temp(11);
delta=FVr_temp(12);

sigma=zeros(t,1);
lamda=zeros(t,1);
f3=zeros(t,1);
abxlong=zeros(t,1);
g=zeros(t,1);
xp=20;
p=zeros(t,xp+1);
for i=1:t

%     if i==13;
%        i=13; 
%     end
       E=0;
    if i==1
        
       abxlong(i)=0; 
    else    
        for j=0:xp 
        %计算E
        E=E+j*p(i-1,j+1);
        end
        abxlong(i)=E-lamda(i-1);
        if(r(i-1)-mu<0)
        g(i)=exp(alpha+alphaj*E+alphaa+alphaaj*E);
        else
        g(i)=exp(alpha+alphaj*E);    
        end
        
    end
    
   if(i==1)
    lamda(i)=lamda0/(1-rho);
    sigma(i)=omega;
   else
    lamda(i)=lamda0+rho*lamda(i-1)+gama*abxlong(i);
    sigma(i)=omega+g(i)*((r(i-1)-mu)^2)+beta*sigma(i-1);   
       
   end
   
   
   %计算当日的似然函数log值
   sums=0;
   for j=0:xp 
       x1=1/(sqrt(2*pi*(sigma(i)+j*delta*delta)));
       s1=(r(i)-mu+theta*lamda(i)-theta*j);
       s2=2*(sigma(i)+j*delta*delta);
       x2=exp(-s1*s1./s2);
       x3=exp(-lamda(i))*(lamda(i)^j)/factorial(j);
       sums=sums+x1*x2*x3;
   end
    f3(i)=log(sums);
   %计算当日后验条件概率
   for j=0:xp 
       x1=1/(sqrt(2*pi*(sigma(i)+j*delta*delta)));
       s1=(r(i)-mu+theta*lamda(i)-theta*j);
       s2=2*(sigma(i)+j*delta*delta);
       x2=exp(-s1*s1./s2);
       x3=exp(-lamda(i))*(lamda(i)^j)/factorial(j);
       p(i,j+1)=x1*x2*x3/sums;
   end
   
%    proba(i)=sum(p(i,2:end));
   
end



F_cost=-sum(f3);
if(isnan(F_cost))
    F_cost=10000;
end
end



% 
% %---Peaks function----------------------------------------------
% F_cost = peaks(FVr_temp(1),FVr_temp(2));

%----strategy to put everything into a cost function------------
S_MSE.I_nc      = 0;%no constraints
S_MSE.FVr_ca    = 0;%no constraint array
S_MSE.I_no      = 1;%number of objectives (costs)
S_MSE.FVr_oa(1) = F_cost;