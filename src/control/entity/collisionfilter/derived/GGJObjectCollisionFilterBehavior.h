//
//  ObjectCollisionFilterBehavior.h
//  MazeADay
//
//  Created by James Folk on 1/26/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#ifndef __MazeADay__GGJObjectCollisionFilterBehavior__
#define __MazeADay__GGJObjectCollisionFilterBehavior__

#include "BaseCollisionFilterBehavior.h"

struct GGJObjectFilterBehaviorInfo :
public CollisionFilterBehaviorInfo
{
    GGJObjectFilterBehaviorInfo() : CollisionFilterBehaviorInfo(CollisionFilterBehaviorTypes_GGJObject){}
    virtual ~GGJObjectFilterBehaviorInfo(){}
};

class GGJObjectCollisionFilterBehavior :
public BaseCollisionFilterBehavior
{
public:
    friend class CollisionFilterBehaviorFactory;
    
    GGJObjectCollisionFilterBehavior(const GGJObjectFilterBehaviorInfo& constructionInfo);
    virtual ~GGJObjectCollisionFilterBehavior();
public:
    virtual bool shouldCollide(const BaseEntity *pOtherEntity)const;
    
    
};

#endif /* defined(__MazeADay__GGJObjectCollisionFilterBehavior__) */
