


L=1000;
p=zeros(L,1);
p(1)=50;
for t =2:L          
 a= rand(1); 
 if a>=0.5
    p( t ) = p( t - 1 ) +0.5; 
 else
   p( t ) = p( t - 1 ) -0.5;   
 end
end
plot(p)
