function outvec = normalShock(M1, gamma, outlist)
%   Function to evaluate the normal shock parameters
%   INPUT:
%       M1,      double[1, 1]: mach number before the shock
%       gamma,   double[1, 1]: specif heat ratio [-]
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

nout = length(outlist);    
outvec = zeros(size(outlist));      % preallocate the output vector

for i = 1:nout

    switch outlist(i)
        case 1                      % compute the mach number after the shock
            NUM = 2 + (gamma - 1) .* M1.^2; 
            DEN = 2.*gamma.*M1.^2 + 1 - gamma; 
            res = sqrt(NUM./DEN); 

        case 2                      % compute the density ratio  
            NUM = (gamma + 1).*M1.^2; 
            DEN = 2 + (gamma - 1).*M1.^2; 
            res = NUM./DEN; 

        case 3                      % compute the pressure ratio
            NUM = 2*gamma.*M1.^2 + 1 - gamma; 
            DEN = gamma +  1;
            res = NUM./DEN;

        case 4                      % compute the temperature ratio
            NUM1 = (2*gamma.*M1.^2 + 1 - gamma); 
            DEN1 = gamma + 1; 
            NUM2 = 2 + (gamma - 1).*M1.^2; 
            DEN2 = (gamma + 1).*M1.^2; 
            res = (NUM1 .* NUM2) ./ (DEN1 .* DEN2); 

        case 5                      % compute the total pressure ratio
            NUM = M1.^2.*(gamma + 1).^((gamma+1)/gamma); 
            DEN1 = 2 + (gamma - 1).*M1.^2; 
            DEN2 = (2*gamma.*M1.^2 + 1 - gamma).^(1/gamma); 
            res = (NUM./(DEN1.*DEN2)).^(gamma/(gamma - 1)); 

        otherwise
            error('Output parameters are listed from 1 to 5 only')
    end

    outvec(i) = res; 
end


end

