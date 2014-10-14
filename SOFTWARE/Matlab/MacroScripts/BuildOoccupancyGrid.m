%BuildOoccupancyGrid
%Generates Initial Occupancy Grid.

%DPG 4-OCT-2014
%Created Program

%DPG 13-OCT-2014
%BUG: Start/Stop Angles are calculated incorrectly.
global Occupancy_Grid
Occupancy_Grid = [];
global GRID_WIDTH
global GRID_HEIGHT
if (mod(GRID_WIDTH,2) == 0) || (mod(GRID_HEIGHT,2) == 0)
    disp('ERROR: Grid Size should be ODD.');
end

for w = 1:GRID_WIDTH
    for h = 1:GRID_HEIGHT

        Occupancy_Grid(w,h).Value = Cell_Types(1).Value;
        Occupancy_Grid(w,h).Color = Cell_Types(1).Color;
        Occupancy_Grid(w,h).Limit = 0;
        Occupanc_Grid(w,h).Applicable_Sensor = 0;
        if w <= floor(GRID_WIDTH/2)
            if h <= floor(GRID_HEIGHT/2)
                Occupancy_Grid(w,h).Sector = 'TL';
            elseif h > ceil(GRID_HEIGHT/2)
                Occupancy_Grid(w,h).Sector = 'BL';
            else
                Occupancy_Grid(w,h).Sector = 'L';
            end
        elseif w > ceil(GRID_WIDTH/2)
            if h <= floor(GRID_HEIGHT/2)
                Occupancy_Grid(w,h).Sector = 'TR';
            elseif h > ceil(GRID_HEIGHT/2)
                Occupancy_Grid(w,h).Sector = 'BR';
            else
                Occupancy_Grid(w,h).Sector = 'R';
            end
        else
            if h <= floor(GRID_HEIGHT/2)
                Occupancy_Grid(w,h).Sector = 'T';
            elseif h > ceil(GRID_HEIGHT/2)
                Occupancy_Grid(w,h).Sector = 'B';
            else
                Occupancy_Grid(w,h).Sector = 'M';
            end
            
        end
        coords = zeros(2,4);
        dely = 2*Sonar_Max_Distance/GRID_HEIGHT;
        delx = 2*Sonar_Max_Distance/GRID_WIDTH;
                if (w ==6) && (h == 4)
        end
        coords(:,1) = [(w-GRID_WIDTH/2-1)*delx; -(h-GRID_HEIGHT/2-1)*dely];
        coords(:,2) = [coords(1,1) + delx; coords(2,1) + 0];
        coords(:,3) = [coords(1,1) + 0; coords(2,1) - dely];
        coords(:,4) = [coords(1,1) + delx; coords(2,1) - dely];
        switch Occupancy_Grid(w,h).Sector
            case 'TL'
                Occupancy_Grid(w,h).Top = coords(:,2);
                Occupancy_Grid(w,h).Bottom = coords(:,3);
            case 'TR'
                Occupancy_Grid(w,h).Top = coords(:,1);
                Occupancy_Grid(w,h).Bottom = coords(:,4);
            case 'BL'
                Occupancy_Grid(w,h).Top = coords(:,1);
                Occupancy_Grid(w,h).Bottom = coords(:,4);
            case 'BR'
                Occupancy_Grid(w,h).Top = coords(:,2);
                Occupancy_Grid(w,h).Bottom = coords(:,3);
            case 'L'
                Occupancy_Grid(w,h).Top = coords(:,1);
                Occupancy_Grid(w,h).Bottom = coords(:,3);
            case 'T'
                Occupancy_Grid(w,h).Top = coords(:,1);
                Occupancy_Grid(w,h).Bottom = coords(:,2);
            case 'R'
                Occupancy_Grid(w,h).Top = coords(:,2);
                Occupancy_Grid(w,h).Bottom = coords(:,4);
            case 'B'
                Occupancy_Grid(w,h).Top = coords(:,3);
                Occupancy_Grid(w,h).Bottom = coords(:,4);
            otherwise
        end
        if (w ~= ceil(GRID_WIDTH/2)) || (h ~= ceil(GRID_HEIGHT/2))
            angle1 = atan(Occupancy_Grid(w,h).Top(2)/Occupancy_Grid(w,h).Top(1))*180/pi;
            angle2 = atan(Occupancy_Grid(w,h).Bottom(2)/Occupancy_Grid(w,h).Bottom(1))*180/pi;
        end
        switch Occupancy_Grid(w,h).Sector
            case 'TL'
                angle1 = 90-angle1+180;
                angle2 = 90-angle2+180;
                
                
            case 'TR'
                angle1 = 90 - angle1;
                angle2 = 90 - angle2;
            case 'BR'
                angle1 = 90-angle1;
                angle2 = 90-angle2;
            case 'BL'
                angle1 = 90-angle1+180;
                angle2 = 90-angle2+180;
            case 'M'
                angle1 = 0;
                angle2 = 0;
            case 'T' %OK
                angle1 = angle1+90;
                angle2 = angle2 +270;
            case 'L' %OK
                angle1 = angle1+270;
                angle2 = angle2+270;
            case 'R' %OK
                angle1 = 90-angle1;
                angle2 = 90-angle2;
            case 'B' %OK
                angle1 = angle1+90;90-angle1+270;
                angle2 = angle2 + 270;
            otherwise
                angle1 = 0;
                angle2 = 0;
                
                
        end
        if angle1 <= angle2
            Occupancy_Grid(w,h).StartAngle = angle1;
            Occupancy_Grid(w,h).StopAngle = angle2;
        else
            Occupancy_Grid(w,h).StartAngle = angle2;
            Occupancy_Grid(w,h).StopAngle = angle1;
        end
    end
end
Occupancy_Grid(ceil(GRID_WIDTH/2),(ceil(GRID_HEIGHT/2))).Sector = 'M';
Occupancy_Grid(ceil(GRID_WIDTH/2),ceil(GRID_HEIGHT/2)).Value = Cell_Types(3).Value;
Occupancy_Grid(ceil(GRID_WIDTH/2),ceil(GRID_HEIGHT/2)).Color = Cell_Types(3).Color;

for b = 1:length(BUCKET_ITEMS)
    for i = b:GRID_WIDTH-b+1
        Occupancy_Grid(i,b).Limit = BUCKET_ITEMS(b);
    end
    for i = b:GRID_HEIGHT-b+1
        Occupancy_Grid(b,i).Limit = BUCKET_ITEMS(b);
    end
    for i = b:GRID_WIDTH-b+1
        Occupancy_Grid(i,GRID_WIDTH-b+1).Limit = BUCKET_ITEMS(b);
    end
    for i = b:GRID_HEIGHT-b+1
        Occupancy_Grid(GRID_HEIGHT-b+1,i).Limit = BUCKET_ITEMS(b);
    end
    
end

%PrintGrid(Occupancy_Grid,'Angle')