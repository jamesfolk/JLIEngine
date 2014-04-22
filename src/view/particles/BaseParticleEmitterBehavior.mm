//
//  BaseParticleEmitterBehavior.mm
//  GameAsteroids
//
//  Created by James Folk on 7/1/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "BaseParticleEmitterBehavior.h"
#include "BaseEntity.h"
#include "RigidEntity.h"
#include "BaseViewObject.h"
#include "UtilityFunctions.h"
#include "btTransform.h"
#include "VertexAttributeLoader.h"
#include "ViewObjectFactory.h"
#include "EntityFactory.h"
#include "CameraFactory.h"
#include "BaseCamera.h"

void BaseParticleEmitterBehavior::operator() (int i, const btVector3 &vertice)
{
    m_EmitterVertices[i] = vertice;
}

void BaseParticleEmitterBehavior::load()
{
//    btAssert(getOwner()->getVertexBufferObject()->isLoaded());
//    
//    m_EmitterVertices.resize(getOwner()->getVertexBufferObject()->getNumVertices());
    
    size_t offset_position = reinterpret_cast<size_t>(getOwner()->getVertexBufferObject()->getPositionOffset());
    
    getOwner()->getVertexBufferObject()->get_each_attribute<BaseParticleEmitterBehavior, btVector3>(*this, offset_position);
    
    loadParticles();
}

void BaseParticleEmitterBehavior::updateAction( btCollisionWorld* collisionWorld, btScalar deltaTimeStep)
{
    m_CurrentTime += deltaTimeStep;
    
    double time = (m_ParticlesPerSecond / (double)((FrameCounter::getInstance()->getPreferredFramesPerSecond() * 60.0f)));
    
    if(m_CurrentTime >= time)
    {
        emitParticle();
        m_CurrentTime -= time;
    }
}

void BaseParticleEmitterBehavior::render(BaseCamera *pCamera)
{
    BaseViewObject *pVBO = getParticleVBO();
    
    if(NULL != pVBO)
    {
        pVBO->setGLSLPointSize(m_ParticleSize);
        pVBO->enableGLSLPointCoord();
        
        size_t offset_position = reinterpret_cast<size_t>(pVBO->getPositionOffset());
        size_t offset_color = reinterpret_cast<size_t>(pVBO->getColorOffset());
        
        pVBO->set_each_attribute<ParticleAttributeTransform, btVector3>(*m_ParticleAttributeTransform,
                                                                                    offset_position);
        
        
        pVBO->set_each_attribute<ParticleAttributeTransform, btVector4>(*m_ParticleAttributeTransform,
                                                                                    offset_color);
        
        if(pCamera == NULL)
            pCamera = CameraFactory::getInstance()->getCurrentCamera();
        
        pVBO->setGLSLUniforms(pCamera->getWorldTransform().inverse(), pCamera->getProjection2(), btTransform::getIdentity());
        
////        GLKMatrix4 cameraLocationMatrix = getGLKMatrix4(pCamera->getWorldTransform().inverse());
//        btTransform cameraLocationMatrix(pCamera->getWorldTransform().inverse());
//        
////        GLKMatrix4 _modelViewMatrix = cameraLocationMatrix;
//        btTransform modelViewMatrix(cameraLocationMatrix);
//        
////        GLKMatrix4 _projectionMatrix = pCamera->getProjection();
//        btTransform projectionMatrix(pCamera->getProjection2());
//        
////        GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(_modelViewMatrix), NULL);
//        btMatrix3x3 normalMatrix(modelViewMatrix.getBasis().inverse().transpose());
//        
//        
//        float m[16];
//        
//        modelViewMatrix.getOpenGLMatrix(m);
//        pVBO->setGLSLModelViewMatrix(m);
//        
//        projectionMatrix.getOpenGLMatrix(m);
//        pVBO->setGLSLProjectionMatrix(m);
//        
//        normalMatrix.getOpenGLSubMatrix(m);
//        pVBO->setGLSLNormalMatrix(m);
        
        pVBO->render(GL_POINTS);
    }
}

void BaseParticleEmitterBehavior::debugDraw(btIDebugDraw* debugDrawer)
{
    
}

BaseParticleEmitterBehavior::BaseParticleEmitterBehavior(const ParticleEmitterBehaviorInfo& constructionInfo):
AbstractBehavior<BaseEntity>(NULL),
m_ParticleAttributeTransform(new ParticleAttributeTransform()),
m_NewParticleIndex(0),
m_particleViewObjectID(0),
m_MaxNumberOfParticles(constructionInfo.m_MaxNumberOfParticles),
m_shaderFactoryID(constructionInfo.m_shaderFactoryID),
m_ParticlesPerSecond(constructionInfo.m_ParticlesPerSecond),
m_CurrentTime(0.0f),
m_frame(0),
m_ParticleEntityConstructionInfo(NULL),
m_ParticleSize(constructionInfo.m_ParticleSize)
{
    WorldPhysics::getInstance()->addActionObject(this);
}

BaseParticleEmitterBehavior::~BaseParticleEmitterBehavior()
{
    WorldPhysics::getInstance()->removeActionObject(this);
    
    ViewObjectFactory::getInstance()->destroy(m_particleViewObjectID);
    
    for(int i = 0; i < m_ParticleAttributeTransform->m_Particles.size(); ++i)
    {
        IDType ID = m_ParticleAttributeTransform->m_Particles[i]->getID();
        EntityFactory::getInstance()->destroy(ID);
    }
    
    delete m_ParticleAttributeTransform;
    
    delete m_ParticleEntityConstructionInfo;
    
    if(getOwner())
        getOwner()->setParticleEmitterBehaviorID(0);
}


void BaseParticleEmitterBehavior::createParticleConstructionInfo()
{
    m_ParticleEntityConstructionInfo = new BaseEntityInfo();
}

void BaseParticleEmitterBehavior::emitParticle()
{
    int random_index = randomIntegerRange(0, m_EmitterVertices.size() - 1);
    
    BaseEntity* pEntity = getNewParticle();
    
    pEntity->setOrigin(getOwner()->getOrigin() + m_EmitterVertices[random_index]);
    pEntity->show(100);
}

BaseEntityInfo *BaseParticleEmitterBehavior::getParticleConstructionInfo()const
{
    return m_ParticleEntityConstructionInfo;
}

BaseEntity *BaseParticleEmitterBehavior::getNewParticle()
{
    BaseEntity *entity = m_ParticleAttributeTransform->m_Particles[m_NewParticleIndex];
    
    m_NewParticleIndex++;
    
    m_NewParticleIndex %= m_MaxNumberOfParticles;
    
    return entity;
}

BaseViewObject *BaseParticleEmitterBehavior::getParticleVBO()const
{
    return ViewObjectFactory::getInstance()->get(m_particleViewObjectID);
}

void BaseParticleEmitterBehavior::loadParticles()
{
    btAssert(m_MaxNumberOfParticles > 0);
    
    btAlignedObjectArray<GLushort> indiceData;
    btAlignedObjectArray<VertexAttributes_Vertex_Color> vertexData;
    VertexAttributeLoader::getInstance()->createbtAlignedObjectArray(m_MaxNumberOfParticles, indiceData, vertexData);
    
    BaseViewObjectInfo *viewConstructionInfo = new BaseViewObjectInfo(m_shaderFactoryID);
    m_particleViewObjectID = ViewObjectFactory::getInstance()->create(viewConstructionInfo);
    
    VertexAttributeLoader::getInstance()->load(getParticleVBO(), vertexData);
    delete viewConstructionInfo;
 
    createParticleConstructionInfo();
    
    m_ParticleAttributeTransform->m_Particles.resize(vertexData.size());
    
    BaseEntity *entity = NULL;
    IDType particleEntityID = 0;
    for (int i = 0; i < m_MaxNumberOfParticles; ++i)
    {
        particleEntityID = EntityFactory::getInstance()->create(getParticleConstructionInfo());
        entity = EntityFactory::getInstance()->get(particleEntityID);
        
        entity->hide();
        m_ParticleAttributeTransform->m_Particles[i] = entity;
    }
}
