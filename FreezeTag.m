% Runs a simulation of a game of freeze tag that only ends if all the
% Runners are frozen

numRunners = 30;
runnerSpeed = 1;
freezerSpeed = 1.5;
freezeRadius = freezerSpeed;
unfreezeRadius = runnerSpeed;
maxX = 100;
minX = -maxX;
maxY = 100;
minY = -maxY;
boundaries = [minX, maxX, minY, maxY];
deltaTime = 1;

% Creates a runnerArray, where each Runner starts at a random position
runnerArray = cell(1,numRunners);
for i = 1:numRunners
    position = [(maxX - minX)*rand + minX, (maxY - minY)*rand + minY];
    runnerArray{i} = Runner(position, runnerSpeed, 'Running');
end

% Creates the Freezer, starting at the center of the plot
position = [(maxX - minX)*rand + minX, (maxY - minY)*rand + minY];
freezer = Freezer(position, freezerSpeed, 'Freezer');

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
    
    % Move all the Runners
    for i = 1:numRunners
        p = runnerArray{i};
        if ~strcmp(p.state,'Frozen')
            p.move(p.pickDirection(runnerArray,freezer, deltaTime, boundaries), deltaTime);
            
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
    freezer.move(freezer.pickDirection(runnerArray, freezer, deltaTime, boundaries), deltaTime);
    fPoint.XData = freezer.position(1);
    fPoint.YData = freezer.position(2);
    
    % Freeze and unfreeze Runners
    [runnerArray, rPointsArray] = freeze(freezer, runnerArray, rPointsArray, freezeRadius);
    [runnerArray, rPointsArray] = unfreeze(runnerArray, rPointsArray, unfreezeRadius);
    
    % Calculates the number of runners remaining
    currentRunners = 0;
    for i = 1:numRunners
        if (strcmp(runnerArray{i}.state,'Running'))
            currentRunners = currentRunners + 1;
        end
    end
    
    
    pause(0.01);
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

function [rArray, rPArray] = unfreeze(runnerArray, rPointsArray, unfreezeRadius)
rArray = runnerArray;
rPArray = rPointsArray;
for i = 1:length(rArray)
    p = rArray{i};
    if strcmp(p.state, 'Frozen')
        n = 1;
        while ((n <= length(rArray)) && ...
                ((~strcmp(rArray{n}.state,'Running')) || ...
                (distance(p.position, rArray{n}.position) > unfreezeRadius)))
            n = n+1;
        end
        if (n <= length(rArray))
            p.state = 'Running';
            rArray{i} = p;
            rPArray{i}.Color = 'r';
        end
    end
end
end