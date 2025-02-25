#ifndef STATE_TAKEOFF_TRANSITIONING_H
#define STATE_TAKEOFF_TRANSITIONING_H

#include <mavlink.h>

#include "abstract_state_ardupilot.h"

#include "../ardupilot_target_progess.h"

#include "module_vehicle_MAVLINK/controllers/controller_guided_mission_item.h"

namespace ardupilot{
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
    bool handleCommand(const std::shared_ptr<AbstractCommandItem> command) override;

    void Update() override;

    void OnEnter() override;

    void OnEnter(const std::shared_ptr<AbstractCommandItem> command) override;

    void OnExit() override;

private:
    ArdupilotTargetProgess guidedProgress;
};

} //end of namespace ardupilot
} //end of namespace state

#endif // STATE_TAKEOFF_TRANSITIONING_H
