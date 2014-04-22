//
//  FontTestState.cpp
//  GameAsteroids
//
//  Created by James Folk on 4/29/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "FontTestState.h"
#include "ShaderFactory.h"
//#include "CameraFactory.h"
//#include "CameraEntity.h"

//#include "BaseSpriteView.h"
//#include "PlayerInput.h"

#include "LoadGameState.h"
#include "GameStateMachine.h"

FontTestState::FontTestState():
m_Rotate(0.0f)
{
    
}
FontTestState::~FontTestState()
{
}

void FontTestState::update_specific(btScalar deltaTimeStep)
{
    //m_Rotate += (deltaTimeStep * 5);
    if(m_Rotate > DEGREES_TO_RADIANS(360))
        m_Rotate = 0;
    
    TextViewObjectFactory::getInstance()->updateDrawText(m_timer->toString(),
                                                         LocalizedTextViewObjectType_Helvetica_128pt,
                                                         btVector3(32, 0, 0),
                                                         m_TimerDrawingText);
    
    TextViewObjectFactory::getInstance()->updateDrawText(m_clock->toString(),
                                                         LocalizedTextViewObjectType_Helvetica_128pt,
                                                         btVector3(32, 128, 0),
                                                         m_ClockDrawingText);
    
    TextViewObjectFactory::getInstance()->updateDrawText(m_stop_watch->toString(),
                                                         LocalizedTextViewObjectType_Helvetica_128pt,
                                                         btVector3(32, 256, 0),
                                                         m_StopWatchDrawingText,
                                                         btVector3(0.0f, 1.0f, 0.0f));
    
//    if(PlayerInput::getInstance()->getNumTouches() > 1)
//    {
//        LoadGameState *pLoadGameState = new LoadGameState();
//        
//        pLoadGameState->setOnFinishedState(new FontTestState());
//        pLoadGameState->setZipFile("maze.zip");
//        GameStateMachine::getInstance()->changeState(pLoadGameState);
//    }
    
    
    
}
void FontTestState::enter_specific()
{
//    ShaderFactoryKey key(VERTEX_SHADER, FRAGMENT_SHADER);
//    shaderFactoryID = ShaderFactory::getInstance()->create(&key);
    shaderFactoryID = ShaderFactory::getInstance()->getCurrentShaderID();
    
    int size = 32;
    BaseTextViewInfo *info = new BaseTextViewInfo(shaderFactoryID);
    
    for(size_t i = 0; i < size; i++)
    {
        m_TimerDrawingText.push_back(TextViewObjectFactory::getInstance()->create(info));
        m_ClockDrawingText.push_back(TextViewObjectFactory::getInstance()->create(info));
        m_StopWatchDrawingText.push_back(TextViewObjectFactory::getInstance()->create(info));
    }
    
    delete info;
    
    
    
    
    
    //m_CurrentTime=0;
    
    TimerInfo timerInfo;
    IDType timerID = 0;
    
    timerInfo.m_timerType = TimerType_Timer;
    timerID = FrameCounter::getInstance()->create(&timerInfo);
    m_timer = dynamic_cast<Timer*>(FrameCounter::getInstance()->get(timerID));
    
    timerInfo.m_timerType = TimerType_Clock;
    timerID = FrameCounter::getInstance()->create(&timerInfo);
    m_clock = dynamic_cast<Clock*>(FrameCounter::getInstance()->get(timerID));
    
    timerInfo.m_timerType = TimerType_StopWatch;
    timerID = FrameCounter::getInstance()->create(&timerInfo);
    m_stop_watch = dynamic_cast<StopWatch*>(FrameCounter::getInstance()->get(timerID));
    
    std::string timerString(m_timer->toString());
    std::string clockString(m_clock->toString());
    std::string stopWatchString(m_stop_watch->toString());
    
    m_stop_watch->start();
    
    
    
}
void FontTestState::exit_specific()
{
    int size = 32;
    for(size_t i = 0; i < size; i++)
    {
        TextViewObjectFactory::getInstance()->destroy(m_TimerDrawingText[i]);
        TextViewObjectFactory::getInstance()->destroy(m_ClockDrawingText[i]);
        TextViewObjectFactory::getInstance()->destroy(m_StopWatchDrawingText[i]);
    }
    m_TimerDrawingText.clear();
    m_ClockDrawingText.clear();
    m_StopWatchDrawingText.clear();
    
    IDType ID = 0;
    ID = m_timer->getID();
    FrameCounter::getInstance()->destroy(ID);
    m_timer = NULL;
    
    ID = m_clock->getID();
    FrameCounter::getInstance()->destroy(ID);
    m_clock = NULL;
    
    ID = m_stop_watch->getID();
    FrameCounter::getInstance()->destroy(ID);
    m_stop_watch = NULL;
}

void FontTestState::render_specific()
{
}

//void FontTestState::touchesBegan()
//{
//    
//}
//void FontTestState::touchesMoved()
//{
//    
//}
//void FontTestState::touchesEnded()
//{
//    if(m_timer->isFinished())
//    {
//        m_timer->start(1000 * 10);
//    }
//    else
//    {
//        m_timer->enablePause(!m_timer->isPaused());
//    }
//    
//    if(m_stop_watch->isStopped())
//    {
//        m_stop_watch->start();
//    }
//    else
//    {
//        m_stop_watch->stop();
//    }
//}
//void FontTestState::touchesCancelled()
//{
//    
//}
