%UpdatePlot
%Updates Plot based on Plot Type

%DPG 4-OCT-2014
%Created Program

%DPG 10-OCT-2014
%Added Draw Environment
function [Plots ] = UpdatePlot( Plots,PlotType )
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

if strcmp(PlotType,'SensorSweepSmallWindow')
    figure(2)
    set(2,'Name','Sensor Sweep','NumberTitle','off');
    movegui(2,'west')
    
    clf
    axis([-(Sonar_Max_Distance + 25) (Sonar_Max_Distance + 25) -(Sonar_Max_Distance + 25) (Sonar_Max_Distance + 25)]);
    axis square
    grid_line_dely = 2*Sonar_Max_Distance/GRID_HEIGHT;
    grid_line_delx = 2*Sonar_Max_Distance/GRID_WIDTH;
    %Draw Horizontal Lines
    starty = -Sonar_Max_Distance;
    for h = 1:(GRID_HEIGHT+1)
        line([-Sonar_Max_Distance,Sonar_Max_Distance],[starty,starty]);
        starty = starty + grid_line_dely;
    end
    startx = -Sonar_Max_Distance;
    for h = 1:(GRID_WIDTH+1)
        line([startx,startx],[-Sonar_Max_Distance,Sonar_Max_Distance]);
        startx = startx + grid_line_delx;
    end
    
    for s = 1:length(SonarSensors)
        angle = (SonarSensors(s).CurrentAngle+Sonar_Beamwidth/2)*pi/180;
        x = (Sonar_Max_Distance+100)*sin(angle);
        y = (Sonar_Max_Distance+100)*cos(angle);
        line([0,x],[0,y]','Color','r')
        angle = (SonarSensors(s).CurrentAngle-Sonar_Beamwidth/2)*pi/180;
        x = (Sonar_Max_Distance+100)*sin(angle);
        y = (Sonar_Max_Distance+100)*cos(angle);
        line([0,x],[0,y]','Color','r')
        x = (100)*sin(angle);
        y = (100)*cos(angle);
        tempstr = [num2str(SonarSensors(s).Index)];
        if SonarSensors(s).Object_Detected
            tempstr = [tempstr ',' num2str(SonarSensors(s).Object_Index)];
        end
        text(x,y,tempstr);
    end
    for w = 1:GRID_WIDTH
        for h = 1:GRID_HEIGHT
            text((w-GRID_WIDTH/2)*grid_line_delx-grid_line_delx/2,-(h-GRID_HEIGHT/2)*grid_line_dely+grid_line_delx/2,num2str(Occupancy_Grid(w,h).Applicable_Sensor));
            if Occupancy_Grid(w,h).Value ~= Cell_Types(1).Value
                
                x = [(w-GRID_WIDTH/2)*grid_line_delx (w-1-GRID_WIDTH/2)*grid_line_delx (w-1-GRID_WIDTH/2)*grid_line_delx (w-GRID_WIDTH/2)*grid_line_delx];
                y = [-(h-GRID_HEIGHT/2)*grid_line_dely -(h-GRID_HEIGHT/2)*grid_line_dely -(h-1-GRID_HEIGHT/2)*grid_line_dely -(h-1-GRID_HEIGHT/2)*grid_line_dely];
                patch(x,y,Occupancy_Grid(w,h).Color)
            end
        end
    end
    
elseif strcmp(PlotType,'DrawEnvironment')
    scrsz = get(groot,'ScreenSize');
    
    
    figure(3)
    set(3,'Name','Environment','NumberTitle','off');
    movegui(3,'north')
    clf
    axis([-Room_Width/2 Room_Width/2 -Room_Height/2 Room_Height/2]);
    axis square
    hold on
    %Draw Obstacles
    for o = 1:length(Obstacles)
        x1 = Obstacles(o).x-Obstacles(o).Diameter/2;
        x2 = Obstacles(o).Diameter;
        y1 = Obstacles(o).y-Obstacles(o).Diameter/2;
        y2 = x2;
        rectangle('Position',[x1,y1,x2,y2],'FaceColor','r','Curvature',[1,1])
        text(Obstacles(o).x,Obstacles(o).y,num2str(Obstacles(o).Index));
    end
    %Draw Vehicle
    d = 5;
    rectangle('Position',[Vehicle.Center_x-d/2,Vehicle.Center_y-d/2,d,d],'FaceColor','b','Curvature',[1,1])
    r = ((Vehicle.Length/2)^2 + (Vehicle.Width/2)^2)^.5;
    theta1 = atan2(Vehicle.Length,Vehicle.Width)-(Vehicle.Current_Point_Angle*pi/180);
    theta2 = atan2(Vehicle.Length,Vehicle.Width)+(Vehicle.Current_Point_Angle*pi/180);
    theta3 = atan2(Vehicle.Length,Vehicle.Width)+(Vehicle.Current_Point_Angle*pi/180);
    theta4 = atan2(Vehicle.Length,Vehicle.Width)-(Vehicle.Current_Point_Angle*pi/180);
    p1 = [Vehicle.Center_x;Vehicle.Center_y]+[r*cos(theta1);r*sin(theta1)];
    p2 = [Vehicle.Center_x;Vehicle.Center_y]+[-r*cos(theta2);r*sin(theta2)];
    p3 = [Vehicle.Center_x;Vehicle.Center_y]+[r*cos(theta3);-r*sin(theta3)];
    p4 = [Vehicle.Center_x;Vehicle.Center_y]+[-r*cos(theta4);-r*sin(theta4)];
    line([p1(1) p2(1)],[p1(2) p2(2)]);
    line([p1(1) p3(1)],[p1(2) p3(2)]);
    line([p2(1) p4(1)],[p2(2) p4(2)]);
    line([p4(1) p3(1)],[p4(2) p3(2)]);
    p1 = [Vehicle.Center_x;Vehicle.Center_y];
    p2 = p1 + [Vehicle.Length*sin(Vehicle.Current_Point_Angle*pi/180); Vehicle.Length*cos(Vehicle.Current_Point_Angle*pi/180)];
    line([p1(1) p2(1)],[p1(2) p2(2)],'Color','g');
    p2 = p1 + [Vehicle.Length*sin((Vehicle.Current_Steer_Angle+Vehicle.Current_Point_Angle)*pi/180); Vehicle.Length*cos((Vehicle.Current_Steer_Angle+Vehicle.Current_Point_Angle)*pi/180)];
    line([p1(1) p2(1)],[p1(2) p2(2)],'Color','r');
    %rectangle('Position',[p1(1),p1(2),4,4],'FaceColor','k','Curvature',[1,1])
    %rectangle('Position',[p2(1),p2(2),4,4],'FaceColor','k','Curvature',[1,1])
elseif strcmp(PlotType,'PoseGraph')
    figure(4)
    set(4,'Name','Vehicle Pose','NumberTitle','off');
    movegui(4,'south')
    clf
    subplot(4,1,1)
    plot(VehiclePose(5,:),VehiclePose(1,:))
    ylabel('x')
    title('x(t)')
    subplot(4,1,2)
    plot(VehiclePose(5,:),VehiclePose(2,:))
    ylabel('y')
    title('y(t)')
     subplot(4,1,3)
    plot(VehiclePose(5,:),VehiclePose(3,:))
    ylabel('Point Angle')
    title('Point Angle(t)')
     subplot(4,1,4)
    plot(VehiclePose(5,:),VehiclePose(4,:))
    ylabel('Steer Angle')
    xlabel('t')
    title('Steer Angle(t)')
elseif strcmp(PlotType,'OccupancyGrid3D')
    [X Y] = size(Occupancy_Grid);
    Z = zeros(X,Y);
    for x = 1:X
        for y = 1:Y
            if Occupancy_Grid(x,y).Value > 0
                Z(x,y) = Occupancy_Grid(x,y).Limit;
            end
        end
    end
    Plots(5).Index = 5;
    Plots(5).Figure = figure(Plots(5).Index);
    hold on

    set(Plots(5).Index,'Name',Plots(5).Title,'NumberTitle','off');
    movegui(Plots(5).Index,'east')
    clf
    Plots(5).Plot = mesh(Z);
    direction = [0 0 1];
    rotate(Plots(5).Plot ,direction, 180)
end
end

