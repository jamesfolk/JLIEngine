//
//  FinishLevelCollisionResponseBehavior.h
//  GameAsteroids
//
//  Created by James Folk on 7/16/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__FinishLevelCollisionResponseBehavior__
#define __GameAsteroids__FinishLevelCollisionResponseBehavior__

#include "BaseCollisionResponseBehavior.h"

struct FinishLevelResponseBehaviorInfo :
public CollisionResponseBehaviorInfo
{
    FinishLevelResponseBehaviorInfo() : CollisionResponseBehaviorInfo(CollisionResponseBehaviorTypes_FinishLevel){}
    virtual ~FinishLevelResponseBehaviorInfo(){}
};

class FinishLevelCollisionResponseBehavior :
public BaseCollisionResponseBehavior
{
public:
    friend class CollisionResponseBehaviorFactory;

    FinishLevelCollisionResponseBehavior(const FinishLevelResponseBehaviorInfo& constructionInfo);
    virtual ~FinishLevelCollisionResponseBehavior();
    
    virtual void respond(BaseEntity *pOtherEntity, const btManifoldPoint &pt = btManifoldPoint());

    virtual void reset();
private:
    bool m_responded;
};

#endif /* defined(__GameAsteroids__FinishLevelCollisionResponseBehavior__) */
