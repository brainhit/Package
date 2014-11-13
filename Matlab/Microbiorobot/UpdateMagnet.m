%% function: update magnet
% editor: Yan Ou
% date: 20140513

function h_mag = UpdateMagnet(h_mag,r)
% constant value
xr = h_mag.x;
yr = h_mag.y;
lt = h_mag.lt;
w = h_mag.width/2;
l = h_mag.len/2;
% plot north magnet
xn = [xr+w*cos(r-pi/2);xr+l*cos(r);xr+w*cos(pi/2+r)];
yn = [yr+w*sin(r-pi/2);yr+l*sin(r);yr+w*sin(pi/2+r)];
set(h_mag.ntri,'XData',xn,'YData',yn);
% plot south magne
xs = [xr+w*cos(pi/2+r);xr-l*cos(r);xr+w*cos(r-pi/2)];
ys = [yr+w*sin(pi/2+r);yr-l*sin(r);yr+w*sin(r-pi/2)];
set(h_mag.stri,'XData',xs,'YData',ys);
% add test 'N' and 'S'
set(h_mag.Ntext,'Position',[xr+lt*cos(r),yr+lt*sin(r)]);
set(h_mag.Stext,'Position',[xr+lt*cos(r+pi),yr+lt*sin(r+pi)]);
end