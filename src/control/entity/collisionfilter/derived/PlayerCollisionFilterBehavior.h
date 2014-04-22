//
//  PlayerCollisionFilterBehavior.h
//  GameAsteroids
//
//  Created by James Folk on 7/19/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__PlayerCollisionFilterBehavior__
#define __GameAsteroids__PlayerCollisionFilterBehavior__

#include "BaseCollisionFilterBehavior.h"

struct PlayerFilterBehaviorInfo :
public CollisionFilterBehaviorInfo
{
    PlayerFilterBehaviorInfo() : CollisionFilterBehaviorInfo(CollisionFilterBehaviorTypes_Player){}
    virtual ~PlayerFilterBehaviorInfo(){}
};

class PlayerCollisionFilterBehavior :
public BaseCollisionFilterBehavior
{
public:
    friend class CollisionFilterBehaviorFactory;
    
    PlayerCollisionFilterBehavior(const PlayerFilterBehaviorInfo& constructionInfo);
    virtual ~PlayerCollisionFilterBehavior();
public:
    virtual bool shouldCollide(const BaseEntity *pOtherEntity)const;
    
    
};

#endif /* defined(__GameAsteroids__PlayerCollisionFilterBehavior__) */
