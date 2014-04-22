//
//  SoftEntity.mm
//  GameAsteroids
//
//  Created by James Folk on 7/6/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "SoftEntity.h"
#include "WorldPhysics.h"
#include "VertexBufferObject.h"

/*
 the steering behavior is attached to the motionstate. thus the motion state must not be
 null if there is going to be a steering behavior.
 */
SoftEntity::SoftEntity( const SoftEntityInfo& constructionInfo) :
BaseEntity(constructionInfo),
m_btSoftBody(NULL),
//m_CollisionShapeFactoryID(constructionInfo.m_collisionShapeFactoryID),
m_Mass(constructionInfo.m_mass)
{
    btTransform initialTransform(btTransform::getIdentity());
    if(getVertexBufferObject())
        initialTransform = getVertexBufferObject()->getInitialTransform();
    
    m_btSoftBody = WorldPhysics::getInstance()->addSoftBody(this,
                                                            initialTransform,
                                                            m_Mass);
    
    //getSoftBody()->setCollisionFlags(0);
    
    btAssert(m_btSoftBody);
}

SoftEntity::SoftEntity() :
BaseEntity(),
m_btSoftBody(NULL),
m_Mass(0)
{
    btAssert(true);
    //:!!!:NEED TO IMPLEMENT
    
}
SoftEntity::~SoftEntity()
{
    WorldPhysics::getInstance()->removeSoftBody(getSoftBody());
    m_btSoftBody = NULL;
}

void SoftEntity::updateAction( btCollisionWorld* collisionWorld, btScalar deltaTimeStep)
{
    BaseEntity::updateAction(collisionWorld, deltaTimeStep);
}

void SoftEntity::debugDraw(btIDebugDraw* debugDrawer)
{
    if(getVertexBufferObject())
    {
        btVector3 maxAabb =  getOrigin() + getVertexBufferObject()->getHalfExtends();
        btVector3 minAabb = getOrigin() - getVertexBufferObject()->getHalfExtends();
        btVector3 colorvec(1,1,1);
        
        debugDrawer->drawAabb(minAabb, maxAabb, colorvec);
    }
}

void SoftEntity::setOrigin(const btVector3 &pos)
{
//    BaseEntity::setOrigin(pos);
//    
//    btTransform transform = getSoftBody()->getCenterOfMassTransform();
//    transform.setOrigin(pos);
//    getSoftBody()->setCenterOfMassTransform(transform);
}

void SoftEntity::setRotation(const btQuaternion &rot)
{
//    BaseEntity::setRotation(rot);
//    
//    btTransform transform = getSoftBody()->getCenterOfMassTransform();
//    transform.setRotation(rot.inverse());
//    getSoftBody()->setCenterOfMassTransform(transform);
}

void SoftEntity::lookAt(const btVector3 &pos)
{
//    BaseEntity::lookAt(pos);
//    getSoftBody()->clearForces();
}

bool SoftEntity::setScale(const btVector3 &scale)
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

void SoftEntity::setDynamicPhysics()
{
    btTransform _btTransform = getWorldTransform();
    bool isactionObject = WorldPhysics::getInstance()->isActionObject(this);
    
    WorldPhysics::getInstance()->removeSoftBody(getSoftBody());
    if(isactionObject)
        WorldPhysics::getInstance()->removeActionObject(this);
    
    m_btSoftBody = WorldPhysics::getInstance()->addSoftBody(this,
                                                            _btTransform,
                                                            m_Mass);
    if(isactionObject)
        WorldPhysics::getInstance()->addActionObject(this);
    
    setWorldTransform(_btTransform);
}

void SoftEntity::setKinematicPhysics()
{
    btTransform _btTransform = getWorldTransform();
    bool isactionObject = WorldPhysics::getInstance()->isActionObject(this);
    
    WorldPhysics::getInstance()->removeSoftBody(getSoftBody());
    if(isactionObject)
        WorldPhysics::getInstance()->removeActionObject(this);
    
    m_btSoftBody = WorldPhysics::getInstance()->addSoftBody(this,
                                                            _btTransform,
                                                            0);
    if(isactionObject)
        WorldPhysics::getInstance()->addActionObject(this);
    
    getSoftBody()->setCollisionFlags(getSoftBody()->getCollisionFlags() | btCollisionObject::CF_KINEMATIC_OBJECT);
    getSoftBody()->setActivationState(DISABLE_DEACTIVATION);
    
    setWorldTransform(_btTransform);
}

void SoftEntity::setStaticPhysics()
{
    btTransform _btTransform = getWorldTransform();
    bool isactionObject = WorldPhysics::getInstance()->isActionObject(this);
    
    WorldPhysics::getInstance()->removeSoftBody(getSoftBody());
    if(isactionObject)
        WorldPhysics::getInstance()->removeActionObject(this);
    
    m_btSoftBody = WorldPhysics::getInstance()->addSoftBody(this,
                                                            _btTransform,
                                                            0);
    if(isactionObject)
        WorldPhysics::getInstance()->addActionObject(this);
    
    setWorldTransform(_btTransform);
}

void SoftEntity::enableCollision(const bool enable)
{
    if(enable)
    {
        if(!isCollisionEnabled())
        {
            //If i want to enable collision and collision is disabled...
            getSoftBody()->setCollisionFlags(getSoftBody()->getCollisionFlags() | btCollisionObject::CF_NO_CONTACT_RESPONSE);
        }
    }
    else
    {
        if(isCollisionEnabled())
        {
            //If I want to disable collision and collision is enabled...
            getSoftBody()->setCollisionFlags(getSoftBody()->getCollisionFlags() ^ btCollisionObject::CF_NO_CONTACT_RESPONSE);
        }
    }
}

bool SoftEntity::isCollisionEnabled()const
{
    if(getSoftBody())
    {
        if(getSoftBody()->getCollisionFlags() & btCollisionObject::CF_NO_CONTACT_RESPONSE)
            return false;
        return true;
    }
    return false;
}


void SoftEntity::enableHandleCollision(const bool enable)
{
    if(enable)
    {
        if(!isCollisionHandleEnabled())
        {
            //If i want to enable collision and collision is disabled...
            getSoftBody()->setCollisionFlags(getSoftBody()->getCollisionFlags() | btCollisionObject::CF_CUSTOM_MATERIAL_CALLBACK);
        }
    }
    else
    {
        if(isCollisionHandleEnabled())
        {
            //If I want to disable collision and collision is enabled...
            getSoftBody()->setCollisionFlags(getSoftBody()->getCollisionFlags() ^ btCollisionObject::CF_CUSTOM_MATERIAL_CALLBACK);
        }
    }
}

bool SoftEntity::isCollisionHandleEnabled()const
{
    if(getSoftBody()->getCollisionFlags() & btCollisionObject::CF_CUSTOM_MATERIAL_CALLBACK)
        return true;
    return false;
}

btTransform SoftEntity::getWorldTransform() const
{
//    btTransform _btTransform(getSoftBody()->getWorldTransform());
//    
//    _btTransform.setBasis(_btTransform.getBasis().scaled(getScale()));
//    
//    
//    return _btTransform;
    return btTransform::getIdentity();
    

}
void SoftEntity::setWorldTransform(const btTransform& worldTrans)
{
    BaseEntity::setWorldTransform(worldTrans);
    getSoftBody()->setWorldTransform(BaseEntity::getWorldTransform());
    getSoftBody()->transform(BaseEntity::getWorldTransform());
    
    DebugString::log("soft body trans: " + DebugString::btTransformStr(worldTrans));
}

/*
 int numFaces = sBody->m_faces.size();
 for (int i=0; i< numFaces; i++)
 {
 btSoftBody::Node*   node_0=sBody->m_faces[i].m_n[0];
 btSoftBody::Node*    node_1=sBody->m_faces[i].m_n[1];
 btSoftBody::Node*   node_2=sBody->m_faces[i].m_n[2];
 
 btVector3 p0;
 p0 = node_0->m_x;
 btVector3 p1;
 p1 = node_1->m_x;
 btVector3 p2;
 p2 = node_2->m_x;
 
 
 //Calculate the normals for the 2 triangles and add on
 btVector3 tpt1, tpt2;
 tpt1 = p1-p0;
 tpt2 = p2-p0;
 btVector3 normal= tpt1.cross(tpt2);
 */
void SoftEntity::render(BaseCamera *pCamera)
{
    struct myclass
    {
        btSoftBody *pSoftBody;
        
        void operator() (int idx,
                         btVector3 *v1,
                         btVector3 *v2,
                         btVector3 *v3,
                         btVector3 *n1 = NULL,
                         btVector3 *n2 = NULL,
                         btVector3 *n3 = NULL)
        {
            if(idx < pSoftBody->m_faces.size())
            {
                btSoftBody::Node*   node_0=pSoftBody->m_faces[idx].m_n[0];
                btSoftBody::Node*    node_1=pSoftBody->m_faces[idx].m_n[1];
                btSoftBody::Node*   node_2=pSoftBody->m_faces[idx].m_n[2];
                
    //            v1->setValue(node_0->m_x.x() - node_0->m_q.x(),
    //                         node_0->m_x.y() - node_0->m_q.y(),
    //                         node_0->m_x.z() - node_0->m_q.z());
    //            v2->setValue(node_1->m_x.x() - node_1->m_q.x(),
    //                         node_1->m_x.y() - node_1->m_q.y(),
    //                         node_1->m_x.z() - node_1->m_q.z());
    //            v3->setValue(node_2->m_x.x() - node_2->m_q.x(),
    //                         node_2->m_x.y() - node_2->m_q.y(),
    //                         node_2->m_x.z() - node_2->m_q.z());
                
                *v1 = node_0->m_x;
                *v2 = node_1->m_x;
                *v3 = node_2->m_x;
                
                if(n1)
                    *n1 = node_0->m_n;
                if(n2)
                    *n2 = node_1->m_n;
                if(n3)
                    *n3 = node_2->m_n;
            }
        }
    } myobject;
    
    myobject.pSoftBody = m_btSoftBody;
    
    getVertexBufferObject()->set_each_triangle<myclass>(myobject);
    
    
    
    
//    BaseEntity::render(pCamera);
}


//void SoftEntity::handleRigidBodyCollide(BaseEntity *pOtherEntity, const btManifoldPoint&pt)
//{
//    //DebugString::log("RIGID BODY - RIGID BODY\n" + DebugString::btManifoldPointStr(pt) + "\n");
//}
//void SoftEntity::handleGhostBodyCollide(GhostEntity *pOtherEntity, const btManifoldPoint &pt)
//{
//    //DebugString::log("RIGID BODY - GHOST\n" + DebugString::btManifoldPointStr(pt) + "\n");
//}
//
//void SoftEntity::handleCollisionNear(BaseEntity *pOtherEntity, btScalar timeOfImpact)
//{
//}




btScalar SoftEntity::getLinearSpeed()const
{
    //return getSoftBody()->getLinearVelocity().length();
}
btScalar SoftEntity::getLinearSpeedSq()const
{
    //return getSoftBody()->getLinearVelocity().length2();
}

btScalar SoftEntity::getAngularSpeed()const
{
    //return getSoftBody()->getAngularVelocity().length();
}
btScalar SoftEntity::getAngularSpeedSq()const
{
    //return getSoftBody()->getAngularVelocity().length2();
}

void SoftEntity::setLinearSpeed(const btScalar speed)
{
    //getSoftBody()->setLinearVelocity(getSoftBody()->getLinearVelocity().normalized() * fabs(speed));
}
void SoftEntity::setAngularSpeed(const btScalar speed)
{
    //getSoftBody()->setAngularVelocity(getSoftBody()->getAngularVelocity().normalized() * fabs(speed));
}

btVector3 SoftEntity::getLinearVelocityHeading()const
{
//    btVector3 heading(getSoftBody()->getLinearVelocity());
//    
//    if(heading.isZero())
//        return getHeadingVector();
//    
//    return heading.normalized();
}