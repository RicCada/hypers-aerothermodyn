function cpVec = tanWedge2D(M1, p1, alpha, xx, yy, gamma, common)
%   cpVec = shockexp(mach, fsdir, vehicleData)
%   funcition to compute the pressure coefficient of the contour of a given
%   2D section with the shock expantion method
%
%   INPUT: 
%       M1,     double[1, 1]: free stream mach number [-]     
%       p1,     double[1, 1]: free stream static pressure [Pa]
%       alpha,  double[1, 1]: angle of attack [rad]
%       xx,     double[1, n]: x-coordinates the the section contour [m]
%       yy,     double[2, n]: y-coordinates of the upper(1) and lower(2) section contour [m]
%       gamma,  double[1, 1]: specific heat ratio [-]
%       common,       struct: contains common variables
%                           - optFsolve: options for the fsolve algorithm
%   OUTPUT:
%       cpVec,  double[2, n]: Pressure coefficient at each location of the upper (1) and 
%                             lower (2) contour

    npts = length(xx) - 1; 
    cpVec   = zeros(2, npts); 

    for i = 1:2 % account for upper and lower surface

        thetaGeom = atan2(diff(yy(i, :)), diff(xx));                        % compute the local inclination in body axis
        theta = thetaGeom - alpha;                                          % compute local inclination in wind axis
        if i == 2                                                           % consider the opposite angle value for the lower surface
            theta = -theta; 
        end
        
        beta = 0.01;                                                        % first beta guess
        for n = 1:npts
            
            if theta(n) > 0 % if segment is exposed to free stream
                funBeta = @(x) obliqueShockAngle(x, M1, gamma) - theta(n);
                [beta, ~, iexit] = fsolve(funBeta, beta, common.optFsolve); % compute the shockwave angle
                
                % compute mach number and pressure ratio after the initial shock
                if iexit == 1
                    resVec = obliqueShock(M1, beta, theta(n), gamma, [1 3]);  % oblique shock
                else
                    beta = pi/2; 
                    resVec = normalShock(M1, gamma, [1, 3]);                % normal shock
                end
                
                p2p1 = resVec(2);                                           % extract the pressure ratio     
                p2 = p2p1 * p1;                                             % compute pressure at local point
                
                % free stream total pressure [Pa]
                p0 = (1 + (gamma-1)/2 * M1^2)^(gamma/(gamma-1)) * p1; 
                
                % compute the pressure coefficient
                cpVec(i, n) = (p2 - p1)./(p0 - p1); 
            end        
        end
    end
end


function theta = obliqueShockAngle(beta, M, gamma)
    % Compute the oblique shock angle
    % INPUT:   
    %   M: mach number before shock
    %   beta: oblique shock wave angle
    % OUTPUT:
    %   theta: wedge semi angle

    NUM = M.^2 .* sin(beta).^2 - 1; 
    DEN = (gamma + cos(2*beta)).*M.^2 + 2; 

    theta = atan(2./tan(beta) .* NUM./DEN); 
end