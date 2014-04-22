//
//  MazeGameState_NextLevel.h
//  MazeADay
//
//  Created by James Folk on 11/15/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __MazeADay__MazeGameState_NextLevel__
#define __MazeADay__MazeGameState_NextLevel__

#include "BaseGameState.h"

class MazeGameState_NextLevel: public BaseGameState
{
public:
    MazeGameState_NextLevel();
    virtual ~MazeGameState_NextLevel();
    
    virtual void enter(void*);
    virtual void update(void*, btScalar deltaTimeStep);
    virtual void render();
    virtual void exit(void*);
    virtual bool onMessage(void*, const Telegram&);
private:
    IDType m_timerID;
};

#endif /* defined(__MazeADay__MazeGameState_NextLevel__) */
