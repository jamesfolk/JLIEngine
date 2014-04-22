//
//  SwitchToEvadeCollisionResponseBehavior.cpp
//  MazeADay
//
//  Created by James Folk on 1/25/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#include "SwitchToEvadeCollisionResponseBehavior.h"

#include "btManifoldPoint.h"
#include "BaseEntity.h"
#include "SteeringEntity.h"

#include "GlobalGameJamGame.h"

SwitchToEvadeCollisionResponseBehavior::SwitchToEvadeCollisionResponseBehavior(const SwitchToEvadeCollisionResponseBehaviorInfo& constructionInfo) :
BaseCollisionResponseBehavior(constructionInfo)
{
    
}

SwitchToEvadeCollisionResponseBehavior::~SwitchToEvadeCollisionResponseBehavior()
{
    
}

#include "UpdateBehaviorFactory.h"
#include "ObjectUpdateBehavior.h"

void SwitchToEvadeCollisionResponseBehavior::respond(BaseEntity *pOtherEntity, const btManifoldPoint &pt)
{
    m_pOtherEntity = pOtherEntity;
    
    SteeringEntity *pSteeringEntity = dynamic_cast<SteeringEntity*>(m_pOtherEntity);
    if(pSteeringEntity)
    {
        if (pSteeringEntity->getSteeringBehavior()->isPursuitOn())
        {
            pSteeringEntity->playSoundEffect("laser");
            
            ObjectUpdateBehaviorInfo *cinfo = new ObjectUpdateBehaviorInfo();
            IDType updatebehavior = UpdateBehaviorFactory::getInstance()->create(cinfo);
            delete cinfo;
            
            ObjectUpdateBehavior *o = dynamic_cast<ObjectUpdateBehavior*>(UpdateBehaviorFactory::getInstance()->get(updatebehavior));
            
            o->startTimer();
            
            pSteeringEntity->setUpdateBehavior(updatebehavior);
            
            pSteeringEntity->getSteeringBehavior()->PursuitOff();
            pSteeringEntity->getRigidBody()->setLinearVelocity(btVector3(0, 0, 0));
            pSteeringEntity->getSteeringBehavior()->setLinearFactor(btVector3(0,0,0));
            pSteeringEntity->setVBOID(GlobalGameJamGame::sphereViewObjectID);
        }
        

    }
    
}

const BaseEntity *SwitchToEvadeCollisionResponseBehavior::getOtherEntity()const
{
    return m_pOtherEntity;
}