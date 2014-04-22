//
//  GGJEvadeCollisionResponse.h
//  MazeADay
//
//  Created by James Folk on 1/26/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#ifndef __MazeADay__GGJEvadeCollisionResponse__
#define __MazeADay__GGJEvadeCollisionResponse__

#include "BaseCollisionResponseBehavior.h"

struct GGJEvadeCollisionResponseBehaviorInfo :
public CollisionResponseBehaviorInfo
{
    GGJEvadeCollisionResponseBehaviorInfo() : CollisionResponseBehaviorInfo(CollisionResponseBehaviorTypes_GGJEvade){}
    virtual ~GGJEvadeCollisionResponseBehaviorInfo(){}
};

class GGJEvadeCollisionResponseBehavior :
public BaseCollisionResponseBehavior
{
public:
    friend class CollisionResponseBehaviorFactory;
    
    GGJEvadeCollisionResponseBehavior(const GGJEvadeCollisionResponseBehaviorInfo& constructionInfo);
    virtual ~GGJEvadeCollisionResponseBehavior();
public:
    virtual void respond(BaseEntity *pOtherEntity, const btManifoldPoint &pt = btManifoldPoint());
    
    const BaseEntity *getOtherEntity()const;
private:
    BaseEntity *m_pOtherEntity;
    
};

#endif /* defined(__MazeADay__GGJEvadeCollisionResponse__) */
