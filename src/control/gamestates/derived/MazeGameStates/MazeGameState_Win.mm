//
//  MazeGameState_Win.cpp
//  MazeADay
//
//  Created by James Folk on 11/15/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "MazeGameState_Win.h"
#include "MazeGameState.h"
#include "GameStateMachine.h"
#include "RigidEntity.h"
#include "CameraSteeringEntity.h"
#import "AppDelegate.h"

MazeGameState_Win::MazeGameState_Win():
m_timerID(0)
{
    
}
MazeGameState_Win::~MazeGameState_Win()
{
    
}

void MazeGameState_Win::enter(void*)
{
    m_betterTime = false;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    int level = MazeGameState::getCurrentLevel();
    long best_time = [appDelegate getMazeEntry:[NSDate date] theLevel:level];
    long current_time = MazeGameState::getCurrentStopWatch()->getMilliseconds();
    float wait = 1.0f;
    
    if(current_time < best_time)
    {
        [appDelegate addMazeEntry:[NSDate date]
                         theLevel:level
                     theTotalTime:current_time];
        m_betterTime = true;
        wait = .25f;
    }
    
    TimerInfo timerInfo;
    
    timerInfo.m_timerType = TimerType_Timer;
    m_timerID = FrameCounter::getInstance()->create(&timerInfo);
    
    
    Timer *timer = dynamic_cast<Timer*>(FrameCounter::getInstance()->get(m_timerID));
    timer->start(0.25f * (1000 * wait));
}
void MazeGameState_Win::update(void*, btScalar deltaTimeStep)
{
    MazeGameState::lookAtPlayerCenter();
    
    
    Timer *timer = dynamic_cast<Timer*>(FrameCounter::getInstance()->get(m_timerID));
    
    if (timer->getMilliseconds() <= 0)
        GameStateMachine::getInstance()->pushCurrentState(MazeGameState::getGameState(GameStateType_MazeGameState_ReadySetGo));
}
void MazeGameState_Win::render()
{
    
}
void MazeGameState_Win::exit(void*)
{
    FrameCounter::getInstance()->destroy(m_timerID);
    
    MazeGameState::getGamePlayer()->getRigidBody()->clearForces();
    MazeGameState::getGamePlayer()->getRigidBody()->setLinearVelocity(btVector3(0,0,0));
    MazeGameState::getGamePlayer()->getRigidBody()->setAngularVelocity(btVector3(0,0,0));
    
    MazeGameState::increaseBoardSize();
}
bool MazeGameState_Win::onMessage(void*, const Telegram&)
{
    
}
