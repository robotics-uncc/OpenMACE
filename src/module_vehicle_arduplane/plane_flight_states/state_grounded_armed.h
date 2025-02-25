#ifndef AP_STATE_GROUNDED_ARMED_H
#define AP_STATE_GROUNDED_ARMED_H


#include "module_vehicle_ardupilot/flight_states/abstract_state_ardupilot.h"

namespace ardupilot {
namespace state{

class AP_State_GroundedIdle;
class AP_State_GroundedDisarming;

class AP_State_GroundedArmed : public AbstractStateArdupilot
{
public:
    AP_State_GroundedArmed();

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

};

} //end of namespace ardupilot
} //end of namespace state

#endif // AP_STATE_GROUNDED_ARMED_H
