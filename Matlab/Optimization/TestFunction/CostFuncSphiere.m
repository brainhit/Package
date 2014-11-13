%% function: sphiere function
% editor: Yan Ou
% date: 20131205

function f = CostFuncSphiere(x)
position = linspace(1,length(x),length(x));
f = norm(x-position')^2;
end