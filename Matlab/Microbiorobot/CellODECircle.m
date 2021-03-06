%% function: robot ode
% author: Yan Ou
% date: 20130429

function dx = CellODECircle(t,x,freq,thetaM0,robot)
dx = zeros(size(x));
N = numel(x)/3; % number of robot
th = x(2*N+1:3*N); % current orientation of the cells
vel = robot.speed;
a = robot.turningRate; % the characters of the robot
thetaM = freq*t+thetaM0; % current thetaM
dx(1:N) = vel.*cos(th);
dx(N+1:2*N) = vel.*sin(th);
dx(2*N+1:3*N) = a.*sin(thetaM - th);
end