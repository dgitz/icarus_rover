%UpdateVehicle
%Updates Vehicle based on Ackermann Steering. Reference: http://www.ni.com/white-paper/12721/en/

%DPG 11-OCT-2014
%Created Program

%DPG 13-OCT-2014
%Fixed bug: Vehicle is not rotating as fast as it should. Cause was not
%multiplying final current_point_angle integral summation with radians to
%degree conversion factor.
function [ myVehicle ] = UpdateVehicle( myVehicle,dt )
global VehiclePose;
if myVehicle.Current_Steer_Angle > myVehicle.Max_Right
    myVehicle.Current_Steer_Angle = myVehicle.Max_Right;
elseif myVehicle.Current_Steer_Angle < myVehicle.Max_Left
    myVehicle.Current_Steer_Angle = myVehicle.Max_Left;
end
w1 = .5*myVehicle.Throttle*myVehicle.Max_Speed;
w2 = .5*myVehicle.Throttle*myVehicle.Max_Speed;
v = myVehicle.Wheel_Radius*(w1+w2);
myVehicle.xdot = myVehicle.Wheel_Radius*(w1+w2)*sin(myVehicle.Current_Point_Angle*pi/180);
myVehicle.ydot = myVehicle.Wheel_Radius*(w1+w2)*cos(myVehicle.Current_Point_Angle*pi/180);
myVehicle.psidot = ( v/myVehicle.Width)*tan(myVehicle.Current_Steer_Angle*pi/180);
myVehicle.Center_x = myVehicle.Center_x+ myVehicle.xdot*dt;
myVehicle.Center_y =myVehicle.Center_y + myVehicle.ydot*dt;
myVehicle.Current_Point_Angle = WrapAngle(myVehicle.Current_Point_Angle + myVehicle.psidot*180*dt/pi);
VehiclePose(:,1+length(VehiclePose(1,:))) = [myVehicle.Center_x myVehicle.Center_y myVehicle.Current_Point_Angle myVehicle.Current_Steer_Angle (VehiclePose(5,length(VehiclePose(5,:))) +dt) ];

end

