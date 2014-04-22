//
//  GGJPlayerCollisionFilterBehavior.h
//  MazeADay
//
//  Created by James Folk on 1/26/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#ifndef __MazeADay__GGJPlayerCollisionFilterBehavior__
#define __MazeADay__GGJPlayerCollisionFilterBehavior__

#include "BaseCollisionFilterBehavior.h"

struct GGJPlayerFilterBehaviorInfo :
public CollisionFilterBehaviorInfo
{
    GGJPlayerFilterBehaviorInfo() : CollisionFilterBehaviorInfo(CollisionFilterBehaviorTypes_GGJPlayer){}
    virtual ~GGJPlayerFilterBehaviorInfo(){}
};

class GGJPlayerCollisionFilterBehavior :
public BaseCollisionFilterBehavior
{
public:
    friend class CollisionFilterBehaviorFactory;
    
    GGJPlayerCollisionFilterBehavior(const GGJPlayerFilterBehaviorInfo& constructionInfo);
    virtual ~GGJPlayerCollisionFilterBehavior();
public:
    virtual bool shouldCollide(const BaseEntity *pOtherEntity)const;
    
    
};

#endif /* defined(__MazeADay__GGJPlayerCollisionFilterBehavior__) */
