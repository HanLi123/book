clear all;
close all;

%胜率
p=0.9;
% 重复试验次数
T=100000;
%投资比例
f=0:0.01:1;
n=length(f);
result=zeros(n,1);
for i=1:n
    ret=0;
    for j=1:T
    x=rand(1);
    if x<=p
        
      ret=ret+log(f(i)+1);
    else
        
       ret=ret+log(-f(i)+1);
    end

        
    end
  result(i)=ret;  
end

plot(f,result)
title('Fixed invest ratios and cumsum log return')
xlabel('Fixed invest ratios') % x-axis label
ylabel(' cumsum log return') % y-axis label