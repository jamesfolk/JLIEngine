//
//  CameraEntity.cpp
//  GameAsteroids
//
//  Created by James Folk on 3/12/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "CameraEntity.h"
#include "btTransform.h"
#include "btMatrix3x3.h"
#include "btVector3.h"

#include "UtilityFunctions.h"
#include "CameraFactory.h"

#include "EntityStateMachine.h"
#include "BaseEntityAnimationController.h"

BaseCamera *CameraEntity::create(int type)
{
    //return dynamic_cast<CameraEntity*>(CameraFactory::getInstance()->createObject(type));
    return CameraFactory::getInstance()->createObject(type);
}

bool CameraEntity::destroy(IDType &_id)
{
    return CameraFactory::getInstance()->destroy(_id);
}

bool CameraEntity::destroy(BaseCamera *entity)
{
    bool ret = false;
    if(entity)
    {
        IDType _id = entity->getID();
        ret = CameraEntity::destroy(_id);
    }
    entity = NULL;
    return ret;
}

BaseCamera *CameraEntity::get(IDType _id)
{
    return CameraFactory::getInstance()->get(_id);
}

void CameraEntity::updateAction( btCollisionWorld* collisionWorld, btScalar deltaTimeStep)
{
    BaseCamera::updateAction(collisionWorld, deltaTimeStep);
    BaseEntity::updateAction(collisionWorld, deltaTimeStep);
}

void CameraEntity::debugDraw(btIDebugDraw* debugDrawer)
{
    BaseCamera::debugDraw(debugDrawer);
    BaseEntity::debugDraw(debugDrawer);
}

btVector3 CameraEntity::getHeadingVector()const
{
    return BaseEntity::getHeadingVector();
}

btVector3 CameraEntity::getUpVector()const
{
    return BaseEntity::getUpVector();
}
btVector3 CameraEntity::getSideVector()const
{
    return BaseEntity::getSideVector();
}
btVector3 CameraEntity::getOrigin()const
{
    return getWorldTransform().getOrigin();
}

void CameraEntity::setOrigin(const btVector3 &pos)
{
    BaseCamera::setOrigin(pos);
    BaseEntity::setOrigin(pos);
}

btQuaternion CameraEntity::getRotation()const
{
    return BaseEntity::getRotation();
    //return getWorldTransform().getRotation();
}
void CameraEntity::setRotation(const btQuaternion &rot)
{
    BaseCamera::setRotation(rot);
    BaseEntity::setRotation(rot);
}

//void CameraEntity::setHeadingVector(const btVector3 &vec)
//{
//    BaseCamera::setHeadingVector(vec);
//    BaseEntity::setHeadingVector(vec);
//}

void CameraEntity::lookAt(const btVector3 &pos, const btVector3 &up)
{
    BaseEntity::lookAt(pos, up);
}

//void CameraEntity::rotateHeader(const btQuaternion &rot)
//{
//    BaseEntity::rotateHeader(rot);
//}

btTransform CameraEntity::getWorldTransform() const
{
    return BaseEntity::getWorldTransform();
}

void CameraEntity::setWorldTransform(const btTransform& worldTrans)
{
    BaseEntity::setWorldTransform(worldTrans);
}

CameraEntity::CameraEntity() :
BaseCamera(),
BaseEntity()
{
    
}

CameraEntity::CameraEntity( const CameraEntityInfo& constructionInfo) :
BaseCamera(constructionInfo),
BaseEntity(constructionInfo)
{
    if(getAnimationController())
        getAnimationController()->setOwner(this);
    
    if(getStateMachine())
        getStateMachine()->setOwner(this);
}
CameraEntity::~CameraEntity()
{
}
