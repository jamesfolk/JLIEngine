//
//  MazePickupCollisionResponseBehavior.cpp
//  GameAsteroids
//
//  Created by James Folk on 7/19/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "MazePickupCollisionResponseBehavior.h"

#include "btManifoldPoint.h"
#include "BaseEntity.h"

MazePickupCollisionResponseBehavior::MazePickupCollisionResponseBehavior(const MazePickupResponseBehaviorInfo& constructionInfo) :
BaseCollisionResponseBehavior(constructionInfo)
{
    
}

MazePickupCollisionResponseBehavior::~MazePickupCollisionResponseBehavior()
{
    
}

void MazePickupCollisionResponseBehavior::respond(BaseEntity *pOtherEntity, const btManifoldPoint &pt)
{
    if(pOtherEntity)
        getOwner()->hide();
}