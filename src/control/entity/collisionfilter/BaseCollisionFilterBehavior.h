//
//  BaseCollisionFilterBehavior.h
//  GameAsteroids
//
//  Created by James Folk on 7/19/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__BaseCollisionFilterBehavior__
#define __GameAsteroids__BaseCollisionFilterBehavior__

#include "AbstractFactory.h"
#include "AbstractBehavior.h"
#include "CollisionFilterBehaviorFactoryIncludes.h"

class BaseEntity;

class BaseCollisionFilterBehavior :
public AbstractFactoryObject,
public AbstractBehavior<BaseEntity>
{
public:
    friend class CollisionFilterBehaviorFactory;
    
    BaseCollisionFilterBehavior(const CollisionFilterBehaviorInfo& constructionInfo);
    virtual ~BaseCollisionFilterBehavior();
public:
    virtual bool shouldCollide(const BaseEntity *pOtherEntity)const;
    virtual CollisionFilterBehaviorTypes getCollideType()const;
protected:
    CollisionFilterBehaviorTypes getOtherType(const BaseEntity *pOtherEntity)const;
private:
    CollisionFilterBehaviorTypes m_collideType;
};


#endif /* defined(__GameAsteroids__BaseCollisionFilterBehavior__) */
