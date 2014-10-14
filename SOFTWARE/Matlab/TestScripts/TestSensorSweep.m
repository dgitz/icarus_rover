%TestSensorSweep
%Creates animation of Sensor Sweep.
direction = 1;
etime = 0;
global SonarSensors
lastangle = 0;
while etime < 10
    tic;
    lastangle = SonarSensors(1).CurrentAngle;
    UpdatePlot(Plots,'SensorSweepSmallWindow');
    
    dtime = toc;
    UpdateSensors(dtime);
    etime = etime + dtime;
    dtheta = dtime * SENSOR_ROTATE_SPEED;

    %disp(['FPS: ' num2str(1/dtime)])
    %disp(['Theta Rate: ' num2str((SonarSensors(1).CurrentAngle-lastangle)/dtime) ])
    disp(['Sensor1 Theta: ' num2str(SonarSensors(1).CurrentAngle)])
end