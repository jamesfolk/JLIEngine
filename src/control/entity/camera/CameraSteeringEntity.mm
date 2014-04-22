//
//  CameraSteeringEntity.cpp
//  GameAsteroids
//
//  Created by James Folk on 4/11/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "CameraSteeringEntity.h"
#include "EntityStateMachine.h"
#include "BaseEntityAnimationController.h"


void CameraSteeringEntity::updateAction( btCollisionWorld* collisionWorld, btScalar deltaTimeStep)
{
    BaseCamera::updateAction(collisionWorld, deltaTimeStep);
    SteeringEntity::updateAction(collisionWorld, deltaTimeStep);
}

void CameraSteeringEntity::debugDraw(btIDebugDraw* debugDrawer)
{
    BaseCamera::debugDraw(debugDrawer);
    SteeringEntity::debugDraw(debugDrawer);
}

btVector3 CameraSteeringEntity::getHeadingVector()const
{
    return SteeringEntity::getHeadingVector();
}

btVector3 CameraSteeringEntity::getUpVector()const
{
    return SteeringEntity::getUpVector();
}
btVector3 CameraSteeringEntity::getSideVector()const
{
    return SteeringEntity::getSideVector();
}
btVector3 CameraSteeringEntity::getOrigin()const
{
    return getWorldTransform().getOrigin();
}

void CameraSteeringEntity::setOrigin(const btVector3 &pos)
{
    BaseCamera::setOrigin(pos);
    SteeringEntity::setOrigin(pos);
}

btQuaternion CameraSteeringEntity::getRotation()const
{
    return SteeringEntity::getRotation();
}

void CameraSteeringEntity::setRotation(const btQuaternion &rot)
{
    BaseCamera::setRotation(rot);
    SteeringEntity::setRotation(rot);
}

//void CameraSteeringEntity::setHeadingVector(const btVector3 &vec)
//{
//    BaseCamera::setHeadingVector(vec);
//    SteeringEntity::setHeadingVector(vec);
//}

void CameraSteeringEntity::lookAt(const btVector3 &pos, const btVector3 &up)
{
    BaseEntity::lookAt(pos, up);
}

//void CameraSteeringEntity::rotateHeader(const btQuaternion &rot)
//{
//    SteeringEntity::rotateHeader(rot);
//}

btTransform CameraSteeringEntity::getWorldTransform() const
{
    return SteeringEntity::getWorldTransform();
}

void CameraSteeringEntity::setWorldTransform(const btTransform& worldTrans)
{
    SteeringEntity::setWorldTransform(worldTrans);
}

CameraSteeringEntity::CameraSteeringEntity() :
BaseCamera(),
SteeringEntity()
{
    
}

CameraSteeringEntity::CameraSteeringEntity( const CameraSteeringEntityInfo& constructionInfo) :
BaseCamera(constructionInfo),
SteeringEntity(constructionInfo)
{
    if(getAnimationController())
        getAnimationController()->setOwner(this);
    
    if(getStateMachine())
        getStateMachine()->setOwner(this);
}
CameraSteeringEntity::~CameraSteeringEntity()
{
}