function [dir, dist] = sideNormalDirection(Cx, A, B)
    
    % compute the side distance from the center
    dist = abs( (B(1) - A(1)) * (A(2) - Cx(2)) - (A(1) - Cx(1)) * (B(2) - A(2)) ) / ...
           sqrt( (B(1) - A(1))^2 + (B(2) - A(2))^2 ); 

    vAB = A - B; 
    if vAB(1) ~= 0 
        u = - vAB(2)/vAB(1); 
        dir = [u; 1]; 
    else
        dir = [1; 0]; 
    end

    dir = dir/norm(dir); 
    
    PCx = dist * dir + Cx;  % project the center in the given segment
    vPCxB = PCx - B;   % compute the segment from B to the center projection
    
    par = vPCxB(1)*vAB(2) - vPCxB(2)*vAB(1);  % Compute the vectorial product in 2D
    

    if abs(par) < 1e-6
        dir = dir; 
    else
        dir = -dir; 
    end


end

