//
//  EntityStateMachineFactory.h
//  GameAsteroids
//
//  Created by James Folk on 3/15/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__EntityStateMachineFactory__
#define __GameAsteroids__EntityStateMachineFactory__

#include "AbstractFactory.h"
#include "EntityStateMachineFactoryIncludes.h"
#include "EntityStateMachine.h"

class EntityStateMachineFactory;

class EntityStateMachineFactory :
public AbstractFactory<EntityStateMachineFactory, EntityStateMachineInfo, EntityStateMachine>
{
    friend class AbstractSingleton;
    
    EntityStateMachine *createStateMachine(EntityStateMachineInfo *constructionInfo);
    
    EntityStateMachineFactory(){}
    virtual ~EntityStateMachineFactory()
    {
    }
protected:
    virtual EntityStateMachine *ctor(EntityStateMachineInfo *constructionInfo);
    virtual EntityStateMachine *ctor(int type = 0);
    virtual void dtor(EntityStateMachine *object);
};

#endif /* defined(__GameAsteroids__StateMachineFactory__) */
