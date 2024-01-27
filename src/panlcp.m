function CP = panlcp(theta, M, gamma)
% CP = panlcp(theta, M, p, gamma)
% computes the pressure coefficient of a panel according to the modified
% Newton method
%
%   INPUT: 
%       theta,  double[1, 1]: inglination angle between panel and free stream [deg]
%       M,      double[1, 1]: free stream mach number [-]
%       gamma,  double[1, 1]: specif heat ratio [-]
%   OUTPUT:     
%       CP,     double[1, 1]: pressure coefficient [-]


% Compute the total stagnation pressure/free stream pressure ratio 
%  - approximating the bow shock as normal shock -
NUM1 = (gamma + 1)^2 * M^2; 
DEN1 = 4*gamma*M^2 - 2*(gamma - 1); 

NUM2 = 2*gamma*M^2 - (gamma - 1); 
DEN2 = gamma + 1; 

pRatio = (NUM1/DEN1)^(gamma/(gamma - 1)) * NUM2/DEN2;  % [-] p02/p1

% compute the CP at the stagnation point
CpMax = 2/(gamma*M^2)*(pRatio - 1); 

% Compute the actual CP
CP = CpMax * sin(theta)^2;  

end

