//
//  PlayerUpdateBehavior.cpp
//  GameAsteroids
//
//  Created by library on 8/5/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "PlayerUpdateBehavior.h"


#include "BaseEntity.h"
#include "BaseCollisionResponseBehavior.h"
//#include "PlayerCollisionResponseBehavior.h"
#include "RigidEntity.h"
#include "btRigidBody.h"

PlayerUpdateBehavior::PlayerUpdateBehavior(const PlayerUpdateBehaviorInfo& constructionInfo):
BaseUpdateBehavior(constructionInfo)
{
    
}

PlayerUpdateBehavior::~PlayerUpdateBehavior()
{
    
}

void PlayerUpdateBehavior::update(btCollisionWorld* collisionWorld, btScalar deltaTimeStep)
{
//    PlayerCollisionResponseBehavior *colResponse = dynamic_cast<PlayerCollisionResponseBehavior*>(getOwner()->getCollisionResponseBehavior());
    
    RigidEntity *pPlayer = dynamic_cast<RigidEntity*>(getOwner());
    pPlayer->getRigidBody()->applyCentralImpulse(btVector3(0,-1000,0));
}