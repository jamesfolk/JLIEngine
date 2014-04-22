//
//  GGJDyingCollisionResponse.h
//  MazeADay
//
//  Created by James Folk on 1/26/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#ifndef __MazeADay__GGJDyingCollisionResponse__
#define __MazeADay__GGJDyingCollisionResponse__

#include "BaseCollisionResponseBehavior.h"

struct GGJDyingCollisionResponseBehaviorInfo :
public CollisionResponseBehaviorInfo
{
    GGJDyingCollisionResponseBehaviorInfo() : CollisionResponseBehaviorInfo(CollisionResponseBehaviorTypes_GGJDying){}
    virtual ~GGJDyingCollisionResponseBehaviorInfo(){}
};

class GGJDyingCollisionResponseBehavior :
public BaseCollisionResponseBehavior
{
public:
    friend class CollisionResponseBehaviorFactory;
    
    GGJDyingCollisionResponseBehavior(const GGJDyingCollisionResponseBehaviorInfo& constructionInfo);
    virtual ~GGJDyingCollisionResponseBehavior();
public:
    virtual void respond(BaseEntity *pOtherEntity, const btManifoldPoint &pt = btManifoldPoint());
    
    const BaseEntity *getOtherEntity()const;
private:
    BaseEntity *m_pOtherEntity;
    
};

#endif /* defined(__MazeADay__GGJDyingCollisionResponse__) */
