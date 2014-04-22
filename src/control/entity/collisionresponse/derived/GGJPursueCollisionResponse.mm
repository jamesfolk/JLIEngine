//
//  GGJPursueCollisionResponse.cpp
//  MazeADay
//
//  Created by James Folk on 1/26/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#include "GGJPursueCollisionResponse.h"

#include "btManifoldPoint.h"
#include "BaseEntity.h"
#include "SteeringEntity.h"

#include "GlobalGameJamGame.h"

GGJPursueCollisionResponseBehavior::GGJPursueCollisionResponseBehavior(const GGJPursueCollisionResponseBehaviorInfo& constructionInfo) :
BaseCollisionResponseBehavior(constructionInfo)
{
    
}

GGJPursueCollisionResponseBehavior::~GGJPursueCollisionResponseBehavior()
{
    
}

void GGJPursueCollisionResponseBehavior::respond(BaseEntity *pOtherEntity, const btManifoldPoint &pt)
{
    
    m_pOtherEntity = pOtherEntity;
    
    SteeringEntity *pSteeringEntity = dynamic_cast<SteeringEntity*>(getOwner());
    if(pSteeringEntity)
    {
        RigidEntity *cam = dynamic_cast<RigidEntity*>(EntityFactory::getInstance()->get(GlobalGameJamGame::cameraPlayerID));
        
        pSteeringEntity->getSteeringBehavior()->setPursuitOn(cam);
        
        pSteeringEntity->setMaxLinearForce(10.f);
        pSteeringEntity->setMaxLinearSpeed(10.f);
        
        pSteeringEntity->setCollisionResponseBehavior(0);
//        pSteeringEntity->getSteeringBehavior()->setLinearFactor(btVector3(0,0,0));
//        pSteeringEntity->setVBOID(GlobalGameJamGame::sphereViewObjectID);
    }
    
}

const BaseEntity *GGJPursueCollisionResponseBehavior::getOtherEntity()const
{
    return m_pOtherEntity;
}