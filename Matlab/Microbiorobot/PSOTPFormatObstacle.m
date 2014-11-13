%% function: form the c++ format psoTP function input
% editor: Yan Ou
% date: 2013/12/23

function [funPsoTP,obstacleInfo] = PSOTPFormatObstacle(constantValue)
% cell info
cellNo = constantValue.cellNo;
cellInfo = [constantValue.speed',constantValue.alpha'];
stateInfo = [reshape(constantValue.initialState',1,numel(constantValue.initialState)),reshape(constantValue.goalState',1,numel(constantValue.goalState))];
funPsoTP = [cellNo,cellInfo,stateInfo];
% obstacle info
obs = [constantValue.center,constantValue.radius',constantValue.expTol',constantValue.expWeight',constantValue.inplusePotential',constantValue.impulsetolDist'];
obs = reshape(obs',[1,size(obs,1)*size(obs,2)]);
obstacleInfo = [length(constantValue.radius),constantValue.potentialType,constantValue.weightingFactor,obs];
end