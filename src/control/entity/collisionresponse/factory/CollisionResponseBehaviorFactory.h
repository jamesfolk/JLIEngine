//
//  CollisionResponseBehaviorFactory.h
//  GameAsteroids
//
//  Created by James Folk on 7/16/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__CollisionResponseBehaviorFactory__
#define __GameAsteroids__CollisionResponseBehaviorFactory__

#include "AbstractFactory.h"
//#include "AbstractSingleton.h"
#include "CollisionResponseBehaviorFactoryIncludes.h"
#include "BaseCollisionResponseBehavior.h"
//class BaseCollisionResponseBehavior;

#include "BaseEntity.h"

class CollisionResponseBehaviorFactory;

class CollisionResponseBehaviorFactory :
public AbstractFactory<CollisionResponseBehaviorFactory, BaseCollisionResponseBehaviorInfo, BaseCollisionResponseBehavior>
{
    friend class AbstractSingleton;
    
    CollisionResponseBehaviorFactory(){}//:m_CurrentCollisionEntity(NULL){}
    virtual ~CollisionResponseBehaviorFactory(){}//{m_CurrentCollisionEntity = NULL;}
//public:
//    
//    void	setCurrentLuaEntity(BaseEntity* entity);
//    const BaseEntity*	getCurrentLuaEntity() const;
    
protected:
    virtual BaseCollisionResponseBehavior *ctor(BaseCollisionResponseBehaviorInfo *constructionInfo);
    virtual BaseCollisionResponseBehavior *ctor(int type = 0);
    virtual void dtor(BaseCollisionResponseBehavior *object);
    
    //BaseEntity *m_CurrentCollisionEntity;
    
};

#endif /* defined(__GameAsteroids__CollisionResponseBehaviorFactory__) */
