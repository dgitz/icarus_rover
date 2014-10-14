%BuildVehicle
%Definitions for the Vehicle

%DPG 11-OCT-2014
%Created Program

global Vehicle
Vehicle.Width = 12;
Vehicle.Length = 18;
Vehicle.Current_Point_Angle = 290; %Degrees
Vehicle.Current_Steer_Angle = 0;
Vehicle.Current_Speed = 0;
Vehicle.Throttle = 0;
Vehicle.Center_x = 0;
Vehicle.Center_y = 0;
Vehicle.Max_Speed = 10; %Inches/Second
Vehicle.Max_Left = -30; %Degrees
Vehicle.Max_Right = 30;
Vehicle.Wheel_Radius = 3;
Vehicle.xdot = 0;
Vehicle.ydot = 0;
Vehicle.psidot = 0;

global VehiclePose;
VehiclePose = [];
VehiclePose = zeros(5,1);
VehiclePose(:,1) = [Vehicle.Center_x Vehicle.Center_y Vehicle.Current_Point_Angle Vehicle.Current_Steer_Angle 0];

