#include "state_landing_complete.h"

namespace ardupilot {
namespace state{

AP_State_LandingComplete::AP_State_LandingComplete():
    AbstractStateArdupilot(Data::MACEHSMState::STATE_LANDING_COMPLETE)
{

}

AbstractStateArdupilot* AP_State_LandingComplete::getClone() const
{
    return (new AP_State_LandingComplete(*this));
}

void AP_State_LandingComplete::getClone(AbstractStateArdupilot** state) const
{
    *state = new AP_State_LandingComplete(*this);
}

hsm::Transition AP_State_LandingComplete::GetTransition()
{
    hsm::Transition rtn = hsm::NoTransition();

    if(_currentState != _desiredState)
    {
        //this means we want to chage the state of the vehicle for some reason
        //this could be caused by a command, action sensed by the vehicle, or
        //for various other peripheral reasons
        switch (_desiredState) {

        default:
            std::cout<<"I dont know how we ended up in this transition state from STATE_TAKEOFF."<<std::endl;
            break;
        }
    }
    return rtn;
}

bool AP_State_LandingComplete::handleCommand(const std::shared_ptr<command_item::AbstractCommandItem> command)
{
    UNUSED(command);
    return false;
}

void AP_State_LandingComplete::Update()
{

}

void AP_State_LandingComplete::OnEnter()
{

}

void AP_State_LandingComplete::OnEnter(const std::shared_ptr<command_item::AbstractCommandItem> command)
{
    if(command != nullptr)
    {

    }
}

} //end of namespace ardupilot
} //end of namespace state
