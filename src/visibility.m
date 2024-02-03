function indexVis = visibility(vehicleData, dir)
    
    nPanel = vehicleData.nPanel; 
    
    id = 1; 
    indexVis = true(1, nPanel); 
    idSorted = vehicleData.indOrd; 
        
    % remove panels oriented in the wrong direction
    for i = 1:nPanel
        normal = vehicleData.normal(i, :)'; 
        if dot(dir, normal) >= 0
            indexVis(i) = false; 
%             plot3(vehicleData.center(i, 1), vehicleData.center(i, 2), vehicleData.center(i, 3), 'MarkerSize', 20, 'Color', 'k', 'Marker', '.')            
        end
    end
    

    % scan the ok panels
    for id = 1:nPanel
        
        ids = idSorted(id); % idnex in the sorted order
        if indexVis(ids)
            % consider the beginning of the line as the center of the panel
            l0 = vehicleData.center(ids, :)';   
            
            indexLine = [];     % pre initialize vector to store the elements along the same line
            for i = 1:nPanel
                if (i ~= ids) && (indexVis(i)) % check each panel except for the source one and the ones already non visible

                    % for each of the other panels check if they are hit by the
                    % line
                    p0 = vehicleData.center(i, :)';  
                    normal = vehicleData.normal(i, :)'; 
        
                    if dot(dir, normal) ~= 0  % consider only the cases not parallel to the line
            
                        dist = dot((p0 - l0), normal)/dot(dir, normal); 
                        Pint = l0 + dir * dist; % intersection point between the line and the plane
                        
                        %%% Compute the rotated reference frame to resolve a planar problem
                        
                        % retrieve the triangle vertex - transpose to get column vectors
                        A = squeeze(vehicleData.vertex(i, 1, :)); 
                        B = squeeze(vehicleData.vertex(i, 2, :)); 
                        C = squeeze(vehicleData.vertex(i, 3, :)); 
    
                        % compute the reference frame aligned with the triangle
                        v1 = (A - B)./(norm(A - B));        % triangle side
                        v3 = vehicleData.normal(i, :)';     % triangle normal
                        v2 = cross(v3, v1);                 % complete the triad
                        
                        Rot = [v1'; v2'; v3'];              % rotation from xyz to planar
                        
                        % compute the points coordinates in the rotated
                        % reference frame
                        Ar = Rot*A; 
                        Br = Rot*B; 
                        Cr = Rot*C; 
                        Pr = Rot*Pint; 
    
                        innerFlag = innertri(Pr(1:2), Ar(1:2), Br(1:2), Cr(1:2));
            
                        if innerFlag
                          indexLine = [indexLine, i]; 
                        end
                    end
                end
    
            end
            % finisced loop on all the panels to get the ones in the same line
            indexLine = [indexLine, ids];   % store also the initial point
            
            % find the first element along the line of sight (greatest x-coordinate)
            idFirst = 0;      % index of the first element of the line
            xMax = realmin;  % maximum x cooridinate
            for j = indexLine
                xCenter = vehicleData.center(j, 1); 
                if xCenter > xMax
                    xMax = xCenter; 
                    idFirst = j; 
                end
            end

            % set false the visibility of all the non-first elements
            for j = indexLine
                if j ~= idFirst
                    indexVis(j) = false; 
%                     plot3(vehicleData.center(j, 1), vehicleData.center(j, 2), vehicleData.center(j, 3), 'MarkerSize', 20, 'Color', 'r', 'Marker', '.')                
%                     drawnow
                end
            end
        end
        clc; 
        fprintf('%d / %d, [%d visible]\n', id, nPanel, sum(indexVis)); 
    end
        
    for i = 1:vehicleData.nPanel
        if indexVis(i)
            plot3(vehicleData.center(i, 1), vehicleData.center(i, 2), vehicleData.center(i, 3), 'MarkerSize', 20, 'Color', 'y', 'Marker', '.')
        end
    end

end


