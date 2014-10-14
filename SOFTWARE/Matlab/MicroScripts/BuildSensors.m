%BuildSensors
%Builds collection of Sonar Sensors

%DPG 4-OCT-2014
%
global Sonar_Beamwidth
Sonar_Beamwidth = 30; %Degrees
global Sonar_Max_Distance
Sonar_Max_Distance = 255; %Inches
global SonarSensor_State;
SonarSensor_State = 'Forward';
global SonarSensor_MaxAngle
SonarSensor_MaxAngle = 90;
global SonarSensor_MinAngle
SonarSensor_MinAngle = -90;
global SonarSensor_MainAngle
SonarSensor_MainAngle = 0;
global SonarSensors
SonarSensors = [];
if SONAR_SEPARATION_ANGLE*SONAR_COUNT > 360
    disp('ERROR: TOO MANY SONAR SENSORS')
    break;
end
if mod(SONAR_COUNT,2) == 0
    disp('ERROR: SONAR COUNT SHOULD BE AN ODD NUMBER')
    break;
end
for s = 1:SONAR_COUNT
    SonarSensors(s).Object_Detected = false;
    SonarSensors(s).Object_Range = -1;
    SonarSensors(s).Object_Index = -1;
    SonarSensors(s).Index = s;
    
    if s == 1
        SonarSensors(s).StartAngle = 0;
    else
        if mod(s,2) == 0 %Even, put Sensor on Right
            SonarSensors(s).StartAngle = floor(s/2)*SONAR_SEPARATION_ANGLE;
        else %Odd, put Sensor on Left
            SonarSensors(s).StartAngle = -floor(s/2)*SONAR_SEPARATION_ANGLE;
        end
    end
%     if SonarSensors(s).CurrentAngle < 0
%         SonarSensors(s).CurrentAngle = SonarSensors(s).CurrentAngle + 360;
%     end
    SonarSensors(s).CurrentAngle = SonarSensors(s).StartAngle;
end