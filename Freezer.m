classdef Freezer < Player
    
    methods
        function direction = pickDirection(self, runnerArray, deltaTime)
            % Returns the direction that the freezer should run in.
            % playerArray is an array containing all the players in the
            % game. The freezer runs in the direction of the closest player
            % that is Running
            
            % Initializes direction and minDistance
            direction = [0, 0];
            minDistance = intmax;
            
            % Goes through each player in the runnerArray
            for i = 1:length(runnerArray)
                p = runnerArray{i};
                
                %Checks if the current player is not frozen
                if (~strcmp(p.state,'Frozen'))
                    dist = distance(self.position, p.position);
                    
                    % Changes the direction and minDistance if this is the
                    % closest player so far
                    if (dist < minDistance)
                        minDistance = dist;
                        unscaledDirection = p.position - self.position;
                        if (dist < self.speed*deltaTime)
                            direction = unscaledDirection/self.speed * deltaTime;
                        else
                            direction = unscaledDirection/norm(unscaledDirection);
                        end
                    end
                end
            end
        end
    end
end