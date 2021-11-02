#!/bin/bash

# Note: This script assumes the existence of the environment variables:
# - $MACE_ROOT 
# - $ARDUPILOT_ROOT

package="launchMACE_AtUNCC"
cwd=$(pwd)

# default values
NUM_REAL_AGENTS=0
# give USB ports here:
REAL_AGENT_USB[1]=0
REAL_AGENT_USB[2]=1
REAL_AGENT_USB[3]=2
REAL_AGENT_USB[4]=3
# give vehicle ID here:
REAL_AGENT_ID[1]=1
REAL_AGENT_ID[2]=2
REAL_AGENT_ID[3]=5
REAL_AGENT_ID[4]=6


# default values
NUM_SIM_AGENTS=1
# give sim agent is
SIM_AGENT_ID[1]=1
SIM_AGENT_ID[2]=2
SIM_AGENT_ID[3]=3
SIM_AGENT_ID[4]=4
SIM_AGENT_ID[5]=5
SIM_AGENT_ID[6]=6


#IP_ADDRESS=192.168.1.62 # Kim Lab
IP_ADDRESS=10.16.10.190 # localhost
#IP_ADDRESS=192.168.1.219 # Artur Home
#IP_ADDRESS=10.104.196.174 # Artur Office
CONFIG_XML="Default_UNCC.xml"

# Default Heron Farm Lat/Long
#LAT=37.889246
#LONG=-76.814084

# Motorsports Building, UNCC
LAT=35.31224
LONG=-80.73999


LAUNCH_ROS=1
GUI=1
OPEN_TERMINALS=1
ARDUCOPTER_CMD_LIST="arduCopter.sh"
ARDUCOPTER_CMD=0 # 0 do not wati for aducopter

while test $# -gt 0; do
        case "$1" in
                -h|--help)
                        echo "$package - launches ROS/MACE interface"
                        echo " "
                        echo "$package [options] "
                        echo " "
                        echo "options:"
                        echo "-h,  --help                  show brief help"
                        echo "-n,  --num-agents            specify how many agents to launch"
                        echo "-ip, --agent-ip              specify IP address to use"
                        exit 0
                        ;;
                -n*)
                        shift
                        if test $1 -gt 0; then
                                export NUM_AGENTS=$1
                                echo "Number of Agents: $NUM_AGENTS"
                        else
                                echo "Error: Must specify at least one agent (got -n=$1)"
                                exit 1
                        fi
                        shift
                        ;;
                -a|--arducopter-cmds*)
                        shift
                        export ARDUCOPTER_CMD=0
                        echo "Will *not read Arducopter Commands from File: $ARDUCOPTER_CMD_LIST"
                        ;;
                -i|--ip*)
                        shift
                        export IP_ADDRESS=$1 
                        echo "Agent/Sim IP Address: $IP_ADDRESS"
                        ;;
                -x|--xml*)
                        shift
                        export CONFIG_XML=$1
                        echo "Using Config-file: $MACE_ROOT/MaceSetup_Configs/$CONFIG_XML"
                        ;;
                -l|--location*)
                        shift
                        export LAT_LONG=$1 
                        echo "Using Custom Location: $LAT_LONG"
                        ;;
                -r|--roscore*)
                        shift
                        export LAUNCH_ROS=0
                        echo "Will *not* launch ROS"
                        ;;
                -g|--gui*)
                        shift
                        export GUI=0
                        echo "Will *not* launch GUI"
                        ;;
                -q|--quiet*)
                        shift
                        export OPEN_TERMINALS=0
                        echo "Will run in quiet mode."
                        ;;
                *)
                        breakat 
                        ;;
        esac
done

# Launch ROS
if [ $LAUNCH_ROS -eq 1 ]  
  then
  echo "Launching roscore..."
#  if [ $OPEN_TERMINALS -eq 0 ]
#    then
      roscore </dev/null &>/dev/null &
#    else
#      gnome-terminal -e "bash -c \"roscore\""
#  fi
  sleep 5s
fi



# Create .XML file
cd $MACE_ROOT/MaceSetup_Configs/
echo "Creating XML File..."
rm -f $CONFIG_XML
touch $CONFIG_XML
echo " <?xml version=\"1.0\" encoding=\"utf-8\"?>
<ModuleConfigurations MaceInstance=\"0\">" > $CONFIG_XML

echo "
    <GlobalParams>
        <Parameter Name=\"GlobalOrigin\">
            <Parameter Name=\"Latitude\">${LAT}</Parameter>
            <Parameter Name=\"Longitude\">${LONG}</Parameter>
            <Parameter Name=\"Altitude\">0.0</Parameter>
        </Parameter>
        <Parameter Name=\"EnvironmentBoundary\">
        <Parameter Name=\"Vertices\">(-35.359349, 149.154646),
            (-35.359421, 149.160719)
            (-35.363713, 149.162548)
            (-35.365700, 149.155107)
        </Parameter>
        <Parameter Name=\"Type\">soft</Parameter>
        <Parameter Name=\"Name\">YOU SHALL NOT PASS</Parameter>
        </Parameter>
        <Parameter Name=\"maceID\">1</Parameter>
    </GlobalParams> " >> $CONFIG_XML
    
for ((i=1; i<$((NUM_SIM_AGENTS + 1)); i++)); do   
echo " <Module Class=\"VehicleComms\" Type=\"Arducopter\">
    <Parameter Name=\"ID\">$i</Parameter>
    <Parameter Name=\"ProtocolParameters\">
      <Parameter Name=\"Name\">Mavlink</Parameter>
      <Parameter Name=\"Version\">V2</Parameter>
    </Parameter>
	<Parameter Name=\"UDPParameters\">
      <Parameter Name=\"ListenAddress\">${IP_ADDRESS}</Parameter>
      <Parameter Name=\"ListenPortNumber\">1455${SIM_AGENT_ID[$i]}</Parameter>
    </Parameter>
    <Parameter Name=\"ModuleParameters\">
      <Parameter Name=\"AirborneInstance\">false</Parameter>
    </Parameter>
    <Parameter Name=\"LocalPositionParameters\">
      <Parameter Name=\"TransformAltitude\">false</Parameter>
    </Parameter>
    <Parameter Name=\"EKFOrigin\">
      <Parameter Name=\"SetEKFOrigin\">true</Parameter>
      <Parameter Name=\"DuplicateToHome\">false</Parameter>
      <Parameter Name=\"Latitude\">${LAT}</Parameter>
      <Parameter Name=\"Longitude\">${LONG}</Parameter>
      <Parameter Name=\"Altitude\">0.0</Parameter>
    </Parameter>    
  </Module>  " >> $CONFIG_XML
done

### UPDATE BELOW 
for ((i=1; i<$((NUM_REAL_AGENTS + 1)); i++)); do   
echo "  <Module Class=\"VehicleComms\" Type=\"Arducopter\">
    <Parameter Name=\"ProtocolParameters\">
      <Parameter Name=\"Name\">Mavlink</Parameter>
      <Parameter Name=\"Version\">V2</Parameter>
    </Parameter>
<Parameter Name=\"SerialParameters\">
     <Parameter Name=\"PortName\">ttyUSB${REAL_AGENT_USB[$i]}</Parameter>
     <Parameter Name=\"BaudRate\">57600</Parameter>
     <Parameter Name=\"DataBits\">8</Parameter>
     <Parameter Name=\"StopBits\">1</Parameter>
     <Parameter Name=\"Parity\">false</Parameter>
     <Parameter Name=\"FlowControl\">1</Parameter>
   </Parameter>
    <Parameter Name=\"ModuleParameters\">
      <Parameter Name=\"AirborneInstance\">false</Parameter>
    </Parameter>
    <Parameter Name=\"LocalPositionParameters\">
      <Parameter Name=\"TransformAltitude\">false</Parameter>
    </Parameter>
  </Module>  " >> $CONFIG_XML
done
if [ $GUI -eq 1 ]
  then
    echo "<Module Class=\"GroundStation\" Type=\"NASAPhase2\">
	    <Parameter Name=\"ID\">100</Parameter>
	    <Parameter Name=\"MACEComms\">
		    <Parameter Name=\"GUIHostAddress\">$IP_ADDRESS</Parameter>
		    <Parameter Name=\"ListenPort\">5678</Parameter>
		    <Parameter Name=\"SendPort\">1234</Parameter>
	    </Parameter>
       </Module> 
    </ModuleConfigurations> " >> $CONFIG_XML
fi

# Create .json file
cd $MACE_ROOT
rm -f GUIConfig.json
touch GUIConfig.json
echo "Creating .json File..."
echo "{
    \"MACEComms\": {
        \"ipAddress\": \"$IP_ADDRESS\",
		\"listenPortNumber\": 1234,
		\"sendPortNumber\": 5678
    },
	\"GUIInit\": {
		\"mapCenter\": {
			\"lat\": $LAT,
			\"lng\": $LONG
		},
		\"mapZoom\": 17
	},
	\"VehicleSettings\": {
		\"defaultTakeoffAlt\": 10
	}
}" > GUIConfig.json

#Launch GUI
if [ $GUI -eq 1 ]
  then  
    cd $MACE_ROOT/MACE_Frontend
    echo "Launching MACE GUI..."  
#    if [ $OPEN_TERMINALS -eq 0 ]
#      then        
	yarn start:app &>/dev/null &
        #yarn run watch </dev/null &>/dev/null &
        #sleep 5s
        #yarn run start </dev/null &>/dev/null &   
        #sleep 5s
#      else
#        gnome-terminal -e "bash -c \"yarn run watch\""
#        sleep 5s
#        gnome-terminal -e "bash -c \"yarn run start\""
#        sleep 5s
#    fi
fi

# Launch MACE
cd $MACE_ROOT
echo "Launching MACE..."
#if [ $OPEN_TERMINALS -eq 0 ]
#  then
#    MACE ./MaceSetup_Configs/$CONFIG_XML</dev/null &>/dev/null &
#  else
    #gnome-terminal -e "bash -c \"MACE ./MaceSetup_Configs/$CONFIG_XML; exec /bin/bash\""
    gnome-terminal -e "bash -c \"$MACE_ROOT/bin/MACE MaceSetup_Configs/$CONFIG_XML; exec /bin/bash\""
#fi
sleep 5s


# Launch Arducopter simulations
cd $ARDUPILOT_ROOT/ArduCopter
if [ $ARDUCOPTER_CMD -eq 0 ]
  then
    for ((i=1; i<$((NUM_SIM_AGENTS + 1)); i++)); do    
        echo "Launching Arducopter Sim $i..." 
        echo "sim_vehicle.py -I ${SIM_AGENT_ID[$i]} --console --instance=1 --sysid=$i --out=udp:$IP_ADDRESS:1455${SIM_AGENT_ID[$i]} --custom-location=$LAT,$LONG,0,240 </dev/null &>/dev/null &" 
       # if [ $OPEN_TERMINALS -eq 0 ]
       #   then
            sim_vehicle.py -I ${SIM_AGENT_ID[$i]} --console --instance=1 --sysid=$i --out=udp:$IP_ADDRESS:1455${SIM_AGENT_ID[$i]} --custom-location=$LAT,$LONG,0,240 
            #</dev/null &>/dev/null &
       #   else
       #     gnome-terminal -e "bash -c \"sim_vehicle.py -I ${SIM_AGENT_ID[$i]} --console --out=udp:$IP_ADDRESS:1455${SIM_AGENT_ID[$i]} --custom-location=$LAT,$LONG,0,240\""
       # fi
        sleep 5s
    done    
  else
    echo "Waiting for $cwd/$ARDUCOPTER_CMD_LIST..." 
    while [ ! -f $cwd/$ARDUCOPTER_CMD_LIST ] ;
    do
          sleep 2
    done
    $cwd/$ARDUCOPTER_CMD_LIST 
fi

## Launch Arducopter simulations
#cd $ARDUPILOT_ROOT/ArduCopter
#for ((i=1; i<$((NUM_AGENTS + 1)); i++)); do    
#    echo "Launching Arducopter Sim $i..."  
#    if [ $OPEN_TERMINALS -eq 0 ]

#      then
#        sim_vehicle.py -I $i --console --out=udp:$IP_ADDRESS:1455$i --custom-location=$LAT,$LONG,0,240 </dev/null &>/dev/null &
#      else
#        gnome-terminal -e "bash -c \"sim_vehicle.py -I $i --console --out=udp:$IP_ADDRESS:1455$i --custom-location=$LAT,$LONG,0,240\""
#    fi
#    sleep 5s
#done

cd $cwd
echo "Done."
