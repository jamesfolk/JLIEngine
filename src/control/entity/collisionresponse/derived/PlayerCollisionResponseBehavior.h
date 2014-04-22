//
//  PlayerCollisionResponseBehavior.h
//  GameAsteroids
//
//  Created by James Folk on 8/1/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__PlayerCollisionResponseBehavior__
#define __GameAsteroids__PlayerCollisionResponseBehavior__

#include "BaseCollisionResponseBehavior.h"

struct PlayerCollisionResponseBehaviorInfo :
public CollisionResponseBehaviorInfo
{
    PlayerCollisionResponseBehaviorInfo() : CollisionResponseBehaviorInfo(CollisionResponseBehaviorTypes_Player){}
    virtual ~PlayerCollisionResponseBehaviorInfo(){}
};

class PlayerCollisionResponseBehavior :
public BaseCollisionResponseBehavior
{
public:
    friend class CollisionResponseBehaviorFactory;
    
    PlayerCollisionResponseBehavior(const PlayerCollisionResponseBehaviorInfo& constructionInfo);
    virtual ~PlayerCollisionResponseBehavior();
public:
    virtual void respond(BaseEntity *pOtherEntity, const btManifoldPoint &pt = btManifoldPoint());
    
    const BaseEntity *getOtherEntity()const;
private:
    BaseEntity *m_pOtherEntity;
    
};

#endif /* defined(__GameAsteroids__PlayerCollisionResponseBehavior__) */
