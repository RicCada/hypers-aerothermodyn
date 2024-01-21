function [CF, CM] = synths(CP, normal, area, center, cg, aRef, lRef)
%   [CF, CM] = synths(cp, normal, area, center)
%   function to compute the three compoents of force and moment coefficient
%
%   INPUT: 
%       CP,     double[1, n]: pressure coefficient of each panel [-]
%       normal, double[1, n]: normal vector to each panel [-]
%       area,   double[1, n]: area of each panel [m2]
%       center, double[3, n]: center of each panel [m]
%       nPanel, double[1, 1]: number of panels [-]
%       aRef,   double[1, 1]: reference area [m2]
%       lRef,   double[1, 1]: reference length [m]
%   OUTPUT: 
%       CF,     double[3, 1]: force coefficient on the three axis [CA, CY, CN]
%       CM,     double[3, 1]: moment coefficient on the three axis [Cl, Cm, Cn]

position = center - cg.*ones(size(center)); 

dF = 1/aRef * (CP .* (-1*normal) .* area);  
dM = 1/lRef * cross(position, dF); 

CF = sum(dF, 2);
CM = sum(dM, 2); 

end

