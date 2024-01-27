function outvec = obliqueShock(M1, beta, theta, gamma, outlist)
%   Function to evaluate the normal shock parameters
%   INPUT:
%       M1,      double[1, 1]: mach number before the shock
%       beta,    double[1, 1]: oblique shock angle [rad]
%       gamma,   double[1, 1]: specif heat ratio [-]
%       theta,   double[1, 1]: wedge angle [rad]
%       outlist, double[1, n]: contains the list of the output parameters
%                              IDs according to the following legend,
%                              output will be retrieved with the same order
%                              - 1: mach number after the shock [M2]
%                              - 2: density ratio  [rho2/rho1]
%                              - 3: pressure ratio [p2/p1]
%                              - 4: temperature ratio [T2/T1]
%                              - 5: total pressure ratio [p02/p01]
%   OUTPUT:
%       outvec, double[1, n]: contains the output parameters requested in outilst

if any(M1 <= 1)
    error('The flow uptstream shall be supersonic'); 
end

M1n = M1*sin(beta);                 % flow normal to the shockwave
outvec = normalShock(M1n, gamma, outlist); 

% correct the mach number after the shock
if any(outlist == 1)
    indM2 = find(outlist == 1);    
    outvec(indM2) = outvec(indM2)/sin(beta - theta); 
end


end

