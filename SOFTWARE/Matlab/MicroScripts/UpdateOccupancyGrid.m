%UpdateOccupancyGrid
%Updates Occupancy Grid based on Sonar Sensors and Buckets

%DPG 13-OCT-2014
%Created Program. BUG: Applicable_Sensor not calculated correctly.
function [ mygrid ] = UpdateOccupancyGrid( mygrid,mybuckets,mysensors )
global Sonar_Beamwidth
AppendError( mfilename('fullpath'),'Occupancy Grid Calculation','Occupancy Grid not getting correct Applicable Sensor',GetLineNumber,false);
[X Y] = size(mygrid);
for x = 1:X
    for y = 1:Y
        mygrid(x,y).Applicable_Sensor = 0;
    end
end
for x = 1:X
    for y = 1:Y
        for s = 1:length(mysensors)
            sensor_in_sight = 0;
            if (x == 4) && (y == 1) && (s == 3)
            end
            for i = 1:3
                sensor_in_sight = sensor_in_sight && CellSeesSonar( mygrid(x,y).StartAngle,mygrid(x,y).StopAngle,mysensors(s).CurrentAngle-Sonar_Beamwidth/2,mysensors(s).CurrentAngle,mysensors(s).CurrentAngle+Sonar_Beamwidth/2,(i-1)*90);
                if sensor_in_sight
                    break;
                end
            end
    
            if sensor_in_sight
                mygrid(x,y).Applicable_Sensor = s;
            end
        end
        
    end
end