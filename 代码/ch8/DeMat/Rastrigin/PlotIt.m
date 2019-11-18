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
%----First of four subplots.---------------------------------------
  subplot(2,2,1)
  %----Define the mesh of samples----------------------------------
  mesh(S_struct.FM_meshd);
  
  %---Either plot the contour lines and population-----------------
  contour(S_struct.FVc_xx,S_struct.FVc_yy,S_struct.FM_meshd,20);
  title('Peaks function');
  hold on;%keep the contour lines
  plot(S_struct.FM_pop(:,1),S_struct.FM_pop(:,2),'r.');
  hold off;

  %---Or plot peaks function and population in 3D------------------
  subplot(2,2,2)
  surfc(S_struct.FVc_xx,S_struct.FVc_yy,(S_struct.FM_meshd));
  axis([-3 3 -3 3 -8 5]);
  view(-15,45);
  title('Peaks function');
  hold on;
  plot3(S_struct.FM_pop(:,1),S_struct.FM_pop(:,2),...
        peaks(S_struct.FM_pop(:,1),S_struct.FM_pop(:,2)),'r.');
  hold off;
  
  %----Convergence plot--------------------------------------------
  subplot(2,2,3)
  S_MSE = objfun(S_struct.FVr_bestmem,S_struct);
  plot(iter,S_MSE.FVr_oa(1),'ro');
  title(sprintf('Best cost: %f',S_MSE.FVr_oa(1)));
  axis([1 S_struct.I_itermax S_struct.F_VTR 1]);
  grid on;
  hold on;
  
  %----Difference vector distribution plot-------------------------
  subplot(2,2,4)
  hold off;
  FM3D = ones(S_struct.I_NP,S_struct.I_NP,2);
  for i=1:S_struct.I_NP
     for j=1:S_struct.I_NP
        FM3D(i,j,:) = S_struct.FM_pop(i,:);
        for k=1:2
           FM3D(i,j,k) = FM3D(i,j,k) - S_struct.FM_pop(j,k);
        end
        plot(FM3D(i,j,1),FM3D(i,j,2),'r.');
        axis([-5,5,-5,5]);
        hold on;
     end     
     title('Difference vector distribution');
     grid on;
  end
  
  drawnow;
  pause(1); %wait for one second to allow convenient viewing
  return
