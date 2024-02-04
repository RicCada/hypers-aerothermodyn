%{

SOFTWARE TO COMPUTE THE AERODYNAMIC FORCES OF A HYPERSONIC REENTRY VEHICLE

THE VEHICLE REFERENCE FRAME SHALL BE DEFINED AS: 
    X-AXIS: towards the nosecone
    Z-AXIS: up
    Y-AZIS: complete the triad
%}




clc;
clear; 
close all; 

addpath(genpath('src\')); 
addpath(genpath('data\'));

data = configHypers; 

vehicle = readin(data.vehicleName);
vehicleData = meshdata(vehicle); 

[F, M, CpMat, LD, coeffs] = aero(vehicleData, data.fltcon);
delcel = LD(2, :)./vehicle.data.mass

iAlp = 1; 
iMach = 1; 

printCP(vehicle.mesh, CpMat(:, iAlp, iMach), vehicleData.CG, iAlp, iMach, data.fltcon); 

wing = wingDesign;

[CL, CD] = profile2D(wing, wing.solver);





