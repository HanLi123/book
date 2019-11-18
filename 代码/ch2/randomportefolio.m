clear all;
close all;
load data
start=500;
T=100;
risklessrate=3/100/365;
[n,m]=size(data);


%测试1 按月调仓，随机仓位
 weight=[];
jinzhi=ones(n,1);
for i=start:n
    %计算今日股票收益
    ret=data(i,:)./data(i-1,:);
    if isempty(weight)
        jinzhi(i)=jinzhi(i-1);
    else
       %计算今日基金净值
        weight=weight.*ret(today>0)';
       jinzhi(i)=sum(weight); 
    end
    if ismember(i,posx)%判断当天是否月末
       %遍历所有股票,选出200个交易日前已经上市的股票
       today=data(i-200,:);
       temp=today(today>0);
       price=data(i,today>0);
       num=length(temp);
       aa=rand(num,1);
       %随机分配仓位
       weight=aa./sum(aa)*jinzhi(i);

    end
    
end


figure(1)
plot(benchmark./benchmark(503),'blue')
hold on
plot(jinzhi,'red')




jinzhi1=ones(n,1);
%测试2 按月调仓，平均仓位
weight=[];
for i=start:n
    %计算今日股票收益
    ret=data(i,:)./data(i-1,:);
    if isempty(weight)
        jinzhi1(i)=jinzhi1(i-1);
    else
        weight=weight.*ret(today>0)';
       jinzhi1(i)=sum(weight); 
    end
    if ismember(i,posx)%判断当天是否月末
       %遍历所有股票,选出200个交易日前已经上市的股票
       today=data(i-200,:);
       temp=today(today>0);
       num=length(temp);
       %平均分配持仓
       weight=ones(num,1)/num*jinzhi1(i);
    end
    
end
figure(2)
plot(benchmark./benchmark(503),'blue')
hold on
plot(jinzhi1,'red')

%测试3 按月调仓，平均仓位,按200日均线决定是否持有现金
jinzhi2=ones(n,1);
weight=[];
for i=start:n
    %计算今日股票收益
    ret=data(i,:)./data(i-1,:);
    if isempty(weight)
        jinzhi2(i)=jinzhi2(i-1);
    else
       ret2= ret(today>0);
       %将无风险收益赋值给相应资产
       ret2(compare)=risklessrate+1;
       weight=weight.*ret2';
       jinzhi2(i)=sum(weight); 
    end
    if ismember(i,posx)%判断当天是否月末
       %遍历所有股票,选出200个交易日前已经上市的股票
       today=data(i-200,:);
       ma200=sum(data(i-199:i,:))/200;
       temp=today(today>0);
       temp2=ma200(today>0);
       price=data(i,today>0);
       %找到今日收盘价小于200日均线的资产的index
       compare=find(price<temp2);
       num=length(temp);
       weight=ones(num,1)/num*jinzhi2(i);
    end
    
end
figure(3)
plot(benchmark./benchmark(503),'blue')
hold on
plot(jinzhi1,'red')
hold on
plot(jinzhi2,'green')

%测试4 按月调仓，随机仓位,重复100次

k=0;
result=zeros(n,T);
while k<T
 weight=[];
jinzhi3=ones(n,1);
k=k+1;
for i=start:n
    %计算今日股票收益
    ret=data(i,:)./data(i-1,:);
    if isempty(weight)
        jinzhi3(i)=jinzhi3(i-1);
    else
        
        weight=weight.*ret(today>0)';
       jinzhi3(i)=sum(weight); 
    end
    if ismember(i,posx)%判断当天是否月末
       %遍历所有股票,选出200个交易日前已经上市的股票
       today=data(i-200,:);
       temp=today(today>0);
       price=data(i,today>0);
       num=length(temp);
       aa=rand(num,1);

       weight=aa./sum(aa)*jinzhi3(i);

    end
    
end
result(:,k)=jinzhi3;
disp(k);
end
benchmark=benchmark./benchmark(503);
figure(4)
plot(benchmark(503:end),'blue')
hold on
plot(result(503:end,:),'red')
hold on
plot(jinzhi2(503:end),'green')