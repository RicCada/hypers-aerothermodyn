%{

SOFTWARE TO COMPUTE THE AERODYNAMIC FORCES OF A HYPERSONIC REENTRY VEHICLE

THE VEHICLE REFERENCE FRAME SHALL BE DEFINED AS: 
    X-AXIS: towards the nosecone
    Z-AXIS: up
    Y-AZIS: complete the triad


nome -> readin -> vehicle 
                        - triangulation 
                        - data : SRef [1x1]
                               : LRef [1x1]
                               : xCG [3x1]
%}




clc;
clear; 
close all; 

addpath(genpath('src\')); 

% load config
data = configHypers; 

vehicle = stlread(strcat('data\', data.vehicle)); 
vehicleData = meshdata(vehicle); 


P = vehicleData.center; 
F = vehicleData.normal;


figure; 
s = trisurf(vehicle, 'FaceColor','cyan','FaceAlpha',0.8); hold on
quiver3(P(:, 1),P(:, 2),P(:, 3),F(:, 1),F(:, 2),F(:, 3),0.5,'color','r');

dir = [1,0, 0.5]; 
cpVec = vehicleCp(6, dir/norm(dir), F', 1.4); 

%% Plot

figure('Name','Result')
s2 = trisurf(vehicle, 'EdgeColor','none'); 
s2.CData = cpVec; 
colormap turbo; axis equal; 
colorbar
xlabel('x'),    ylabel('y'),    zlabel('z'); 