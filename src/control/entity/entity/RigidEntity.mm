//
//  RigidEntity.cpp
//  GameAsteroids
//
//  Created by James Folk on 3/11/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "RigidEntity.h"

#include "WorldPhysics.h"
#include "CollisionShapeFactory.h"
#include "VertexBufferObject.h"

/*
    the steering behavior is attached to the motionstate. thus the motion state must not be 
    null if there is going to be a steering behavior.
 */
RigidEntity::RigidEntity( const RigidEntityInfo& constructionInfo) :
BaseEntity(constructionInfo),
m_btRigidBody(NULL),
m_CollisionShapeFactoryID(constructionInfo.m_collisionShapeFactoryID),
m_Mass(constructionInfo.m_mass)
{
    btTransform initialTransform(btTransform::getIdentity());
    if(getVertexBufferObject())
        initialTransform = getVertexBufferObject()->getInitialTransform();
    
//    m_btRigidBody = WorldPhysics::getInstance()->addRigidBody(this,
//                                                              initialTransform,
//                                                              m_Mass,
//                                                              m_CollisionShapeFactoryID);
    m_btRigidBody = WorldPhysics::getInstance()->addRigidBody(this,
                                                              initialTransform,
                                                              m_Mass,
                                                              m_CollisionShapeFactoryID,
                                                              CollisionMask_ALL,
                                                              CollisionMask_ALL);
    
    
    btAssert(m_btRigidBody);    
}

RigidEntity::RigidEntity():
BaseEntity(),
m_btRigidBody(NULL),
m_CollisionShapeFactoryID(0),
m_Mass(0)
{
}

RigidEntity::~RigidEntity()
{
    WorldPhysics::getInstance()->removeRigidBody(getRigidBody());
    m_btRigidBody = NULL;
}

void RigidEntity::setup(IDType collisionShapeID,
           btScalar mass,
           const btVector3 &origin,
           const btQuaternion &rotation,
           CollisionMask group,
           CollisionMask mask)
{
    //btAssert(mass > 0);
    btAssert(collisionShapeID > 0);
    
    bool isactionObject = WorldPhysics::getInstance()->isActionObject(this);
    
    if(m_btRigidBody)
    {
        WorldPhysics::getInstance()->removeRigidBody(getRigidBody());
    }
    if(isactionObject)
        WorldPhysics::getInstance()->removeActionObject(this);
    
    m_Mass = mass;
    m_CollisionShapeFactoryID = collisionShapeID;
    
    m_btRigidBody = WorldPhysics::getInstance()->addRigidBody(this,
                                                              btTransform(rotation, origin),
                                                              m_Mass,
                                                              m_CollisionShapeFactoryID,
                                                              group,
                                                              mask);
    if(isactionObject)
    WorldPhysics::getInstance()->addActionObject(this);}

//void RigidEntity::setup(IDType collisionShapeID,
//                        btScalar mass,
//                        const btTransform &initialTransform,
//                        CollisionMask group,
//                        CollisionMask mask)
//{
//    //btAssert(mass > 0);
//    btAssert(collisionShapeID > 0);
//    
//    bool isactionObject = WorldPhysics::getInstance()->isActionObject(this);
//    
//    if(m_btRigidBody)
//    {
//        WorldPhysics::getInstance()->removeRigidBody(getRigidBody());
//        if(isactionObject)
//            WorldPhysics::getInstance()->removeActionObject(this);
//    }
//    
//    m_Mass = mass;
//    m_CollisionShapeFactoryID = collisionShapeID;
//    
////    m_btRigidBody = WorldPhysics::getInstance()->addRigidBody(this,
////                                                              initialTransform,
////                                                              m_Mass,
////                                                              m_CollisionShapeFactoryID);
//    m_btRigidBody = WorldPhysics::getInstance()->addRigidBody(this,
//                                                              initialTransform,
//                                                              m_Mass,
//                                                              m_CollisionShapeFactoryID,
//                                                              group,
//                                                              mask);
//    if(isactionObject)
//        WorldPhysics::getInstance()->addActionObject(this);
//}

void RigidEntity::updateAction( btCollisionWorld* collisionWorld, btScalar deltaTimeStep)
{
    BaseEntity::updateAction(collisionWorld, deltaTimeStep);
    
    if(getRigidBody() &&
       WorldPhysics::getInstance()->isContinuousCollisionDetectionEnabled())
    {
        getRigidBody()->setCcdMotionThreshold(getVertexBufferObject()->getBoundingRadius());
        getRigidBody()->setCcdSweptSphereRadius(0.9 * getVertexBufferObject()->getBoundingRadius());
    }
}

void RigidEntity::debugDraw(btIDebugDraw* debugDrawer)
{
//    if(getVBO())
//    {
//        btVector3 maxAabb =  getOrigin() + getVBO()->getHalfExtends();
//        btVector3 minAabb = getOrigin() - getVBO()->getHalfExtends();
//        btVector3 colorvec(1,1,1);
//        
//        debugDrawer->drawAabb(minAabb, maxAabb, colorvec);
//    }
}

void RigidEntity::setOrigin(const btVector3 &pos)
{
    BaseEntity::setOrigin(pos);
    
    btTransform transform = getRigidBody()->getCenterOfMassTransform();
    transform.setOrigin(pos);
    getRigidBody()->setCenterOfMassTransform(transform);
}

void RigidEntity::setRotation(const btQuaternion &rot)
{
    BaseEntity::setRotation(rot);
    
    btTransform transform = getRigidBody()->getCenterOfMassTransform();
    transform.setRotation(rot.inverse());
    getRigidBody()->setCenterOfMassTransform(transform);
}

void RigidEntity::lookAt(const btVector3 &pos)
{
    BaseEntity::lookAt(pos);
    getRigidBody()->clearForces();
}

bool RigidEntity::setScale(const btVector3 &scale)
{
    btAssert(0);
//    switch (m_CollisionShapeType)
//    {
//        case CollisionShapeType_Cube:
//        {
//            btBoxShape *shape = dynamic_cast<btBoxShape*>(getRigidBody()->getCollisionShape());
//            BaseEntity::setScale(scale);
//            shape->setLocalScaling(getScale());
//            
//            return true;
//             
//        }
//            break;
//            
//        case CollisionShapeType_Sphere:
//        {
//            btSphereShape *shape = dynamic_cast<btSphereShape*>(getRigidBody()->getCollisionShape());
//            BaseEntity::setScale(scale);
//            shape->setLocalScaling(getScale());
//            
//            return true;
//        }
//            break;
//        case CollisionShapeType_ConeX:
//        {
//            btConeShapeX *shape = dynamic_cast<btConeShapeX*>(getRigidBody()->getCollisionShape());
//            BaseEntity::setScale(scale);
//            shape->setLocalScaling(getScale());
//            
//            return true;
//        }
//            break;
//        case CollisionShapeType_ConeY:
//        {
//            btConeShape *shape = dynamic_cast<btConeShape*>(getRigidBody()->getCollisionShape());
//            BaseEntity::setScale(scale);
//            shape->setLocalScaling(getScale());
//            
//            return true;
//        }
//            break;
//        case CollisionShapeType_ConeZ:
//        {
//            btConeShapeZ *shape = dynamic_cast<btConeShapeZ*>(getRigidBody()->getCollisionShape());
//            BaseEntity::setScale(scale);
//            shape->setLocalScaling(getScale());
//            
//            return true;
//        }
//            break;
//        case CollisionShapeType_TriangleMesh:
//        {
//            btBvhTriangleMeshShape *shape = dynamic_cast<btBvhTriangleMeshShape*>(getRigidBody()->getCollisionShape());
//            BaseEntity::setScale(scale);
//            shape->setLocalScaling(getScale());
//            
//            return true;
//        }
//            break;
//        case CollisionShapeType_CapsuleX:
//        {
//            btCapsuleShapeX *shape = dynamic_cast<btCapsuleShapeX*>(getRigidBody()->getCollisionShape());
//            BaseEntity::setScale(scale);
//            shape->setLocalScaling(getScale());
//            
//            return true;
//        }
//            break;
//        case CollisionShapeType_CapsuleY:
//        {
//            btCapsuleShape *shape = dynamic_cast<btCapsuleShape*>(getRigidBody()->getCollisionShape());
//            BaseEntity::setScale(scale);
//            shape->setLocalScaling(getScale());
//            
//            return true;
//        }
//            break;
//        case CollisionShapeType_CapsuleZ:
//        {
//            btCapsuleShapeZ *shape = dynamic_cast<btCapsuleShapeZ*>(getRigidBody()->getCollisionShape());
//            BaseEntity::setScale(scale);
//            shape->setLocalScaling(getScale());
//            
//            return true;
//        }
//            break;
//        case CollisionShapeType_CylinderX:
//        {
//            btCylinderShapeX *shape = dynamic_cast<btCylinderShapeX*>(getRigidBody()->getCollisionShape());
//            BaseEntity::setScale(scale);
//            shape->setLocalScaling(getScale());
//            
//            return true;
//        }
//            break;
//        case CollisionShapeType_CylinderY:
//        {
//            btCylinderShape *shape = dynamic_cast<btCylinderShape*>(getRigidBody()->getCollisionShape());
//            BaseEntity::setScale(scale);
//            shape->setLocalScaling(getScale());
//            
//            return true;
//        }
//            break;
//        case CollisionShapeType_CylinderZ:
//        {
//            btCylinderShapeZ *shape = dynamic_cast<btCylinderShapeZ*>(getRigidBody()->getCollisionShape());
//            BaseEntity::setScale(scale);
//            shape->setLocalScaling(getScale());
//            
//            return true;
//        }
//            break;
//        case CollisionShapeType_ConvexHull:
//        {
//            btConvexHullShape *shape = dynamic_cast<btConvexHullShape*>(getRigidBody()->getCollisionShape());
//            BaseEntity::setScale(scale);
//            shape->setLocalScaling(getScale());
//            
//            return true;
//        }
//            break;
////        case CollisionShapeType_StaticPlane:
////        {
////            btStaticPlaneShape *shape = dynamic_cast<btStaticPlaneShape*>(getRigidBody()->getCollisionShape());
////            BaseEntity::setScale(scale);
////            shape->setLocalScaling(getScale());
////        }
//            break;
//    }
    return false;
}

void RigidEntity::setDynamicPhysics()
{
    btTransform _btTransform = getWorldTransform();
    bool isactionObject = WorldPhysics::getInstance()->isActionObject(this);
    
    WorldPhysics::getInstance()->removeRigidBody(getRigidBody());
    if(isactionObject)
        WorldPhysics::getInstance()->removeActionObject(this);
    
//    m_btRigidBody = WorldPhysics::getInstance()->addRigidBody(this,
//                                                              _btTransform,
//                                                              m_Mass,
//                                                              m_CollisionShapeFactoryID);
    m_Mass = (m_Mass <= 0)?std::numeric_limits<btScalar>::min():m_Mass;
    m_btRigidBody = WorldPhysics::getInstance()->addRigidBody(this,
                                                              _btTransform,
                                                              m_Mass,
                                                              m_CollisionShapeFactoryID,
                                                              getCollisionGroup(),
                                                              getCollisionMask());
    
    if(isactionObject)
        WorldPhysics::getInstance()->addActionObject(this);
    
    setWorldTransform(_btTransform);
}

void RigidEntity::setKinematicPhysics()
{
    btTransform _btTransform = getWorldTransform();
    bool isactionObject = WorldPhysics::getInstance()->isActionObject(this);
    
    WorldPhysics::getInstance()->removeRigidBody(getRigidBody());
    if(isactionObject)
        WorldPhysics::getInstance()->removeActionObject(this);
    
    m_Mass = 0;
    
//    m_btRigidBody = WorldPhysics::getInstance()->addRigidBody(this,
//                                                              _btTransform,
//                                                              0,
//                                                              m_CollisionShapeFactoryID);
    m_btRigidBody = WorldPhysics::getInstance()->addRigidBody(this,
                                                              _btTransform,
                                                              m_Mass,
                                                              m_CollisionShapeFactoryID,
                                                              getCollisionGroup(),
                                                              getCollisionMask());
    
    if(isactionObject)
        WorldPhysics::getInstance()->addActionObject(this);
    
    if(isStaticPhysics())
    {
        getRigidBody()->setCollisionFlags(getRigidBody()->getCollisionFlags() ^ btCollisionObject::CF_STATIC_OBJECT);
    }
    getRigidBody()->setCollisionFlags(getRigidBody()->getCollisionFlags() | btCollisionObject::CF_KINEMATIC_OBJECT);
    getRigidBody()->setActivationState(DISABLE_DEACTIVATION);
    
    setWorldTransform(_btTransform);
}

void RigidEntity::setStaticPhysics()
{
    btTransform _btTransform = getWorldTransform();
    bool isactionObject = WorldPhysics::getInstance()->isActionObject(this);
    
    WorldPhysics::getInstance()->removeRigidBody(getRigidBody());
    if(isactionObject)
        WorldPhysics::getInstance()->removeActionObject(this);
    
//    m_btRigidBody = WorldPhysics::getInstance()->addRigidBody(this,
//                                                              _btTransform,
//                                                              0,
//                                                              m_CollisionShapeFactoryID);
    m_btRigidBody = WorldPhysics::getInstance()->addRigidBody(this,
                                                              _btTransform,
                                                              m_Mass,
                                                              m_CollisionShapeFactoryID,
                                                              getCollisionGroup(),
                                                              getCollisionMask());
    
    if(isactionObject)
        WorldPhysics::getInstance()->addActionObject(this);
    
    setWorldTransform(_btTransform);
}

void RigidEntity::enableCollision(const bool enable)
{
    if(enable)
    {
        if(!isCollisionEnabled())
        {
            //If i want to enable collision and collision is disabled...
            getRigidBody()->setCollisionFlags(getRigidBody()->getCollisionFlags() | btCollisionObject::CF_NO_CONTACT_RESPONSE);
        }
    }
    else
    {
        if(isCollisionEnabled())
        {
            //If I want to disable collision and collision is enabled...
            getRigidBody()->setCollisionFlags(getRigidBody()->getCollisionFlags() ^ btCollisionObject::CF_NO_CONTACT_RESPONSE);
        }
    }
}

bool RigidEntity::isCollisionEnabled()const
{
    if(getRigidBody())
    {
        if(getRigidBody()->getCollisionFlags() & btCollisionObject::CF_NO_CONTACT_RESPONSE)
            return false;
        return true;
    }
    return false;
}


void RigidEntity::enableHandleCollision(const bool enable)
{
    if(enable)
    {
        if(!isCollisionHandleEnabled())
        {
            //If i want to enable collision and collision is disabled...
            getRigidBody()->setCollisionFlags(getRigidBody()->getCollisionFlags() | btCollisionObject::CF_CUSTOM_MATERIAL_CALLBACK);
        }
    }
    else
    {
        if(isCollisionHandleEnabled())
        {
            //If I want to disable collision and collision is enabled...
            getRigidBody()->setCollisionFlags(getRigidBody()->getCollisionFlags() ^ btCollisionObject::CF_CUSTOM_MATERIAL_CALLBACK);
        }
    }
}

bool RigidEntity::isCollisionHandleEnabled()const
{
    if(getRigidBody()->getCollisionFlags() & btCollisionObject::CF_CUSTOM_MATERIAL_CALLBACK)
        return true;
    return false;
}

void RigidEntity::enableDebugDraw(const bool enable)
{
    if(enable)
    {
        if(!isEnableDebugDraw())
        {
            //If i want to enable collision and collision is disabled...
            getRigidBody()->setCollisionFlags(getRigidBody()->getCollisionFlags() | btCollisionObject::CF_DISABLE_VISUALIZE_OBJECT);
        }
    }
    else
    {
        if(isEnableDebugDraw())
        {
            //If I want to disable collision and collision is enabled...
            getRigidBody()->setCollisionFlags(getRigidBody()->getCollisionFlags() ^ btCollisionObject::CF_DISABLE_VISUALIZE_OBJECT);
        }
    }
}

bool RigidEntity::isEnableDebugDraw()const
{
    if(getRigidBody()->getCollisionFlags() & btCollisionObject::CF_DISABLE_VISUALIZE_OBJECT)
        return false;
    return true;
}

btTransform RigidEntity::getWorldTransform() const
{
    btTransform _btTransform(btTransform::getIdentity());
    
    getRigidBody()->getMotionState()->getWorldTransform(_btTransform);
    
    _btTransform.setBasis(_btTransform.getBasis().scaled(getScale()));
    
    return _btTransform;
}
void RigidEntity::setWorldTransform(const btTransform& worldTrans)
{
    btAssert(!isStaticPhysics());
    
    BaseEntity::setWorldTransform(worldTrans);
    getRigidBody()->getMotionState()->setWorldTransform(worldTrans);
}

const btCollisionShape*	RigidEntity::getCollisionShape() const
{
    btCollisionShapeWrapper *pbtCollisionShapeWrapper = CollisionShapeFactory::getInstance()->get(m_CollisionShapeFactoryID);
    return pbtCollisionShapeWrapper->m_btCollisionShape;
}
btCollisionShape*	RigidEntity::getCollisionShape()
{
    btCollisionShapeWrapper *pbtCollisionShapeWrapper = CollisionShapeFactory::getInstance()->get(m_CollisionShapeFactoryID);
    return pbtCollisionShapeWrapper->m_btCollisionShape;
}
void RigidEntity::setCollisionShape(const IDType ID)
{
    m_CollisionShapeFactoryID = ID;
    
    if(isDynamicPhysics())
    {
        setDynamicPhysics();
    }
    else if (isStaticPhysics())
    {
        setStaticPhysics();
    }
    else if(isKinematicPhysics())
    {
        setKinematicPhysics();
    }
    else
    {
        btAssert(true);
    }
}

btScalar RigidEntity::getMass()const
{
    return m_Mass;
}

void RigidEntity::setMass(const btScalar mass)
{
    btAssert(!isStaticPhysics());
    btAssert(!isKinematicPhysics());
    btAssert(mass > 0);
    
    m_Mass = mass;
    
    btTransform _btTransform = getWorldTransform();
    bool isactionObject = WorldPhysics::getInstance()->isActionObject(this);
    
    WorldPhysics::getInstance()->removeRigidBody(getRigidBody());
    if(isactionObject)
        WorldPhysics::getInstance()->removeActionObject(this);
    
//    m_btRigidBody = WorldPhysics::getInstance()->addRigidBody(this,
//                                                              _btTransform,
//                                                              m_Mass,
//                                                              m_CollisionShapeFactoryID);
    m_btRigidBody = WorldPhysics::getInstance()->addRigidBody(this,
                                                              _btTransform,
                                                              m_Mass,
                                                              m_CollisionShapeFactoryID,
                                                              getCollisionGroup(),
                                                              getCollisionMask());
    
    if(isactionObject)
        WorldPhysics::getInstance()->addActionObject(this);
    
    setWorldTransform(_btTransform);
}
btScalar RigidEntity::getLinearSpeed()const
{
    return getRigidBody()->getLinearVelocity().length();
}
btScalar RigidEntity::getLinearSpeedSq()const
{
    return getRigidBody()->getLinearVelocity().length2();
}

btScalar RigidEntity::getAngularSpeed()const
{
    return getRigidBody()->getAngularVelocity().length();
}
btScalar RigidEntity::getAngularSpeedSq()const
{
    return getRigidBody()->getAngularVelocity().length2();
}

void RigidEntity::setLinearSpeed(const btScalar speed)
{
    getRigidBody()->setLinearVelocity(getRigidBody()->getLinearVelocity().normalized() * fabs(speed));
}
void RigidEntity::setAngularSpeed(const btScalar speed)
{
    getRigidBody()->setAngularVelocity(getRigidBody()->getAngularVelocity().normalized() * fabs(speed));
}

btVector3 RigidEntity::getLinearVelocityHeading()const
{
    btVector3 heading(getRigidBody()->getLinearVelocity());
    
    if(heading.isZero())
        return getHeadingVector();
    
    return heading.normalized();
}

void RigidEntity::setCollisionMask(CollisionMask mask)
{
    btAssert(mask >= 0 && mask <= 0xFF);
    
//    btTransform _btTransform = getWorldTransform();
//    bool isactionObject = WorldPhysics::getInstance()->isActionObject(this);
//    
//    WorldPhysics::getInstance()->removeRigidBody(getRigidBody());
//    if(isactionObject)
//        WorldPhysics::getInstance()->removeActionObject(this);
//    
//    m_btRigidBody = WorldPhysics::getInstance()->addRigidBody(this,
//                                                              _btTransform,
//                                                              m_Mass,
//                                                              m_CollisionShapeFactoryID,
//                                                              getCollisionGroup(),
//                                                              (short)mask);
//    if(isactionObject)
//        WorldPhysics::getInstance()->addActionObject(this);
//    
//    setWorldTransform(_btTransform);
    
    if(getRigidBody()->getBroadphaseProxy())
        getRigidBody()->getBroadphaseProxy()->m_collisionFilterMask = (short)mask;
}
CollisionMask RigidEntity::getCollisionMask()const
{
    if(getRigidBody()->getBroadphaseProxy())
        return (CollisionMask)getRigidBody()->getBroadphaseProxy()->m_collisionFilterMask;
    return CollisionMask_ALL;
}

void RigidEntity::enableCollisionMask(CollisionMask mask, bool enable)
{
    short currentMask = getCollisionMask();
    short _mask = (CollisionMask)mask;
    
    if(enable)
    {
        if(!hasCollisionMask(mask))
        {
            setCollisionMask((CollisionMask) (currentMask | _mask));
        }
    }
    else
    {
        if(hasCollisionMask(mask))
        {
            setCollisionMask((CollisionMask) (currentMask ^ _mask));
        }
    }
}

bool RigidEntity::hasCollisionMask(CollisionMask mask)const
{
    if(getCollisionMask() & mask)
        return false;
    return true;
}

void RigidEntity::setCollisionGroup(CollisionMask group)
{
    btAssert(group >= 0 && group <= 0xFF);
    
//    btTransform _btTransform = getWorldTransform();
//    bool isactionObject = WorldPhysics::getInstance()->isActionObject(this);
//    
//    WorldPhysics::getInstance()->removeRigidBody(getRigidBody());
//    if(isactionObject)
//        WorldPhysics::getInstance()->removeActionObject(this);
//    
//    m_btRigidBody = WorldPhysics::getInstance()->addRigidBody(this,
//                                                              _btTransform,
//                                                              m_Mass,
//                                                              m_CollisionShapeFactoryID,
//                                                              group,
//                                                              getCollisionMask());
//    if(isactionObject)
//        WorldPhysics::getInstance()->addActionObject(this);
//    
//    setWorldTransform(_btTransform);
    
    if(getRigidBody()->getBroadphaseProxy())
        getRigidBody()->getBroadphaseProxy()->m_collisionFilterGroup = (short)group;
}
CollisionMask RigidEntity::getCollisionGroup()const
{
    if(getRigidBody()->getBroadphaseProxy())
        return (CollisionMask)getRigidBody()->getBroadphaseProxy()->m_collisionFilterGroup;
    return CollisionMask_ALL;
}

void RigidEntity::enableCollisionGroup(CollisionMask group, bool enable)
{
    short currentGroup = getCollisionGroup();
    short _group = (CollisionMask)group;
    
    if(enable)
    {
        if(!hasCollisionGroup(group))
        {
            setCollisionGroup((CollisionMask) (currentGroup | _group));
        }
    }
    else
    {
        if(hasCollisionGroup(group))
        {
            setCollisionGroup((CollisionMask) (currentGroup ^ _group));
        }
    }
}

bool RigidEntity::hasCollisionGroup(CollisionMask mask)const
{
    if(getCollisionGroup() & mask)
        return false;
    return true;
}

bool RigidEntity::isMaskInGroup(CollisionMask group, CollisionMask mask)
{
    return (group & mask)?true:false;
}



