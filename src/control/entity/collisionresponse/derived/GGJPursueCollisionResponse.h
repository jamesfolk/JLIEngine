//
//  GGJPursueCollisionResponse.h
//  MazeADay
//
//  Created by James Folk on 1/26/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#ifndef __MazeADay__GGJPursueCollisionResponse__
#define __MazeADay__GGJPursueCollisionResponse__

#include "BaseCollisionResponseBehavior.h"

struct GGJPursueCollisionResponseBehaviorInfo :
public CollisionResponseBehaviorInfo
{
    GGJPursueCollisionResponseBehaviorInfo() : CollisionResponseBehaviorInfo(CollisionResponseBehaviorTypes_GGJPursue){}
    virtual ~GGJPursueCollisionResponseBehaviorInfo(){}
};

class GGJPursueCollisionResponseBehavior :
public BaseCollisionResponseBehavior
{
public:
    friend class CollisionResponseBehaviorFactory;
    
    GGJPursueCollisionResponseBehavior(const GGJPursueCollisionResponseBehaviorInfo& constructionInfo);
    virtual ~GGJPursueCollisionResponseBehavior();
public:
    virtual void respond(BaseEntity *pOtherEntity, const btManifoldPoint &pt = btManifoldPoint());
    
    const BaseEntity *getOtherEntity()const;
private:
    BaseEntity *m_pOtherEntity;
    
};

#endif /* defined(__MazeADay__GGJPursueCollisionResponse__) */
