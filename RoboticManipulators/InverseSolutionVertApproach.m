function interval = InverseSolutionVertApproach(x, y, z, gap)
% a1 = 7;
% a2 = 14.6;
% a3 = 18.7;
% a4 = 7.5;
a1 = 6.9;
a2 = 14.5;
a3 = 18.6;
a4 = 7.5;

% The first angle is defined by the x,y coordinates. 
theta1 = atan2d(y, x)
working_x = x;
working_y = y;
working_z = z + 7.2827;
% The z I am trying to solve for is higher than the given z
% because the distance from the final joint at x3y3z3 to the center of the
% gripper pads is 7.2827 cm. This function delivers angles to get
% x3y3z3 to the right spot just above the given (x,y,z) and I set theta4 to 
% stretch straight down for the grab.
r = sqrt(working_x^2 + working_y^2);
s = working_z - a1;
if (r < 14) error('Point is too close to arm base. Cannot reach it.\n')
end
% On the plane defined by z0 and the displacements of the links, r and s
% are the new effective x and y to solve the 2 link problem. See page 103
% of Spong.
D = (r^2 + s^2 - a2^2 - a3^2)/(2*a2*a3);
if (D > 1) error('cos(theta3) > 1. Not in my universe, man!') % quit, it's supposed to be cos(theta3)
end
theta3 = atan2d(-sqrt(1 - D^2), D);
theta2 = atan2d(s, r) - atan2d(a3*sind(theta3), a2 + a3*cosd(theta3))
theta3 % just to print the result
theta4 = - theta2 - theta3 - 90.0  % draw a picture. I think it's right.
 
% Now define the homogeneous transformation matrix for each link
% A1 = [cosd(theta1), 0, sind(theta1), 0; sind(theta1), 0, -cosd(theta1), 0; 0, 1, 0, a1; 0, 0, 0, 1];
% A2 = [cosd(theta2), -sind(theta2), 0, a2*cosd(theta2); sind(theta2), cosd(theta2), 0, a2*sind(theta2); 0, 0, 1, 0; 0, 0, 0, 1];
% A3 = [cosd(theta3), -sind(theta3), 0, a3*cosd(theta3); sind(theta3), cosd(theta3), 0, a3*sind(theta3); 0, 0, 1, 0; 0, 0, 0, 1];
% A4 = [cosd(theta4), -sind(theta4), 0, a4*cosd(theta4); sind(theta4), cosd(theta4), 0, a4*sind(theta4); 0, 0, 1.0, 0; 0, 0, 0, 1.0];
 
% Translate the angles, in degrees, into the pwm values, in microseconds, 
% to bring the links to the desired angles. These conversion equations
% were obtained by measurement of extreme positions in the lab.
pwm1 = floor(1500 - 9.375*theta1)
pwm2 = floor(750 + 8.2418*theta2)
pwm3 = floor(750 - 8.8235*theta3)
pwm4 = floor(1500 + 9.375*theta4)
pwm5 = floor(2250 - 415.4839*gap)

% open serial port to robot
helloRobot = serial('com1','BaudRate',115200,'DataBits',8,'StopBits',1);
fopen(helloRobot); % connects port object to device
set(helloRobot,'Terminator','CR');
 
% add control commands you please here
out = sprintf('#0 P%d T1500 #1 P%d T1500 #2 P%d #3 P%d #4 P%d', pwm1, pwm2, pwm3, pwm4, pwm5)
fprintf(helloRobot, out);
interval = 1.5;

%close serial port to robot
fclose(helloRobot);
