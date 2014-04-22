//
//  BaseEntityState.h
//  GameAsteroids
//
//  Created by James Folk on 3/20/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__BaseEntityState__
#define __GameAsteroids__BaseEntityState__

#include "AbstractState.h"
#include "BaseEntity.h"
//#include "EntityStateFactory.h"

class BaseEntityState : public AbstractState<BaseEntity>//, public AbstractFactoryObject
{
    friend class EntityStateFactory;
protected:
    BaseEntityState();
    virtual ~BaseEntityState();
public:
    static BaseEntityState *create(int type = 0);
    static bool destroy(IDType &_id);
    static bool destroy(BaseEntityState *entity);
    static BaseEntityState *get(IDType _id);
    
    virtual void enter(BaseEntity*);
    
    virtual void update(BaseEntity*, btScalar deltaTimeStep);
    
    //this will execute when the state is exited.
    virtual void exit(BaseEntity*);
    
    //this executes if the agent receives a message from the
    //message dispatcher
    virtual bool onMessage(BaseEntity*, const Telegram&);
    
//    SIMD_FORCE_INLINE IDType getID()const
//    {
//        return AbstractFactoryObject::getID();
//    }
//    
//    SIMD_FORCE_INLINE const std::string &getName()const
//    {
//        return AbstractFactoryObject::getName();
//    }
//    
//    SIMD_FORCE_INLINE void setName(const std::string &name)
//    {
//        AbstractFactoryObject::setName(name);
//    }
    
};

#endif /* defined(__GameAsteroids__BaseEntityState__) */
