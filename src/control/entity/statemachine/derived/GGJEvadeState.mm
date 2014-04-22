//
//  GGJEvadeState.cpp
//  MazeADay
//
//  Created by James Folk on 1/26/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#include "GGJEvadeState.h"
#include "GlobalGameJamGame.h"

GGJEvadeState::GGJEvadeState()
{
    
}
GGJEvadeState::~GGJEvadeState()
{
    
}

void GGJEvadeState::enter(BaseEntity*e)
{
    SteeringEntity *se = dynamic_cast<SteeringEntity*>(e);
    
    //se->setCollisionResponseBehavior(GlobalGameJamGame::pursueCollisionResponse);
    //se->setCollisionFilterBehavior(GlobalGameJamGame::planeFilter);
}

void GGJEvadeState::update(BaseEntity*e, btScalar deltaTimeStep)
{
    SteeringEntity *se = dynamic_cast<SteeringEntity*>(e);
}
void GGJEvadeState::exit(BaseEntity*e)
{
    SteeringEntity *se = dynamic_cast<SteeringEntity*>(e);
    
    se->setCollisionResponseBehavior(0);
    //se->setCollisionFilterBehavior(0);
    
}
bool GGJEvadeState::onMessage(BaseEntity*e, const Telegram&)
{
    
}

