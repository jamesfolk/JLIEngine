//
//  ParticleEmitterBehaviorFactory.h
//  GameAsteroids
//
//  Created by James Folk on 7/2/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__ParticleEmitterBehaviorFactory__
#define __GameAsteroids__ParticleEmitterBehaviorFactory__

#include "AbstractFactory.h"
#include "ParticleEmitterBehaviorFactoryIncludes.h"
#include "BaseParticleEmitterBehavior.h"

class ParticleEmitterBehaviorFactory;

class ParticleEmitterBehaviorFactory :
public AbstractFactory<ParticleEmitterBehaviorFactory, ParticleEmitterBehaviorInfo, BaseParticleEmitterBehavior>
{
    friend class AbstractSingleton;
    
    ParticleEmitterBehaviorFactory(){}
    virtual ~ParticleEmitterBehaviorFactory(){}
    
public:
    void render();
    
protected:
    virtual BaseParticleEmitterBehavior *ctor(ParticleEmitterBehaviorInfo *constructionInfo);
    virtual BaseParticleEmitterBehavior *ctor(int type = 0);
    virtual void dtor(BaseParticleEmitterBehavior *object);
    
    btAlignedObjectArray<BaseParticleEmitterBehavior*> m_BaseParticleEmitterBehaviors;
};

#endif /* defined(__GameAsteroids__ParticleEmitterBehaviorFactory__) */
