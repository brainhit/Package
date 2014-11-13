%% function: draw magnetic field
% editor: Yan Ou
% date: 20140513

function h_mag = DrawMagnet(x,y,lt,r,len,width,cn,cs)
% north polar triengle
h_mag.ntri = patch(0,0,cn);
% text 'N'
h_mag.Ntext = text(-1000000,-1000000,'N','FontSize',8);
% south polar triengle
h_mag.stri = patch(0,0,cs);
% text 'S'
h_mag.Stext = text(-1000000,-1000000,'S','FontSize',8);
h_mag.len = len;
h_mag.width = width;
h_mag.x = x;
h_mag.y = y;
h_mag.lt = lt;
h_mag = UpdateMagnet(h_mag,r);
end