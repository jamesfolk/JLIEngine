//
//  PlayerCollisionResponseBehavior.cpp
//  GameAsteroids
//
//  Created by James Folk on 8/1/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "PlayerCollisionResponseBehavior.h"

#include "btManifoldPoint.h"
#include "BaseEntity.h"

PlayerCollisionResponseBehavior::PlayerCollisionResponseBehavior(const PlayerCollisionResponseBehaviorInfo& constructionInfo) :
BaseCollisionResponseBehavior(constructionInfo)
{
    
}

PlayerCollisionResponseBehavior::~PlayerCollisionResponseBehavior()
{
    
}

void PlayerCollisionResponseBehavior::respond(BaseEntity *pOtherEntity, const btManifoldPoint &pt)
{
    m_pOtherEntity = pOtherEntity;
}

const BaseEntity *PlayerCollisionResponseBehavior::getOtherEntity()const
{
    return m_pOtherEntity;
}