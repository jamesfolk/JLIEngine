//
//  BaseUpdateBehavior.h
//  GameAsteroids
//
//  Created by James Folk on 7/16/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__BaseUpdateBehavior__
#define __GameAsteroids__BaseUpdateBehavior__

#include "AbstractFactory.h"
#include "AbstractBehavior.h"
#include "BaseEntity.h"
#include "UpdateBehaviorFactoryIncludes.h"

#include "btScalar.h"

class btCollisionWorld;

class BaseUpdateBehavior :
public AbstractFactoryObject,
public AbstractBehavior<BaseEntity>
{
    friend class UpdateBehaviorFactory;
protected:
    BaseUpdateBehavior();
    BaseUpdateBehavior(const UpdateBehaviorInfo& constructionInfo);
    virtual ~BaseUpdateBehavior();
public:
    static BaseUpdateBehavior *create(int type = 0);
    static bool destroy(IDType &_id);
    static bool destroy(BaseUpdateBehavior *entity);
    static BaseUpdateBehavior *get(IDType _id);

    
    SIMD_FORCE_INLINE IDType getID()const
    {
        return AbstractFactoryObject::getID();
    }
    
    SIMD_FORCE_INLINE const std::string &getName()const
    {
        return AbstractFactoryObject::getName();
    }
    
    virtual void update(BaseEntity *owner, btCollisionWorld* collisionWorld, btScalar deltaTimeStep);
};

#endif /* defined(__GameAsteroids__BaseUpdateBehavior__) */
