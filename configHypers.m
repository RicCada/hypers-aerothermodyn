function data = configHypers()
    KM = 1000; 


    % Select vehicle
    data.vehicleName = 'ApolloCapsule'; 


    % Select flight conditionss
    data.fltcon.alpha = (20) *pi/180; 
    data.fltcon.mach = (6); 
    data.fltcon.alt = [60] .* KM; 
    
    data.fltcon.gamma = 1.4;

end