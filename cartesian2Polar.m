function [theta, rad] = cartesian2Polar(x, y)
% Takes in the cartesian coordinates of a point and returns the polar
% coordiantes. theta is the angle in degrees, and rad is the radius.
rad = sqrt(x^2 + y^2);
if (x > 0) && (y > 0)
    theta = 180*(atan(y/x))/pi;
elseif (x < 0)
    theta = 180 + 180*(atan(y/x))/pi;
elseif (x > 0) && (y < 0)
    theta = 360 + 180*(atan(y/x))/pi;
elseif (y > 0)
    theta = 90;
elseif (y < 0)
    theta = 270;
else
    theta = 0;
end
end