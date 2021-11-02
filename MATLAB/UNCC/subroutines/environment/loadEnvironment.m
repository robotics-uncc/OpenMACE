function trueWorld = loadEnvironment(trueWorld, targetModel)
if ( exist([trueWorld.folder trueWorld.fileName '_' trueWorld.type '_full.mat'],'file') == 0 )
    disp('Creating/parsing new trueWorld node locations...');
    LatRef = [];
    LongRef = [];
    switch trueWorld.type
        case 'cityblocks'
            nodeXY = loadCityBlocksNodes(trueWorld.blockLength, trueWorld.numBlocks, trueWorld.binWidth);
            nodeXY(:,1) = nodeXY(:,1) + trueWorld.borderOffset;
            nodeXY(:,2) = nodeXY(:,2) + trueWorld.borderOffset;            
            [ G_env, A_env, nodeX, nodeY ] = convertNodesXYtoGraph(nodeXY, trueWorld.borderOffset, trueWorld.binWidth );
        case 'cityblocksAtF3'
            [ nodeXY ] = loadCityBlocksNodes_atF3(trueWorld.blockLength, trueWorld.numBlocks, trueWorld.binWidth, trueWorld.f3Workspace);
            nodeXY(:,1) = nodeXY(:,1) + trueWorld.borderOffset;
            nodeXY(:,2) = nodeXY(:,2) + trueWorld.borderOffset;                 
            [ G_env, A_env, nodeX, nodeY ] = convertNodesXYtoGraph(nodeXY, trueWorld.borderOffset, trueWorld.binWidth );
        case 'openStreetMap'
            [ nodeXY, LatRef, LongRef, G_env, A_env] = loadOpenStreetMapNodesFlex(trueWorld.fileName, trueWorld.refX, trueWorld.refY, trueWorld.boxlength, trueWorld.boxwidth, trueWorld.angle, trueWorld.binWidth, trueWorld.removeList, trueWorld.scale);
            nodeX = nodeXY(:,1);
            nodeY = nodeXY(:,2);        
        case 'osmAtF3'
            [ nodeXY ] = loadOpenStreetMapNodes_atF3(trueWorld.fileName, trueWorld.refX, trueWorld.refY, trueWorld.boxlength, ...
                trueWorld.angle, trueWorld.buffer, trueWorld.binWidth, trueWorld.f3Workspace);
            [ G_env, A_env, nodeX, nodeY ] = convertNodesXYtoGraph(nodeXY, trueWorld.borderOffset, trueWorld.binWidth );       
    end
    disp('Computing Additional Properties for trueWorld...');
    trueWorld.nodeXY = nodeXY;
    trueWorld.G_env = G_env;
    trueWorld.A_env = A_env;
    trueWorld.nodeX = nodeX;
    trueWorld.nodeY = nodeY;
    trueWorld.numNodes = numnodes(trueWorld.G_env);
    switch trueWorld.type
        case 'openStreetMap'
            trueWorld.minX = 0;
            trueWorld.minY = 0;
            trueWorld.maxX = trueWorld.boxlength;
            trueWorld.maxY = trueWorld.boxwidth;            
            trueWorld.numBinsX = floor(trueWorld.boxlength/trueWorld.binWidth);
            trueWorld.numBinsY = floor(trueWorld.boxwidth/trueWorld.binWidth); 
            [trueWorld.xpoly,trueWorld.ypoly] = buildRectangularBoundaryFromCorners(0, trueWorld.maxX, 0, trueWorld.maxY, trueWorld.borderOffset);
        case 'cityblocksAtF3'
            % cityblocks
            [xpoly,ypoly] = buildRectangularBoundary(nodeX, nodeY, trueWorld.borderOffset);
            trueWorld.xpoly = xpoly;
            trueWorld.ypoly = ypoly;   
            %f3LowerLeftCornerX = 5;
            %f3LowerLeftCornerY = -11;
            %L = trueWorld.blockLength*trueWorld.numBlocks;
            %trueWorld.minX = f3LowerLeftCornerX - trueWorld.borderOffset;
            %trueWorld.maxX = f3LowerLeftCornerX + L + trueWorld.borderOffset;
            %trueWorld.minY = f3LowerLeftCornerY - trueWorld.borderOffset;
            %trueWorld.maxY = f3LowerLeftCornerY + L + trueWorld.borderOffset;            

            trueWorld.minX = min(xpoly) - trueWorld.borderOffset;
            trueWorld.maxX = max(xpoly) + trueWorld.borderOffset;
            trueWorld.minY = min(ypoly) - trueWorld.borderOffset;
            trueWorld.maxY = max(ypoly) + trueWorld.borderOffset;
            
            trueWorld.numBinsX = floor( (trueWorld.maxX - trueWorld.minX)/trueWorld.binWidth );
            trueWorld.numBinsY = floor( (trueWorld.maxY - trueWorld.minY)/trueWorld.binWidth );
        case 'cityblocks'
            % cityblocks

            [xpoly,ypoly] = buildRectangularBoundary(nodeX, nodeY, trueWorld.borderOffset);
            trueWorld.xpoly = xpoly;
            trueWorld.ypoly = ypoly;   
            L = trueWorld.blockLength*trueWorld.numBlocks;
            trueWorld.minX =  0;
            trueWorld.maxX =  L + 2*trueWorld.borderOffset;
            trueWorld.minY =  0;
            trueWorld.maxY = L + 2*trueWorld.borderOffset;            
                        
            trueWorld.numBinsX = floor( (trueWorld.maxX - trueWorld.minX)/trueWorld.binWidth );
            trueWorld.numBinsY = floor( (trueWorld.maxY - trueWorld.minY)/trueWorld.binWidth );            
    end
    
    if ( ~isempty(LatRef) )
        trueWorld.LatRef = LatRef;
        trueWorld.LongReg = LongRef;
    end
    
    % (xcp, ycp) compute the control pts corresponding to the center of each bin
    % numNodesMat gives number of nodes in each bin
    % bin2NodeID returns nodeIndex given bin coordinates
    disp('Creating Search Grid...');
    [trueWorld.xcp,trueWorld.ycp,trueWorld.bin2NodeID] = createSearchGrid(trueWorld.minX, trueWorld.maxX, trueWorld.minY, trueWorld.maxY, nodeX, nodeY, trueWorld.numBinsX, trueWorld.numBinsY);
    
    [trueWorld.xx,trueWorld.yy] = meshgrid(trueWorld.xcp, trueWorld.ycp);
    trueWorld.binWidth = trueWorld.ycp(2) - trueWorld.ycp(1);
    
    disp('Building Target State Space...');
    % motion model parameters
    [ trueWorld.G_tss, trueWorld.Mp, trueWorld.Mc  ] = environmentToStateSpace( trueWorld.G_env );
    trueWorld.Ns = numnodes(trueWorld.G_tss);
    trueWorld.A = adjacency(trueWorld.G_tss);
    % compute state transition matrix given motion model parameters and state
    % space
    disp('Created state transition matrix...')
    [ trueWorld.Q ] = stateTransitionMatrix ( trueWorld.G_tss, targetModel.probStopping, targetModel.m , targetModel.d );
    
    
    save([trueWorld.folder trueWorld.fileName '_' trueWorld.type '_full.mat'],'trueWorld','-v7.3');
    disp(['Saved new "trueWorld" (full model) to:' trueWorld.folder trueWorld.fileName '_' trueWorld.type '_full.mat']);
else
    load([trueWorld.folder trueWorld.fileName '_' trueWorld.type '_full.mat'],'trueWorld')
    disp(['Loaded exsting "trueWorld" (full model) from:' trueWorld.folder trueWorld.fileName '_' trueWorld.type '_full.mat']);
end


end
