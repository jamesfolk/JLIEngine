//
//  BaseGameState.mm
//  GameAsteroids
//
//  Created by James Folk on 3/20/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "BaseGameState.h"

void BaseGameState::enablePause(bool pause)
{
    m_IsPaused = pause;
    
//    if (m_IsPaused)
//    {
//        [sharedSoundManager pauseBGM];
//        [sharedSoundManager pauseSFX];
//    }
//    else
//    {
//        [sharedSoundManager unPauseBGM];
//        [sharedSoundManager unPauseSFX];
//    }
    
    
    
}

void BaseGameState::allowPause(bool allow)
{
    m_canPause = allow;
}
bool BaseGameState::isPauseAllowed()const
{
    return m_canPause;
}

bool BaseGameState::isPaused()const
{
    return m_IsPaused;
}

void BaseGameState::quit()
{
    m_didQuit = true;
}
bool BaseGameState::didQuit()const
{
    return m_didQuit;
}

void BaseGameState::saveDefaultData()
{
    
}

void BaseGameState::loadDefaultData()
{
    
}