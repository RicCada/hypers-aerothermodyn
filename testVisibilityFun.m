close all; clc; 

dir = [-1; 0; 2]; 

% trisurf(vehicle.mesh, 'FaceAlpha', 0.5, 'FaceColor', 'Cyan');
% hold on; grid on; axis equal; 
% xlabel('x');    ylabel('y');     zlabel('z'); 

%%

tic
    idx = visibility(vehicleData, dir); 
time = toc
tic
    idx = visibilityMod(vehicleData, dir); 
timeMod = toc



%%
figure('Name', 'Result')
ss = trisurf(vehicle.mesh, 'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on; grid on; axis equal; 
xlabel('x');    ylabel('y');     zlabel('z'); 
ss.CData = ones(size(idx)).*idx; 



