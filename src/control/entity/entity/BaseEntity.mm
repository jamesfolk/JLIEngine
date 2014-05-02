//
//  BaseEntity.cpp
//  GameAsteroids
//
//  Created by James Folk on 3/11/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "BaseEntity.h"

#include "BaseViewObject.h"
#include "EntityStateMachine.h"
#include "BaseEntityAnimationController.h"

#include "ViewObjectFactory.h"
#include "EntityStateMachineFactory.h"
#include "AnimationControllerFactory.h"

#include "BaseParticleEmitterBehavior.h"
#include "ParticleEmitterBehaviorFactory.h"


#include "Telegram.h"

#include "UtilityFunctions.h"

#include "WorldPhysics.h"

#include "BaseCamera.h"

#include "CameraFactory.h"
#include "CollisionResponseBehaviorFactory.h"
//#include "UpdateBehaviorFactory.h"
//#include "CollisionFilterBehaviorFactory.h"
#include "EntityFactory.h"
#include "VertexBufferObject.h"
#include "VertexBufferObjectFactory.h"

BaseEntity::BaseEntity( const BaseEntityInfo& constructionInfo) :

m_worldTransform(new btTransform(btTransform::getIdentity())),
m_parentOffset(new btTransform(btTransform::getIdentity())),
m_scale(new btVector3(1.0f, 1.0f, 1.0f)),
//m_Heading(new btVector3(g_vHeadingVector)),
//m_Up(new btVector3(g_vUpVector)),
m_viewObjectFactoryID(constructionInfo.m_ViewObjectID),
m_vertexBufferObjectFactoryID(0),
m_animationControllerFactoryID(constructionInfo.m_StateMachineFactoryID),
m_stateMachineFactoryID(constructionInfo.m_StateMachineFactoryID),
m_particleEmitterFactoryID(0),
m_collisionResponseFactoryID(0),
m_updateFactoryID(0),
m_collisionFilterFactoryID(0),
m_entityDecoratorFactoryID(0),
m_hidden(false),
m_tagged(false),
m_isOrthographic(constructionInfo.m_IsOrthographicEntity),
m_drawMode(constructionInfo.m_drawMode),
m_SecondsShown(0),
m_ShowTimer(false),
m_userPointer(NULL)
{
//    setVBOID(m_viewObjectFactoryID);
    setVertexBufferObject(m_viewObjectFactoryID);
    setAnimationControllerID(m_animationControllerFactoryID);
    setStateMachineID(m_stateMachineFactoryID);
    
//    if(getVBO())
//        setWorldTransform(getVBO()->getInitialTransform());
    if(getVertexBufferObject())
        setWorldTransform(getVertexBufferObject()->getInitialTransform());
    
    WorldPhysics::getInstance()->addActionObject(this);
    
}

BaseEntity::BaseEntity() :
m_worldTransform(new btTransform(btTransform::getIdentity())),
m_parentOffset(new btTransform(btTransform::getIdentity())),
m_scale(new btVector3(1.0f, 1.0f, 1.0f)),
//m_Heading(new btVector3(g_vHeadingVector)),
//m_Up(new btVector3(g_vUpVector)),
m_viewObjectFactoryID(0),
m_vertexBufferObjectFactoryID(0),
m_animationControllerFactoryID(0),
m_stateMachineFactoryID(),
m_particleEmitterFactoryID(0),
m_collisionResponseFactoryID(0),
m_updateFactoryID(0),
m_collisionFilterFactoryID(0),
m_entityDecoratorFactoryID(0),
m_hidden(false),
m_tagged(false),
m_isOrthographic(false),
m_drawMode(GL_TRIANGLES),
m_SecondsShown(0),
m_ShowTimer(false),
m_userPointer(NULL)
{
    WorldPhysics::getInstance()->addActionObject(this);
}

BaseEntity::~BaseEntity()
{
    WorldPhysics::getInstance()->removeActionObject(this);
    
//    delete m_Up;
//    m_Up = NULL;
//    
//    delete m_Heading;
//    m_Heading = NULL;
    
    delete m_scale;
    m_scale = NULL;
    
    delete m_parentOffset;
    m_parentOffset = NULL;
    
    delete m_worldTransform;
    m_worldTransform = NULL;
}

BaseEntity *BaseEntity::create(int type)
{
    return EntityFactory::getInstance()->createObject(type);
}
bool BaseEntity::destroy(IDType &_id)
{
    return EntityFactory::getInstance()->destroy(_id);
}
bool BaseEntity::destroy(BaseEntity *entity)
{
    bool ret = false;
    if(entity)
    {
        IDType _id = entity->getID();
        ret = BaseEntity::destroy(_id);
    }
    entity = NULL;
    return ret;
}
BaseEntity *BaseEntity::get(IDType _id)
{
    return EntityFactory::getInstance()->get(_id);
}

void BaseEntity::updateAction( btCollisionWorld* collisionWorld, btScalar deltaTimeStep)
{
    //NSLog(@"LuaEntityState %d\n", this->getID());
    
//    if(getUpdateBehavior())
//    {
//        getUpdateBehavior()->update(this, collisionWorld, deltaTimeStep);
//    }
    
//    if(getVBO())
//    {
//        getVBO()->setGLSLTime(deltaTimeStep);
//    }
    
    if(getAnimationController())
    {
        getAnimationController()->update(deltaTimeStep);
    }
    
    if(getStateMachine())
    {
        getStateMachine()->update(deltaTimeStep);
    }
    
//    if(getCollisionResponseBehavior())
//    {
//        getCollisionResponseBehavior()->respond(NULL);
//    }
    
    if(!m_hidden && m_ShowTimer)
    {
        m_SecondsShown -= deltaTimeStep;
        if(m_SecondsShown <= 0)
        {
            m_SecondsShown = 0;
            hide();
        }
    }
    
}
void BaseEntity::debugDraw(btIDebugDraw* debugDrawer)
{
}


void BaseEntity::setOrigin(const btVector3 &pos)
{
    btTransform _btTransform(getWorldTransform());
    
    _btTransform.setOrigin(pos);
    
    setWorldTransform(_btTransform);
}

void BaseEntity::setRotation(const btQuaternion &rot)
{
    btTransform _btTransform(getWorldTransform());
    
    _btTransform.setRotation(rot);
    
    setWorldTransform(_btTransform);
    
}

SIMD_FORCE_INLINE static btTransform RotateGlobalSpace(const btTransform& T,const btMatrix3x3& rotationMatrixToApplyBeforeTGlobalSpace,const btVector3& centerOfRotationRelativeToTLocalSpace)
{
    // Note:  - centerOfRotationRelativeToTLocalSpace = TRelativeToCenterOfRotationLocalSpace (LocalSpace is relative to the T.basis())
    const btVector3 TRelativeToTheCenterOfRotationGlobalSpace = T.getBasis() * (-centerOfRotationRelativeToTLocalSpace);   // Distance between the center of rotation and T in global space
    const btVector3 centerOfRotationAbsolute = T.getOrigin() - TRelativeToTheCenterOfRotationGlobalSpace;            // Absolute position of the center of rotation = Absolute position of T + PositionOfTheCenterOfRotationRelativeToT
    return btTransform(rotationMatrixToApplyBeforeTGlobalSpace*T.getBasis(),centerOfRotationAbsolute + rotationMatrixToApplyBeforeTGlobalSpace * TRelativeToTheCenterOfRotationGlobalSpace);
}
SIMD_FORCE_INLINE static btTransform RotateGlobalSpace(const btTransform& T,const btQuaternion& rotationToApplyBeforeTGlobalSpace,const btVector3& centerOfRotationRelativeToTLocalSpace)
{
    return RotateGlobalSpace(T,btMatrix3x3(rotationToApplyBeforeTGlobalSpace),centerOfRotationRelativeToTLocalSpace);
}

void BaseEntity::rotate(const btQuaternion &rot, const btVector3 &pivot)
{
    btVector3 origin(getWorldTransform().getOrigin());
    
    origin = origin - pivot;
    
    btScalar length(origin.length());
    if(origin.length() > 0)
        origin.normalize();
    
    origin = origin.rotate(rot.getAxis(), rot.getAngle());
    
    origin *= length;
    
    origin = origin + pivot;
    
    setRotation(getWorldTransform().getRotation() * rot);
    setOrigin(origin);
}

//void BaseEntity::rotateHeader(const btQuaternion &rot)
//{
//    setHeadingVector(getHeadingVector().rotate(rot.getAxis(), rot.getAngle()));
//    setUpVector(getUpVector().rotate(rot.getAxis(), rot.getAngle()));
//}

void BaseEntity::lookAt(const btVector3 &target, const btVector3 &upVector)
{
    btTransform _btTransform(makeLookAt(getOrigin().getX(),
                                        getOrigin().getY(),
                                        getOrigin().getZ(),
                                        target.getX(),
                                        target.getY(),
                                        target.getZ(),
                                        upVector.getX(),
                                        upVector.getY(),
                                        upVector.getZ()));
    
    setWorldTransform(_btTransform.inverse());
    
//    setHeadingVector(target - getOrigin());
//    setUpVector(upVector);
}

void BaseEntity::lookAtHeading()
{
    lookAt(getOrigin() + (getHeadingVector() * 100.0f));
}

const VertexBufferObject*	BaseEntity::getVertexBufferObject() const
{
    return VertexBufferObjectFactory::getInstance()->get(m_vertexBufferObjectFactoryID);
}
VertexBufferObject*	BaseEntity::getVertexBufferObject()
{
    return VertexBufferObjectFactory::getInstance()->get(m_vertexBufferObjectFactoryID);
}
void BaseEntity::setVertexBufferObject(const IDType ID)
{
    if(getVertexBufferObject())
        getVertexBufferObject()->unRegisterEntity(this);
    
    m_vertexBufferObjectFactoryID = ID;
    
    
    
    if(getVertexBufferObject())
    {
        getVertexBufferObject()->registerEntity(this);
        setName(getVertexBufferObject()->getName());
    }
}

const btVector3 &BaseEntity::getScale()const
{
    return *m_scale;
}
bool BaseEntity::setScale(const btVector3 &scale)
{
    *m_scale = scale.absolute();
    
    return true;
}

void BaseEntity::show()
{
    m_hidden = false;
}
void BaseEntity::hide()
{
    m_hidden = true;
    m_ShowTimer = false;
}

void BaseEntity::show(const btScalar seconds)
{
    btAssert(seconds > 0);
    
    m_ShowTimer = true;
    m_SecondsShown = seconds;
    
    show();
}

void BaseEntity::setDrawMode(GLenum drawMode)
{
    m_drawMode = drawMode;
}

GLenum BaseEntity::getDrawMode()const
{
    return m_drawMode;
}

void BaseEntity::render()
{
    VertexBufferObject *pVBO = getVertexBufferObject();
    if (pVBO)
    {
        pVBO->markInView(this);
    }
    
    //BaseViewObject *pVBO = NULL;//getVBO();
    //if(NULL != pVBO)
    {
        //if(!m_hidden)
        {
//            if(pCamera == NULL)
//                pCamera = CameraFactory::getInstance()->getCurrentCamera();
            
//            pVBO->setGLSLUniforms(pCamera->getWorldTransform().inverse(), pCamera->getProjection2(), getWorldTransform());

//            btVector4 eyeWorldSpace(pCamera->getOrigin().x(),
//                                    pCamera->getOrigin().y(),
//                                    pCamera->getOrigin().z(),
//                                    1.0f);
//            btVector3 eyeObjectSpace(getWorldTransform() * pCamera->getOrigin());
//            btTransform cameraLocationMatrix = pCamera->getWorldTransform().inverse();
//            
//            btTransform _btTransform(getWorldTransform());
//            _btTransform.setBasis(_btTransform.getBasis().scaled(getScale()));
//            
//            btTransform modelMatrix = _btTransform;
//            
//            btTransform modelViewMatrix(cameraLocationMatrix * modelMatrix);
//            
//            btTransform projectionMatrix(pCamera->getProjection2());
//            
//            btTransform normalMatrix(modelMatrix);
//            
//            float m[16];
//            pVBO->setGLSLEyePosition(eyeObjectSpace);
//            
//            modelMatrix.getOpenGLMatrix(m);
//            pVBO->setGLSLModelMatrix(m);
//
//            
//            modelViewMatrix.getOpenGLMatrix(m);
//            pVBO->setGLSLModelViewMatrix(m);
//            
//            projectionMatrix.getOpenGLMatrix(m);
//            pVBO->setGLSLProjectionMatrix(m);
//            
//            normalMatrix.getOpenGLMatrix(m);
//            pVBO->setGLSLNormalMatrix(m);
            
//            pVBO->render(m_drawMode);
        }
    }
}

void BaseEntity::renderInstancing()
{
    VertexBufferObject *pVBO = getVertexBufferObject();
    if (pVBO)
    {
//#pragma mark temp updateGLBuffer();
//        pVBO->updateGLBuffer();
        pVBO->renderGLBuffer(m_drawMode);
    }
}

//void BaseEntity::render(BaseCamera *pCamera)
//{
//    BaseViewObject *pVBO = getVBO();
//    if(NULL != pVBO)
//    {
//        if(!m_hidden)
//        {
//            if(pCamera == NULL)
//                pCamera = CameraFactory::getInstance()->getCurrentCamera();
//            
//            btVector4 eyeWorldSpace(pCamera->getOrigin().x(),
//                                    pCamera->getOrigin().y(),
//                                    pCamera->getOrigin().z(),
//                                    1.0f);
//            btVector3 eyeObjectSpace(getWorldTransform() * pCamera->getOrigin());
//            
//            GLKVector3 _eyeObjectSpace = GLKVector3Make(eyeObjectSpace.x(),
//                                                        eyeObjectSpace.y(),
//                                                        eyeObjectSpace.z());
//            
//            GLKMatrix4 cameraLocationMatrix = getGLKMatrix4(pCamera->getWorldTransform().inverse());
//            btTransform _btTransform(getWorldTransform());
//            _btTransform.setBasis(_btTransform.getBasis().scaled(getScale()));
//            
//            GLKMatrix4 _modelMatrix = getGLKMatrix4(_btTransform);
//            GLKMatrix4 _modelViewMatrix = GLKMatrix4Multiply(cameraLocationMatrix,
//                                                             getGLKMatrix4(_btTransform));
//            GLKMatrix4 _projectionMatrix = pCamera->getProjection();
//            
//            GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(_modelViewMatrix), NULL);
//            
//            pVBO->setGLSLEyePosition(_eyeObjectSpace.v);
//            pVBO->setGLSLModelMatrix(_modelMatrix.m);
//            pVBO->setGLSLModelViewMatrix(_modelViewMatrix.m);
//            pVBO->setGLSLProjectionMatrix(_projectionMatrix.m);
//            pVBO->setGLSLNormalMatrix(normalMatrix.m);
//            
//            pVBO->render(m_drawMode);
//        }
//    }
//}

void BaseEntity::playSoundEffect(const std::string soundKey,
                     bool loop,
                     const btVector3 &offset)
{
	btVector3 vOrigin(getOrigin() + offset);
	const GLfloat pos[] = {vOrigin.getX() , vOrigin.getY(), vOrigin.getZ()};
	const GLfloat v[] = {0.0f, 0.0f, 0.0f};
	BOOL bLoop = (loop)?YES:NO;
    
    

//	[sharedSoundManager playSFXWithKey:key
//									gain:1.0f
//								   pitch:1.0f
//						   rollOffFactor:1.0f
//								location:pos
//								velocity:v
//							   direction:v
//							  isRelative:YES
//							  shouldLoop:bLoop];
}

bool BaseEntity::handleMessage(const Telegram& telegram)
{
    if(getStateMachine())
        return getStateMachine()->handleMessage(telegram);
    return false;
}

bool BaseEntity::isTagged()const
{
    return m_tagged;
}

void BaseEntity::tag(bool tag)
{
    m_tagged = tag;
}



btTransform BaseEntity::getTransformOffset()const
{
    return *m_parentOffset;
}

void BaseEntity::setTransformOffset(const btTransform &parentTrans)
{
    *m_parentOffset = parentTrans;
}

btTransform BaseEntity::getWorldTransform() const
{
    return *m_worldTransform;
}

void BaseEntity::setWorldTransform(const btTransform& worldTrans)
{
    
    m_worldTransform->setOrigin(worldTrans.getOrigin());
    m_worldTransform->setBasis(worldTrans.getBasis());
    
    BaseEntity *pBaseEntity = getEntityDecorator();
    if(pBaseEntity)
    {
        btTransform trans(getWorldTransform().getRotation() * pBaseEntity->getRotationOffset(),
                          getWorldTransform().getOrigin() + pBaseEntity->getOriginOffset());
        
        pBaseEntity->setWorldTransform(trans);
    }
}


//bool BaseEntity::shouldCollide(const BaseEntity *pOtherEntity)const
//{
//    if(getCollisionFilterBehavior())
//        return getCollisionFilterBehavior()->shouldCollide(pOtherEntity);
//    return true;
//}

void BaseEntity::handleCollide(BaseEntity *pOtherEntity, const btManifoldPoint&pt)
{
    BaseCollisionResponseBehavior *pBehavior = getCollisionResponseBehavior();
    if(pBehavior)
        if(!pBehavior->responded())
            pBehavior->respond(this, pOtherEntity, pt);
}

void BaseEntity::handleCollisionNear(BaseEntity *pOtherEntity, const btDispatcherInfo& dispatchInfo)
{
    return;
}

//const BaseViewObject*	BaseEntity::getVBO() const
//{
//    return ViewObjectFactory::getInstance()->get(m_viewObjectFactoryID);
//}
//
//BaseViewObject*	BaseEntity::getVBO()
//{
//    return ViewObjectFactory::getInstance()->get(m_viewObjectFactoryID);
//}
//
//void BaseEntity::setVBOID(const IDType ID)
//{
//    m_viewObjectFactoryID = ID;
//    if(getVBO())
//        setName(getVBO()->getName());
//}

const EntityStateMachine*	BaseEntity::getStateMachine() const
{
    return EntityStateMachineFactory::getInstance()->get(m_stateMachineFactoryID);
}

EntityStateMachine*	BaseEntity::getStateMachine()
{
    return EntityStateMachineFactory::getInstance()->get(m_stateMachineFactoryID);
}

void BaseEntity::setStateMachineID(const IDType ID)
{
    m_stateMachineFactoryID = ID;
    
    if(getStateMachine())
        getStateMachine()->setOwner(this);
}

const BaseEntityAnimationController*	BaseEntity::getAnimationController() const
{
    return AnimationControllerFactory::getInstance()->get(m_animationControllerFactoryID);
}

BaseEntityAnimationController*	BaseEntity::getAnimationController()
{
    return AnimationControllerFactory::getInstance()->get(m_animationControllerFactoryID);
}

void BaseEntity::setAnimationControllerID(const IDType ID)
{
    m_animationControllerFactoryID = ID;
    
    if(getAnimationController())
        getAnimationController()->setOwner(this);
}

const BaseParticleEmitterBehavior*	BaseEntity::getParticleEmitterBehavior() const
{
    return ParticleEmitterBehaviorFactory::getInstance()->get(m_particleEmitterFactoryID);
}

BaseParticleEmitterBehavior*	BaseEntity::getParticleEmitterBehavior()
{
    return ParticleEmitterBehaviorFactory::getInstance()->get(m_particleEmitterFactoryID);
}

void BaseEntity::setParticleEmitterBehaviorID(const IDType ID)
{
    
    if(getParticleEmitterBehavior())
    {
        getParticleEmitterBehavior()->setOwner(NULL);
    }
    
    m_particleEmitterFactoryID = ID;
    
    if(getParticleEmitterBehavior())
    {
        getParticleEmitterBehavior()->setOwner(this);
        
        getParticleEmitterBehavior()->load();
    }
}

const BaseCollisionResponseBehavior*	BaseEntity::getCollisionResponseBehavior() const
{
    BaseCollisionResponseBehavior *p = CollisionResponseBehaviorFactory::getInstance()->get(m_collisionResponseFactoryID);
    if(p->getType() > CollisionResponseBehaviorTypes_NONE && p->getType() < CollisionResponseBehaviorTypes_MAX)
    {
        return p;
    }
    return NULL;
}
BaseCollisionResponseBehavior*	BaseEntity::getCollisionResponseBehavior()
{
    BaseCollisionResponseBehavior *p = CollisionResponseBehaviorFactory::getInstance()->get(m_collisionResponseFactoryID);
    return p;
//    if(p->getType() > CollisionResponseBehaviorTypes_NONE && p->getType() < CollisionResponseBehaviorTypes_MAX)
//    {
//        return p;
//    }
//    return NULL;
    
}
void BaseEntity::setCollisionResponseBehavior(const IDType ID)
{
    m_collisionResponseFactoryID = ID;
    
    BaseCollisionResponseBehavior *cr = getCollisionResponseBehavior();
    
    enableHandleCollision(cr != NULL);
    
    if(cr)
        cr->setOwner(this);
}
//const BaseUpdateBehavior*	BaseEntity::getUpdateBehavior() const
//{
//    return UpdateBehaviorFactory::getInstance()->get(m_updateFactoryID);
//}
//BaseUpdateBehavior*	BaseEntity::getUpdateBehavior()
//{
//    return UpdateBehaviorFactory::getInstance()->get(m_updateFactoryID);
//}
//void BaseEntity::setUpdateBehavior(const IDType ID)
//{
//    m_updateFactoryID = ID;
//    
//    if(getUpdateBehavior())
//        getUpdateBehavior()->setOwner(this);
//}

//const BaseCollisionFilterBehavior*	BaseEntity::getCollisionFilterBehavior() const
//{
//    return CollisionFilterBehaviorFactory::getInstance()->get(m_collisionFilterFactoryID);
//}
//BaseCollisionFilterBehavior*	BaseEntity::getCollisionFilterBehavior()
//{
//    return CollisionFilterBehaviorFactory::getInstance()->get(m_collisionFilterFactoryID);
//}
//void BaseEntity::setCollisionFilterBehavior(const IDType ID)
//{
//    m_collisionFilterFactoryID = ID;
//    
//    if(getCollisionFilterBehavior())
//        getCollisionFilterBehavior()->setOwner(this);
//}

const BaseEntity*	BaseEntity::getEntityDecorator() const
{
    return EntityFactory::getInstance()->get(m_entityDecoratorFactoryID);
}
BaseEntity*	BaseEntity::getEntityDecorator()
{
    return EntityFactory::getInstance()->get(m_entityDecoratorFactoryID);
}
void BaseEntity::setEntityDecorator(const IDType ID)
{
    m_entityDecoratorFactoryID = ID;
    
    if(getEntityDecorator())
    {
        getEntityDecorator()->setWorldTransform(this->getWorldTransform());
        //getEntityDecorator()->setScale(this->getScale());
    }
    
}
