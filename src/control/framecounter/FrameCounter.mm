//
//  FrameCounter.cpp
//  GameAsteroids
//
//  Created by James Folk on 3/20/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "FrameCounter.h"


BaseTimer *FrameCounter::ctor(TimerInfo *info)
{
    BaseTimer *timer = NULL;
    
    switch (info->m_timerType)
    {
        case TimerType_Clock:
            timer = new Clock();
            break;
        case TimerType_StopWatch:
            timer = new StopWatch();
            break;
        case TimerType_Timer:
            timer = new Timer();
            break;
            
        default:
            break;
    }
    if(timer)
        m_Timers.push_back(timer);
    return timer;
}
BaseTimer *FrameCounter::ctor(int type)
{
    return NULL;
}

void FrameCounter::dtor(BaseTimer *timer)
{
    m_Timers.remove(timer);
    delete timer;
}
void FrameCounter::update(double milliseconds)
{
    m_Diff = milliseconds;
    
    m_Count += m_Diff;
    m_FramesElapsed++;
    
    for (int i = 0; i < m_Timers.size(); i++)
    {
        m_Timers[i]->update(milliseconds);
    }
}

double FrameCounter::getCurrentTime()const
{
    return m_Count;
}
double FrameCounter::getCurrentDiffTime()const
{
    return m_Diff;
}


void FrameCounter::reset()
{
    m_Count = 0;
}

void FrameCounter::start()
{
    m_FramesElapsed = 0;
}
NSInteger  FrameCounter::framesElapsedSinceStartCalled()const
{
    return m_FramesElapsed;
}

void FrameCounter::setPreferredFramesPerSecond(NSInteger frames)
{
    m_framesPerSecond = frames;
}

int FrameCounter::getPreferredFramesPerSecond()const
{
    return m_framesPerSecond;
}