    % draw agents in the space
    drawAgents=zeros(length(agents),3);
    for i=1:length(agents)
        drawAgents(i,1)=agents(i).x;
        drawAgents(i,2)=agents(i).y;
        drawAgents(i,3)=agents(i).TBstatus;
    end
    scatter(drawAgents(:,1),drawAgents(:,2),50,drawAgents(:,3),'filled');
    box on
    axis off
    colormap([0 0 1;0 1 0.5;1 0 0]);
