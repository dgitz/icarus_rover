%Main
%Main Program.  All Structures should end with an 's'.  All EA Tuned
%Parameters and User Inputs should be in all CAPITALS, with each word
%separated by an underscore.  All Functions/Scripts should be CamelCase
%with no separation between words.  All indexed values should be lowercase
%with the letter being the first character of the value it is indexing
%over.  All other variables should be in CamelCase with underscores
%separating words.

%DPG 4-OCT-2014
%Created Initial program.
close all
clear variables
clear globals
format short
clc
addpath(genpath('C:\SharedDrive\Dropbox\ICARUS\Rover\SOFTWARE\Matlab\'))
%User Input Parameters
TEST_SIMULATE_SENSOR_SWEEP = false;
TEST_VEHICLE_RANDOM_WALK = false;
TEST_OCCUPANCY_GRID = true;
%EA Tuned Parameters
global GRID_WIDTH
GRID_WIDTH = 7; %Should be ODD
global GRID_HEIGHT
GRID_HEIGHT = GRID_WIDTH; %Should be equal to GRID_WIDTH, for now.
global SONAR_COUNT
SONAR_COUNT = 3; %Should be ODD, at least for now due to 1 Sensor looking forward initially.
global SENSOR_ROTATE_SPEED
SENSOR_ROTATE_SPEED = 100; %Degrees Per Second.  Should be realistic speed based on Rover.
global SONAR_SEPARATION_ANGLE; %Degrees
SONAR_SEPARATION_ANGLE = 45;
global BUCKET_ITEMS

for b = 1:floor(GRID_WIDTH/2)
    BUCKET_ITEMS(b) = floor(b*255/(floor(GRID_WIDTH/2)+1));
end
BUCKET_ITEMS = fliplr(BUCKET_ITEMS);


InitializeProgram;

if TEST_SIMULATE_SENSOR_SWEEP == true
    TestSensorSweep;
end
if TEST_VEHICLE_RANDOM_WALK == true
    TestVehicleRandomWalk;
end
if TEST_OCCUPANCY_GRID == true
    TestOccupancyGrid;
end
