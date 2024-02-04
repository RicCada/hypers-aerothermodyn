function data = wingDesign()

    KM = 1000; 

    % Select flight conditionss
    data.fltcon.alpha = (2) *pi/180; 
    data.fltcon.mach = (6.7); 
    data.fltcon.alt = [58.5] .* KM; 
    
    data.fltcon.gamma = 1.4;

    % Set solver options
    data.common.optFsolve = optimoptions('fsolve','Display','off'); 
    
    % wing profile data
    data.rootC = 4.54;
    data.tipC = 0.91;
    
    load("66006.mat");

    data.xx =  NACA66006(:,1)';
    data.yy = [NACA66006(:,2)'; -1*NACA66006(:,2)'];
    
    data.solver = 'TW'; % TW or SE
end
