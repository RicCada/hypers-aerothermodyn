function fig = printCP(meshData, cpVec, CG, iAlpha, iMach, fltcon)
    
    alphaDeg = round(rad2deg(fltcon.alpha(iAlpha)), 1); 
    mach = round(fltcon.mach(iMach), 1); 

    fig = figure('Name','Result'); 
    % plot the body surface
    s2 = trisurf(meshData, 'EdgeColor','none', 'FaceAlpha', 0.8); hold on; 
    plot3(CG(1), CG(2), CG(3), 'LineStyle','none', 'MarkerSize',10, ...
        'Marker','diamond', 'MarkerFaceColor','r', 'MarkerEdgeColor','none'); 
    xlabel('x [m]'),    ylabel('y [m]'),    zlabel('z [m]'); 
    
    % axis settings
    axis equal; colormap turbo; 
    
    % change colormap settings with the correct cp
    s2.CData = cpVec; 
    
    % plot the colorbar
    cb = colorbar; 
    cb.Label.String = "CP"; 

    % title
    subtit = strcat('AoA: ', num2str(alphaDeg), {' '}, ' [deg] || Mach: ', num2str(mach));
    title('Pressure Coefficient'); 
    subtitle(subtit)
    
    view(60,30)


end

