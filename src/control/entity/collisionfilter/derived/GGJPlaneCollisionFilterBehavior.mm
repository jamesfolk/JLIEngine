//
//  File.cpp
//  MazeADay
//
//  Created by James Folk on 1/26/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#include "GGJPlaneCollisionFilterBehavior.h"
#include "BaseEntity.h"

GGJPlaneCollisionFilterBehavior::GGJPlaneCollisionFilterBehavior(const GGJPlaneFilterBehaviorInfo& constructionInfo) :
BaseCollisionFilterBehavior(constructionInfo)
{
    
}

GGJPlaneCollisionFilterBehavior::~GGJPlaneCollisionFilterBehavior()
{
    
}

bool GGJPlaneCollisionFilterBehavior::shouldCollide(const BaseEntity *pOtherEntity)const
{
    if(BaseCollisionFilterBehavior::shouldCollide(pOtherEntity))
    {
        return true;
    }
    
    return false;
}