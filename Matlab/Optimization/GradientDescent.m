%% funcion: use gradient descent algorithm to find the local minimum
% author: Yan Ou
% date: 20130423

function [localMinPoint, localMin] = GradientDescent(fun,x0,A,b,constantValue)
% set initial value
stopBound = 0.2; % the stop sign: the bound of the error between to steps
maxStep = 1000; % the maximum step of the iteration
xp = x0; % the previous step point
alpha = 0.01; % the step size
c1 = 0.0001; % constant value for Armijo Condition

% find the local min
for i = 1:maxStep
    % check the optimal condition
    if i>1
        if norm(xp-x0)<stopBound
            localMinPoint = xp;
            localMin = fun(xp,constantValue);
            return;
        end
    end
    % check the boundary condition
    if i>1
        if A*x0'>b
            localMinPoint = xp;
            localMin = fun(xp,constantValue);
            return;
        end
    end
    % find the descent direction
    g = GradientCostFunc(fun,x0,constantValue);
    p = -g';
    % get next step point
    xp = x0;
    % line search
    alpha = LineSearch(fun,x0,p,g,c1,constantValue);
    x0 = xp+alpha*p';
end
localMinPoint = xp;
localMin = fun(xp,constantValue);
end