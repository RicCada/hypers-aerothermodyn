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

trisurf(vehicle, 'FaceColor','cyan','FaceAlpha',0.8)
hold on
quiver3(P(:,1),P(:,2),P(:,3),F(:,1),F(:,2),F(:,3),0.5,'color','r'); 
hold off;