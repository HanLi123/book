clear all;
load data
t=length(hs300);
i=1;
j=42;


       [ma_short,ma_long]=movavg(hs300,i,j); 
       jinzhi=ones(length(hs300),1);
       pos=0;
       for t=2:length(hs300)
           if pos>0
              jinzhi(t)=jinzhi(t-1)*(hs300(t)/hs300(t-1));
           else
              jinzhi(t)=jinzhi(t-1);
           end
           if pos==0
               if ma_short(t)>=ma_long(t)
                   pos=1;
               end
           else 
                if ma_short(t)<ma_long(t)
                     pos=0;
                end
           end
       end
         ret=log(jinzhi(2:end))-log(jinzhi(1:end-1));
       sharpe=mean(ret)/std(ret);

