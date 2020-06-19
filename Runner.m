classdef Runner < Player
    
    methods
        function direction = pickDirection(self, runnerArray, freezer, separationAngle)
            % Returns the direction that the runner should run in.
            % playerArray is an array containing all the players in the
            % game. If the state is Frozen, the runner will not move. If the
            % state is Running, the runner will either move in the opposite
            % direction of the Freezer or towards a Frozen runner. If the state 
            % Separating1 or Separating 2, then the runner will move in the
            % same direction as if it were Running, but the direction will
            % be offset by separationAngle/2.
            
            % Stay in place if frozen
            if (strcmp(self.state, 'Frozen'))
                direction = [0, 0];
            else
                direction = rand(1,2);
                minDistFromFrozen = intmax;
                canReachFrozen = false;
                
                % Look through every runner
                for i = 1:length(runnerArray)
                    p = runnerArray{i};
                    
                    if (strcmp(p.state,'Frozen'))
                        % If you find a frozen runner, calculate the time
                        % it would take to get to the runner
                        distFromFrozen = distance(self.position, p.position);
                        timeToFrozen = distFromFrozen/self.speed;
                        
                        % Calculate the time it would take the freezer to
                        % get to the runner
                        distFreezerToFrozen = distance(freezer.position, p.position);
                        timeFreezerToFrozen = distFreezerToFrozen/freezer.speed;
                        
                        % Change direction if you can reach the frozen
                        % runner before the freezer, and if this is the
                        % closest frozen runner
                        if (timeToFrozen < timeFreezerToFrozen)
                            canReachFrozen = true;
                            if (distFromFrozen < minDistFromFrozen)
                                minDistFromFrozen = distFromFrozen;
                                unscaledDirection = p.position - self.position;
                                direction = unscaledDirection/norm(unscaledDirection);
                            end
                        end
                    end
                end
                
                % If you can't reach a frozen runner, run directly away
                % from the freezer
                if (~canReachFrozen)
                    unscaledDirection = self.position - freezer.position;
                    direction = unscaledDirection/norm(unscaledDirection);
                end
                % Offset the direction if separating
                if (strcmp(self.state, 'Separating1'))
                    [theta, rad] = cartesian2Polar(direction(1), direction(2));
                    theta = rem(theta + separationAngle/2,360);
                    [x, y] = polar2Cartesian(theta, rad);
                    direction = [x, y];
                elseif(strcmp(self.state, 'Separating2'))
                    [theta, rad] = cartesian2Polar(direction(1), direction(2));
                    theta = rem((theta - separationAngle/2)+360,360);
                    [x, y] = polar2Cartesian(theta, rad);
                    direction = [x, y];
                end
            end
        end
    end
end