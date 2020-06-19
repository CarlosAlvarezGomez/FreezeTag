function [x, y] = polar2Cartesian(theta, rad)
% Takes in the polar coordinates of a point and returns the cartesian
% coordiantes. theta is the angle in degrees, and rad is the radius.
theta = rem(theta, 360);
if (theta == 180)
    x = -rad;
    y = 0;
elseif (theta == 90)
    x = 0;
    y = rad;
elseif (theta == 270)
    x = 0;
    y = -rad;
else
    angleInRadians = theta*pi/180;
    x = cos(angleInRadians) * rad;
    y = sin(angleInRadians) * rad;
end
x = round(x, 6);
y = round(y, 6);
end