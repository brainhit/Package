%% function: form the hessian function
% author: Yan Ou
% date: 20130418

function h = HessianCostFunc(fun,x0,constantValue)
h = zeros(length(x0),length(x0));
delta = 0.0001; % set the delta value to calculate the hassian of cost function
for i = 1:length(x0)
    for j = 1:length(x0)
        x0Delta = x0;
        x0Delta(j) = x0Delta(j) + delta;
        gDelta = GradientCostFuncTargets(fun,x0Delta,constantValue);
        g = GradientCostFuncTargets(fun,x0,constantValue);
        h(i,j) = (gDelta(i)-g(i))/delta;
    end
end
end