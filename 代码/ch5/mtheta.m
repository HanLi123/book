function y=mtheta(x,A,G,v)
y=x'*A*G*A'*x/(x'*G*x)+10*norm(x,1);
theta=x;
theta=theta./norm(theta,1);
if theta'*G*theta<v
   y=1000;
end


%   y=-y;
end