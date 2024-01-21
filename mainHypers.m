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

data = configHypers; 

vehicle = readin(data.vehicleName);
vehicleData = meshdata(vehicle); 

[F, M, CpMat] = aero(vehicleData, data.fltcon); 

iAlp = 1; 
iMach = 1; 

printCP(vehicle.mesh, CpMat(:, iAlp, iMach), vehicleData.CG, iAlp, iMach, data.fltcon); 


