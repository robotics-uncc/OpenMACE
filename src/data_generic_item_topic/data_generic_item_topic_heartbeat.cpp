#include "data_generic_item_topic_heartbeat.h"

namespace DataGenericItemTopic {

const char DataGenericItemTopicHeartbeat_name[] = "heartbeat";
const MaceCore::TopicComponentStructure DataGenericItemTopicHeartbeat_structure = []{
    MaceCore::TopicComponentStructure structure;
    structure.AddTerminal<Data::CommsProtocol>("protocol");
    structure.AddTerminal<MAV_TYPE>("type");
    structure.AddTerminal<MAV_AUTOPILOT>("autopilot");
    structure.AddTerminal<Data::MissionExecutionState>("missionState");
    structure.AddTerminal<bool>("maceCompanion");
    structure.AddTerminal<uint8_t>("mavlinkID");
    structure.AddTerminal<Data::MACEHSMState>("currentHSMState");
    structure.AddTerminal<uint8_t>("flightMode");
    structure.AddTerminal<bool>("armed");
    return structure;
}();

MaceCore::TopicDatagram DataGenericItemTopic_Heartbeat::GenerateDatagram() const {
    MaceCore::TopicDatagram datagram;
    datagram.AddTerminal<Data::CommsProtocol>("protocol", protocol);
    datagram.AddTerminal<MAV_TYPE>("type", type);
    datagram.AddTerminal<MAV_AUTOPILOT>("autopilot", autopilot);
    datagram.AddTerminal<Data::MissionExecutionState>("missionState", missionState);
    datagram.AddTerminal<bool>("maceCompanion", maceCompanion);
    datagram.AddTerminal<uint8_t>("mavlinkID", mavlinkID);
    datagram.AddTerminal<Data::MACEHSMState>("currentHSMState", currentHSMState);
    datagram.AddTerminal<uint8_t>("flightMode", flightMode);
    datagram.AddTerminal<bool>("armed", armed);
    return datagram;
}

void DataGenericItemTopic_Heartbeat::CreateFromDatagram(const MaceCore::TopicDatagram &datagram) {
    protocol = datagram.GetTerminal<Data::CommsProtocol>("protocol");
    type = datagram.GetTerminal<MAV_TYPE>("type");
    autopilot = datagram.GetTerminal<MAV_AUTOPILOT>("autopilot");
    missionState = datagram.GetTerminal<Data::MissionExecutionState>("missionState");
    maceCompanion = datagram.GetTerminal<bool>("maceCompanion");
    mavlinkID = datagram.GetTerminal<uint8_t>("mavlinkID");
    currentHSMState = datagram.GetTerminal<Data::MACEHSMState>("currentHSMState");
    flightMode = datagram.GetTerminal<uint8_t>("flightMode");
    armed = datagram.GetTerminal<bool>("armed");
}

DataGenericItemTopic_Heartbeat::DataGenericItemTopic_Heartbeat()
    :DataGenericItem::DataGenericItem_Heartbeat()
{

}

DataGenericItemTopic_Heartbeat::DataGenericItemTopic_Heartbeat(const DataGenericItem::DataGenericItem_Heartbeat &copyObj):
    DataGenericItem::DataGenericItem_Heartbeat(copyObj)
{

}

} //end of namespace DataGenericItemTopic
