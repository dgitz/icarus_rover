%PrintGrid
%Prints Occupancy Grid

%DPG 5-OCT-2014
%Created Program
function [ ] = PrintGrid(mygrid,Mode )
disp('')
disp('----------')
if strcmp(Mode,'BucketLimit')
    [X Y] = size(mygrid);
    for y = 1:Y
        disp(num2str([mygrid(1:X,y).Limit]))
    end
elseif strcmp(Mode,'Sector')
    [X Y] = size(mygrid);
    for y = 1:Y
        tempstr = [];
        for x = 1:X
            tempstr = [tempstr mygrid(x,y).Sector '\t'];
        end
        disp(sprintf(tempstr))
    end

elseif strcmp(Mode,'Angle')
    [X Y] = size(mygrid);
    for y = 1:Y
        tempstr = [];
        for x = 1:X
            tempstr = [tempstr num2str(mygrid(x,y).StartAngle) '\t'];
        end
        disp(sprintf(tempstr))
    end
    disp('----------')
    for y = 1:Y
        tempstr = [];
        for x = 1:X
            tempstr = [tempstr num2str(mygrid(x,y).StopAngle) '\t'];
        end
        disp(sprintf(tempstr))
    end
end
disp('----------')
end

