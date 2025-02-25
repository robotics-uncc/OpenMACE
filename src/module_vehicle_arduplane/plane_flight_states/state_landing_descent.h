#ifndef AP_STATE_LANDING_DESCENT_H
#define AP_STATE_LANDING_DESCENT_H

#include <mavlink.h>


#include "module_vehicle_ardupilot/flight_states/abstract_state_ardupilot.h"

#include "module_vehicle_ardupilot/ardupilot_target_progess.h"

#include "controllers/controllers_MAVLINK/commands/command_land.h"

namespace ardupilot {
namespace state{

class AP_State_LandingComplete;

class AP_State_LandingDescent : public AbstractStateArdupilot
{
public:
    AP_State_LandingDescent();

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

#endif // AP_STATE_LANDING_DESCENT_H
