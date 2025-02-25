#include "dynamic_target_kinematic.h"

namespace command_target {

DynamicTarget_Kinematic::DynamicTarget_Kinematic():
    m_Position(nullptr), m_Velocity(nullptr), m_Yaw(nullptr), m_YawRate(nullptr)
{

}

DynamicTarget_Kinematic::DynamicTarget_Kinematic(const Position* pos, const Velocity* vel, const Rotation_2D *rot, const Rotation_2D* rotRate):
    m_Position(nullptr), m_Velocity(nullptr), m_Yaw(nullptr), m_YawRate(nullptr)
{
    this->setPosition(pos);
    this->setVelocity(vel);
    this->setYaw(rot);
    this->setYawRate(rotRate);
}

DynamicTarget_Kinematic::DynamicTarget_Kinematic(const DynamicTarget_Kinematic &copy):
    m_Position(nullptr), m_Velocity(nullptr), m_Yaw(nullptr), m_YawRate(nullptr)
{
    this->setPosition(copy.getPosition());
    this->setVelocity(copy.getVelocity());
    this->setYaw(copy.getYaw());
    this->setYawRate(copy.getYawRate());
}

DynamicTarget_Kinematic::~DynamicTarget_Kinematic()
{
    delete m_Position; m_Position = nullptr;
    delete m_Velocity; m_Velocity = nullptr;
    delete m_Yaw; m_Yaw = nullptr;
    delete m_YawRate; m_YawRate = nullptr;
}

DynamicTarget::TargetTypes DynamicTarget_Kinematic::getTargetType() const
{
    return DynamicTarget::TargetTypes::KINEMATIC;
}

void DynamicTarget_Kinematic::setPosition(const Position* pos)
{
    if(m_Position != nullptr)
    {
        delete m_Position;
        m_Position = nullptr;
    }
    if(pos != nullptr)
        this->m_Position = pos->getPositionalClone();
}

void DynamicTarget_Kinematic::setVelocity(const Velocity* vel)
{
    if(m_Velocity)
    {
        delete m_Velocity;
        m_Velocity = nullptr;
    }
    if(vel != nullptr)
        this->m_Velocity = vel->getVelocityClone();
}

void DynamicTarget_Kinematic::setYaw(const Rotation_2D* rot)
{
    if(m_Yaw)
    {
        delete m_Yaw;
        m_Yaw = nullptr;
    }
    if(rot != nullptr)
        this->m_Yaw = rot->getRotationalClone()->rotationAs<Rotation_2D>();
}

void DynamicTarget_Kinematic::setYawRate(const Rotation_2D* rotRate)
{
    if(m_YawRate)
    {
        delete m_YawRate;
        m_YawRate = nullptr;
    }
    if(rotRate != nullptr)
        this->m_YawRate = rotRate->getRotationalClone()->rotationAs<Rotation_2D>();
}

const Position* DynamicTarget_Kinematic::getPosition() const
{
    return this->m_Position;
}

const Velocity* DynamicTarget_Kinematic::getVelocity() const
{
    return this->m_Velocity;
}

const Rotation_2D* DynamicTarget_Kinematic::getYaw() const
{
    return this->m_Yaw;
}

const Rotation_2D* DynamicTarget_Kinematic::getYawRate() const
{
    return this->m_YawRate;
}

Position* DynamicTarget_Kinematic::getPosition()
{
    return this->m_Position;
}

Velocity* DynamicTarget_Kinematic::getVelocity()
{
    return this->m_Velocity;
}

Rotation_2D* DynamicTarget_Kinematic::getYaw()
{
    return this->m_Yaw;
}

Rotation_2D* DynamicTarget_Kinematic::getYawRate()
{
    return this->m_YawRate;
}

bool DynamicTarget_Kinematic::isCurrentTargetValid() const
{
    if(getCurrentTargetMask() != std::numeric_limits<uint16_t>::max())
        return true;
    return false;
}

uint16_t DynamicTarget_Kinematic::getCurrentTargetMask() const
{
    uint16_t currentMask = 0;

    if(m_Position)
        currentMask = currentMask|m_Position->getDimensionMask();
    if(m_Velocity)
        currentMask = currentMask|m_Velocity->getDimensionMask();
    if(m_Yaw)
        currentMask = currentMask|m_Yaw->getDimensionMask();
    if(m_YawRate)
        currentMask = currentMask|m_YawRate->getDimensionMask();

    return currentMask;
}

} //end of namespace command_target
