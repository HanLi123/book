%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function:         PlotIt(FVr_temp,iter,S_struct)
% Author:           Rainer Storn
% Description:      PlotIt can be used for special purpose plots
%                   used in deopt.m.
% Parameters:       FVr_temp     (I)    Paramter vector
%                   iter         (I)    counter for optimization iterations
%                   S_Struct     (I)    Contains a variety of parameters.
%                                       For details see Rundeopt.m
% Return value:     -
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PlotIt(FVr_temp,iter,S_struct)
  %----First of two subplots.-------------------------------------
  subplot(2,1,1)
  %----plot the polynomial.----------
  plot(S_struct.FVr_xplot,polyval(FVr_temp,S_struct.FVr_xplot),'b');
  hold on;
  %----plot the tolerance scheme.----
  plot(S_struct.FVr_x,S_struct.FVr_lim_up,'r');
  plot(S_struct.FVr_xplot,S_struct.FVr_lim_lo_plot,'r');
  %axis([-1.3 1.3 -2 S_struct.FVr_bound(length(FVr_temp))]);
  axis([-1.3 1.3 -2 10]);
  hold off;
  grid on;
  zoom on;
  title('polynomial fitting');
  
  %----Second of two subplots.-------------------------------------
  subplot(2,1,2)
  stem(FVr_temp); %Stem plot of the current parameter vector elements.
  %axis([0 1.1e6 -40 0]);
  grid on;
  zoom on;
  title('Polynomial coefficients');
  drawnow;
  return
