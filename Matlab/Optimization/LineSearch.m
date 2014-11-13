%% function: line search
% author: Yan Ou
% date: 20130423

function alpha = LineSearch(fun,x0,p,g,c1,constantValue)
% set initial value
alpha = 1;
maxStep = 100;
f = fun(x0,constantValue); % current f value

% find the alpha that satisfies the Armijo Condition
for i = 1:maxStep
    alpha = alpha/2;
    xk = x0 + alpha*p';
    fn = fun(xk,constantValue);
    if fn <= f+c1*alpha*p'*g'
        return;
    end
end
end