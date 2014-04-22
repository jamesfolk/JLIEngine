//
//  FinishLevelCollisionFilterBehavior.cpp
//  GameAsteroids
//
//  Created by James Folk on 7/19/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "FinishLevelCollisionFilterBehavior.h"
#include "BaseEntity.h"

FinishLevelCollisionFilterBehavior::FinishLevelCollisionFilterBehavior(const FinishLevelFilterBehaviorInfo& constructionInfo) :
BaseCollisionFilterBehavior(constructionInfo)
{
    
}

FinishLevelCollisionFilterBehavior::~FinishLevelCollisionFilterBehavior()
{
    
}

bool FinishLevelCollisionFilterBehavior::shouldCollide(const BaseEntity *pOtherEntity)const
{
    if(BaseCollisionFilterBehavior::shouldCollide(pOtherEntity))
    {
        CollisionFilterBehaviorTypes otherType = getOtherType(pOtherEntity);
        
        switch (otherType)
        {
            case CollisionFilterBehaviorTypes_MazePickup:
                return false;
        }
        
        return true;
    }
    
    return false;
}
