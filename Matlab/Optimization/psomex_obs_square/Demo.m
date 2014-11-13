%% function: the demo function to test the effectiveness of pso psoTP function
% editor: Yan Ou
% date: 20131220

function Demo
%% clear all
clear all;

%% initialize the input parameters of the pso function
np = 200;
iner = 0.1;
c = 2;
iter = 40;
stopIter = 10;
step = 15;
x0 = [-3.1108,0.5,3.1315,-3.1416,-0.4347,-0.9854,-1.3518,-1.7880,3.1416,3.1416,3.1416,2.7991,2.1496,1.9199,100000]';
% x0 = [-3.1108,100000,3.1315,-3.1416,-0.4347,-0.9854,-1.3518,-1.7880,3.1416,3.1416,100000,2.7991,100000,1.9199,1.6218]';
% x0 = [];
lb = -pi*ones(step,1); % lower bound
ub = pi*ones(step,1); % upper bound
% funPara = [2,30,50,0.7,0.4,0,20,0,0,0,0,50,120,200,160];
funPara = [3,30,50,60,0.7,0.4,0.6,0,20,0,0,0,0,0,0,0,50,120,200,-160,100,100];

%% run the pso function
tic
[xMin,yMin] = psoTP(funPara,np,lb,ub,iner,c,iter,stopIter,x0);
t = toc;

%% show the result
str = ['the time consumption is: ',num2str(t)];
disp(str);
disp('the best x value is:')
xMin'
disp('the best y value is:')
yMin

end