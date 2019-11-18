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

%---Check the passband first------------------------------------
FVr_err_up  = polyval(FVr_temp,S_struct.FVr_x) - S_struct.FVr_lim_up;
FVr_err_lo  = S_struct.FVr_lim_lo - polyval(FVr_temp,S_struct.FVr_x);
IVr_pos_up  = find(FVr_err_up > 0);
IVr_pos_lo  = find(FVr_err_lo > 0);

F_cost_tol  = sum(FVr_err_up(IVr_pos_up).^2)+ sum(FVr_err_lo(IVr_pos_lo).^2);%squared error

%---Now check the stopband--------------------------------------
if (rem(length(FVr_temp),2) == 1)%take degree of polynomial into account
   F_err_left  = -polyval(FVr_temp,-1.2) + S_struct.FVr_bound(length(FVr_temp));
else
   F_err_left  = -polyval(FVr_temp,-1.2) - S_struct.FVr_bound(length(FVr_temp));
end   
if (F_err_left > 0)
   F_cost_tol = F_cost_tol + F_err_left^2; 
end

F_err_right   = -polyval(FVr_temp,1.2) + S_struct.FVr_bound(length(FVr_temp));
if (F_err_right > 0) 
   F_cost_tol = F_cost_tol + F_err_right^2; 
end

%   
%---End: tolerance scheme---------------------------------------
%----strategy to put everything into a cost function------------
S_MSE.I_nc      = 0;%no constraints
S_MSE.FVr_ca    = 0;%no constraint array
S_MSE.I_no      = 1;%number of objectives (costs)
S_MSE.FVr_oa(1) = F_cost_tol;