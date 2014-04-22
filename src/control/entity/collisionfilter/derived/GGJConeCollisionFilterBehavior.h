//
//  GGJConeCollisionFilterBehavior.h
//  MazeADay
//
//  Created by James Folk on 1/26/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#ifndef __MazeADay__GGJConeCollisionFilterBehavior__
#define __MazeADay__GGJConeCollisionFilterBehavior__

#include "BaseCollisionFilterBehavior.h"

struct GGJConeFilterBehaviorInfo :
public CollisionFilterBehaviorInfo
{
    GGJConeFilterBehaviorInfo() : CollisionFilterBehaviorInfo(CollisionFilterBehaviorTypes_GGJCone){}
    virtual ~GGJConeFilterBehaviorInfo(){}
};

class GGJConeCollisionFilterBehavior :
public BaseCollisionFilterBehavior
{
public:
    friend class CollisionFilterBehaviorFactory;
    
    GGJConeCollisionFilterBehavior(const GGJConeFilterBehaviorInfo& constructionInfo);
    virtual ~GGJConeCollisionFilterBehavior();
public:
    virtual bool shouldCollide(const BaseEntity *pOtherEntity)const;
    
    
};

#endif /* defined(__MazeADay__GGJConeCollisionFilterBehavior__) */
