function [F, M, CpMat] = aero(vehicleData,fltcon)
%   [F, M, CpMat] = aero(vehicleData,fltcon)
%   computes the aerodynamic forces in hypersonic regime
%
%   INPUT: 
%       vehicleData,    struct: data about the vehicle 
%           - center,   double[n, 3]: center of each panel [m]
%           - area,     double[n, 1]: area of each panel [m2]
%           - normal,   double[n, 3]: normal unit vector to each panel [-]
%           - vertex,   double[n, 3, 3]: vertex of each triangle [m]
%           - areaTotal,double[1, 1]: total area of the object [m2]
%           - nPanel,   double[1, 1]: number of panels
%           - SRef,     double[1, 1]: reference area [m2]
%           - lRef,     double[1, 1]: reference length [m]
%       fltcon,         struct: flight conditions
%           - alpha,    double[1, nAlpa]: angle of attack vector [deg]
%           - mach,     
%           - alt, 
%   OUTPUT: 
%       F,              double[3, nAlp, nMach, nAlt]: forces on x, y, z body [N]
%       M,              double[3, nAlp, nMach, nAlt]: moments on x,y, z body wrt the origin [Nm]
%       CpMat,          double[n, nAlp, nMach]: CP of each panel

%%% preallocation
nPanel = vehicleData.nPanel; 
SRef = vehicleData.SRef; 
lRef = vehicleData.LRef; 
normVec = vehicleData.normal';   % normal direction to each panel
center = vehicleData.center';    % center of each panel
area = vehicleData.area;         % area of each panel
cg = vehicleData.CG; 

% angle of attack
alphaVec = fltcon.alpha; 
nAlp = length(alphaVec); 

% mach number
machVec =  fltcon.mach; 
nMach = length(machVec); 

% altitude 
altVec = fltcon.alt; 
nAlt = length(altVec); 

% specif heat constant [-]
gamma = fltcon.gamma; 

% output data
F = zeros(3, nAlp, nMach, nAlt); 
M = zeros(3, nAlp, nMach, nAlt); 
CpMat = zeros(nPanel, nAlp, nMach); 


%%% loop on flight conditions
for iA = 1:nAlp                 % loop on angle of attack
    for iM = 1:nMach            % loop on mach
        alpha = alphaVec(iA);   % [deg] AoA 
        mach = machVec(iM);     % [-] Mach number

        fsDir = [-cos(alpha), 0, sin(alpha)];         % free stream direction
        cpIt = newtonMod(mach, fsDir, normVec, gamma); % [-] cp of each panel in the given conf
        
        indComp = cpIt ~= 0;            % save index of nonzero elements

        [CF, CM] = synths(cpIt(indComp)', normVec(:, indComp), area(indComp)', center(:, indComp), cg, SRef, lRef);     % compute force and moment coeff

        [~, vSon, ~, rho] = atmoscoesa(altVec); % compute atmospheric data
        v = mach * vSon; 

        % compute aerodynamic forces
        F(:, iA, iM, :) = 0.5 .* rho .* v.^2 .* SRef .* CF;
        M(:, iA, iM, :) = 0.5 .* rho .* v.^2 .* SRef .* lRef .* CM; 
        CpMat(:, iA, iM) = cpIt; 
    end
end


end

