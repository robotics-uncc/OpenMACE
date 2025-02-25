%function forecast = ordinaryKrig(X,Y,measurements,R)
%
% Description: Implements a simple kriging algorithm
%
% Input:
%   measurements : (M x 3) matrix, with each row (xval, yval, zval)
%   X : (Nrows x Ncols) grid of X values
%   Y : (Nrows x Ncols) grid of Y values
%   mean : a user-defined mean, the forecast reaches this mean at points
%   away from all the measurements (e.g., a distance >> R)
%   R : a shape parameter (similar to radius of influence)
%
% Output:
%   forecast : (Nrows x Ncols) of interpolated zvals
%
% Ref. Zekai Sen, "Spatial Modeling Principles in Earth Sciences", 2009.
%
% Artur Wolek, 2018

function forecast = anisotropicAdaptiveKrigFast3(measurements, ax,ay, anglesRad, weights, xcp, ycp, V, cellStateMat)
Nx = numel(xcp);
Ny = numel(ycp);
forecast = zeros(Nx,Ny);
weights = weights/sum(weights);
if ( ~isempty(measurements) )
    
    tempTime = tic;
    % process measurements from bins to control pts
    xm = xcp(measurements(:,1))';
    ym = ycp(measurements(:,2))';
    nm = size(measurements,1);
    
    T = [1/ax 0; 0 1/ay]; % scaling
    % transform coordinates for kernel
    for i = 1:1:length(anglesRad)
        M{i} = T*[cos(anglesRad(i)) sin(anglesRad(i)); -sin(anglesRad(i)) cos(anglesRad(i))];
    end
    numAngles = length(anglesRad);
    [xxm,yym] = meshgrid(xm, ym);
    del(1,:) = reshape(xxm - xxm', nm*nm,1);
    del(2,:) = reshape(yym - yym', nm*nm,1);
    for i = 1:1:length(anglesRad)
        % multiple M by the direction vectors in del
        vals = M{i}*del;
        % store the exponential of all the scaled distances into E
        E(:,:,i) = reshape(exp(-vecnorm(vals)),[nm nm]);
    end
    disp('process msmts, compute exponential scaled distances');
    toc(tempTime);
    
    
    tempTime = tic;
    % build the covariance matrix of measurements-to-measurements
    % weights are given by the edge histogram
    C = zeros(nm,nm);
    for i = 1:1:length(numAngles)
        C = C + weights(i)*E(:,:,i);
    end
    
    % augment last row/col Eq. 5.25
    C(end+1,:) = ones(1,nm);
    C(:,end+1) = [ones(1,nm) 0]';
    Cinv = inv(C); % Eq. 5.41
    z = measurements(:,3);
    disp('build cov and compute inverse');
    toc(tempTime);
    
    tempTime = tic;
    % cellStateMat = 2 unexplored
    % cellStateMat = 1 node
    % cellStateMat = 0 empty
    [row,col] = find(cellStateMat==2);
    forecast = V;
    % go through each prediction point
    for k = 1:1:length(row)
        i = col(k);
        j = row(k);
        B = zeros(nm,1);
        delPts = [xcp(i)-xm, ycp(j)-ym];
        for l = 1:1:numAngles
            vals = M{l}*delPts';
            B = B + weights(l)*reshape(exp(-vecnorm(vals)),[nm 1]);
        end
        B = [B; 1];
        w = Cinv*B; % weights, Eq. 5.42
        mu = w(end);
        lam = w(1:end-1);
        forecast(j,i) = lam'*(z-mu)+mu;% linear estimate, Eq. 5.48
    end
    
    disp('predict');
    toc(tempTime);
    
    forecast( forecast > 1 ) = 1;
    forecast( forecast < 0 ) = 0;
    
    
    
end