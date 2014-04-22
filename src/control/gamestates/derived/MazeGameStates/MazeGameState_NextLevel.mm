//
//  MazeGameState_NextLevel.cpp
//  MazeADay
//
//  Created by James Folk on 11/15/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "MazeGameState_NextLevel.h"
#include "MazeGameState.h"
#include "GameStateMachine.h"
#include "RigidEntity.h"

MazeGameState_NextLevel::MazeGameState_NextLevel()
{
    
}
MazeGameState_NextLevel::~MazeGameState_NextLevel()
{
    
}

void MazeGameState_NextLevel::enter(void*)
{
    TimerInfo timerInfo;
    
    timerInfo.m_timerType = TimerType_Timer;
    m_timerID = FrameCounter::getInstance()->create(&timerInfo);
    
    
    Timer *timer = dynamic_cast<Timer*>(FrameCounter::getInstance()->get(m_timerID));
    timer->start(0.25f * 1000);
}
void MazeGameState_NextLevel::update(void*, btScalar deltaTimeStep)
{
    MazeGameState::lookAtPlayerCenter();
    
    
    Timer *timer = dynamic_cast<Timer*>(FrameCounter::getInstance()->get(m_timerID));
    
    if (timer->getMilliseconds() <= 0)
        GameStateMachine::getInstance()->pushCurrentState(MazeGameState::getGameState(GameStateType_MazeGameState_ReadySetGo));
}
void MazeGameState_NextLevel::render()
{
    
}
void MazeGameState_NextLevel::exit(void*)
{
    FrameCounter::getInstance()->destroy(m_timerID);
    
    MazeGameState::getGamePlayer()->getRigidBody()->clearForces();
    MazeGameState::getGamePlayer()->getRigidBody()->setLinearVelocity(btVector3(0,0,0));
    MazeGameState::getGamePlayer()->getRigidBody()->setAngularVelocity(btVector3(0,0,0));
    
    MazeGameState::increaseBoardSize();
}
bool MazeGameState_NextLevel::onMessage(void*, const Telegram&)
{
    
}
