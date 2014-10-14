%FindObstacles
%Maps Obstacles to Sensors

%DPG 12-OCT-2014
%Created Program. Not working yet.

global Sonar_Beamwidth
global SonarSensors
for s = 1:length(SonarSensors)
    SonarSensors(s).Object_Index = -1;
    SonarSensors(s).Object_Detected = false;
    SonarSensors(s).Object_Range = -1;
end
for o = 1:length(Obstacles)
    d = ((Obstacles(o).x - Vehicle.Center_x)^2 + (Obstacles(o).y-Vehicle.Center_y)^2)^.5 - Obstacles(o).Diameter/2;
    Obstacles(o).Distance_To_Vehicle = d;
    Obstacles(o).Angle_To_Vehicle = WrapAngle(atan2((Vehicle.Center_x-Obstacles(o).x),(Vehicle.Center_y-Obstacles(o).y))*180/pi-Vehicle.Current_Point_Angle-180);
    if o == 22
    end
    %Check all angles except for around 360
    for s = 1:length(SonarSensors)
        object_in_sight = false;
        if (Obstacles(o).Angle_To_Vehicle <= (SonarSensors(s).CurrentAngle) + Sonar_Beamwidth) && (Obstacles(o).Angle_To_Vehicle >= (SonarSensors(s).CurrentAngle) - Sonar_Beamwidth)
            object_in_sight = true;
        end
        if ((Obstacles(o).Angle_To_Vehicle-360) <= (SonarSensors(s).CurrentAngle) + Sonar_Beamwidth) && ((Obstacles(o).Angle_To_Vehicle-360) >= (SonarSensors(s).CurrentAngle) - Sonar_Beamwidth)
            object_in_sight = true;
        end
        if object_in_sight
            if (SonarSensors(s).Object_Range > Obstacles(o).Distance_To_Vehicle) || (SonarSensors(s).Object_Detected == false)
                SonarSensors(s).Object_Index = o;
                SonarSensors(s).Object_Detected = true;
                SonarSensors(s).Object_Range = Obstacles(o).Distance_To_Vehicle;
            end
        end
        
    end
    %Check negative angles
end

