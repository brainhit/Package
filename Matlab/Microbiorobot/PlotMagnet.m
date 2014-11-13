%% function: plot the magnetic field
% editor: Yan Ou
% date: 20131105

function handle = PlotMagnet(angle,pos,size)
x = pos(1);
y = pos(2);
dx = size*cos(angle);
dy = size*sin(angle);
handle = quiver(x,y,dx,dy,'LineWidth',1,'Color','k');
end