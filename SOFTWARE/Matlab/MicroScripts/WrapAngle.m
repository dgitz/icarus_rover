%WrapAngle
%Wraps Angle to Unit Circle

%DPG 13-OCT-2014
%Created Program

function [ angle ] = WrapAngle( angle )
if angle > 360
    angle = angle - 360;
elseif angle < 0 
    angle = angle + 360;
end



end

