function cpVec = shockexp2D(M1, p1, alpha, xx, yy, gamma, common)
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
    machVec = zeros(2, npts); 
    cpVec   = zeros(2, npts); 
    beta = zeros(2, 1); 

    for i = 1:2                                                         % account for upper and lower surface

        thetaGeom = atan2(diff(yy(i, :)), diff(xx));                    % compute the local inclination in body axis
        theta = thetaGeom - alpha;                                      % compute local inclination in wind axis
        if i == 2                                                       % consider the opposite angle value for the lower surface
            theta = -theta; 
        end

        theta0 = theta(1);                                              % compute the initial wedge angle
    
        funBeta = @(x) obliqueShockAngle(x, M1, gamma) - theta0; 
    
        [beta(i),~, iexit] = fsolve(funBeta, 0.01, common.optFsolve);   % compute the shockwave angle
        
        % compute mach number and pressure ratio after the initial shock
        if iexit == 1
            resVec = obliqueShock(M1, beta(i), theta0, gamma, [1 3]);     % oblique shock
        else
            beta(i) = pi/2; 
            resVec = normalShock(M1, gamma, [1, 3]);                      % normal shock
        end
    
        
        M2 = resVec(1);                                                   % extract the mach number
        p2p1 = resVec(2);                                                 % extract the pressure ratio 
        
        for j = 1:npts                                                    % compute the mach at each segment
            if theta(j) > 0                                               % compute the mach only if the segment is visible from the flow (i.e. theta > 0)
                nui = prandtlMeyer(M2, gamma) + theta0 - theta(j);        % evaluate the prandtl-meyer function at the given location 
                pmFun = @(x) prandtlMeyer(x, gamma) - nui;                
                machVec(i,j) = fsolve(pmFun, M2, common.optFsolve);       % compute the coresponding mach number
            end
        end
        indComp = theta > 0;                                              % retrieve the indexes of elements to be computed (i.e. theta > 0)  

        % pressure at each location [Pa]
        pVec = ((1 + (gamma-1)/2 * M2^2)./(1 + (gamma-1)/2.*machVec(i, :).^2)).^(gamma/(gamma-1)); 
        pVec = pVec .* (p2p1 * p1);
        
        % free stream total pressure [Pa]
        p0 = (1 + (gamma-1)/2 * M1^2)^(gamma/(gamma-1)) * p1; 
        
        % compute the pressure coefficient
        cpVec(i, indComp) = (pVec(indComp) - p1)./(p0 - p1); 
    end
   


end


function nu = prandtlMeyer(M, gamma)
    % Evaluate the Prandtl - Meyer function

    ARG1 = sqrt((gamma-1)/(gamma+1)*(M^2 - 2)); 
    ARG2 = sqrt(M^2 - 1); 
    nu = sqrt((gamma + 1)/(gamma - 1)) * atan(ARG1) - atan(ARG2);

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









