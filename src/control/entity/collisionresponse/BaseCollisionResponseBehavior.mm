//
//  BaseCollisionResponseBehavior.cpp
//  GameAsteroids
//
//  Created by James Folk on 7/16/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "BaseCollisionResponseBehavior.h"
//#include "BaseEntity.h"
//#include "CollisionResponseBehaviorFactory.h"
#include "BulletCollision/NarrowPhaseCollision/btManifoldPoint.h"
//#include "BaseCollisionFilterBehavior.h"

BaseCollisionResponseBehavior *BaseCollisionResponseBehavior::create(int type)
{
    return CollisionResponseBehaviorFactory::getInstance()->createObject(type);
}

bool BaseCollisionResponseBehavior::destroy(IDType &_id)
{
    return CollisionResponseBehaviorFactory::getInstance()->destroy(_id);
}

bool BaseCollisionResponseBehavior::destroy(BaseCollisionResponseBehavior *entity)
{
    bool ret = false;
    if(entity)
    {
        IDType _id = entity->getID();
        ret = BaseCollisionResponseBehavior::destroy(_id);
    }
    entity = NULL;
    return ret;
}
BaseCollisionResponseBehavior *BaseCollisionResponseBehavior::get(IDType _id)
{
    return CollisionResponseBehaviorFactory::getInstance()->get(_id);
}

BaseCollisionResponseBehavior::BaseCollisionResponseBehavior() :
AbstractBehavior<BaseEntity>(NULL),
m_responded(false),
m_type(CollisionResponseBehaviorTypes_Base)
{
    
}

BaseCollisionResponseBehavior::BaseCollisionResponseBehavior(const BaseCollisionResponseBehaviorInfo& constructionInfo) :
AbstractBehavior<BaseEntity>(NULL),
m_responded(false),
m_type(CollisionResponseBehaviorTypes_Base)
{
    
}

BaseCollisionResponseBehavior::~BaseCollisionResponseBehavior()
{
    if(getOwner())
        getOwner()->setCollisionResponseBehavior(0);
}

void BaseCollisionResponseBehavior::respond(BaseEntity *owner, BaseEntity *pOtherEntity, const btManifoldPoint &pt)
{
    setOwner(owner);
    
    m_responded = true;

}

bool BaseCollisionResponseBehavior::responded()const
{
    return m_responded;
}
void BaseCollisionResponseBehavior::reset()
{
    m_responded = false;
}

