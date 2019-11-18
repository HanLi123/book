function t = torsion(Sigma, model, method, max_niter)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this funciton computes the Principal Components torsion and the Minimum Torsion for diversification analysis
% see A. Meucci, A. Santangelo, R. Deguest - "Measuring Portfolio Diversification Based on Optimized Uncorrelated Factors" to appear (2013)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INPUTS
%  Sigma     : [matrix] (n_ x n_) covariance matrix
%  model     : [string] choose between 'pca' and 'minimum-torsion' model
%  method    : [string] choose between 'approximate' and 'exact' method for 'minimum-torsion' model
%  max_niter : [scalar] choose number of iterations of numerical algorithm 
% OUTPUTS
% t : [matrix] (n_ x n_) torsion matrix

if nargin < 4 || isempty(max_niter)
    max_niter = 10000;
end
if nargin < 3
    method = [];
end

switch model
    
    case 'pca'
        
        % PCA decomposition
        [e, lambda] = eig(Sigma);
        flip = e(1,:)<0;
        e(:, flip)= -e(:, flip); % fix the sign of the eigenvector based on the sign of its first entry
        [~, index] = sort(diag(lambda), 'descend') ;
        
        % PCA torsion
        t = e(:, index)';
        
    case 'minimum-torsion'
        
        % Correlation matrix
        sigma = diag(Sigma).^(1/2);
        C = diag(1./sigma)*Sigma*diag(1./sigma);
        c = sqrtm (C); % Riccati root of C
        
        switch method
            
            case 'approximate'
                t = (diag(sigma) / c) * diag(1./sigma);
                
            case 'exact'
                n_ = size(Sigma, 1);
                
                % initialize
                d = ones(1, n_);
                f = zeros(1, max_niter);
                for i = 1:max_niter
                    
                    U = diag(d)*c*c*diag(d);
                    u = sqrtm(U);
                    q = u\(diag(d)*c);
                    d = diag(q*c);
                    pi_ = diag(d)*q; % perturbation
                    f(i) = norm(c - pi_, 'fro');
                    
                    if i > 1 && abs(f(i) - f(i-1))/f(i)/n_ <= 10^-8
                        f = f(1:i);
                        break
                    elseif i == max_niter && abs(f(max_niter) - f(max_niter-1))/f(max_niter)/n_ > 10^-8
                        disp(['number of max iterations reached: n_iter = ', num2str(max_niter)])
                    end
                    
                end
                x = pi_/c;
                t = diag(sigma) * x * diag(1./sigma);
        end
        
end
