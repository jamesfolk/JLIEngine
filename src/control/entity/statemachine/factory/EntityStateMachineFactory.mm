//
//  EntityStateMachineFactory.cpp
//  GameAsteroids
//
//  Created by James Folk on 3/15/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "EntityStateMachineFactory.h"
#include "EntityStateMachine.h"

EntityStateMachine *EntityStateMachineFactory::createStateMachine(EntityStateMachineInfo *constructionInfo)
{
    EntityStateMachine *pStateMachine = NULL;
    
    switch (constructionInfo->m_Type)
    {
        case StateMachineTypes_Base:
            pStateMachine = new EntityStateMachine(*constructionInfo);
            break;
            
        default:
            break;
    }
    return pStateMachine;
}

EntityStateMachine *EntityStateMachineFactory::ctor(EntityStateMachineInfo *constructionInfo)
{
    return createStateMachine(constructionInfo);
}
EntityStateMachine *EntityStateMachineFactory::ctor(int type)
{
    EntityStateMachine *pStateMachine = NULL;
    
    switch (type)
    {
        default:case StateMachineTypes_Base:
            pStateMachine = new EntityStateMachine();
            break;
    }
    return pStateMachine;
}

void EntityStateMachineFactory::dtor(EntityStateMachine *object)
{
    delete object;
}