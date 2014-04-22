//
//  FinishLevelCollisionResponseBehavior.cpp
//  GameAsteroids
//
//  Created by James Folk on 7/16/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "FinishLevelCollisionResponseBehavior.h"
#include "btManifoldPoint.h"

#include "GameStateMachine.h"
#include "MazeGameState.h"
#include "LoadGameState.h"

#import "AppDelegate.h"
#include "BaseEntity.h"

FinishLevelCollisionResponseBehavior::FinishLevelCollisionResponseBehavior(const FinishLevelResponseBehaviorInfo& constructionInfo) :
BaseCollisionResponseBehavior(constructionInfo),
m_responded(false)
{
    
}

FinishLevelCollisionResponseBehavior::~FinishLevelCollisionResponseBehavior()
{
    
}

void FinishLevelCollisionResponseBehavior::respond(BaseEntity *pOtherEntity, const btManifoldPoint &pt)
{
    if(pOtherEntity && !m_responded)
    {
        
        
        //MazeGameState::getCurrentStopWatch()->stop();
        
        GameStateMachine::getInstance()->pushCurrentState(MazeGameState::getGameState(GameStateType_MazeGameState_Win));
        
        m_responded = true;
    }
}

void FinishLevelCollisionResponseBehavior::reset()
{
    m_responded = false;
}
