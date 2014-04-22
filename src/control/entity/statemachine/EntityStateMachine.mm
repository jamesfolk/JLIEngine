//
//  EntityStateMachine.mm
//  GameAsteroids
//
//  Created by James Folk on 3/13/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "EntityStateMachine.h"

#include "EntityStateMachineFactory.h"

EntityStateMachine *EntityStateMachine::create(int type)
{
    return EntityStateMachineFactory::getInstance()->createObject(type);
}

bool EntityStateMachine::destroy(IDType &_id)
{
    return EntityStateMachineFactory::getInstance()->destroy(_id);
}

bool EntityStateMachine::destroy(EntityStateMachine *entity)
{
    bool ret = false;
    if(entity)
    {
        IDType _id = entity->getID();
        ret = EntityStateMachine::destroy(_id);
    }
    entity = NULL;
    return ret;
}
EntityStateMachine *EntityStateMachine::get(IDType _id)
{
    return EntityStateMachineFactory::getInstance()->get(_id);
}




EntityStateMachine::EntityStateMachine(const EntityStateMachineInfo &constructionInfo) :
m_StateMachineInfo(constructionInfo)
{
    
}

EntityStateMachine::EntityStateMachine()
{
    
}

EntityStateMachine::~EntityStateMachine()
{
    if(getOwner())
        getOwner()->setStateMachineID(0);
}