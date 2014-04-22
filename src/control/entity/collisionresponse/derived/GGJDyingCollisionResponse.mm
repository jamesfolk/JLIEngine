//
//  GGJDyingCollisionResponse.cpp
//  MazeADay
//
//  Created by James Folk on 1/26/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#include "GGJDyingCollisionResponse.h"

#include "btManifoldPoint.h"
#include "BaseEntity.h"
#include "SteeringEntity.h"

#include "GlobalGameJamGame.h"

GGJDyingCollisionResponseBehavior::GGJDyingCollisionResponseBehavior(const GGJDyingCollisionResponseBehaviorInfo& constructionInfo) :
BaseCollisionResponseBehavior(constructionInfo)
{
    
}

GGJDyingCollisionResponseBehavior::~GGJDyingCollisionResponseBehavior()
{
    
}

void GGJDyingCollisionResponseBehavior::respond(BaseEntity *pOtherEntity, const btManifoldPoint &pt)
{
    m_pOtherEntity = pOtherEntity;
    
    SteeringEntity *pSteeringEntity = dynamic_cast<SteeringEntity*>(m_pOtherEntity);
    if(pSteeringEntity)
    {
        pSteeringEntity->getSteeringBehavior()->setLinearFactor(btVector3(0,0,0));
        pSteeringEntity->setVBOID(GlobalGameJamGame::sphereViewObjectID);
    }
    
}

const BaseEntity *GGJDyingCollisionResponseBehavior::getOtherEntity()const
{
    return m_pOtherEntity;
}