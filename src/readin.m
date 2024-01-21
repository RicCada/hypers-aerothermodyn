function [vehicle] = readin(objName)
%READIN creates structure with trianglation mesh data and model information 
% such as reference area, reference length, and CG location in mm and mm^2
% for models in the database

vehicle.mesh = stlread(strcat(objName, '.stl'));

fID = fopen(strcat(objName, '.txt'),'r');
data = fscanf(fID, '%f');

vehicle.data.SRef = data(1);
vehicle.data.LRef = data(2);
vehicle.data.CG = data(3:5);

end

