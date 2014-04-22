//
//  PlayerUpdateBehavior.h
//  GameAsteroids
//
//  Created by library on 8/5/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__PlayerUpdateBehavior__
#define __GameAsteroids__PlayerUpdateBehavior__

#include "BaseUpdateBehavior.h"

struct PlayerUpdateBehaviorInfo :
public UpdateBehaviorInfo
{
    PlayerUpdateBehaviorInfo() : UpdateBehaviorInfo(UpdateBehaviorTypes_Player){}
    virtual ~PlayerUpdateBehaviorInfo(){}
};

class PlayerUpdateBehavior  :
public BaseUpdateBehavior
{
public:
    
    PlayerUpdateBehavior(const PlayerUpdateBehaviorInfo& constructionInfo);
    virtual ~PlayerUpdateBehavior();
    
    virtual void update(btCollisionWorld* collisionWorld, btScalar deltaTimeStep);
};

#endif /* defined(__GameAsteroids__PlayerUpdateBehavior__) */
