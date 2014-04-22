//
//  GGJConeCollisionFilterBehavior.cpp
//  MazeADay
//
//  Created by James Folk on 1/26/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#include "GGJConeCollisionFilterBehavior.h"
#include "BaseEntity.h"

GGJConeCollisionFilterBehavior::GGJConeCollisionFilterBehavior(const GGJConeFilterBehaviorInfo& constructionInfo) :
BaseCollisionFilterBehavior(constructionInfo)
{
    
}

GGJConeCollisionFilterBehavior::~GGJConeCollisionFilterBehavior()
{
    
}

bool GGJConeCollisionFilterBehavior::shouldCollide(const BaseEntity *pOtherEntity)const
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