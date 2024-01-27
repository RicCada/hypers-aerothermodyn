function cpVec = newtonMod(mach, fsdir, normalVec, gamma)
%   cpVec = vehicleCp(mach, fsdir, vehicleData)
%   funcition to compute the pressure coefficient of each panel in
%   vehicleData with the Modified Newton method
%
%   INPUT
%       mach,      double[1, 1]: free stream mach number [-]
%       fsdir,     double[3, 1]: free stream direction in body reference frame - unit vector [-]
%       normalVec, double[3, n]: normal to each panel - unit vector
%       gamma,     double[1, 1]: specif heat constant [-]
%   OUTPUT:     
%       cpVec,     double[n, 3]: pressure coefficient of each panel

nPanel = size(normalVec, 2); 
cpVec = zeros(nPanel, 1); 

for i = 1:nPanel

    normal = normalVec(:, i);   % normal unit vector to the panel

    dotProd = dot(normal, fsdir); 

    if dotProd < 0  % the panel is hit by the free stream
        theta = acos(dotProd) - pi/2;  % inclination angle: free stream wrt panel
        cpVec(i) = panlcp(theta, mach, gamma);   % compute the CP
    end

end


end