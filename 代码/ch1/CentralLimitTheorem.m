%胜率
p=0.9;
% 重复试验次数
T=100000;
result=zeros(T,1);
for j=1:T
    x=rand(1);
    if x<=p
    result(j)=1;
    else
    result(j)=-1;    
    end
end
hist(result)

%随机抽取10000组，每组1000个数据
dist=zeros(10000,1);
for i=1:10000
    randindx=randperm(T);
    dist(i)=sum(result(randindx(1:1000)));
end
hist(dist,1000)