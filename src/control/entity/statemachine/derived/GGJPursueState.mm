//
//  GGJPursueState.cpp
//  MazeADay
//
//  Created by James Folk on 1/26/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#include "GGJPursueState.h"
#include "GlobalGameJamGame.h"

GGJPursueState::GGJPursueState()
{
    
}
GGJPursueState::~GGJPursueState()
{
    
}

void GGJPursueState::enter(BaseEntity*e)
{
    SteeringEntity *se = dynamic_cast<SteeringEntity*>(e);
    
    //se->setCollisionResponseBehavior(GlobalGameJamGame::pursueCollisionResponse);
    //se->setCollisionFilterBehavior(GlobalGameJamGame::planeFilter);
}

void GGJPursueState::update(BaseEntity*e, btScalar deltaTimeStep)
{
    SteeringEntity *se = dynamic_cast<SteeringEntity*>(e);
}
void GGJPursueState::exit(BaseEntity*e)
{
    SteeringEntity *se = dynamic_cast<SteeringEntity*>(e);
    
    //se->setCollisionResponseBehavior(0);
    //se->setCollisionFilterBehavior(0);
    
}
bool GGJPursueState::onMessage(BaseEntity*e, const Telegram&)
{
    
}

