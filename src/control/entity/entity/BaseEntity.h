//
//  BaseEntity.h
//  GameAsteroids
//
//  Created by James Folk on 3/11/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__BaseEntity__
#define __GameAsteroids__BaseEntity__

#include "btBulletDynamicsCommon.h"
#include "AbstractFactory.h"

#include "EntityFactoryIncludes.h"
#include "EntityStateMachineFactoryIncludes.h"
#include "AnimationControllerFactoryIncludes.h"
#include "ParticleEmitterBehaviorFactoryIncludes.h"
#include "BaseEntityAnimationController.h"

#include <string>


class Telegram;

class BaseCamera;

class BaseViewObject;
class EntityStateMachine;
class BaseParticleEmitterBehavior;
class BaseCollisionResponseBehavior;
class BaseUpdateBehavior;

class VertexBufferObject;

class BaseEntity :
public btActionInterface,
public AbstractFactoryObject
{
    friend class EntityFactory;
protected:
    BaseEntity( const BaseEntityInfo& constructionInfo);
    BaseEntity();
    virtual ~BaseEntity();
public:
    static BaseEntity *create(int type = 0);
    static bool destroy(IDType &_id);
    static bool destroy(BaseEntity *entity);
    static BaseEntity *get(IDType _id);
    
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
    
    //BT_DECLARE_ALIGNED_ALLOCATOR();
    
    virtual void updateAction( btCollisionWorld* collisionWorld, btScalar deltaTimeStep);
	virtual void debugDraw(btIDebugDraw* debugDrawer);
    
    virtual SIMD_FORCE_INLINE btVector3 getOrigin()const
    {
        return getWorldTransform().getOrigin();
    }
    virtual void setOrigin(const btVector3 &pos);
    
    virtual SIMD_FORCE_INLINE btQuaternion getRotation()const
    {
        return getWorldTransform().getRotation();
    }
    virtual void setRotation(const btQuaternion &rot);
    
    virtual void rotate(const btQuaternion &rot, const btVector3 &pivot = btVector3(0,0,0));
//    virtual void rotateHeader(const btQuaternion &rot);
    
    virtual const btVector3 &getScale()const;
    virtual bool setScale(const btVector3 &scale);
    
    virtual void lookAt(const btVector3 &pos, const btVector3 &up = g_vUpVector);
    virtual void lookAtHeading();
    
    virtual btVector3 getHeadingVector()const
    {
        return g_vHeadingVector.rotate(getRotation().getAxis(), getRotation().getAngle());
    }
	virtual btVector3 getUpVector()const
    {
        return g_vUpVector.rotate(getRotation().getAxis(), getRotation().getAngle());
    }
    virtual btVector3 getSideVector()const
    {
        return getUpVector().cross(getHeadingVector());
    }
    
//    SIMD_FORCE_INLINE int getVOTransformArrayIndex()const
//    {
//        return m_voTransformArrayIndex;
//    }
//    
//    SIMD_FORCE_INLINE void setVOTransformArrayIndex(const int idx)
//    {
//        m_voTransformArrayIndex = idx;
//    }
    
    const VertexBufferObject*	getVertexBufferObject() const;
    VertexBufferObject*	getVertexBufferObject();
    void setVertexBufferObject(const IDType ID);
    
    
    SIMD_FORCE_INLINE int getViewObjectTransformArrayIndex()const
    {
        return m_viewObjectTransformIndex;
    }
    
    SIMD_FORCE_INLINE void setViewObjectTransformArrayIndex(const int idx)
    {
        m_viewObjectTransformIndex = idx;
    }
                
//    const BaseViewObject*	getVBO() const;
//    BaseViewObject*	getVBO();
//    void setVBOID(const IDType ID);

    const EntityStateMachine*	getStateMachine() const;
    EntityStateMachine*	getStateMachine();
    void setStateMachineID(const IDType ID);
public:
    const BaseEntityAnimationController*	getAnimationController()const;
    BaseEntityAnimationController*	getAnimationController();
    void setAnimationControllerID(const IDType ID);
    
    const BaseParticleEmitterBehavior*	getParticleEmitterBehavior() const;
    BaseParticleEmitterBehavior*	getParticleEmitterBehavior();
    void setParticleEmitterBehaviorID(const IDType ID);
    
    const BaseCollisionResponseBehavior*	getCollisionResponseBehavior() const;
    BaseCollisionResponseBehavior*	getCollisionResponseBehavior();
    void setCollisionResponseBehavior(const IDType ID);
    
//    const BaseUpdateBehavior*	getUpdateBehavior() const;
//    BaseUpdateBehavior*	getUpdateBehavior();
//    void setUpdateBehavior(const IDType ID);
    
    const BaseEntity*	getEntityDecorator() const;
    BaseEntity*	getEntityDecorator();
    void setEntityDecorator(const IDType ID);
    
    SIMD_FORCE_INLINE bool isHidden()const
    {
        return m_hidden;
    }
    virtual void show();
    virtual void hide();
    void show(const btScalar seconds);
    
    void setDrawMode(GLenum drawMode);
    GLenum getDrawMode()const;
    
    virtual void render();
    virtual void renderInstancing();
    
    virtual void playSoundEffect(const std::string soundKey,
                                 bool loop = false,
                                 const btVector3 &offset = btVector3(0,0,0));
    virtual bool handleMessage(const Telegram& telegram);
    
    bool isTagged()const;
    void tag(bool tag = true);
    
    virtual btTransform getTransformOffset()const;
    virtual void setTransformOffset(const btTransform &parentTrans);
    
    virtual SIMD_FORCE_INLINE btVector3 getOriginOffset()const
    {
        return getTransformOffset().getOrigin();
    }
    virtual void setOriginOffset(const btVector3 &pos)
    {
        btTransform _btTransform(getTransformOffset());
        _btTransform.setOrigin(pos);
        setTransformOffset(_btTransform);
    }
    
    virtual SIMD_FORCE_INLINE btQuaternion getRotationOffset()const
    {
        return getTransformOffset().getRotation();
    }
    
    virtual void setRotationOffset(const btQuaternion &rot)
    {
        btTransform _btTransform(getTransformOffset());
        _btTransform.setRotation(rot);
        setTransformOffset(_btTransform);
    }
    
    
    virtual btTransform getWorldTransform() const;
    virtual void setWorldTransform(const btTransform& worldTrans);
    
    virtual void enableHandleCollision(const bool enable = true){btAssert(true);}
    virtual bool isCollisionHandleEnabled()const{return false;}
    
    virtual void enableCollision(const bool enable = true){}
    virtual bool isCollisionEnabled()const{return false;}
    
    //virtual bool shouldCollide(const BaseEntity *pOtherEntity)const;
    virtual void handleCollide(BaseEntity *pOtherEntity, const btManifoldPoint&pt);
	virtual void handleCollisionNear(BaseEntity *pOtherEntity, const btDispatcherInfo& dispatchInfo);
    
    bool isShowTimed()const
    {
        return m_ShowTimer;
    }
    btScalar getShowSeconds()const
    {
        return m_SecondsShown;
    }
    
    ///optional user data pointer
	void	setUserPointer(void*  userPtr)
	{
		m_userPointer = userPtr;
	}
    
	void*	getUserPointer() const
	{
		return m_userPointer;
	}
//protected:
//    virtual void setHeadingVector(const btVector3 &vec)
//    {
//        if(vec.isZero())
//            *m_Heading = g_vHeadingVector;
//        else
//            *m_Heading = vec.normalized();
//    }
//    virtual void setUpVector(const btVector3 &vec)
//    {
//        if(vec.isZero())
//            *m_Up = g_vUpVector;
//        else
//            *m_Up = vec.normalized();
//    }
    
private:
//    unsigned int m_voTransformArrayIndex;
    int m_viewObjectTransformIndex;
    
    btTransform *m_worldTransform;
    btTransform *m_parentOffset;
    
    btVector3 *m_scale;
//    btVector3 *m_Heading;
//    btVector3 *m_Up;
    
    IDType m_viewObjectFactoryID;
    IDType m_vertexBufferObjectFactoryID;
    
    
    IDType m_animationControllerFactoryID;
    IDType m_stateMachineFactoryID;
    IDType m_particleEmitterFactoryID;
    IDType m_collisionResponseFactoryID;
    IDType m_updateFactoryID;
    IDType m_collisionFilterFactoryID;
    
    IDType m_entityDecoratorFactoryID;
    
    bool m_hidden;
    bool m_tagged;
    
    GLenum m_drawMode;
    
    btScalar m_SecondsShown;
    bool m_ShowTimer;
    
    void *m_userPointer;
private:
    
    BaseEntity(const BaseEntity &rhs);
    BaseEntity &operator=(const BaseEntity &rhs);
};

#endif /* defined(__GameAsteroids__BaseEntity__) */
