//
//  BaseCollisionResponseBehavior.h
//  GameAsteroids
//
//  Created by James Folk on 7/16/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__BaseCollisionResponseBehavior__
#define __GameAsteroids__BaseCollisionResponseBehavior__

//#include "AbstractLuaFactoryObject.h"
#include "AbstractFactory.h"
#include "AbstractBehavior.h"
#include "BaseEntity.h"

#include "CollisionResponseBehaviorFactoryIncludes.h"
//#include "CollisionFilterBehaviorFactoryIncludes.h"

//#include "btManifoldPoint.h"


//#include <string>


#include "CollisionResponseBehaviorFactory.h"

/*
-make the constructors and destructors private for the factory objects.
 -implement getID functions for AbstractFactoryObjects
 -on the destruction of the base AbstractBehavior remember to set the id to zero on the owner
 
 */

class btManifoldPoint;
class BaseCollisionResponseBehavior;
class CollisionResponseBehaviorFactory;

class BaseCollisionResponseBehavior :
//
public AbstractFactoryObject,
//public AbstractLuaFactoryObject<BaseCollisionResponseBehavior, CollisionResponseBehaviorFactory>,
public AbstractBehavior<BaseEntity>
{

    friend class CollisionResponseBehaviorFactory;
public:
    static BaseCollisionResponseBehavior *create(int type = 0);
    static bool destroy(IDType &_id);
    static bool destroy(BaseCollisionResponseBehavior *entity);
    static BaseCollisionResponseBehavior *get(IDType _id);
    
    SIMD_FORCE_INLINE IDType getID()const
    {
        return AbstractFactoryObject::getID();
    }
    
    SIMD_FORCE_INLINE const std::string &getName()const
    {
        return AbstractFactoryObject::getName();
    }
    
    SIMD_FORCE_INLINE void setName(const std::string &name)
    {
        AbstractFactoryObject::setName(name);
    }
    
protected:
    BaseCollisionResponseBehavior();
    
    BaseCollisionResponseBehavior(const BaseCollisionResponseBehaviorInfo& constructionInfo);
    virtual ~BaseCollisionResponseBehavior();
public:
    //CollisionFilterBehaviorTypes getOtherType(const BaseEntity *pOtherEntity)const;
    
    //virtual void respond(BaseEntity *pOtherEntity, const btManifoldPoint &pt);
    virtual void respond(BaseEntity *owner, BaseEntity *pOtherEntity, const btManifoldPoint &pt);
    
    void reset();
    
    bool responded()const;
    
    CollisionResponseBehaviorTypes getType()const{return m_type;}
protected:
    bool m_responded;
    CollisionResponseBehaviorTypes m_type;
    
    
    

};

#endif /* defined(__GameAsteroids__BaseCollisionResponseBehavior__) */
