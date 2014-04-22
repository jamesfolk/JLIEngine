//
//  PlayerCollisionFilterBehavior.cpp
//  GameAsteroids
//
//  Created by James Folk on 7/19/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "PlayerCollisionFilterBehavior.h"

PlayerCollisionFilterBehavior::PlayerCollisionFilterBehavior(const PlayerFilterBehaviorInfo& constructionInfo) :
BaseCollisionFilterBehavior(constructionInfo)
{
    
}

PlayerCollisionFilterBehavior::~PlayerCollisionFilterBehavior()
{
    
}

bool PlayerCollisionFilterBehavior::shouldCollide(const BaseEntity *pOtherEntity)const
{
    if(BaseCollisionFilterBehavior::shouldCollide(pOtherEntity))
    {
        CollisionFilterBehaviorTypes otherType = getOtherType(pOtherEntity);
        
        //Player collides with everything...
        
        return true;
    }
    
    return false;
}