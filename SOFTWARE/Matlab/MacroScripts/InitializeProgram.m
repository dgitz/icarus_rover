%InitializeProgram
%Initialize Program with various Scripts

%DPG 4-OCT-2014
%Created Program
%DPG 10-OCT-2014
%Added modifications for constructing environment.

%%Program Constants

%Occupancy Grid
global Cell_Types;
Cell_Types(1).Value = 0;
Cell_Types(1).Color = 'white';
Cell_Types(1).Name = 'Free';
Cell_Types(2).Value = 1;
Cell_Types(2).Color = 'black';
Cell_Types(2).Name = 'Occuppied';
Cell_Types(3).Value = 2;
Cell_Types(3).Color = 'red';
Cell_Types(3).Name = 'Not Available';

Plots(1).Index = 1;
Plots(1).Rotation = 0;
Plots(1).Figure = [];
Plots(1).Title = '';
Plots(1).Plot = [];
Plots(5).Index = 5;
Plots(5).Rotation = 0;
Plots(5).Title = 'Occupancy Grid 3D';

%Error List
global Errors
Errors = [];


BuildSensors;
BuildOoccupancyGrid;
BuildEnvironment;
BuildVehicle;