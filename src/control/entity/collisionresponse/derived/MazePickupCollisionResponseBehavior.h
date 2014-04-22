//
//  MazePickupCollisionResponseBehavior.h
//  GameAsteroids
//
//  Created by James Folk on 7/19/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__MazePickupCollisionResponseBehavior__
#define __GameAsteroids__MazePickupCollisionResponseBehavior__

#include "BaseCollisionResponseBehavior.h"

struct MazePickupResponseBehaviorInfo :
public CollisionResponseBehaviorInfo
{
    MazePickupResponseBehaviorInfo() : CollisionResponseBehaviorInfo(CollisionResponseBehaviorTypes_MazePickup){}
    virtual ~MazePickupResponseBehaviorInfo(){}
};

class MazePickupCollisionResponseBehavior :
public BaseCollisionResponseBehavior
{
public:
    friend class CollisionResponseBehaviorFactory;
    
    MazePickupCollisionResponseBehavior(const MazePickupResponseBehaviorInfo& constructionInfo);
    virtual ~MazePickupCollisionResponseBehavior();
public:
    virtual void respond(BaseEntity *pOtherEntity, const btManifoldPoint &pt = btManifoldPoint());
    
    
};

#endif /* defined(__GameAsteroids__MazePickupCollisionResponseBehavior__) */
