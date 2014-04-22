//
//  ParticleEmitterBehaviorFactory.cpp
//  GameAsteroids
//
//  Created by James Folk on 7/2/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "ParticleEmitterBehaviorFactory.h"
#include "BaseParticleEmitterBehavior.h"
#include "GLDebugDrawer.h"

void ParticleEmitterBehaviorFactory::render()
{
//    if(GLDebugDrawer::getInstance())
//        return;
    
    for(int i = 0; i < m_BaseParticleEmitterBehaviors.size(); i++)
        m_BaseParticleEmitterBehaviors[i]->render();
}

BaseParticleEmitterBehavior *ParticleEmitterBehaviorFactory::ctor(ParticleEmitterBehaviorInfo *constructionInfo)
{
    BaseParticleEmitterBehavior *pe = new BaseParticleEmitterBehavior(*constructionInfo);
    m_BaseParticleEmitterBehaviors.push_back(pe);
    return pe;
}
BaseParticleEmitterBehavior *ParticleEmitterBehaviorFactory::ctor(int type)
{
    return NULL;
}
void ParticleEmitterBehaviorFactory::dtor(BaseParticleEmitterBehavior *object)
{
    m_BaseParticleEmitterBehaviors.remove(object);
    delete object;
}