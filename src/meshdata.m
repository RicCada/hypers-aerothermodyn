function vehicle = meshdata(vehicleInit)
    
    %%% Initialization
    vehicle = struct; 
    nPanel = size(vehicleInit.ConnectivityList, 1); % panel number
    
    areaVec = zeros(nPanel,1); 
    vertex = zeros(nPanel, 3, 3); % vertex of each panel
    center = zeros(nPanel, 3);  % coordinates of the center of each triangle

    %%% compute area of each panel
    for i = 1:nPanel
        
        % extract the points composing the i-th triangle
        pts = vehicleInit.Points(vehicleInit.ConnectivityList(i, :), :); 
        p1 = pts(1, :); 
        p2 = pts(2, :); 
        p3 = pts(3, :); 

        % compute the triangle side vectors
        s21 = p2 - p1;  
        s31 = p3 - p1; 

        % compute the area
        areaVec(i) = 0.5 * norm(cross(s21, s31)); 
        
        % compute the center position
        center(i, 1) = (p1(1) + p2(1) + p3(1))/3; 
        center(i, 2) = (p1(2) + p2(2) + p3(2))/3; 
        center(i, 3) = (p1(3) + p2(3) + p3(3))/3; 

        % save vertex position
        vertex(i, :, :) = [p1; p1; p3]; 
     
    end
    
    normVec = faceNormal(vehicleInit);  % normal vector to each panel
    
    vehicle.center = center; 
    vehicle.area = areaVec; 
    vehicle.normal = normVec;
    vehicle.vertex = vertex; 
    vehicle.areaTotal = sum(vehicle.area); 
    vehicle.nPanel = nPanel; 

end

