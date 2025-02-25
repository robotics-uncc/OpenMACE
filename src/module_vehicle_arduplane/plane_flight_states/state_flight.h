#ifndef AP_STATE_FLIGHT_H
#define AP_STATE_FLIGHT_H

#include <mavlink.h>

#include "module_vehicle_ardupilot/flight_states/abstract_root_state.h"

#include "controllers/controllers_MAVLINK/commands/command_rtl.h"

namespace ardupilot{
namespace state{

class AP_State_FlightAI;

class AP_State_FlightAuto;
class AP_State_FlightGuided;
class AP_State_FlightLand;
class AP_State_FlightLoiter;
class AP_State_FlightManual;
class AP_State_FlightStabilize;
class AP_State_FlightFBW;
class AP_State_FlightRTL;
class AP_State_FlightUnknown;
class AP_State_Unknown;

class AP_State_Landing;
class AP_State_Grounded;
class AP_State_GroundedDisarming;

class AP_State_Flight : public AbstractRootState
{
public:
    AP_State_Flight();

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

public:

    void checkForDelayedTransition(const uint8_t &mode) override;
    
private:
    void checkTransitionFromMode(const std::string &mode);

};

} //end of namespace ardupilot
} //end of namespace state

#endif // AP_STATE_FLIGHT_H
