//
//  BaseParticleEmitterBehavior.h
//  GameAsteroids
//
//  Created by James Folk on 7/1/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__BaseParticleEmitterBehavior__
#define __GameAsteroids__BaseParticleEmitterBehavior__



#include "ParticleEmitterBehaviorFactoryIncludes.h"
#include "btActionInterface.h"
#include "AbstractFactory.h"
#include "AbstractBehavior.h"

//class BaseEntity;
#include "BaseEntity.h"
#include "ParticleEmitterBehaviorFactory.h"

class SteeringEntity;
class BaseEntityInfo;
class BaseViewObject;
class BaseCamera;


struct ParticleAttributeTransform
{
    ParticleAttributeTransform()
    {}
    ~ParticleAttributeTransform()
    {
    }
    
    btAlignedObjectArray<BaseEntity*> m_Particles;
    
    
    //called on render
    void operator() (int i, btVector3 &to, const btVector3 &from)const
    {
        to = m_Particles[i]->getOrigin();
    }
    
    void operator() (int i, btVector4 &to, const btVector4 &from)const
    {
        to = from;
        
        if(m_Particles[i]->isHidden())
            to.setW(0.0f);
        else
            to.setW(1.0f);
    }
};

class BaseParticleEmitterBehavior :
public btActionInterface,
public AbstractFactoryObject,
public AbstractBehavior<BaseEntity>
{
    friend class ParticleEmitterBehaviorFactory;
protected:
    BaseParticleEmitterBehavior(const ParticleEmitterBehaviorInfo& constructionInfo);
    virtual ~BaseParticleEmitterBehavior();
public:
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
    
    
    virtual void operator() (int i, const btVector3 &vertice);
    
    virtual void load();
    
    virtual void updateAction( btCollisionWorld* collisionWorld, btScalar deltaTimeStep);
    
    virtual void render(BaseCamera *pCamera = NULL);
    
	virtual void debugDraw(btIDebugDraw* debugDrawer);
    
    
    
//    void setParticlesPerFrame(const float amount);
//    float getParticlesPerFrame()const;
//    
//    void setParticlesPerFrameVariance(const float var);
//    float getParticlesPerFrameVariance()const;
    
protected:
    virtual void createParticleConstructionInfo();
    virtual void emitParticle();
    
    BaseEntityInfo *getParticleConstructionInfo()const;
    BaseEntity *getNewParticle();
    
    BaseViewObject *getParticleVBO()const;
private:
    btAlignedObjectArray<btVector3> m_EmitterVertices;
    
    ParticleAttributeTransform *m_ParticleAttributeTransform;
    int m_NewParticleIndex;
    
    IDType m_particleViewObjectID;
    unsigned int m_MaxNumberOfParticles;
    IDType m_shaderFactoryID;
    
    float m_ParticlesPerSecond;
    float m_CurrentTime;
    unsigned int m_frame;
    BaseEntityInfo *m_ParticleEntityConstructionInfo;
    float m_ParticleSize;
    
    void loadParticles();
};

#endif /* defined(__GameAsteroids__BaseParticleEmitterBehavior__) */
