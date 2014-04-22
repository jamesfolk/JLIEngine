//
//  EntityStateMachine.h
//  GameAsteroids
//
//  Created by James Folk on 3/13/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__EntityStateMachine__
#define __GameAsteroids__EntityStateMachine__

#include "BaseEntity.h"

#include "AbstractStateMachine.h"
#include "AbstractFactory.h"

#include "EntityStateMachineFactoryIncludes.h"
#include "EntityStateMachineFactory.h"

class BaseEntity;

class EntityStateMachine :
public AbstractStateMachine<BaseEntity>,
public AbstractFactoryObject
{
    friend class EntityStateMachineFactory;
protected:
    EntityStateMachine(const EntityStateMachineInfo &constructionInfo);
    EntityStateMachine();
    virtual ~EntityStateMachine();
    
public:
    static EntityStateMachine *create(int type = 0);
    static bool destroy(IDType &_id);
    static bool destroy(EntityStateMachine *entity);
    static EntityStateMachine *get(IDType _id);
    
    //BT_DECLARE_ALIGNED_ALLOCATOR();
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
    
    
   
    
    SIMD_FORCE_INLINE const EntityStateMachineInfo &getStateMachineInfo()const
    {
        return m_StateMachineInfo;
    }
private:
    EntityStateMachineInfo m_StateMachineInfo;
    EntityStateMachine(const EntityStateMachine &rhs);
};

#endif /* defined(__GameAsteroids__StateMachine__) */
