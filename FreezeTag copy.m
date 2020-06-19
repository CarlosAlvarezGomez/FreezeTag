% Runs a simulation of a game of freeze tag that only ends if all the
% Runners are frozen

numRunners = 3;
runnerSpeed = 1;
freezerSpeed = 1.25;
freezeRadius = freezerSpeed;
unfreezeRadius = runnerSpeed;
maxX = 100;
minX = -maxX;
maxY = 100;
minY = -maxY;
boundaries = [minX, maxX, minY, maxY];
deltaTime = 1;
separationAngle = 90;
separationSteps = 50;

% Creates a runnerArray, where each Runner starts at a random position
runnerArray = cell(1,numRunners);
position1 = [-5, -2];
runnerArray{1} = Runner(position1, runnerSpeed, 'Running');
position2 = [0, 10];
runnerArray{2} = Runner(position2, runnerSpeed, 'Running');
position3 = [5,-2]; 
runnerArray{3} = Runner(position3, runnerSpeed, 'Running');
%for i = 1:numRunners
    %position = [(maxX - minX)*rand + minX, (maxY - minY)*rand + minY];
    %runnerArray{i} = Runner(position, runnerSpeed, 'Running');
%end

% Creates the Freezer, starting at the center of the plot
%position = [(maxX - minX)*rand + minX, (maxY - minY)*rand + minY];
positionf = [0,0];
freezer = Freezer(positionf, freezerSpeed, 'Freezer');


% Creates plot
figure
totalTime = 0;
message = sprintf('Time = %3.2f', totalTime);
title(message)
axis ([minX maxX minY maxY]);
hold on

% Plots all runners and the freezer
rPointsArray = cell(1,numRunners);
for i = 1:numRunners
    rPointsArray{i} = plot(runnerArray{i}.position(1), runnerArray{i}.position(2), 'ro');
end
fPoint = plot(freezer.position(1), freezer.position(2), 'bo');

% Moves players until no Runners are left
currentRunners = numRunners;
while (currentRunners ~= 0)
    
    for i = 1:numRunners
        p = runnerArray{i};
        if ~strcmp(p.state,'Frozen')
            p.move(p.pickDirection(runnerArray,freezer, separationAngle), deltaTime);
            if (p.separationSteps > 1)
                p.separationSteps = p.separationSteps - 1;
            elseif (p.separationSteps == 1)
                p.separationSteps = 0;
                p.state = 'Running';
                rPointsArray{i}.Color = 'r';
            end
            % Updates axis barriers
            if (runnerArray{i}.position(1) < minX)
                minX = runnerArray{i}.position(1);
                axis ([minX maxX minY maxY]);
            elseif (runnerArray{i}.position(1) > maxX)
                maxX = runnerArray{i}.position(1);
                axis ([minX maxX minY maxY]);
            end
            if (runnerArray{i}.position(2) < minY)
                minY = runnerArray{i}.position(2);
                axis ([minX maxX minY maxY]);
            elseif (runnerArray{i}.position(2) > maxY)
                maxY = runnerArray{i}.position(2);
                axis ([minX maxX minY maxY]);
            end
            
            rPointsArray{i}.XData = p.position(1);
            rPointsArray{i}.YData = p.position(2);
        end
    end
    
    % Move the Freezer
    oldPosition = freezer.position;
    freezer.move(freezer.pickDirection(runnerArray, deltaTime), deltaTime);
    fPoint.XData = freezer.position(1);
    fPoint.YData = freezer.position(2);
    
    % Freeze and unfreeze Runners
    [runnerArray, rPointsArray] = freeze(freezer, runnerArray, rPointsArray, freezeRadius);
    [runnerArray, rPointsArray] = unfreeze(runnerArray, rPointsArray, unfreezeRadius, separationSteps);
    
    % Calculates the number of runners remaining
    currentRunners = 0;
    for i = 1:numRunners
        if (~strcmp(runnerArray{i}.state,'Frozen'))
            currentRunners = currentRunners + 1;
        end
    end
    
    
    pause(.0001);
    %Plots adjusts the axis, time, and changes title
    totalTime = totalTime + deltaTime;
    message = sprintf('Time = %3.2f', totalTime);
    title(message)
end

function [rArray, rPArray] = freeze(freezer, runnerArray, rPointsArray, freezeRadius)
fposition = freezer.position;
rPArray = rPointsArray;
rArray = runnerArray;
for i = 1:length(rArray)
    p = rArray{i};
    if (distance(fposition, p.position) < freezeRadius)
        rArray{i}.state = 'Frozen';
        rPArray{i}.Color = 'k';
    end
end
end

function [rArray, rPArray] = unfreeze(runnerArray, rPointsArray, unfreezeRadius, separationSteps)
rArray = runnerArray;
rPArray = rPointsArray;
for i = 1:length(rArray)
    p = rArray{i};
    if strcmp(p.state, 'Frozen')
        n = 1;
        while ((n <= length(rArray)) && ...
                ((strcmp(rArray{n}.state,'Frozen')) || ...
                (distance(p.position, rArray{n}.position) > unfreezeRadius)))
            n = n+1;
        end
        if (n <= length(rArray))
            p.state = 'Separating1';
            p.separationSteps = separationSteps;
            rArray{n}.state = 'Separating2';
            rArray{n}.separationSteps = separationSteps;
            rArray{i} = p;
            rPArray{i}.Color = 'm';
            rPArray{n}.Color = 'm';
        end
    end
end
end