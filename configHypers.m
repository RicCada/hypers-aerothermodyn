function data = configHypers()
    KM = 1000; 


    % Select vehicle
    data.vehicleName = 'ApolloCapsule'; 

    % Select flight conditionss
    data.fltcon.alpha = (26.1) *pi/180; 
    data.fltcon.alt = [75] .* KM; 
    [~,vSon,~,~] = atmoscoesa(data.fltcon.alt);
    data.fltcon.mach = (9600/vSon);

    data.fltcon.gamma = 1.4;

    % Set solver options
    data.common.optFsolve = optimoptions('fsolve','Display','off'); 
    
end