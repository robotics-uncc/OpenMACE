#ifndef STATE_TAKEOFF_TRANSITIONING_H
#define STATE_TAKEOFF_TRANSITIONING_H

#include <mavlink.h>


#include "module_vehicle_ardupilot/flight_states/abstract_state_ardupilot.h"

#include "module_vehicle_ardupilot/ardupilot_target_progess.h"

#include "controllers/controllers_MAVLINK/controller_guided_mission_item.h"

namespace ardupilot {
namespace state{

class State_TakeoffComplete;

class State_TakeoffTransitioning : public AbstractStateArdupilot
{
public:
    State_TakeoffTransitioning();

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

    void OnExit() override;

private:
    ArdupilotTargetProgess guidedProgress;
};

} //end of namespace ardupilot
} //end of namespace state

#endif // STATE_TAKEOFF_TRANSITIONING_H
