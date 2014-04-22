//
//  FinishLevelCollisionFilterBehavior.h
//  GameAsteroids
//
//  Created by James Folk on 7/19/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__FinishLevelCollisionFilterBehavior__
#define __GameAsteroids__FinishLevelCollisionFilterBehavior__

#include "BaseCollisionFilterBehavior.h"

struct FinishLevelFilterBehaviorInfo :
public CollisionFilterBehaviorInfo
{
    FinishLevelFilterBehaviorInfo() : CollisionFilterBehaviorInfo(CollisionFilterBehaviorTypes_FinishLevel){}
    virtual ~FinishLevelFilterBehaviorInfo(){}
};

class FinishLevelCollisionFilterBehavior :
public BaseCollisionFilterBehavior
{
public:
    friend class CollisionFilterBehaviorFactory;
    
    FinishLevelCollisionFilterBehavior(const FinishLevelFilterBehaviorInfo& constructionInfo);
    virtual ~FinishLevelCollisionFilterBehavior();
public:
    virtual bool shouldCollide(const BaseEntity *pOtherEntity)const;
    
    
};

#endif /* defined(__GameAsteroids__FinishLevelCollisionFilterBehavior__) */
