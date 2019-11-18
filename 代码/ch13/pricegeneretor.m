clear all;
close all;
n=600;
p=zeros(n,1);
p(1)=10;
p(2)=p(1);
p(3)=p(2);

a1=zeros(n,1);
a2=a1;

a1(1:80)=0;
a1(81:200)=0.2;
a1(201:400)=0;
a1(401:500)=0.4;
a2(1:60)=0;
a2(61:150)=0.15;
a2(151:300)=0.2;
a2(301:450)=0;
a2(451:550)=0.2;
c=0.01;

for i=4:n
    ma3=sum(p(i-3:i-1))/3;
    x3=log(p(i-1)/ma3);
    y1=meb(x3,0,c,2*c);
    y2=meb(x3,c,2*c,3*c);
    y3=meb(x3,2*c,3*c,3*c);
    y4=meb(x3,-2*c,-c,0);
    y5=meb(x3,-3*c,-2*c,-c);
    y6=meb(x3,-3*c,-3*c,-2*c);
    y7=meb(x3,-c,0,c);
    y=y1+y2+y3+y7;
    ed1=0;
    if y~=0
        ed1=(-0.1*y1-0.2*y2-0.4*y3)/y;
    end;
    y=y4+y5+y6+y7;
    ed2=0;
    if y~=0
        ed2=(0.1*y4+0.2*y5+0.4*y6)/y;
    end;
    p(i)=exp(log(p(i-1))+a1(i)*ed1+a2(i)*ed2+normrnd(0,0.02));
    
    
end


figure(1)
plot(p)

n1=1;
n2=n;

ma1=3;
lmd=0.9;

P=[10 0;0 10];
for k=1:n1+ma1
    aa(:,:,k)=[0;0];
end;
r=[];
for k=n1+1:n2
    r(k)=log(p(k)/p(k-1));
end;
error=zeros(n,1);
for k=n1+ma1:n2-1
    pa=0;
    for i=1:ma1
        pa=pa+p(k-i+1)/ma1;
    end;
    x3=log(p(k)/pa);
    y1=meb(x3,0,c,2*c);%ps +
    y2=meb(x3,c,2*c,3*c);%pm ++
    y3=meb(x3,2*c,3*c,3*c);%pl +++
    y4=meb(x3,-2*c,-c,0);%ns -
    y5=meb(x3,-3*c,-2*c,-c);%nm --
    y6=meb(x3,-3*c,-3*c,-2*c);%nl ---
    y7=meb(x3,-c,0,c);%az 0
    y=y1+y2+y3+y7;
    ed1=0;
    %ed6
    if y~=0
        ed1=(-0.1*y1-0.2*y2-0.4*y3)/y;
    end;
    y=y4+y5+y6+y7;
    ed2=0;
    %ed7
    if y~=0
        ed2=(0.1*y4+0.2*y5+0.4*y6)/y;
    end;
    x=[ed1;ed2];
    error(k)=(log(p(k+1)/p(k))-x'*aa(:,:,k-1));
    K=P*x/(x'*P*x+lmd);
     aa(:,:,k)=aa(:,:,k-1)+K*error(k);
    P=(P-K*x'*P)/lmd;
end
for k=n1:n2-1
    aaup(k)=aa(1,1,k);   
    aadn(k)=aa(2,1,k); 
end
aaup=[0;aaup'];
aadn=-[0;aadn'];
a2=-a2;

figure(2)
subplot(2,1,1)
plot(aaup,'blue')
hold on 
plot(a1,'red')
hold on 
plot(aadn,'blue')
hold on 
plot(a2,'red')

subplot(2,1,2)
plot(p)
