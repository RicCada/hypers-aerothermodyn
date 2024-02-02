function data = configHypers()
    KM = 1000; 


    % Select vehicle
    data.vehicleName = 'STS'; 

    % Select flight conditionss
    data.fltcon.alpha = (0:5:45) *pi/180; 
    data.fltcon.mach = (18); 
    data.fltcon.alt = [61] .* KM; 
    
    data.fltcon.gamma = 1.4;

    % Set solver options
    data.common.optFsolve = optimoptions('fsolve','Display','off'); 
    
end