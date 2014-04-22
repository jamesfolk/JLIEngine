//
//  ObjectCollisionFilterBehavior.cpp
//  MazeADay
//
//  Created by James Folk on 1/26/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#include "GGJObjectCollisionFilterBehavior.h"
#include "BaseEntity.h"

GGJObjectCollisionFilterBehavior::GGJObjectCollisionFilterBehavior(const GGJObjectFilterBehaviorInfo& constructionInfo) :
BaseCollisionFilterBehavior(constructionInfo)
{
    
}

GGJObjectCollisionFilterBehavior::~GGJObjectCollisionFilterBehavior()
{
    
}

bool GGJObjectCollisionFilterBehavior::shouldCollide(const BaseEntity *pOtherEntity)const
{
    if(BaseCollisionFilterBehavior::shouldCollide(pOtherEntity))
    {
        CollisionFilterBehaviorTypes otherType = getOtherType(pOtherEntity);
        
        switch (otherType)
        {
            case CollisionFilterBehaviorTypes_GGJPlayer:
                return true;
        }
    }
    
    return false;
}