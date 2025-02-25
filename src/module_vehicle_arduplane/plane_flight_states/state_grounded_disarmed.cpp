#include "state_grounded_disarmed.h"

namespace ardupilot {
namespace state{

AP_State_GroundedDisarmed::AP_State_GroundedDisarmed():
    AbstractStateArdupilot(Data::MACEHSMState::STATE_GROUNDED_DISARMED)
{

}

AbstractStateArdupilot* AP_State_GroundedDisarmed::getClone() const
{
    return (new AP_State_GroundedDisarmed(*this));
}

void AP_State_GroundedDisarmed::getClone(AbstractStateArdupilot** state) const
{
    *state = new AP_State_GroundedDisarmed(*this);
}

hsm::Transition AP_State_GroundedDisarmed::GetTransition()
{
    hsm::Transition rtn = hsm::NoTransition();

    if(_currentState != _desiredState)
    {
        //this means we want to chage the state of the vehicle for some reason
        //this could be caused by a command, action sensed by the vehicle, or
        //for various other peripheral reasons
        switch (_desiredState) {
        case Data::MACEHSMState::STATE_GROUNDED_IDLE:
        {
            rtn = hsm::SiblingTransition<AP_State_GroundedIdle>();
            break;
        }
        default:
            std::cout<<"I dont know how we ended up in this transition state from AP_State_GroundedDisarmed."<<std::endl;
            break;
        }
    }
    return rtn;
}

bool AP_State_GroundedDisarmed::handleCommand(const std::shared_ptr<command_item::AbstractCommandItem> command)
{
    UNUSED(command);
    return false;
}

void AP_State_GroundedDisarmed::Update()
{
}

void AP_State_GroundedDisarmed::OnEnter()
{
    _desiredState = Data::MACEHSMState::STATE_GROUNDED_IDLE;
}

void AP_State_GroundedDisarmed::OnEnter(const std::shared_ptr<command_item::AbstractCommandItem> command)
{
    UNUSED(command);
    this->OnEnter();
}

} //end of namespace ardupilot
} //end of namespace

#include "plane_flight_states/state_grounded_idle.h"
