function swarmState = sendDatumAndWaitForGPS( ROS_MACE )

swarmState = struct;

% Setup datum command:
datumRequest = rosmessage(ROS_MACE.datumClient);
datumRequest.CommandID = 0; % TODO: Set command ID enum in MACE
datumRequest.LatitudeDeg = ROS_MACE.LatRef;
datumRequest.LongitudeDeg = ROS_MACE.LongRef;
datumRequest.Timestamp = rostime('now');
datumRequest.VehicleID = 1; % Not necessary for this
datumResponse = call(ROS_MACE.datumClient, datumRequest, 'Timeout', 5);
if ( datumResponse.Success )
    fprintf('Datum Command Sent.\n');
else
    fprintf('Datum Command Failed.\n');
end
pause(1);

fprintf('Waiting for GPS...\n');
% Wait for each vehicle to get GPS
gpsAvailable = zeros(1,ROS_MACE.N);
while( ~all(gpsAvailable) )
    msg = ROS_MACE.positionSub.LatestMessage;
%     msgGeo = ROS_MACE.geopositionSub.LatestMessage;
    positionCallback( ROS_MACE, msg); 
    if ( ~isempty(msg) )
        agentIndex = ROS_MACE.agentIDtoIndex( msg.VehicleID );
        if ( gpsAvailable(agentIndex) == 0 )
            gpsAvailable(agentIndex) = 1;
            fprintf('VehicleID %d GPS Available.\n', msg.VehicleID);
            
%             [Easting, Northing,~] = geodetic2enu(msgGeo.Latitude,msgGeo.Longitude,0,ROS_MACE.LatRef,ROS_MACE.LongRef,0,wgs84Ellipsoid,'degrees');
            fprintf('Vehicle location before arm and takeoff easting = %3.1f, northing = %3.1f\n',msg.Easting , msg.Northing);
%             fprintf('Vehicle geo location before a and t lat = %f, long = %f\n',msg.Latitude,msg.Longitude);
            % each agent has states [x y xdot ydot]
            i = agentIndex;
            switch ROS_MACE.coordSys
                case 'ENU'
                    swarmState.x0(4*i-3,1) = msg.Easting;
                    swarmState.x0(4*i-2,1) = msg.Northing;
                    swarmState.x0(4*i-1,1) = 0; % unused for now
                    swarmState.x0(4*i,1) = 0;
                case 'F3'
%                     [Easting, Northing,~] = geodetic2enu(msgGeo.Latitude,msgGeo.Longitude,0,ROS_MACE.LatRef,ROS_MACE.LongRef,0,wgs84Ellipsoid,'degrees');
                    [xF3, yF3] = ENUtoF3(msg.Easting, msg.Northing);
                    swarmState.x0(4*i-3,1) = xF3;
                    swarmState.x0(4*i-2,1) = yF3;
                    swarmState.x0(4*i-1,1) = 0; % unused for now
                    swarmState.x0(4*i,1) = 0;
            end
        end
    end
    pause(0.1);
end

%swarmState.x0 = [ 0 0 0 0]';
swarmState.x = swarmState.x0;

% initialize run time
swarmState.t = 0;
swarmState.k = 0;

disp('Press a key to begin arm/takeoff procedure...')
pause;

end