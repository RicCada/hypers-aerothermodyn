function inner = innertri(P, A, B, C)
%   inner = innertri(P, A, B, C): computes if the point P is inner in the 
%   triangle defined by A, B, C
    
    % compute the triangle centroid 
    Cx = (A + B + C)/3;
    
    % compute the direction vector from the center to a given side
    [dirAB, distAB] = sideNormalDirection(Cx, A, B);
    [dirBC, distBC] = sideNormalDirection(Cx, B, C); 
    [dirAC, distAC] = sideNormalDirection(Cx, A, C); 
    
    % compute projections
    prjAB = dot(dirAB, P - Cx); 
    prjBC = dot(dirBC, P - Cx); 
    prjAC = dot(dirAC, P - Cx); 
    
    if prjAB < distAB && prjBC < distBC && prjAC < distAC
        inner = true; 
    else
        inner = false; 
    end

end

