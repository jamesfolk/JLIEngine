//
//  ObjectFallState.cpp
//  MazeADay
//
//  Created by James Folk on 1/26/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#include "ObjectFallState.h"
#include "GlobalGameJamGame.h"

ObjectFallState::ObjectFallState()
{
    
}
ObjectFallState::~ObjectFallState()
{
    
}

void ObjectFallState::enter(BaseEntity*e)
{
    SteeringEntity *se = dynamic_cast<SteeringEntity*>(e);
    
    //se->setCollisionResponseBehavior(GlobalGameJamGame::pursueCollisionResponse);
    //se->setCollisionFilterBehavior(GlobalGameJamGame::planeFilter);
}

void ObjectFallState::update(BaseEntity*e, btScalar deltaTimeStep)
{
    SteeringEntity *se = dynamic_cast<SteeringEntity*>(e);
}
void ObjectFallState::exit(BaseEntity*e)
{
    SteeringEntity *se = dynamic_cast<SteeringEntity*>(e);
    
    //se->setCollisionResponseBehavior(0);
    //se->setCollisionFilterBehavior(0);
    
}
bool ObjectFallState::onMessage(BaseEntity*e, const Telegram&)
{
    
}

