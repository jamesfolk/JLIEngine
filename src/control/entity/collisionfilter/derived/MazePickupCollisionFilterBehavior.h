//
//  MazePickupCollisionFilterBehavior.h
//  GameAsteroids
//
//  Created by James Folk on 7/19/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__MazePickupCollisionFilterBehavior__
#define __GameAsteroids__MazePickupCollisionFilterBehavior__

#include "BaseCollisionFilterBehavior.h"

struct MazePickupFilterBehaviorInfo :
public CollisionFilterBehaviorInfo
{
    MazePickupFilterBehaviorInfo() : CollisionFilterBehaviorInfo(CollisionFilterBehaviorTypes_MazePickup){}
    virtual ~MazePickupFilterBehaviorInfo(){}
};

class MazePickupCollisionFilterBehavior :
public BaseCollisionFilterBehavior
{
public:
    friend class CollisionFilterBehaviorFactory;
    
    MazePickupCollisionFilterBehavior(const MazePickupFilterBehaviorInfo& constructionInfo);
    virtual ~MazePickupCollisionFilterBehavior();
public:
    virtual bool shouldCollide(const BaseEntity *pOtherEntity)const;
    
    
};

#endif /* defined(__GameAsteroids__MazePickupCollisionFilterBehavior__) */
