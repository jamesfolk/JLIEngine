//
//  ParticleEmitterBehaviorFactoryIncludes.h
//  GameAsteroids
//
//  Created by James Folk on 7/1/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef GameAsteroids_ParticleEmitterBehaviorFactoryIncludes_h
#define GameAsteroids_ParticleEmitterBehaviorFactoryIncludes_h

#include "AbstractFactoryIncludes.h"

struct ParticleEmitterBehaviorInfo
{
    IDType m_shaderFactoryID;
    unsigned int m_MaxNumberOfParticles;
    float m_ParticlesPerSecond;
    float m_ParticleSize;
    
    ParticleEmitterBehaviorInfo(IDType shaderFactoryID,
                                unsigned int maxParticles = 10,
                                float particlesPerSecond = 60.0f,
                                float particleSize = 32.0f) :
    m_shaderFactoryID(shaderFactoryID),
    m_MaxNumberOfParticles(maxParticles),
    m_ParticlesPerSecond(particlesPerSecond),
    m_ParticleSize(particleSize)
    {
    }
};

#endif
