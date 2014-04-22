//
//  BaseUpdateBehavior.cpp
//  GameAsteroids
//
//  Created by James Folk on 7/16/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "BaseUpdateBehavior.h"
#include "BulletCollision/CollisionDispatch/btCollisionWorld.h"
#include "UpdateBehaviorFactory.h"

BaseUpdateBehavior *BaseUpdateBehavior::create(int type)
{
    return UpdateBehaviorFactory::getInstance()->createObject(type);
}

bool BaseUpdateBehavior::destroy(IDType &_id)
{
    return UpdateBehaviorFactory::getInstance()->destroy(_id);
}

bool BaseUpdateBehavior::destroy(BaseUpdateBehavior *entity)
{
    bool ret = false;
    if(entity)
    {
        IDType _id = entity->getID();
        ret = BaseUpdateBehavior::destroy(_id);
    }
    entity = NULL;
    return ret;
}
BaseUpdateBehavior *BaseUpdateBehavior::get(IDType _id)
{
    return UpdateBehaviorFactory::getInstance()->get(_id);
}


BaseUpdateBehavior::BaseUpdateBehavior():
AbstractBehavior<BaseEntity>(NULL)
{
    
}

BaseUpdateBehavior::BaseUpdateBehavior(const UpdateBehaviorInfo& constructionInfo) :
AbstractBehavior<BaseEntity>(NULL)
{
    
}

BaseUpdateBehavior::~BaseUpdateBehavior()
{
    if(getOwner())
        getOwner()->setUpdateBehavior(0);
}

void BaseUpdateBehavior::update(BaseEntity *owner, btCollisionWorld* collisionWorld, btScalar deltaTimeStep)
{
    setOwner(owner);
}