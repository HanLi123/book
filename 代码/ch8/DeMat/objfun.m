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
hs300=S_struct.data;
t=length(hs300);
i=round(FVr_temp(1));
j=round(FVr_temp(2));
if(j<i)
    F_cost=10000;
else

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
        F_cost=-mean(ret)/std(ret);
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