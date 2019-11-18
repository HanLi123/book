clear all;
close all;
load data;
mid=(data(:,4)+data(:,6))/2;
start=1;
endp=length(mid);
countmax=3000;
countx=2000;
range=20;
count=1;
[ma5,ma20]=movavg(mid,500,2000);
[ma50,ma100]=movavg(mid,5000,10000);
[ma150,ma200]=movavg(mid,15000,20000);
a1=matest(ma50,ma200);
a2=matest(ma100,ma200);
a3=matest(ma150,ma200);
a4=matest(ma50,ma150);
a5=matest(ma100,ma150);
a6=matest(ma50,ma100);
a7=matest(ma5,ma20);
a8=matest(ma20,ma50);

startv=mid(start);
a=1:1:length(mid);
mid=mid(start:endp);
a1=a1(start:endp);
a2=a2(start:endp);
a3=a3(start:endp);
a4=a4(start:endp);
a5=a5(start:endp);
a6=a6(start:endp);
a7=a7(start:endp);
a8=a8(start:endp);
a=a(start:endp);
en=en(start:endp);
data=data(start:endp,:);

a=a';
ff=[];
force=[];
count1=0;
count2=0;
count3=0;
while(count<=countmax)
start=unidrnd(length(mid));
startv=mid(start);


for i=start:length(mid)
    if mid(i)-startv>=range || mid(i)-startv<=-range
        n=(i-start+1);
        mm=mid(start:i);
        if mid(i)>startv
            class=ones(n,1);
            count2=count2+1;
            ind=find(abs(mid(start:i)-startv)>=range/2);
            half=ind(1);
            if length(ind)==1||abs(mm(ind(1))-startv)>range/2+1
                break;
            end
        else
             ind=find(abs(mid(start:i)-startv)>=range/2);
              half=ind(1);
             class=-1*ones(n,1);
              count3=count3+1;
            if length(ind)==1||abs(mm(ind(1))-startv)>range/2+1
               break;
            end

        end
        
    columns = {'t', 'class', 'a1', 'a2', 'a3', 'a4', 'a5','a6','a7','a8'};
    if count<=countx
% 指定各列的列名，默认为变量名
  datas = table(a(start:i),class , a1(start:i),  a2(start:i), a3(start:i),  a4(start:i),  a5(start:i), a6(start:i),a7(start:i),a8(start:i),'VariableNames', columns); % 基于这些单独的变量创建一个table类型变量data
    else
  datas = table(a(start:start+half-1),class(1:half) , a1(start:start+half-1),  a2(start:start+half-1), a3(start:start+half-1),  a4(start:start+half-1),  a5(start:start+half-1), a6(start:start+half-1),a7(start:start+half-1),a8(start:start+half-1) ,'VariableNames', columns); % 基于这些单独的变量创建一个table类型变量data
    end
temp='F:\CTBNCToolkitClone-master\train\strj';
temp2=num2str(count);
temp3='.csv';
file=[temp,temp2,temp3];
writetable(datas, file);    
        count=count+1;
           startv=mid(i);
            start=i;
     break;
      
    end
end

end

function [ a ] = matest( ma1,ma2 )
n=length(ma1);
a=zeros(n,1);
for i=1:n
    if  ma1(i)>ma2(i)
           a(i)=1;
    else
         a(i)=-1;
        
    end
end
end
