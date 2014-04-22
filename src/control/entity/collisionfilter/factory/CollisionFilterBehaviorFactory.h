//
//  CollisionFilterBehaviorFactory.h
//  GameAsteroids
//
//  Created by James Folk on 7/19/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__CollisionFilterBehaviorFactory__
#define __GameAsteroids__CollisionFilterBehaviorFactory__

#include "AbstractFactory.h"
#include "CollisionFilterBehaviorFactoryIncludes.h"
#include "BaseCollisionFilterBehavior.h"
//class BaseCollisionFilterBehavior;
class CollisionFilterBehaviorFactory;

class CollisionFilterBehaviorFactory :
public AbstractFactory<CollisionFilterBehaviorFactory, CollisionFilterBehaviorInfo, BaseCollisionFilterBehavior>
{
    friend class AbstractSingleton;
    
    CollisionFilterBehaviorFactory(){}
    virtual ~CollisionFilterBehaviorFactory(){}
protected:
    virtual BaseCollisionFilterBehavior *ctor(CollisionFilterBehaviorInfo *constructionInfo);
    virtual BaseCollisionFilterBehavior *ctor(int type = 0);
    virtual void dtor(BaseCollisionFilterBehavior *object);
};

#endif /* defined(__GameAsteroids__CollisionFilterBehaviorFactory__) */
