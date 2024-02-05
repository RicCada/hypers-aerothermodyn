function indexVis = visibilityMod(vehicleData, dir)
%   indexVis = visibilityMod(vehicleData, dir): function to exclude the panels shaded by other panels in the flow direction
%   INPUT: 
%       vehicleData,    struct: contains informations about the vehicle
%               - center,    double[n, 3]: center cordinate of each panel
%               - area,      double[n, 1]: area of each panel
%               - normal,    double[n, 3]: normal unit vector to each panel
%               - areaTotal, double[1, 1]: total external area of the model
%               - nPanel,    double[1, 1]: number of panels (nPanel == n)
%               - vertex,    double[n, 3, 3]: vertex of each panel, each
%                                             vertex has coordinates [i, j, :]
%               - indOrd,    double[n, 1]: ordered indexes in x-coordinate
%                                          descending order
%               - SRef,      double[1, 1]: reference surface
%               - LRef,      double[1, 1]: reference length
%               - CG,        double[1, 3]: CG coordinates
%       dir,      double[3, 1]: flow direction in body reference frame
%   OUTPUT: 
%       indexVis,  logic[1, n]: true if the panel is visible, false otherwise
    

    nPanel = vehicleData.nPanel; 


    % remove panels oriented in the wrong direction
    indexVis = ((vehicleData.normal * dir) < 0)'; 

    % update the idSorted array to contain also the non sorted order
    idPanels = 1:nPanel; 
    idPanels = idPanels(indexVis); 
        
    % compute the number of visible panels to be processed
    nPanelVis = length(idPanels); 
   
    A = zeros(3, 1); 
    B = zeros(3, 1); 
    C = zeros(3, 1); 

    % preallocation work array - used to keep trace of the panels in the
    % line of sight: the first line contains the panel number, the second
    % the distance from the reference
    losWork = nan(2, nPanelVis); 

    %%% --------------- DEBUG ONLY ---------------
    % for k = 1:nPanelVis
    %   i = idPanels(k); 
    %   plot3(vehicleData.center(i, 1), vehicleData.center(i, 2), vehicleData.center(i, 3), 'MarkerSize', 20, 'Color', 'k', 'Marker', '.')
    % end
    %%% -----------------------------------------
   
    % scan visible panels
    for idRed = 1:nPanelVis
        
        idp0 = idPanels(idRed);                           % index of the reference panel (the source of the "line")
        if indexVis(idp0)
            
            % consider the beginning of the line as the center of the panel
            l0 = vehicleData.center(idp0, :)';   

            %%% --------------- DEBUG ONLY ---------------
            % plot3(l0(1), l0(2), l0(3), 'MarkerSize', 20, 'Color', 'y', 'Marker', '.')
            %%% ------------------------------------------

            for i = 1:nPanelVis
                id = idPanels(i);                               % index of the considered panel 
                if (id ~= idp0) && (indexVis(id))             % check each panel except for the source one and the ones already non visible
                    
                    % for each of the other panels check if they are hit by the line
                    p0 = vehicleData.center(id, :)';  
                    normal = vehicleData.normal(id, :)'; 
        
            
                    dist = dot((p0 - l0), normal)/dot(dir, normal); 
                    Pint = l0 + dir * dist;              % intersection point between the line and the plane
                    
                    %%% Compute the rotated reference frame to resolve a planar problem
                    
                    % retrieve the triangle vertex - transpose to get column vectors
                    VMat = vehicleData.vertex(id, :, :); 
                    A(1) = VMat(1, 1, 1);
                    A(2) = VMat(1, 1, 2);
                    A(3) = VMat(1, 1, 3);
                    
                    B(1) = VMat(1, 2, 1); 
                    B(2) = VMat(1, 2, 2); 
                    B(3) = VMat(1, 2, 3); 

                    C(1) = VMat(1, 3, 1); 
                    C(2) = VMat(1, 3, 2); 
                    C(3) = VMat(1, 3, 3); 

                    % compute the reference frame aligned with the triangle
                    v1 = (A - B)./(norm(A - B));         % triangle side
                    v3 = vehicleData.normal(id, :)';      % triangle normal
                    v2 = cross(v3, v1);                  % complete the triad
                    
                    Rot = [v1'; v2'; v3'];               % rotation from xyz to planar
                    
                    % compute the points coordinates in the rotated
                    % reference frame
                    Ar = Rot*A; 
                    Br = Rot*B; 
                    Cr = Rot*C; 
                    Pr = Rot*Pint; 
         
                    if innertri(Pr(1:2), Ar(1:2), Br(1:2), Cr(1:2))
                      losWork(:, i) = [id; dist]; 
                      
                      %%% --------------- DEBUG ONLY ---------------
                      % plot3(p0(1), p0(2), p0(3), 'MarkerSize', 20, 'Color', 'b', 'Marker', '.')
                      %%% -----------------------------------------
                    end
                    
                end
    
            end
            % finished loop on all the panels to get the ones in the same line
            losWork(:, idRed) = [idp0; 0]; 
            nNanId = not(isnan(losWork(1,:)));
            indexLine = losWork(1, nNanId); 
            distLine = losWork(2, nNanId); 
            losWork(:, nNanId) = nan; 
            % find the first element along the line of sight (greatest x-coordinate)
            
            [~, iDMin] = min(distLine); 
            for j = 1:length(indexLine)
                if j ~= iDMin
                    indexVis(indexLine(j)) = false;
                    %%% --------------- DEBUG ONLY ---------------
                    % plot3(vehicleData.center(indexLine(j), 1), vehicleData.center(indexLine(j), 2), vehicleData.center(indexLine(j), 3),...
                    %       'MarkerSize', 20, 'Color', 'r', 'Marker', '.')                
                    %%% ------------------------------------------
                end
            end

        end
        
%         %%% --------------- DEBUG ONLY ---------------
%         clc; 
%         fprintf('%d / %d, [%d visible]\n', idRed, nPanel, sum(indexVis)); 
%         %%% ------------------------------------------

    end
        
    %%% --------------- DEBUG ONLY ---------------
    % for i = 1:vehicleData.nPanel
    %     if indexVis(i)
    %         plot3(vehicleData.center(i, 1), vehicleData.center(i, 2), vehicleData.center(i, 3), 'MarkerSize', 20, 'Color', 'y', 'Marker', '.')
    %     end
    % end
    %%% -----------------------------------------

end


