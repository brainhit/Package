%% function: use equally seprated array to find the global minimum
% author: Yan Ou
% date: 20130418

function [globalMinPoint,globalMin] = EqualArrayStart(fun,constantValue,options)
% set initial values
gridDimension = constantValue.gridDimension; % the equally separated rate in one dimension
stepDimension = constantValue.step; % inputs step
upBound = pi/2;
lowBound = -pi/2;
gridSize = (upBound-lowBound)/gridDimension; % how dense we search the space
shift = zeros(1,stepDimension); % to calculate the point we start to search the local min
iniValueNum = (gridDimension-1)^stepDimension; % how many dot in total we begin to search for the local minima
localMin = zeros(1,iniValueNum); % the local min recorded for all the initial values
localMinPoint = zeros(stepDimension,iniValueNum); % local min point recorded
globalMin = 0; % global min
globalMinPoint = zeros(1,stepDimension);% global min position
x0low = lowBound*ones(1,stepDimension)+gridSize*ones(1,stepDimension);
x0 = zeros(2,iniValueNum);

% search for all the local min
for i = 0:(iniValueNum-1)
    shift = zeros(1,stepDimension);
    b = dec2diffbase(i,gridDimension-1); % change from decimal to other base
    base = zeros(1,stepDimension);
    if length(b) < stepDimension
        base(end-length(b)+1:end) = b;
    else
        base = b;
    end
    for j = 1:length(base)
        shift(j) = base(j);
    end
    x0 = x0low+shift*gridSize; % the dot we begin to search the local min
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%find local min%%%%%%
    % fmincon
%     [thetaM,fval] = fmincon(@(x)fun(x,constantValue),x0,constantValue.A,constantValue.b,[],[],[],[],[],options); % find the solution of the cost function
    % newton's method
%     [thetaM,fval] = NewtonMethod(fun,x0,constantValue.A,constantValue.b,constantValue);
    % gradient descent
    [thetaM,fval] = GradientDescent(fun,x0,constantValue.A,constantValue.b,constantValue);
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    localMin(i+1) = fval;
    localMinPoint(:,i+1) = thetaM';
end

% find one of the local min as the global min
globalMin = min(localMin);
globalMinPoint = localMinPoint(:,localMin == globalMin)';
end