%TestVehicleRandomWalk
%Simulates random walk of Vehicle in Environment

%DPG 11-OCT-2014
%Created Program
delta_angle = 0;
steerangle = 0;
timeout = 0;
curtime = 0;
while(~timeout)
    tic;
    UpdatePlot(Plots,'DrawEnvironment');
    UpdatePlot(Plots,'PoseGraph');
    speed = -50;
    delta_angle = rand*10;
    Vehicle.Current_Steer_Angle = Vehicle.Current_Steer_Angle + (rand-.5)*delta_angle;
    
    Vehicle.Throttle = .75;%rand*5;
    %steerangle = 15;
    
    dtime = toc;
    curtime = curtime + dtime;
    if curtime > 10
        timeout = 1;
    end
    disp(['FPS: ' num2str(1/dtime)])
    Vehicle = UpdateVehicle(Vehicle,dtime);
end
