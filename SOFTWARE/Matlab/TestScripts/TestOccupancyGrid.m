%TestOccupancyGrid
%Tests evaluation of Occupancy Grid

%DPG 12-OCT-2014
%Created Program

timeout = 0;
etime = 0;
global Obstacles
disp(['Obstacle Count: ' num2str(BuildEnvironment('SmallObstacles'))])
while(~timeout)
    tic;
    Vehicle.Current_Point_Angle = Vehicle.Current_Point_Angle - .5;
    Vehicle.Current_Point_Angle
    FindObstacles;
    Occupancy_Grid = UpdateOccupancyGrid(Occupancy_Grid,BUCKET_ITEMS,SonarSensors);
    UpdatePlot(Plots,'DrawEnvironment');
    UpdatePlot(Plots,'SensorSweepSmallWindow');
    UpdatePlot(Plots,'OccupancyGrid3D');
    %UpdatePlot(Plots,'PoseGraph');
    dtime = toc;
    Vehicle = UpdateVehicle(Vehicle,dtime);
    
    disp(['FPS: ' num2str(1/dtime)])
    etime = etime + dtime;
    timeout = 1;
    if etime > 30
        timeout = 1;
    end
end
for e = 1:length(Errors)
    if Errors(e).Cleared == false
    disp(['Error ' num2str(Errors(e).Index) ': ' Errors(e).Text ', ' Errors(e).Description])
    end
end