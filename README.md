# FreezeTag
Freezetag Simulation

This projects it meant to create a simulation of a game of freeze tag. In order to run the simulation, run Freezetag.m. In this
simulation, there is one chaser/freezer, and there are 30 runners, which are either running or frozen. The game will continue
until all of the runners are frozen.

Distance.m

This is the euclidean distance formula, which is used in both Freezer.m, Runner.m, and FreezeTag.m

Freezer.m

This is another sublass of Player.m, and it only contains function pickDirection. This function calculates the distance between the freezer and each point in the runnerArray, and it picks the direction of the closest runner that is not frozen.

FreezeTag.m

This is the main simulation file. This initializes the runners at random point with x-values within [minX, maxX] and y-values
within [minY, maxY]. Then it stores all these runners in a cell array called runnerArray. Then it creates a freezer and puts it at the center of the graph. After all players are created, this plots all of their positions and stores the points in
rPointsArray and freezerPoint. Then, the simulation repeatedly moves all points, freezes/unfreezes the runners depending on
distances from the freezer and from non-frozen runners, and then plots the results.

FreezeTagTests.m

This contains test cases for the Player, Freezer, and Runner classes.

Player.m

This is the superclass for Runners and Freezer. It contains a position, speed, and a state, which is either 'Running,'
'Frozen,' or 'Freezer.' The methods in this class are the constructor, move(), which takes in a unit vector and moves the
player in that direction, and an abstract method called pickDirection.

Runner.m

This is a subclass of Player.m. The only method in this sublass is pickDirection. This function picks a direction of [0,0] if
the player is frozen. If the player is not frozen, then it checks if it can reach a frozen point by looking through each frozen point in runnerArray, calculating the time it would take to reach that point, and then calculating the time it would take the freezer to reach that point. If it can reach a frozen point before the freezer, then it goes in the direction of the frozen point, but if it cannot reach any frozen points, it runs the the opposite direction of where the freezer is.
