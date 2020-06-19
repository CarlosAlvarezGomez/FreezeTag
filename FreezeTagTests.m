% Tests the properties in players are set correctly
p1 = Runner([1,1], 5, 'Running');
p2 = Runner([10,10], 9, 'Frozen');
p3 = Freezer([-1,-6], 2, 'Freezer');

assert(all(p1.position == [1,1]));
assert(strcmp(p1.state,'Running'));
assert(p1.speed == 5);

assert(all(p2.position == [10, 10]));
assert(strcmp(p2.state,'Frozen'));
assert(p2.speed == 9);

assert(all(p3.position == [-1,-6]));
assert(strcmp(p3.state,'Freezer'));
assert(p3.speed == 2);

fprintf('Properties tests passed\n')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tests the move function
direction = [1,1] / norm([1,1]);
p1.move(direction,10);
assert(all(p1.position == [1,1] + direction*5*10))

direction = [0,1] / norm([0,1]);
p2.move(direction,5);
assert(all(p2.position == [10, 10] + direction*9*5))

direction = [-2321,123] / norm([-2321,123]);
p3.move(direction,100);
assert(all(p3.position == [-1, -6] + direction*2*100))

fprintf('Move tests passed\n')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tests the pickDirection function in players
runnerArray = {p1, p2};

% Checks that frozen points cannot move
assert(all(p2.pickDirection(runnerArray, p3) == [0,0]))

% Checks that, if there are no frozen points nearyby, runners move the the
% exact opposite direction of the freezer
p1.position = [0,0];
p1.speed = 1;
p2.position = [-10000, -10000];

p3.position = [1,1];
assert(all(p1.pickDirection(runnerArray, p3) == [-1, -1]/ norm([1,1])));

p3.position = [2,-2];
assert(all(p1.pickDirection(runnerArray, p3) == [-1, 1]/norm([1,1])));

p3.position = [-3,3];
assert(all(round(p1.pickDirection(runnerArray, p3),4) == round([1, -1]/ norm([1,1]),4)));

p3.position = [-4,-4];
assert(all(p1.pickDirection(runnerArray, p3) == [1, 1]/ norm([1,1])));

p1.speed = 1;
p3.speed = 2;
p2.position = [0.5,0];
p3.position = [1.5001,0];

assert(all(p1.pickDirection(runnerArray, p3) == [1, 0]));

%Checks that separating points are moving away from each other at the right
%angle
p1.state = 'Separating1';
p1.position = [0,0];
p2.state = 'Separating2';
p2.position = [0,0];
p3.position = [1,1];


x = p1.pickDirection(runnerArray, p3, 30);

assert(all(p1.pickDirection(runnerArray, p3, 30) == [-0.5,round(-sqrt(3)/2,6)]));
assert(all(p2.pickDirection(runnerArray, p3, 30) == [round(-sqrt(3)/2,6),-0.5,]));

p3.position = [0,1];

assert(all(p1.pickDirection(runnerArray, p3, 90) == [round(sqrt(2)/2,6), round(-sqrt(2)/2,6)]));
assert(all(p2.pickDirection(runnerArray, p3, 90) == [round(-sqrt(2)/2,6), round(-sqrt(2)/2,6)]));

p3.position = [-1,1];

assert(all(p1.pickDirection(runnerArray, p3, 90) == [1,0]));
assert(all(p2.pickDirection(runnerArray, p3, 90) == [0,-1]));

p3.position = [-1,0];

assert(all(p1.pickDirection(runnerArray, p3, 90) == [round(sqrt(2)/2,6), round(sqrt(2)/2,6)]));
assert(all(p2.pickDirection(runnerArray, p3, 90) == [round(sqrt(2)/2,6), round(-sqrt(2)/2,6)]));

p3.position = [-1,-1];

assert(all(p1.pickDirection(runnerArray, p3, 90) == [0,1]));
assert(all(p2.pickDirection(runnerArray, p3, 90) == [1,0]));

p3.position = [0,-1];

assert(all(p1.pickDirection(runnerArray, p3, 90) == [round(-sqrt(2)/2,6), round(sqrt(2)/2,6)]));
assert(all(p2.pickDirection(runnerArray, p3, 90) == [round(sqrt(2)/2,6), round(sqrt(2)/2,6)]));

p3.position = [1,-1];

assert(all(p1.pickDirection(runnerArray, p3, 90) == [-1,0]));
assert(all(p2.pickDirection(runnerArray, p3, 90) == [0,1]));

p3.position = [1,0];

assert(all(p1.pickDirection(runnerArray, p3, 90) == [round(-sqrt(2)/2,6), round(-sqrt(2)/2,6)]));
assert(all(p2.pickDirection(runnerArray, p3, 90) == [round(-sqrt(2)/2,6), round(sqrt(2)/2,6)]));

fprintf('pickDirection tests passed\n')

