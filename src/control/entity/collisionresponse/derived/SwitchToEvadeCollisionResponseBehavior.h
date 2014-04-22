//
//  SwitchToEvadeCollisionResponseBehavior.h
//  MazeADay
//
//  Created by James Folk on 1/25/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#ifndef __MazeADay__SwitchToEvadeCollisionResponseBehavior__
#define __MazeADay__SwitchToEvadeCollisionResponseBehavior__

#include "BaseCollisionResponseBehavior.h"

struct SwitchToEvadeCollisionResponseBehaviorInfo :
public CollisionResponseBehaviorInfo
{
    SwitchToEvadeCollisionResponseBehaviorInfo() : CollisionResponseBehaviorInfo(CollisionResponseBehaviorTypes_SwitchToEvade){}
    virtual ~SwitchToEvadeCollisionResponseBehaviorInfo(){}
};

class SwitchToEvadeCollisionResponseBehavior :
public BaseCollisionResponseBehavior
{
public:
    friend class CollisionResponseBehaviorFactory;
    
    SwitchToEvadeCollisionResponseBehavior(const SwitchToEvadeCollisionResponseBehaviorInfo& constructionInfo);
    virtual ~SwitchToEvadeCollisionResponseBehavior();
public:
    virtual void respond(BaseEntity *pOtherEntity, const btManifoldPoint &pt = btManifoldPoint());
    
    const BaseEntity *getOtherEntity()const;
private:
    BaseEntity *m_pOtherEntity;
    
};

#endif /* defined(__MazeADay__SwitchToEvadeCollisionResponseBehavior__) */
