function [CL, CD] = profile2D(wing, solver)
    
    [~, ~, P, ~] = atmoscoesa(wing.fltcon.alt);
    
    alpha = wing.fltcon.alpha;

    switch solver
        case 'TW'
            cpVec = tanWedge2D(wing.fltcon.mach, P, alpha, wing.xx, wing.yy, wing.fltcon.gamma, wing.common);

        case 'SE'
            cpVec = shockexp2D(wing.fltcon.mach, P, alpha, wing.xx, wing.yy, wing.fltcon.gamma, wing.common);

    end
    
    cpXY = [0, 0];
    nEl = size(cpVec, 2);
    for i=1:2
        for j=1:nEl

            lVect = [wing.xx(j+1) - wing.xx(j), wing.yy(i, j+1) - wing.yy(i, j), 0];
            lNorm = vecnorm(lVect);
                
            normal = cross(lVect, [0, 0, 1]);
            normal = normal / norm(normal);
            normal = normal(1:2);
            
            if i==2
                normal = -normal;
            end
            
            cpXY = cpXY + cpVec(i, j) * lNorm * normal;
        end
    end
    
    CL = -cpXY(1)*sin(alpha) + cpXY(2)*cos(alpha);
    CD = cpXY(1)*cos(alpha) + cpXY(2)*sin(alpha);


end