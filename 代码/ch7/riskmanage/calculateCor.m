clear all;
load data1
alpha=0.3;
LinRet=log(data(2:end,:))-log(data(1:end-1,:));
LinRet=LinRet';
% equally weighted exposures (weights) to factors (returns)
n_ = size(LinRet, 1);
b=ones(n_,1)/n_;
R=b'*LinRet;
% Sample covariance matrix
Sigma = cov( LinRet' ) ;

% PCA decomposition
[e, lambda] = eig(Sigma);

% Minimum-Torsion matrix and exposures for ew portfolio
t_MT = torsion(Sigma, 'minimum-torsion', 'exact');

% Diversification Distribition and NEB using Minimum-Torsion matrix
[ENB_MT, DiverDistr_MT] = EffectiveBets(b, Sigma, t_MT);

p=zeros(n_,1);
omega=b'/t_MT;
F=t_MT*LinRet;

for i=1:n_
   p(i)=var(omega(i)*F(i,:))/var(R);
end
R1=corrcoef(LinRet');
R2=corrcoef(F');



