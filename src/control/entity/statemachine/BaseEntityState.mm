//
//  BaseEntityState.cpp
//  GameAsteroids
//
//  Created by James Folk on 3/20/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "BaseEntityState.h"
#include "EntityStateFactory.h"

BaseEntityState::BaseEntityState()
{
    
}

BaseEntityState::~BaseEntityState()
{
    
}






BaseEntityState *BaseEntityState::create(int type)
{
    return EntityStateFactory::getInstance()->createObject(type);
}

bool BaseEntityState::destroy(IDType &_id)
{
    return EntityStateFactory::getInstance()->destroy(_id);
}

bool BaseEntityState::destroy(BaseEntityState *entity)
{
    bool ret = false;
    if(entity)
    {
        IDType _id = entity->getID();
        ret = BaseEntityState::destroy(_id);
    }
    entity = NULL;
    return ret;
}
BaseEntityState *BaseEntityState::get(IDType _id)
{
    return EntityStateFactory::getInstance()->get(_id);
}





void BaseEntityState::enter(BaseEntity *pBaseEntity)
{
    
}

void BaseEntityState::update(BaseEntity*pBaseEntity, btScalar deltaTimeStep)
{
    
}

//this will execute when the state is exited.
void BaseEntityState::exit(BaseEntity *pBaseEntity)
{
    
}


//this executes if the agent receives a message from the
//message dispatcher
bool BaseEntityState::onMessage(BaseEntity *pBaseEntity, const Telegram &telegram)
{
    return pBaseEntity->handleMessage(telegram);
}
