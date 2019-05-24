%% Calibrate the arm, then move the arm to central position
to_pause = Calibrate_n_Initialize()
pause(1.5)

%% Here is where the fun starts

% Files for location data
orange_file = 'orange.dat';
pink_file = 'pink.dat';
green_file = 'green.dat';

% 1) Ask user which object to pickup
fprintf('Which pen do you want the robot to pick up?');
fprintf('\n1: Orange  2: Pink  3: Green');
desired_obj = input('\nChoose one (type 1/2/3, then hit "return": ');

% 2) Read the correcponding CSV file to get the location of the object
switch desired_obj
    case 1
        M = csvread(orange_file);
    case 2
        M = csvread(pink_file);
    case 3
        M = csvread(green_file);
end

% 3) Convert the coordinates of object in the frame of the camera to the 
% coordinate of the arm
x_arm = M(2)/19.4
y_arm = (M(1) - 320)*.05

% 4) Move the arm to the correct position and grab the desired object
to_pause = InverseSolutionVertApproach(x_arm, y_arm, 15, 3)
pause(to_pause)
to_pause = InverseSolutionVertApproach(x_arm, y_arm, 2, 3)
pause(to_pause)
to_pause = InverseSolutionVertApproach(x_arm, y_arm, 2, .2)
pause(to_pause)

% 5) Pick it up
to_pause = InverseSolutionVertApproach(15, 0, 15, .2)
pause(to_pause)

% 6) Release the object
to_pause = InverseSolutionVertApproach(25, 0, 20, .2)
pause(to_pause)
to_pause = InverseSolutionVertApproach(25, 0, 20, 3)
pause(to_pause)

% 7) Move the arm back to initial position
to_pause = Calibrate_n_Initialize()
pause(to_pause)
