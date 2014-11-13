%% function: get the potential of the obstacle
% editor: Yan Ou
% date: 20140902

function O = ObstaclePotential(xCollect,yCollect,obs)
% calculate the potential value based on the obstacle potential function
% the obstacle is a circle
if obs.obsType == 1 
if obs.potentialType == 1
    O = ObstaclePotentialExponential(xCollect,yCollect,obs);
end
if obs.potentialType == 2
    O = ObstaclePotentialImpulse(xCollect,yCollect,obs);
end
if obs.potentialType == 3
    O = ObstaclePotentialGaussian(xCollect,yCollect,obs);
end
if obs.potentialType == 4
    O = ObstaclePotentialImpulseBoundaryPoints(xCollect,yCollect,obs);
end
end
% the obstacle is a square
if obs.obsType == 2
    O = ObstacleSquare(xCollect,yCollect,obs);
end
end

%% function: square obstacle potential
% editor: Yan Ou
% date: 20140905

function y = ObstacleSquare(x,y,obs)
% check states in or not
inOrNot = (x>=obs.squareLD(1)).*(x<=obs.squareRU(1)).*(y>=obs.squareLD(2)).*(y<=obs.squareRU(2));
% sum
y = sum(sum(inOrNot)*obs.squarePotential);
end

%% function: obstacle potential using impulse function
% editor: Yan Ou
% date: 20140822

function y = ObstaclePotentialImpulse(x,y,obs)
% calculate the distance of the positions to the center of obs
xShift = x-obs.center(1);
yShift = y-obs.center(2);
dis = (xShift.^2+yShift.^2).^0.5;
% calculate the potential of the positions
inOrNot = dis<=obs.radius+obs.impulsetolDist;
% sum
y = sum(sum(inOrNot)*obs.inplusePotential);
end

%% function: obstacle potential using exponential function
% editor: Yan Ou
% date: 20140827

function y = ObstaclePotentialExponential(x,y,obs)
% calculate the distance of the positions to the center of obs
xShift = x-obs.center(1);
yShift = y-obs.center(2);
dis = (xShift.^2+yShift.^2).^0.5;
% calculate the potential of the positions
R = obs.radius+obs.expTol;
potential = -obs.expWeight*log(dis./R);
% sum
y = sum(sum(potential));
end

%% function: obstacle potential using gaussian function
% editor: Yan Ou
% date: 20140827

function y = ObstaclePotentialGaussian(x,y,obs)
% calculate the potential of the positions
temp = (x-obs.gaussianMean(1)).^2./(2*obs.gaussianStd^2)+(y-obs.gaussianMean(2)).^2/(2*obs.gaussianStd^2);
potential = obs.gaussianAmplitude*exp(-temp);
% sum
y = sum(sum(potential));
end

%% function: obstacle potential using impulse function with boundary points
% editor: Yan Ou
% date: 20140827

function y = ObstaclePotentialImpulseBoundaryPoints(x,y,obs)
dis = zeros(size(x));
for i = 1:size(obs.boundaryPoints,2)
    xb = obs.boundaryPoints(1,i);
    yb = obs.boundaryPoints(2,i);
    % calculate the distance from all the point to the cell position
    xShift = x-xb;
    yShift = y-yb;
    tmp = (xShift.^2+yShift.^2).^0.5;
    % check whether the distance is within certain tolerance range
    dis = dis+tmp<obs.tolDist;
end
% calculate the potential of the positions
inOrNot = dis>=1;
% sum
y = sum(sum(inOrNot)*obs.inplusePotential);
end