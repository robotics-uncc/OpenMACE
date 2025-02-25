#ifndef DYNAMIC_MISSION_QUEUE_H
#define DYNAMIC_MISSION_QUEUE_H

#include "../mission_items/mission_key.h"

#include "dynamic_target_list.h"

namespace command_target {

MACE_CLASS_FORWARD(DynamicMissionQueue);

class DynamicMissionQueue
{
public:
    DynamicMissionQueue();

    DynamicMissionQueue(const MissionItem::MissionKey &key, const unsigned int &index);

    DynamicMissionQueue(const DynamicMissionQueue &copy);

    ~DynamicMissionQueue();

    void setMissionKey(const MissionItem::MissionKey &key)
    {
        this->m_missionKey = key;
    }

    void setDynamicTargetList(const DynamicTargetList &list)
    {
        this->m_TargetList = list;
    }

    const DynamicTargetList* getDynamicTargetList() const
    {
        return &this->m_TargetList;
    }

    DynamicTargetList* getDynamicTargetList()
    {
        return &this->m_TargetList;
    }

    MissionItem::MissionKey getAssociatedMissionKey() const
    {
        return this->m_missionKey;
    }

    void setAssociatedMissionItem(const unsigned int &itemIndex)
    {
        this->associatedMissionItem = itemIndex;
    }

    unsigned int getAssociatedMissionItem() const
    {
        return this->associatedMissionItem;
    }

public:
    DynamicMissionQueue& operator = (const DynamicMissionQueue &rhs)
    {
        this->m_missionKey = rhs.m_missionKey;
        this->associatedMissionItem = rhs.associatedMissionItem;
        this->m_TargetList = rhs.m_TargetList;
        return *this;
    }

    bool operator == (const DynamicMissionQueue &rhs) const{
        if(this->m_missionKey != rhs.m_missionKey){
            return false;
        }
        if(this->associatedMissionItem != rhs.associatedMissionItem){
            return false;
        }
        if(this->m_TargetList != rhs.m_TargetList){
            return false;
        }
        return true;
    }

    bool operator != (const DynamicMissionQueue &rhs) const{
        return !(*this == rhs);
    }

private:
    MissionItem::MissionKey m_missionKey;
    unsigned int associatedMissionItem = 0;

    DynamicTargetList m_TargetList;
};

} //end of namespace command_target

#endif // DYNAMIC_MISSION_QUEUE_H
