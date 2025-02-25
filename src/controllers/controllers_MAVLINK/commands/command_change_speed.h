#ifndef MAVLINK_CONTROLLER_COMMAND_CHANGE_SPEED_H
#define MAVLINK_CONTROLLER_COMMAND_CHANGE_SPEED_H

#include "generic_long_command.h"

#include "data_generic_command_item/do_items/action_change_speed.h"

namespace MAVLINKUXVControllers{


class Command_ChangeSpeed : public Controller_GenericLongCommand<command_item::ActionChangeSpeed, MAV_CMD_DO_CHANGE_SPEED>
{
public:
    Command_ChangeSpeed(const Controllers::IMessageNotifier<mavlink_message_t, MavlinkEntityKey> *cb, TransmitQueue *queue, int linkChan) :
        Controller_GenericLongCommand<command_item::ActionChangeSpeed, MAV_CMD_DO_CHANGE_SPEED>(cb, queue, linkChan, "ChangeSpeed")
    {

    }

    virtual ~Command_ChangeSpeed() = default;

protected:

    virtual void FillCommand(const command_item::ActionChangeSpeed &commandItem, mavlink_command_long_t &cmd) const
    {
        cmd.target_system = static_cast<uint8_t>(commandItem.getTargetSystem());
        cmd.param1 = static_cast<float>(0);
        cmd.param2 = static_cast<float>(commandItem.getDesiredSpeed());
        cmd.param3 = static_cast<float>(-1);
        cmd.param4 = static_cast<float>(0);

    }

    virtual void BuildCommand(const mavlink_command_long_t &message, command_item::ActionChangeSpeed &data) const
    {
        data.setTargetSystem(message.target_system);
        data.setSpeedFrame(Data::SpeedFrame::AIRSPEED); // param
        data.setDesiredSpeed(message.param2);
    }
};

} //end of namespace MAVLINK_CONTROLLER_COMMAND_CHANGE_SPEED_H


#endif // COMMAND_CHANGE_SPEED_H
