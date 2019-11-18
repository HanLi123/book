%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function:         S_MSE= objfun(FVr_temp, S_struct)
% Author:           Rainer Storn
% Description:      Implements the cost function to be minimized.
%                   The objective function describes Zimmermann's 
%                   problem where the optimum is f(7,2) = 0.
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

%---Cost function to minimize-----------------------------------
%helper functions
F_h1 = 9 - FVr_temp(1) - FVr_temp(2);
F_h2 = (FVr_temp(1) - 3)^2 + (FVr_temp(2) - 2)^2 - 16;
F_h3 = FVr_temp(1)*FVr_temp(2) - 14;

%partial costs
F_pc1 = F_h1;                     
F_pc2 = 100*(1+F_h2)*step(F_h2);
F_pc3 = 100*(1+F_h3)*step(F_h3);
F_pc4 = 100*(1-FVr_temp(1))*step(-FVr_temp(1));
F_pc5 = 100*(1-FVr_temp(2))*step(-FVr_temp(2));

%array of partial costs
FVr_pc = [F_pc1 F_pc2 F_pc3 F_pc4 F_pc5];%Vector with partial costs

F_cost = max(FVr_pc);%maximum of all partial costs

%---Constraints to be met (must be <= 0)------------------------
F_g1 = FVr_temp(1)*FVr_temp(2) - 14;
F_g2 = (FVr_temp(1) - 3)^2 + (FVr_temp(2) - 2)^2 - 16;
   
%----strategy to put everything into a cost function------------
S_MSE.I_nc      = 2;%number of constraints
S_MSE.FVr_ca    = [F_g1 F_g2];%constraint array
S_MSE.I_no      = 1;%number of objectives (costs)
S_MSE.FVr_oa(1) = F_cost;%objective array