%% function: form the differentiation function
% author: Yan Ou
% date: 20130418

function g = GradientCostFunc(fun,x0,para)
g = zeros(1,length(x0));
delta = 0.0001; % set the delta value to calculate the gradient of cost function
for i = 1:length(x0)
    x0Delta = x0;
    x0Delta(i) = x0Delta(i) + delta;
    g(i) = (fun(x0Delta,para)-fun(x0,para))/delta;
end % find the gradient for the cost function
end