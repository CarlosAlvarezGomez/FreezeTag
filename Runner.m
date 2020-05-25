classdef Runner < Player
    
    methods
        function direction = pickDirection(self, runnerArray, freezer, deltaTime, boundaries)
            % Returns the direction that the freezer should run in.
            % playerArray is an array containing all the players in the
            % game. The freezer runs in the direction of the closest player
            % that is Running
            minX = boundaries(1);
            maxX = boundaries(2);
            minY = boundaries(3);
            maxY = boundaries(4);
            
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
                                %                                 if (distFromFrozen < self.speed*deltaTime)
                                %                                     direction = unscaledDirection/self.speed * deltaTime;
                                %                                 else
                                direction = unscaledDirection/norm(unscaledDirection);
                                %                                 end
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
            end
        end
    end
end