//
//  BaseEntityAnimationController.h
//  GameAsteroids
//
//  Created by James Folk on 3/11/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__BaseEntityAnimationController__
#define __GameAsteroids__BaseEntityAnimationController__

#include "AnimationControllerFactoryIncludes.h"

#include "btScalar.h"

#include "AbstractFactory.h"
#include "AbstractBehavior.h"
#include "AnimationControllerFactory.h"

class BaseEntity;

class BaseEntityAnimationController :
public AbstractFactoryObject,
public AbstractBehavior<BaseEntity>
{
    friend class AnimationControllerFactory;
protected:
    BaseEntityAnimationController(const AnimationControllerInfo &constructionInfo);
    virtual ~BaseEntityAnimationController();
public:
    virtual void update(btScalar deltaTimeStep) = 0;
    
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
    
    
    const AnimationControllerInfo &getAnimationControllerInfo()const;
private:
    AnimationControllerInfo m_AnimationControllerInfo;
};



#endif /* defined(__GameAsteroids__BaseEntityAnimationController__) */
