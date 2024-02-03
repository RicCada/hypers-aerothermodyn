function vehicle = meshdata(vechileInit)
%   vehicle = meshdata(vehicleInit): preprocess the mesh data coresponding
%   to a given vehicle
%
%   INPUT: 
%       vehicleInit,    triangulation: triangulation data of the requested model    
%   OUTPUT:
%       vehicle,    struct: preprocessed data
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

    vehicleMesh = vechileInit.mesh; 
    data = vechileInit.data; 

    %%% Initialization
    vehicle = struct; 
    nPanel = size(vehicleMesh.ConnectivityList, 1); % panel number
    
    areaVec = zeros(nPanel,1); 
    vertex = zeros(nPanel, 3, 3); % vertex of each panel
    center = zeros(nPanel, 3);  % coordinates of the center of each triangle

    %%% compute area of each panel
    for i = 1:nPanel
        
        % extract the points composing the i-th triangle
        pts = vehicleMesh.Points(vehicleMesh.ConnectivityList(i, :), :); 
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
        vertex(i, :, :) = [p1; p2; p3]; 
     
    end
    
    %%% sort panels in x-coordinate descending order
    datawork = sortrows([center(:, 1), (1:nPanel)'], 'descend'); 
    idOrd = datawork(:, 2);     % extract the ordered indices of the panels
    
    normVec = faceNormal(vehicleMesh);  % normal vector to each panel
    
    vehicle.center = center; 
    vehicle.area = areaVec; 
    vehicle.normal = normVec;
    vehicle.vertex = vertex; 
    vehicle.indOrd = idOrd; 
    vehicle.areaTotal = sum(vehicle.area); 
    vehicle.nPanel = nPanel; 
    vehicle.SRef = data.SRef; 
    vehicle.LRef = data.LRef; 
    vehicle.CG = data.CG;  %+ data.LRef/2*[0 1 1]'; 

end

