function T = getCoordinateTransform(A)
% getCoordinateTransform.m: This will find the transformation matrix,
% scaling factor, and translation. 
% Very useful for registering videos to same coordinates. 

[b dev stats] = glmfit([A.xAxis(1,1) A.xAxis(2,1)],[A.xAxis(1,2) A.xAxis(2,2)]);

rotAngle = -rad2deg(atan(b(2))); % need to rotate image eventually! 
R = [cosd(rotAngle) -sind(rotAngle); sind(rotAngle) cosd(rotAngle)];

% Distance between pokes in pixels:
d_pixels = sqrt((A.xAxis(1,1)-A.xAxis(2,1))^2 + (A.xAxis(1,2)-A.xAxis(2,2))^2);
convFactor = d_pixels/A.xLength; % transform from pixels to cm

c = R*A.origin';

T.R = R;
T.trans = [-c(1,1); -c(2,1)];
T.scaling = convFactor;


