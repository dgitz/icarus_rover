%UpdateSensors
%Updates rotation of Sonar Sensors

%DPG 12-OCT-2014
%Created Program
function [ ] = UpdateSensors(dtime)
global SENSOR_ROTATE_SPEED
global SonarSensor_State
global SonarSensor_MaxAngle
global SonarSensor_MinAngle
global SonarSensor_MainAngle
global SonarSensors
for s = 1:length(SonarSensors)
    if strcmp(SonarSensor_State,'Forward')
        
        SonarSensors(s).CurrentAngle = SonarSensors(s).CurrentAngle + SENSOR_ROTATE_SPEED*dtime;
    elseif strcmp(SonarSensor_State,'Backward')
        
        SonarSensors(s).CurrentAngle = SonarSensors(s).CurrentAngle - SENSOR_ROTATE_SPEED*dtime;
    end
    if SonarSensors(s).CurrentAngle < 0
        SonarSensors(s).CurrentAngle = SonarSensors(s).CurrentAngle + 360;
    elseif SonarSensors(s).CurrentAngle > 360
        SonarSensors(s).CurrentAngle = SonarSensors(s).CurrentAngle - 360;
    end
    
end
    if strcmp(SonarSensor_State,'Forward')
        SonarSensor_MainAngle = SonarSensor_MainAngle + SENSOR_ROTATE_SPEED*dtime;
    elseif strcmp(SonarSensor_State,'Backward')
        
        SonarSensor_MainAngle = SonarSensor_MainAngle - SENSOR_ROTATE_SPEED*dtime;
    end
if SonarSensor_MainAngle > SonarSensor_MaxAngle
    SonarSensor_State = 'Backward';
elseif SonarSensor_MainAngle < SonarSensor_MinAngle
    SonarSensor_State = 'Forward';
end

end

