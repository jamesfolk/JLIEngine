//
//  MazeGameState_ReadySetGo.cpp
//  MazeADay
//
//  Created by James Folk on 11/15/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "MazeGameState_ReadySetGo.h"
#include "MazeGameState.h"
#include "btVector3.h"
#include "RigidEntity.h"
#include "TextViewObjectFactory.h"
#include "CameraFactory.h"
#include "GameStateMachine.h"
#include "BaseCollisionResponseBehavior.h"
#import "AppDelegate.h"
#include "MazeMiniMapFBO.h"

#include "MeshMazeCreator.h"

MazeGameState_ReadySetGo::MazeGameState_ReadySetGo():
m_PlayerStartPosition(new btVector3(0,0,0))
{
    
}
MazeGameState_ReadySetGo::~MazeGameState_ReadySetGo()
{
    delete m_PlayerStartPosition;
    m_PlayerStartPosition = NULL;
}

static long getBestTimeForToday()
{
    
}

void MazeGameState_ReadySetGo::enter(void*)
{
    MazeGameState::getCurrentStopWatch()->stop();
    MazeGameState::getCurrentStopWatch()->reset();
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    long best_time = [appDelegate getMazeEntry:[NSDate date] theLevel:MazeGameState::getCurrentLevel()];
    
    MazeGameState::getSavedStopWatch()->setMilliseconds(best_time);
    
    MazeGameState::destroyMaze();
    MazeGameState::createMaze(MazeGameState::getBoardSize(), MazeGameState::getSeed(), MazeGameState::completedLevel(MazeGameState::getCurrentLevel()));
    
    MazeGameState::getMazeMiniMapSprite()->setOrigin(btVector3(CameraFactory::getScreenWidth() - 128, CameraFactory::getScreenHeight() - 128,0));
    
    BaseTextViewInfo *info = NULL;
    
    const size_t size = 32;
    
    info = new BaseTextViewInfo(ShaderFactory::getInstance()->getCurrentShaderID());
    for(size_t i = 0; i < size; i++)
    {
        m_TimerWatchDrawingText.push_back(TextViewObjectFactory::getInstance()->create(info));
    }
    delete info;
    
    TimerInfo timerInfo;
    
    timerInfo.m_timerType = TimerType_Timer;
    m_timerID = FrameCounter::getInstance()->create(&timerInfo);
    
    setup();
    
//    if(MazeGameState::completedLevel(MazeGameState::getCurrentLevel()))
//        MazeGameState::getMazeMiniMapTBO()->solve();
    
    Timer *timer = dynamic_cast<Timer*>(FrameCounter::getInstance()->get(m_timerID));
    timer->start(4 * 1000);
}


void MazeGameState_ReadySetGo::update(void*, btScalar deltaTimeStep)
{   
    MazeGameState::lookAtPlayerCenter();
    
    if(isPaused())
        return;
    
    Timer *timer = dynamic_cast<Timer*>(FrameCounter::getInstance()->get(m_timerID));
    
    std::string text = "";
    if (timer->getMilliseconds() > 2000)
    {
        text = "Ready...";
        MazeGameState::getMazeMeshCreator()->getMaze()->show();
        
    }
    else if(timer->getMilliseconds() > 1000)
    {
        text = "Set...";
        MazeGameState::getMazeMiniMapSprite()->show();
        
    }
    else if(timer->getMilliseconds() > 0)
    {
        text = "GO!!!";
    }
    else
    {
        GameStateMachine::getInstance()->pushCurrentState(MazeGameState::getGameState(GameStateType_MazeGameState_Play));
        text = "";
    }
    
    
    TextViewObjectFactory::getInstance()->updateDrawText(text,
                                                         LocalizedTextViewObjectType_Helvetica_128pt,
                                                         btVector3(0, CameraFactory::getScreenHeight() * .5f, 200),
                                                         m_TimerWatchDrawingText,
                                                         btVector3(1.0f, 0.0f, 0.0f));
    
    
    MazeGameState::getGamePlayer()->getRigidBody()->clearForces();
    MazeGameState::getGamePlayer()->getRigidBody()->setLinearVelocity(btVector3(0,0,0));
    MazeGameState::getGamePlayer()->getRigidBody()->setAngularVelocity(btVector3(0,0,0));
    MazeGameState::getGamePlayer()->setOrigin(*m_PlayerStartPosition);
}

void MazeGameState_ReadySetGo::render()
{
    
}

void MazeGameState_ReadySetGo::exit(void*)
{
    FrameCounter::getInstance()->destroy(m_timerID);
    
    for(int i = 0; i < m_TimerWatchDrawingText.size(); i++)
    {
        TextViewObjectFactory::getInstance()->destroy(m_TimerWatchDrawingText.at(i));
    }
    m_TimerWatchDrawingText.clear();
    
    if(MazeGameState::getGameGoal() &&
       MazeGameState::getGameGoal()->getCollisionResponseBehavior())
        MazeGameState::getGameGoal()->getCollisionResponseBehavior()->reset();
    
//    if(MazeGameState::getMazeMiniMapSprite())
//        MazeGameState::getMazeMiniMapSprite()->hide();
}

bool MazeGameState_ReadySetGo::onMessage(void*, const Telegram&)
{
    
}



void MazeGameState_ReadySetGo::setup()
{
    btVector3 aabbMin, aabbMax;
    
    *m_PlayerStartPosition = MazeGameState::getMazeStartOrigin();
    m_PlayerStartPosition->setY(m_PlayerStartPosition->getY() + 4.0f);
    MazeGameState::getGamePlayer()->getRigidBody()->getCollisionShape()->getAabb(btTransform::getIdentity(),
                                                                                 aabbMin, aabbMax);
    m_PlayerStartPosition->setY(m_PlayerStartPosition->y() + aabbMax.y() );
    
    
    btVector3 origin(MazeGameState::getMazeEndOrigin());
    origin.setY(origin.y());
    
    MazeGameState::getGameGoal()->getGhostObject()->getCollisionShape()->getAabb(btTransform::getIdentity(),
                                                                                 aabbMin, aabbMax);
    origin.setY(origin.y() + aabbMax.y());
    MazeGameState::getGameGoal()->setOrigin(origin);
    
    //allowPause(false);
}