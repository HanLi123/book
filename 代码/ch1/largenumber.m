clear all;
close all;

%胜率
p=0.9;
% 重复试验次数
T=10000;
result=zeros(T,1);
win=0;
count=0;
for j=1:T
x=rand(1);
count=count+1;
    if x<=p
      win=win+1;   
    end

result(j)=win/count;
end
plot(1:T,result)
