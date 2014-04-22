//
//  GhostEntity.cpp
//  GameAsteroids
//
//  Created by James Folk on 4/17/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "GhostEntity.h"

#include "WorldPhysics.h"

#include "EntityStateMachine.h"

#include "BaseViewObject.h"

#include "BaseEntityAnimationController.h"

#include "VertexBufferObject.h"

GhostEntity::GhostEntity(const GhostEntityInfo& constructionInfo) :
BaseEntity(constructionInfo),
m_btPairCachingGhostObject(NULL),
m_CollisionShapeID(constructionInfo.m_collisionShapeFactoryID),
m_CollisionEnabled(true)
{
    m_btPairCachingGhostObject = WorldPhysics::getInstance()->addGhostObject(this, m_CollisionShapeID);
    
    btAssert(m_btPairCachingGhostObject);
    
    if(getStateMachine())
        getStateMachine()->setOwner(this);
    
    if(getAnimationController())
        getAnimationController()->setOwner(this);
    
//    if(getVBO())
//        setWorldTransform(getVBO()->getInitialTransform());
    if(getVertexBufferObject())
        setWorldTransform(getVertexBufferObject()->getInitialTransform());
}

GhostEntity::GhostEntity() :
BaseEntity(),
m_btPairCachingGhostObject(NULL),
m_CollisionShapeID(0),
m_CollisionEnabled(false)
{
    
}
GhostEntity::~GhostEntity()
{
    WorldPhysics::getInstance()->removeGhostObject(m_btPairCachingGhostObject);
    m_btPairCachingGhostObject = NULL;
}

void GhostEntity::setup(IDType collisionShapeID, const btTransform &initialTransform)
{
    btAssert(collisionShapeID > 0);
    
    if(m_btPairCachingGhostObject)
    {
        WorldPhysics::getInstance()->removeGhostObject(m_btPairCachingGhostObject);
    }
    m_CollisionShapeID = collisionShapeID;
    
    m_btPairCachingGhostObject = WorldPhysics::getInstance()->addGhostObject(this, m_CollisionShapeID);
    
    setWorldTransform(initialTransform);
}

void GhostEntity::updateAction( btCollisionWorld* collisionWorld, btScalar deltaTimeStep)
{
    BaseEntity::updateAction(collisionWorld, deltaTimeStep);
}
void GhostEntity::debugDraw(btIDebugDraw* debugDrawer)
{
    if(getGhostObject())
    {
        btVector3 aabbMin, aabbMax;
        btVector3 colorvec(1,1,1);
        
        getGhostObject()->getCollisionShape()->getAabb(getWorldTransform(), aabbMin, aabbMax);
        debugDrawer->drawAabb(aabbMin, aabbMax, colorvec);
    }
}

void GhostEntity::setOrigin(const btVector3 &pos)
{
    BaseEntity::setOrigin(pos);
}
void GhostEntity::setRotation(const btQuaternion &rot)
{
    BaseEntity::setRotation(rot);
}

void GhostEntity::lookAt(const btVector3 &pos)
{
    BaseEntity::lookAt(pos);
}

bool GhostEntity::setScale(const btVector3 &scale)
{
//    switch (m_CollisionShapeType)
//    {
//        case CollisionShapeType_Cube:
//        {
//            btBoxShape *shape = dynamic_cast<btBoxShape*>(getGhostObject()->getCollisionShape());
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
//            btSphereShape *shape = dynamic_cast<btSphereShape*>(getGhostObject()->getCollisionShape());
//            BaseEntity::setScale(scale);
//            shape->setLocalScaling(getScale());
//            
//            return true;
//        }
//            break;
//        case CollisionShapeType_ConeX:
//        {
//            btConeShapeX *shape = dynamic_cast<btConeShapeX*>(getGhostObject()->getCollisionShape());
//            BaseEntity::setScale(scale);
//            shape->setLocalScaling(getScale());
//            
//            return true;
//        }
//            break;
//        case CollisionShapeType_ConeY:
//        {
//            btConeShape *shape = dynamic_cast<btConeShape*>(getGhostObject()->getCollisionShape());
//            BaseEntity::setScale(scale);
//            shape->setLocalScaling(getScale());
//            
//            return true;
//        }
//            break;
//        case CollisionShapeType_ConeZ:
//        {
//            btConeShapeZ *shape = dynamic_cast<btConeShapeZ*>(getGhostObject()->getCollisionShape());
//            BaseEntity::setScale(scale);
//            shape->setLocalScaling(getScale());
//            
//            return true;
//        }
//            break;
//        case CollisionShapeType_TriangleMesh:
//        {
//            btBvhTriangleMeshShape *shape = dynamic_cast<btBvhTriangleMeshShape*>(getGhostObject()->getCollisionShape());
//            BaseEntity::setScale(scale);
//            shape->setLocalScaling(getScale());
//            
//            return true;
//        }
//            break;
//        case CollisionShapeType_CapsuleX:
//        {
//            btCapsuleShapeX *shape = dynamic_cast<btCapsuleShapeX*>(getGhostObject()->getCollisionShape());
//            BaseEntity::setScale(scale);
//            shape->setLocalScaling(getScale());
//            
//            return true;
//        }
//            break;
//        case CollisionShapeType_CapsuleY:
//        {
//            btCapsuleShape *shape = dynamic_cast<btCapsuleShape*>(getGhostObject()->getCollisionShape());
//            BaseEntity::setScale(scale);
//            shape->setLocalScaling(getScale());
//            
//            return true;
//        }
//            break;
//        case CollisionShapeType_CapsuleZ:
//        {
//            btCapsuleShapeZ *shape = dynamic_cast<btCapsuleShapeZ*>(getGhostObject()->getCollisionShape());
//            BaseEntity::setScale(scale);
//            shape->setLocalScaling(getScale());
//            
//            return true;
//        }
//            break;
//        case CollisionShapeType_CylinderX:
//        {
//            btCylinderShapeX *shape = dynamic_cast<btCylinderShapeX*>(getGhostObject()->getCollisionShape());
//            BaseEntity::setScale(scale);
//            shape->setLocalScaling(getScale());
//            
//            return true;
//        }
//            break;
//        case CollisionShapeType_CylinderY:
//        {
//            btCylinderShape *shape = dynamic_cast<btCylinderShape*>(getGhostObject()->getCollisionShape());
//            BaseEntity::setScale(scale);
//            shape->setLocalScaling(getScale());
//            
//            return true;
//        }
//            break;
//        case CollisionShapeType_CylinderZ:
//        {
//            btCylinderShapeZ *shape = dynamic_cast<btCylinderShapeZ*>(getGhostObject()->getCollisionShape());
//            BaseEntity::setScale(scale);
//            shape->setLocalScaling(getScale());
//            
//            return true;
//        }
//            break;
//        case CollisionShapeType_ConvexHull:
//        {
//            btConvexHullShape *shape = dynamic_cast<btConvexHullShape*>(getGhostObject()->getCollisionShape());
//            BaseEntity::setScale(scale);
//            shape->setLocalScaling(getScale());
//            
//            return true;
//        }
//            break;
//            //        case CollisionShapeType_StaticPlane:
//            //        {
//            //            btStaticPlaneShape *shape = dynamic_cast<btStaticPlaneShape*>(getGhostObject()->getCollisionShape());
//            //            BaseEntity::setScale(scale);
//            //            shape->setLocalScaling(getScale());
//            //        }
//            break;
//    }
    return false;
}

//void GhostEntity::show()
//{
//    if(isHidden())
//    {
//        BaseEntity::show();
//        getGhostObject()->setCollisionFlags(getGhostObject()->getCollisionFlags() ^ btCollisionObject::CF_NO_CONTACT_RESPONSE);
//    }
//}
//
//void GhostEntity::hide()
//{
//    BaseEntity::hide();
//    getGhostObject()->setCollisionFlags(getGhostObject()->getCollisionFlags() | btCollisionObject::CF_NO_CONTACT_RESPONSE);
//}

void GhostEntity::enableCollision(const bool enable)
{
    m_CollisionEnabled = enable;
//    if(enable)
//    {
//        if(!isCollisionEnabled())
//        {
//            //If i want to enable collision and collision is disabled...
//            getGhostObject()->setCollisionFlags(getGhostObject()->getCollisionFlags() | btCollisionObject::CF_NO_CONTACT_RESPONSE);
//        }
//    }
//    else
//    {
//        if(isCollisionEnabled())
//        {
//            //If I want to disable collision and collision is enabled...
//            getGhostObject()->setCollisionFlags(getGhostObject()->getCollisionFlags() ^ btCollisionObject::CF_NO_CONTACT_RESPONSE);
//        }
//    }
}

bool GhostEntity::isCollisionEnabled()const
{
    return m_CollisionEnabled;
//    if(getGhostObject())
//    {
//        if(getGhostObject()->getCollisionFlags() & btCollisionObject::CF_NO_CONTACT_RESPONSE)
//            return false;
//        return true;
//    }
//    return false;
}

void GhostEntity::enableDebugDraw(const bool enable)
{
    if(enable)
    {
        if(!isEnableDebugDraw())
        {
            //If i want to enable collision and collision is disabled...
            getGhostObject()->setCollisionFlags(getGhostObject()->getCollisionFlags() | btCollisionObject::CF_DISABLE_VISUALIZE_OBJECT);
        }
    }
    else
    {
        if(isEnableDebugDraw())
        {
            //If I want to disable collision and collision is enabled...
            getGhostObject()->setCollisionFlags(getGhostObject()->getCollisionFlags() ^ btCollisionObject::CF_DISABLE_VISUALIZE_OBJECT);
        }
    }
}

bool GhostEntity::isEnableDebugDraw()const
{
    if(getGhostObject()->getCollisionFlags() & btCollisionObject::CF_DISABLE_VISUALIZE_OBJECT)
        return false;
    return true;
}

btTransform GhostEntity::getWorldTransform() const
{
    btTransform _btTransform(getGhostObject()->getWorldTransform());
    
    _btTransform.setBasis(_btTransform.getBasis().scaled(getScale()));
    
    return _btTransform;
}
void GhostEntity::setWorldTransform(const btTransform& worldTrans)
{
    BaseEntity::setWorldTransform(worldTrans);
    getGhostObject()->setWorldTransform(BaseEntity::getWorldTransform());
    
    
}