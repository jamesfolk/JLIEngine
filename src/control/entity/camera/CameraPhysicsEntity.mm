//
//  CameraPhysicsEntity.cpp
//  GameAsteroids
//
//  Created by James Folk on 3/29/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "CameraPhysicsEntity.h"
#include "EntityStateMachine.h"
#include "BaseEntityAnimationController.h"

void CameraPhysicsEntity::updateAction( btCollisionWorld* collisionWorld, btScalar deltaTimeStep)
{
    BaseCamera::updateAction(collisionWorld, deltaTimeStep);
    RigidEntity::updateAction(collisionWorld, deltaTimeStep);
}

void CameraPhysicsEntity::debugDraw(btIDebugDraw* debugDrawer)
{
    BaseCamera::debugDraw(debugDrawer);
    RigidEntity::debugDraw(debugDrawer);
}

btVector3 CameraPhysicsEntity::getHeadingVector()const
{
    return RigidEntity::getHeadingVector();
}

btVector3 CameraPhysicsEntity::getUpVector()const
{
    return RigidEntity::getUpVector();
}
btVector3 CameraPhysicsEntity::getSideVector()const
{
    return RigidEntity::getSideVector();
}
btVector3 CameraPhysicsEntity::getOrigin()const
{
    return getWorldTransform().getOrigin();
}

void CameraPhysicsEntity::setOrigin(const btVector3 &pos)
{
    BaseCamera::setOrigin(pos);
    RigidEntity::setOrigin(pos);
}

btQuaternion CameraPhysicsEntity::getRotation()const
{
    return RigidEntity::getRotation();
    //return getWorldTransform().getRotation();
}

void CameraPhysicsEntity::setRotation(const btQuaternion &rot)
{
    BaseCamera::setRotation(rot);
    RigidEntity::setRotation(rot);
}

//void CameraPhysicsEntity::setHeadingVector(const btVector3 &vec)
//{
//    BaseCamera::setHeadingVector(vec);
//    RigidEntity::setHeadingVector(vec);
//}

void CameraPhysicsEntity::lookAt(const btVector3 &pos, const btVector3 &up)
{
    BaseEntity::lookAt(pos, up);
}

//void CameraPhysicsEntity::rotateHeader(const btQuaternion &rot)
//{
//    RigidEntity::rotateHeader(rot);
//}

btTransform CameraPhysicsEntity::getWorldTransform() const
{
    return RigidEntity::getWorldTransform();
}

void CameraPhysicsEntity::setWorldTransform(const btTransform& worldTrans)
{
    RigidEntity::setWorldTransform(worldTrans);
}

void CameraPhysicsEntity::enableCollision(const bool enable)
{
    RigidEntity::enableCollision(enable);
}

bool CameraPhysicsEntity::isCollisionEnabled()const
{
    return RigidEntity::isCollisionEnabled();
}

CameraPhysicsEntity::CameraPhysicsEntity() :
BaseCamera(),
RigidEntity()
{
    
}

CameraPhysicsEntity::CameraPhysicsEntity( const CameraPhysicsEntityInfo& constructionInfo) :
BaseCamera(constructionInfo),
RigidEntity(constructionInfo)//,
//m_CameraPhysicsEntityInfo(constructionInfo)
{
    if(getAnimationController())
        getAnimationController()->setOwner(this);
    
    if(getStateMachine())
        getStateMachine()->setOwner(this);
}
CameraPhysicsEntity::~CameraPhysicsEntity()
{
}