//
//  GGJPlayerCollisionFilterBehavior.cpp
//  MazeADay
//
//  Created by James Folk on 1/26/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#include "GGJPlayerCollisionFilterBehavior.h"
#include "BaseEntity.h"

GGJPlayerCollisionFilterBehavior::GGJPlayerCollisionFilterBehavior(const GGJPlayerFilterBehaviorInfo& constructionInfo) :
BaseCollisionFilterBehavior(constructionInfo)
{
    
}

GGJPlayerCollisionFilterBehavior::~GGJPlayerCollisionFilterBehavior()
{
    
}

bool GGJPlayerCollisionFilterBehavior::shouldCollide(const BaseEntity *pOtherEntity)const
{
    if(BaseCollisionFilterBehavior::shouldCollide(pOtherEntity))
    {
        CollisionFilterBehaviorTypes otherType = getOtherType(pOtherEntity);
        
        switch (otherType)
        {
            case CollisionFilterBehaviorTypes_GGJObject:
                return true;
        }
    }
    
    return false;
}