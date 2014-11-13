%% function: form the cost function for the cells head to diff targets considering the obstacle
% author: Yan Ou
% date: 20140822

function f = CostFuncTargetsObstacle(x,constantValue)
% set the constant values
cellNo = constantValue.cellNo; % cell number
speed = constantValue.speed(1:cellNo); % cell speed
alpha = constantValue.alpha(1:cellNo); % cell angular changing rate
xIni = constantValue.initialState(1:cellNo,1); % cell starting point
yIni = constantValue.initialState(1:cellNo,2);
thetaIni = constantValue.initialState(1:cellNo,3);
xSetPoint = constantValue.goalState(1:cellNo,1); % cell ending point
ySetPoint = constantValue.goalState(1:cellNo,2);
step = constantValue.step; % how many step to head to the target
obs.radius = constantValue.radius;
obs.center = constantValue.center;
obs.inplusePotential = constantValue.inplusePotential;
obs.weightingFactor = constantValue.weightingFactor;
obs.impulsetolDist = constantValue.impulsetolDist;
obs.potentialType = constantValue.potentialType;
obs.exponentialShift = constantValue.exponentialShift;
obs.gaussianMean = constantValue.gaussianMean;
obs.gaussianStd = constantValue.gaussianStd;
obs.gaussianAmplitude = constantValue.gaussianAmplitude;
obs.boundaryPoints = constantValue.boundaryPoints;
obs.expWeight = constantValue.expWeight; % exponential weighting factor
obs.expTol = constantValue.expTol; % the tolerance value for the exponential function
obs.obsType = constantValue.obsType; % obstacle type. 1: circle; 2: square
obs.squareLD = constantValue.squareLD; % left down of a square (mm)
obs.squareRU = constantValue.squareRU; % right up of a square (mm)
obs.squarePotential = constantValue.squarePotential;

% form the cost function
xCell = xIni;
yCell = yIni;
thetaCell = thetaIni; % set the initial cell position
xCollect = zeros(step,cellNo);
yCollect = zeros(step,cellNo);
step
% if step == 10
%     disp('hello');
% end
for i = 1:step
    thetaCell = thetaCell + alpha.*sin(x(i)-thetaCell);
    xCell = xCell + speed.*cos(thetaCell);
    yCell = yCell + speed.*sin(thetaCell);
    xCollect(i,:) = xCell';
    yCollect(i,:) = yCell';
end % update the cell position based on the plant input
% calculate the potential value based on the obstacle potential function
O = ObstaclePotential(xCollect,yCollect,obs);
% calculate the cost value based on mpc and the potential function
f = (norm(xCell - xSetPoint)^2 + norm(yCell - ySetPoint)^2)^0.5+obs.weightingFactor*O;
end