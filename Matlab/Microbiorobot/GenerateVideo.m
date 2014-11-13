%% function: generate video of the robots motion
% editor: Yan Ou
% date: 20131105

function GenerateVideo(control,robot,filename)

%% set the constant values
global running;
running = 1;

%% show the movie of the robot motion
% set the write video handle
writerObj = VideoWriter(filename);
writerObj.FrameRate = 80;
set(writerObj,'Quality',100);
open(writerObj);

% create a figure to plot the cell track
color = distinguishable_colors(robot.cellNo);
G.fig = figure(1);
clf
set(G.fig,'Units','normalized','outerposition',[0 0 1 1],'NumberTitle','off','MenuBar','none','color','w'); % show movie
set(G.fig,'CloseRequestFcn',@F2Close);
clf
hold on
xlabel('x axis (mm)');
ylabel('y axis (mm)');
title('Path generation');
xlim([-2,2]);
ylim([-2,2]);

% plot the scale bar
plot([-1.5,-0.5],[-0.5,-0.5],'LineWidth',2,'Color','k');
text(-1.2,-0.35,'1 mm','FontSize',12);

% handle for the draw stuff in the figure
hPath = zeros(robot.cellNo,1);
hCell = cell(robot.cellNo,1);

% plot initial state and target points
width = 0.02;
height = 0.06;
r = 0.03;
for i = 1:robot.cellNo
    rectangle('Position',[robot.initial(i,1)-width/2,robot.initial(i,2)-height/2,width,height],'FaceColor',color(i,:));
    rectangle('Position',[robot.initial(i,1)-height/2,robot.initial(i,2)-width/2,height,width],'FaceColor',color(i,:));
    filledCircle([robot.goal(i,1),robot.goal(i,2)],r,1000,color(i,:));
end

% plot the initial state of the cells and magnet
for i = 1:robot.cellNo
    hPath(i) = plot(robot.xFeedback(1,i),robot.yFeedback(1,i),'-','color',color(i,:),'linewidth',2);
    hCell{i} = drawCell(robot.xFeedback(1,i),robot.yFeedback(1,i),robot.thetaFeedback(1,i)...
        ,robot.turningRate(i),0.02);
end
hTitle = title({[num2str(robot.cellNo),' cells simulated for ',num2str(robot.time(end)),' s']});%;
mag = PlotMagnet(control.thetaM(1),[-1.5,1.5],0.4);
timeh = text(-1,-1,['t = ',num2str(robot.time(1)),'s']);

for i = 2:size(robot.xAll,1)
    figure(G.fig);
    set(gcf,'renderer','painters')
    if ~running
        close(writerObj);
        return
    end
    set(hTitle,'string',{[num2str(robot.cellNo),' cells simulated for ',num2str(robot.time(i)),' s']});%['\theta_M = ',num2str(Mag),'sin(',num2str(freq),'t), T = ',num2str(T(j), '% 5.0f'),' s']});
    
    % display the time
    set(timeh,'Visible','off');
    timeh = text(-1.2,-1,['t = ',num2str(robot.time(i),'%.3f'),'s'],'FontSize',12);
    
    % update the cell info
    for j = 1:robot.cellNo
        hPath = plot([robot.xAll(i,j),robot.xAll(i-1,j)],[robot.yAll(i,j),robot.yAll(i-1,j)],'Color',color(j,:));
        updateCell(hCell{j},robot.xAll(i,j),robot.yAll(i,j),robot.thetaAll(i,j));
    end
    
    % update the magnetic field info
    if rem(robot.time(i),control.sampleTime) == 0
        set(mag,'Visible','off');
        filledCircle([-1,1],0.02,1000,'k');
        mag = PlotMagnet(control.thetaM(round(robot.time(i)/control.sampleTime+1)),[-1,1],0.9);
        text(-0.8,0.8,'magnetic field','FontSize',6);
    end
    drawnow
    tfig = myaa(3);
    
    % save the figure into the video file
    if running
        pause(0.01);
        frame = getframe;
        writeVideo(writerObj,frame);
        close(tfig);
    end
end

close(writerObj);
end

%% function: stop the movie if we close the figure
% author: Yan Ou
% date: 20130501

function F2Close(~,~)
global running
running = 0;
delete(gcf);
end