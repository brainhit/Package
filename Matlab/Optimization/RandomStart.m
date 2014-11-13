%% function: use random start initial values to find the global minimum
% author: Yan Ou
% date: 20130424

function [globalMinPoint,globalMin] = RandomStart(fun,constantValue,options)
% set initial values
gridDimension = constantValue.gridDimension; % the equally separated rate in one dimension
stepDimension = constantValue.step; % inputs step
upBound = pi;
lowBound = -pi;
gridSize = (upBound-lowBound)/gridDimension; % how dense we search the space
shift = zeros(1,stepDimension); % to calculate the point we start to search the local min
totalGrid = (gridDimension-1)^stepDimension; % total grid number
iniValueNum = constantValue.randomStartNum; % how many dot in total we begin to search for the local minima
localMin = zeros(1,iniValueNum); % the local min recorded for all the initial values
localMinPoint = zeros(stepDimension,iniValueNum); % local min point recorded
globalMin = 0; % global min
globalMinPoint = zeros(1,stepDimension);% global min position
x0low = lowBound*ones(1,stepDimension)+gridSize*ones(1,stepDimension);
x0 = zeros(2,iniValueNum);

% search for all the local min
for i = 1:iniValueNum
    shift = zeros(1,stepDimension);
    uniformSepNum = randi(totalGrid-1,1,1);
    b = dec2diffbase(uniformSepNum,gridDimension-1); % change from decimal to other base
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
%     [thetaM,fval] = fmincon(@(x)fun(x,constantValue),x0,A,b,[],[],[],[],[],options); % find the solution of the cost function
    % newton's method
%     [thetaM,fval] = NewtonMethod(fun,x0,A,b,constantValue);
    % gradient descent
    [thetaM,fval] = GradientDescent(fun,x0,constantValue.A,constantValue.b,constantValue);
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    localMin(i) = fval;
    localMinPoint(:,i) = thetaM';
end

% find one of the local min as the global min
globalMin = min(localMin);
globalMinPoint = localMinPoint(:,localMin == globalMin)';
end