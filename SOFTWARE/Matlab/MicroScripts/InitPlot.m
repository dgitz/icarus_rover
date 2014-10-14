%InitPlot
%Initializes Plot based on Plot Type.  Supposed to work dynamically but
%doesn't.

%DPG 11-OCT-2014
%Created Program
global Sonar_Max_Distance
global GRID_HEIGHT
global GRID_WIDTH
global SonarSensors
global Sonar_Beamwidth
global Cell_Types
global Room_Width
global Room_Height
global Obstacles
global Vehicle
global VehiclePose
global Occupancy_Grid
PlotType = 'DrawEnvironment';
if strcmp(PlotType,'DrawEnvironment')
    figure(4);
    set(4,'Name','Vehicle Pose','NumberTitle','off');
    plot_pose = plot(Vehicle_Pose_X);
     plot_pose.YDataSource = 'Vehicle_Pose_X';
    refreshdata
   
%     movegui(4,'south')
%     subplot(4,1,1)
%     plot(VehiclePose(1,:))
%     ylabel('x')
%     ylabel('t')
%     subplot(4,1,2)
%     plot(VehiclePose(2,:))
%     ylabel('y')
%     ylabel('t')
%      subplot(4,1,3)
%     plot(VehiclePose(3,:))
%     ylabel('Point Angle')
%     ylabel('t')
%      subplot(4,1,4)
%     plot(VehiclePose(4,:))
%     ylabel('Steer Angle')
%     ylabel('t')
%     linkdata on
    
end


