function data = configHypers()
    KM = 1000; 


    % Select vehicle
    data.vehicleName = 'ApolloCapsule'; 

    % Select flight conditionss
    data.fltcon.alpha = (30) *pi/180; 
    data.fltcon.mach = (10); 
    data.fltcon.alt = [80] .* KM; 
    
    data.fltcon.gamma = 1.4;

    % Set solver options
    data.common.optFsolve = optimoptions('fsolve','Display','off'); 
    
end