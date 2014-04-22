//
//  EntityStateMachineFactoryIncludes.h
//  GameAsteroids
//
//  Created by James Folk on 3/15/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef GameAsteroids_EntityStateMachineFactoryIncludes_h
#define GameAsteroids_EntityStateMachineFactoryIncludes_h

enum StateMachineTypes
{
    StateMachineTypes_NONE,
    StateMachineTypes_Base,
    StateMachineTypes_MAX
};

struct EntityStateMachineInfo
{
    StateMachineTypes m_Type;
    
    EntityStateMachineInfo():m_Type(StateMachineTypes_Base){}
    
    int value()const
    {
        return m_Type;
    }
    
    bool operator() (const EntityStateMachineInfo& lhs, const EntityStateMachineInfo& rhs) const{return lhs.value()<rhs.value();}
};

#endif
