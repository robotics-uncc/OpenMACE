function [cellsInView, mapSignals, targSignals, cellStateMat, numViews ] = simulateNoisySensors( xcp, ycp, Rsense, x, N, targetState, targetModel, cellStateMat, bin2NodeID, mG, nG, mZ, nZ, trueWorldGraph, numViews )
% Input:

% Output:
%   cellsInView: (bx, by) coordinates of cells in view of current agent
%   discoveredCells: (bx, by) coordinates of cells that have never been
%       visited i.e. cellStateMat(bx,by) == 2
%   nodeCells: (bx, by) coordinates of discovered cells subset which
%       contains nodes
%   cellStateMat: updated cellState matrix (1,2,0)

% 
numBinsX = length(xcp);
numBinsY = length(ycp);
dx = xcp(2) - xcp(1);
dy = ycp(2) - ycp(1);
windowWidth = 3*ceil(Rsense/dx)+1;
halfWidth = floor((windowWidth-1)/2);

minX = xcp(1) - dx;
minY = ycp(1) - dy;
% get targets xy
for i = 1:1:targetModel.M
    curNode = targetState.x(2*i-1,1);
    targXY(i,1) = trueWorldGraph.Nodes.x( curNode );
    targXY(i,2) = trueWorldGraph.Nodes.y( curNode );
    targetBinX(i) = max(ceil( (targXY(i,1) - minX ) /  dx ),1);
    targetBinY(i) = max(ceil( (targXY(i,2) - minY ) /  dy ),1);
    targetBinX(i) = min(targetBinX(i), numBinsX);
    targetBinY(i) = min(targetBinY(i), numBinsY);
end

%
cellsInView = [];
for i = 1:1:N
    % state of i-th agent
    agents(i,:) = [x(4*i-3) x(4*i-2)];
end
k = 1;
for i = 1:1:size(agents,1)
    agent = agents(i,:);
    % gridCellSensorFunction
    % Input:
    %
    % Output:
    %   cellsInView: (bx, by) coordinates of cells in view of current agent
    %   discoveredCells: (bx, by) coordinates of cells that have never been
    %       visited i.e. cellStateMat(bx,by) == 2
    %   nodeCells: (bx, by) coordinates of discovered cells subset which
    %       contains nodes
    %   cellStateMat: updated cellState matrix (1,2,0)
    
    % find the nominal bin in which the vehicle currently is in
    binX = max(floor( (agent(1) - xcp(1)) /  dx ),1);
    binY = max(floor( (agent(2) - ycp(1)) /  dy ),1);
    binX = min(binX, numBinsX);
    binY = min(binY, numBinsY);
    % determine the bin indices that need to be checked (i.e., that define
    % the current window)
    binXStart = max( binX - halfWidth + 1, 1);
    binXEnd = min( binX + halfWidth + 1, numBinsX );
    binYStart = max( binY - halfWidth + 1, 1);
    binYEnd = min( binY + halfWidth + 1, numBinsY );
    % create search bin vectors to search locally around each agent
    for bx = [binXStart:1:binXEnd]
        for by = [binYStart:1:binYEnd]
            controlPt = [xcp(bx) ycp(by)];
            % check if control point is within sensing range
            if ( norm(controlPt-agent) <= Rsense )
                cellsInView = [ cellsInView; bx by];
                
                % grid sensor
                % 1 - if it contains a node of the occupancy graph
                % 0 - if it is an obstacle cell
                cellStateMat(by,bx) = (bin2NodeID(by,bx)~= 0);  %
                if ( cellStateMat(by,bx) == 1 ) % is a node
                    mapSignals(k) = quantizedSensor(mG, nG, 1);
                else
                    mapSignals(k) = quantizedSensor(mG, nG, 0);
                end
                % target sensor                
                for j = 1:1:targetModel.M                       
                   if ( (bx == targetBinX(j)) && (by == targetBinY(j)) )
                       targSignals(k) = quantizedSensor(mZ, nZ, 1);
                       fprintf('\n\n Target In View! Bin (bx,by) = (%d, %d), Pos (x,y) = (%3.3f,%3.3f)\n', bx, by, xcp(bx), ycp(by));
                       numViews = numViews + 1;
%                        figure;
%                        plot(swarmWorld.exploredGraph,'XData',swarmWorld.exploredGraph.Nodes.nodeX,'YData',swarmWorld.exploredGraph.Nodes.nodeY)
%                        hold on;
%                        drawgrid(0, 40, 0, 40, 5);
%                        plot(xcp(bx), ycp(by),'m+','MarkerSize',10);
                   else
                       %fprintf('Target is in (%3.3f, %3.3f)\n',targXY(j,1),targXY(j,2));
                       targSignals(k) = quantizedSensor(mZ, nZ, 0);
                   end
                end
                k = k + 1;
            end
        end
    end
end

end

