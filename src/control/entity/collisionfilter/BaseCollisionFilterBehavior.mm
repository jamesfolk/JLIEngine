//
//  BaseCollisionFilterBehavior.cpp
//  GameAsteroids
//
//  Created by James Folk on 7/19/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "BaseCollisionFilterBehavior.h"
#include "BaseEntity.h"

BaseCollisionFilterBehavior::BaseCollisionFilterBehavior(const CollisionFilterBehaviorInfo& constructionInfo) :
AbstractBehavior<BaseEntity>(NULL),
m_collideType(constructionInfo.m_Type)
{
    
}

BaseCollisionFilterBehavior::~BaseCollisionFilterBehavior()
{
    
}

bool BaseCollisionFilterBehavior::shouldCollide(const BaseEntity *pOtherEntity)const
{
    return getOwner()->isCollisionEnabled() && pOtherEntity->isCollisionEnabled();
}

CollisionFilterBehaviorTypes BaseCollisionFilterBehavior::getCollideType()const
{
    return m_collideType;
}

CollisionFilterBehaviorTypes BaseCollisionFilterBehavior::getOtherType(const BaseEntity *pOtherEntity)const
{
    CollisionFilterBehaviorTypes otherType = CollisionFilterBehaviorTypes_NONE;
    
    if(pOtherEntity->getCollisionFilterBehavior())
        otherType = pOtherEntity->getCollisionFilterBehavior()->getCollideType();
    
    return otherType;
}
