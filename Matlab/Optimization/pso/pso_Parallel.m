%% function: Find the minimum value of the cost function using pso algorithm
% editor: Yan Ou
% date: 20131007

% fun: cost function
% np: number of particle swarm
% lb: lower bound of x
% ub: upper bound of x
% inertia: inertial value
% correction_factor: correlation factor
% stopIter: iteration to check the stop critera
% x0: warm start (the unknown variables must be defined as inf)

function [xMin,yMin] = pso_Parallel(fun,np,lb,ub,inertia,correction_factor,iteration,stopIter,x0)


% set the defualt value for the inertia, correction_factor, iteration
if nargin < 9
    x0 = [];
    if nargin < 8
        stopIter = 10;
        if nargin < 7
            iteration = 50;
            if nargin < 6
                correction_factor = 2;
                if nargin < 5
                    inertia = 0.1;
                end
            end
        end
    end
end
if isempty(inertia) == 1
    inertia = 0.1;
end
if isempty(correction_factor) == 1
    correction_factor = 2;
end
% neighborhoodNum = round(np/3); % define the neighborhood number as the calculation of the global best solution
xIni = [];
vIni = [];
for i = 1:length(lb)
    xIni = [xIni,randi([round(lb(i)*1000),round(ub(i)*1000)],np,1)/1000];
    vIni = [vIni,randi([round(-abs(ub(i)-lb(i)))*1000,round(abs(ub(i)-lb(i)))*1000],np,1)/1000];
end
swarm = zeros(np,5,size(xIni,2));
% neighborSwarm = zeros(neighborhoodNum,5,size(xIni,2));
swarm(:,1,:) = xIni;
% allocate value to the unknown part of x0
if isempty(x0) ~= 1
    for i = 1:length(x0)
        if x0(i) == inf
            x0(i) = randi([round(lb(i)*1000),round(ub(i)*1000)],1,1)/1000;
        end
    end
end
if isempty(x0) ~= 1
    swarm(:,3,:) = ones(np,1)*x0';
else
    swarm(:,3,:) = xIni;
end
for i = 1:np
    swarm(i,4,1) = fun(reshape(swarm(i,3,:),length(swarm(i,3,:)),1));
end
% swarm(:,4,1) = 1000000000;
[tempValue, tempIndex] = min(swarm(:, 4, 1));
if isempty(x0) ~= 1
    gbest = reshape(x0,1,1,length(x0));
else
    gbest = swarm(tempIndex, 3, :);
end
swarm(:,2,:) = vIni;
if isempty(x0) ~= 1
    for i = 1:np
        swarm(i, 2, :) = inertia*swarm(i, 2, :) + correction_factor*rand(1,1,size(xIni,2)).*(swarm(i, 3, :) - swarm(i, 1, :)) + correction_factor*rand(1,1,size(xIni,2)).*(gbest - swarm(i, 1, :));   %x velocity component
    end
end
gbestValue = fun(reshape(gbest,length(gbest),1)); % the gather of the gbest values
stopValue = 100; % the stop criteria of the iteration
temp_lbest = swarm(:, 3, :);
temp_gbest = swarm(i, 1, :);
temp_swarm = swarm;

% run particle swarm optimization algorithm to converge the particle swarm
for iter = 1 : iteration
    % pl, pb, pb_val
    for i = 1 : np
        
        % project the particle which is outside the boundary to inside the boundary
        newParticle = swarm(i, 1, :) + swarm(i, 2, :);
        newParticle = min(newParticle,reshape(ub,1,1,length(lb)));
        newParticle = max(newParticle,reshape(lb,1,1,length(lb)));

        % reset the velocity of the particles
        swarm(i, 2, :) = newParticle - swarm(i,1,:);
        % calculate the new particle position
        swarm(i, 1, :) = newParticle;

        val = fun(reshape(swarm(i,1,:),length(swarm(i,1,:)),1));          % fitness evaluation (you may replace this objective function with any function having a global minima)
        if val < swarm(i, 4, 1)                 % if new position is better
            swarm(i,3,:) = swarm(i,1,:);
            swarm(i, 4, 1) = val;               % and best value
        end
    end
    
    % pg
%     swarmPosition = reshape(swarm(:,1,:),np,length(lb));
%     particlePosition = reshape(swarm(i,1,:),1,length(lb));
%     swarmDist = bsxfun(@minus, swarmPosition, particlePosition);
%     swarmDist = sqrt(sum(swarmDist.^2,2));
%     sortDist = sort(swarmDist);
%     threshold = sortDist(neighborhoodNum);
%     neighborSwarm = swarm(swarmDist<=threshold,:,:); % find the neighborhood particles
    [tempValue, tempIndex] = min(swarm(:, 4, 1));        % global best position
    if (tempValue < fun(reshape(gbest,length(gbest),1)))
        gbest = swarm(tempIndex, 3, :);
    end
    swarm(i,5,:) = gbest;
    gbestValue(end+1) = fun(reshape(gbest,length(gbest),1));
    
    % velocity
    parfor i = 1:np
        temp_lbest(i, 1, :) = correction_factor*rand(1,1,size(xIni,2)).*(swarm(i, 3, :) - swarm(i, 1, :));
    end
    parfor i = 1:np
        temp_gbest(i,1,:) = correction_factor*rand(1,1,size(xIni,2)).*(gbest - swarm(i, 1, :));
    end
    parfor i = 1:np
        temp_swarm(i, 2, :) = inertia*swarm(i, 2, :) + temp_lbest(i, 1, :) +  temp_gbest(i,1,:);  %x velocity component
    end
    parfor i = 1:np
        swarm(i,2,:) = temp_swarm(i,2,:);
    end
    
    % stop criteria
    if iter > stopIter
        deltaGbestValue = abs(gbestValue(2:end) - gbestValue(1:end-1));
        deltaGbestValueLog = log(deltaGbestValue(deltaGbestValue~=0));
        if length(deltaGbestValueLog) > 10
            stopValue = sum(log(gbestValue(end-9:end)));
            sumDelta = sum(deltaGbestValueLog(end-9:end));
        else
            stopValue = sum(log(gbestValue));
            sumDelta = sum(deltaGbestValueLog);
        end
        if sumDelta < stopValue/2
            break;
        end
    end
end

% return the value
xMin = reshape(gbest,size(gbest,3),1);
yMin = gbestValue(end);
end