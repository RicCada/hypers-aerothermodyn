function data = configHypers()
    KM = 1000; 
    RE = 6.3781e6; 

    % Select vehicle
    data.vehicleName = 'Plug'; 

    % Select flight conditionss
    data.fltcon.alpha = (-180:5:180) *pi/180; 
    data.fltcon.alt = [105] .* KM; 
        
    hGP = data.fltcon.alt/(1 + data.fltcon.alt/RE); 
    T = atmoscira(0, 'GPHeight', hGP); 
    vSon = sqrt(1.4 * 287.05 * T); 

    data.fltcon.mach = (9600/vSon);


    data.fltcon.gamma = 1.4;

    % Set solver options
    data.common.optFsolve = optimoptions('fsolve','Display','off'); 
    
end