//
//  SteeringBehaviorFactory.h
//  GameAsteroids
//
//  Created by James Folk on 3/15/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__SteeringBehaviorFactory__
#define __GameAsteroids__SteeringBehaviorFactory__

#include "AbstractFactory.h"
#include "SteeringBehaviorFactoryIncludes.h"
#include "BaseEntitySteeringBehavior.h"

//class BaseEntitySteeringBehavior;
class SteeringBehaviorFactory;

class SteeringBehaviorFactory :
public AbstractFactory<SteeringBehaviorFactory, SteeringBehaviorInfo, BaseEntitySteeringBehavior>
{
    friend class AbstractSingleton;
    
    BaseEntitySteeringBehavior *createSteeringBehavior(SteeringBehaviorInfo *constructionInfo);
    
    SteeringBehaviorFactory(){}
    virtual ~SteeringBehaviorFactory()
    {
    }
protected:
    virtual BaseEntitySteeringBehavior *ctor(SteeringBehaviorInfo *constructionInfo);
    virtual BaseEntitySteeringBehavior *ctor(int type = 0);
    virtual void dtor(BaseEntitySteeringBehavior *object);
};

#endif /* defined(__GameAsteroids__SteeringBehaviorFactory__) */
