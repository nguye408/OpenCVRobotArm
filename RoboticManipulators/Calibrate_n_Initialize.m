function interval = Calibrate_n_Initialize()

% open serial port to robot, center the joints, then set the offset values
helloRobot = serial('com1','BaudRate',115200,'DataBits',8,'StopBits',1);
fopen(helloRobot); % connects port object to device
set(helloRobot,'Terminator','CR');

fprintf(helloRobot,'#0 P1500 T1500 #1 P2200 #2 P2150 #3 P800 #4 P800');
calibrate_time = 1.5;
pause(calibrate_time)

fprintf(helloRobot, '#0 PO-121 #2 PO-30 #3 PO50')
offset_time = 1;
pause(offset_time)

interval = offset_time + calibrate_time;

%close serial port to robot 
     fclose(helloRobot);
