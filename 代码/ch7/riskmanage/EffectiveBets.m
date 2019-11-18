function [enb, p] = EffectiveBets(b, Sigma, t)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this funciton computes the Effective Number of Bets and the Diversification distribution
% see A. Meucci, A. Santangelo, R. Deguest - "Measuring Portfolio Diversification Based on Optimized Uncorrelated Factors" to appear (2013)
%
% Last version of code and article available at http://symmys.com/node/599
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INPUTS
%  b     : [vector] (n_ x 1) exposures
%  Sigma : [matrix] (n_ x n_) covariance matrix
%  t     : [matrix] (n_ x n_) torsion matrix
%
% OUTPUTS
%  enb : [scalar] Effetive Number of Bets
%  p   : [vector] (n_ x 1) diversification distribution

p = (t'\b).*(t*Sigma*b)/( b'*Sigma*b );
enb = exp(-sum(p.*log(1+(p-1).*(p>1e-5))));


