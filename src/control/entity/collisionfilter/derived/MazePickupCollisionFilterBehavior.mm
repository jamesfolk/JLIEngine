//
//  MazePickupCollisionFilterBehavior.cpp
//  GameAsteroids
//
//  Created by James Folk on 7/19/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "MazePickupCollisionFilterBehavior.h"
#include "BaseEntity.h"

MazePickupCollisionFilterBehavior::MazePickupCollisionFilterBehavior(const MazePickupFilterBehaviorInfo& constructionInfo) :
BaseCollisionFilterBehavior(constructionInfo)
{
    
}

MazePickupCollisionFilterBehavior::~MazePickupCollisionFilterBehavior()
{
    
}

bool MazePickupCollisionFilterBehavior::shouldCollide(const BaseEntity *pOtherEntity)const
{
    if(BaseCollisionFilterBehavior::shouldCollide(pOtherEntity))
    {
        CollisionFilterBehaviorTypes otherType = getOtherType(pOtherEntity);
        
        switch (otherType)
        {
            case CollisionFilterBehaviorTypes_Player:
                return true;
        }
    }
    
    return false;
}