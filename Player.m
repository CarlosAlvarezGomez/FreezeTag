classdef Player < handle
    
    properties
        position % Vector containing x and y coordinates of the current position
        state % Either Freezer, Frozen, or Running
        speed
    end
    
    methods
        function obj = Player(position, speed, state)
            obj.position = position;
            obj.speed = speed;
            obj.state = state;
        end
        
        function move(self, direction, deltaTime)
            self.position = self.position + self.speed*deltaTime*direction;
        end
    end
    
    methods (Abstract)
        direction = pickDirection(self, playerArray)
    end
end