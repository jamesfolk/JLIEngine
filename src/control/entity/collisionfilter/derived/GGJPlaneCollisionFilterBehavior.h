//
//  File.h
//  MazeADay
//
//  Created by James Folk on 1/26/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#ifndef __MazeADay__GGJPlaneCollisionFilterBehavior__
#define __MazeADay__GGJPlaneCollisionFilterBehavior__

#include "BaseCollisionFilterBehavior.h"

struct GGJPlaneFilterBehaviorInfo :
public CollisionFilterBehaviorInfo
{
    GGJPlaneFilterBehaviorInfo() : CollisionFilterBehaviorInfo(CollisionFilterBehaviorTypes_GGJPlane){}
    virtual ~GGJPlaneFilterBehaviorInfo(){}
};

class GGJPlaneCollisionFilterBehavior :
public BaseCollisionFilterBehavior
{
public:
    friend class CollisionFilterBehaviorFactory;
    
    GGJPlaneCollisionFilterBehavior(const GGJPlaneFilterBehaviorInfo& constructionInfo);
    virtual ~GGJPlaneCollisionFilterBehavior();
public:
    virtual bool shouldCollide(const BaseEntity *pOtherEntity)const;
    
    
};

#endif /* defined(__MazeADay__File__) */
