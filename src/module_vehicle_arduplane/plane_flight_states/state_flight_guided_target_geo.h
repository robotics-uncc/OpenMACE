#ifndef AP_STATE_FLIGHT_GUIDED_TARGET_GEO_H
#define AP_STATE_FLIGHT_GUIDED_TARGET_GEO_H

#include <iostream>
#include <mavlink.h>

#include "data/timer.h"


#include "module_vehicle_ardupilot/flight_states/abstract_state_ardupilot.h"

#include "module_vehicle_ardupilot/guided_timeout_controller.h"

#include "controllers/controllers_MAVLINK/controller_guided_target_item_global.h"

#include "data_generic_command_item/command_item_components.h"

#include "data_generic_mission_item_topic/mission_item_reached_topic.h"


namespace ardupilot {
namespace state{

class AP_State_FlightGuided_GeoTarget : public AbstractStateArdupilot
{
public:
    AP_State_FlightGuided_GeoTarget();

    void OnExit() override;

public:
    AbstractStateArdupilot* getClone() const override;

    void getClone(AbstractStateArdupilot** state) const override;

public:
    hsm::Transition GetTransition() override;

public:
    bool handleCommand(const std::shared_ptr<command_item::AbstractCommandItem> command) override;

    void Update() override;

    void OnEnter() override;

    void OnEnter(const std::shared_ptr<command_item::AbstractCommandItem> command) override;

private:
    static void retransmitGuidedCommand(void *p, command_item::Action_DynamicTarget &commandTarget)
    {
        static_cast<AP_State_FlightGuided_GeoTarget*>(p)->constructAndSendTarget(commandTarget);
    }
    void constructAndSendTarget(const command_item::Action_DynamicTarget &command)
    {
        MavlinkEntityKey sender = 255;
        static_cast<MAVLINKUXVControllers::ControllerGuidedTargetItem_Global*>(Owner().ControllersCollection()->At("GeodeticTargetController"))->Broadcast(command, sender);
    }

private:
    ardupilot_vehicle::GuidedTimeoutController m_TimeoutController;

};

} //end of namespace state
} //end of namespace arudcopter

#endif // AP_STATE_FLIGHT_GUIDED_TARGET_GEO_H
