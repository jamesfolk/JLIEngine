//
//  MazeGameState_ReadySetGo.h
//  MazeADay
//
//  Created by James Folk on 11/15/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __MazeADay__MazeGameState_ReadySetGo__
#define __MazeADay__MazeGameState_ReadySetGo__

#include "BaseGameState.h"
class btVector3;

class MazeGameState_ReadySetGo: public BaseGameState
{
public:
    MazeGameState_ReadySetGo();
    virtual ~MazeGameState_ReadySetGo();
    
    virtual void enter(void*);
    virtual void update(void*, btScalar deltaTimeStep);
    virtual void render();
    virtual void exit(void*);
    virtual bool onMessage(void*, const Telegram&);
private:
    void setup();
    
    IDType m_timerID;
    btAlignedObjectArray<IDType> m_TimerWatchDrawingText;
    
    btVector3 *m_PlayerStartPosition;
};

#endif /* defined(__MazeADay__MazeGameState_ReadySetGo__) */
