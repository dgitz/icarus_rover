function [ObstacleCount ] = BuildEnvironment( ObstacleName )
%BuildEnvironment
%Builds Obstacles in Environment

%DPG 10-OCT-2014
%Created Program
global Room_Width
Room_Width = 255;
global Room_Height
Room_Height = 255;
global Obstacle_Density
Obstacle_Density = .3;
global Obstacle_Small_Diameter
Obstacle_Small_Diameter = 5;
global Obstacle_Large_Diameter
Obstacle_Large_Diameter = 50;

global Obstacles
Obstacles = [];
if (~(exist('ObstacleName')))
    
    
    usedarea = 0;
    Obstacle_Counter = 0;
    while(usedarea < Room_Width*Room_Height*Obstacle_Density)
        Obstacle_Counter = Obstacle_Counter +1;
        Obstacles(Obstacle_Counter).Index = Obstacle_Counter;
        Obstacles(Obstacle_Counter).Diameter = rand*(Obstacle_Large_Diameter-Obstacle_Small_Diameter)+Obstacle_Small_Diameter;
        usedarea = usedarea + pi*(Obstacles(Obstacle_Counter).Diameter/2)^2;
        
        Obstacles(Obstacle_Counter).x = 2*(rand-.5)*Room_Width;
        Obstacles(Obstacle_Counter).y = 2*(rand-.5)*Room_Width;
    end
    
else
    
    load(ObstacleName);
    
    
end
ObstacleCount = length(Obstacles);