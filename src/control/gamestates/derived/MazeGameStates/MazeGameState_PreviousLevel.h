//
//  MazeGameState_PreviousLevel.h
//  MazeADay
//
//  Created by James Folk on 11/15/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __MazeADay__MazeGameState_PreviousLevel__
#define __MazeADay__MazeGameState_PreviousLevel__

#include "BaseGameState.h"

class MazeGameState_PreviousLevel: public BaseGameState
{
public:
    MazeGameState_PreviousLevel();
    virtual ~MazeGameState_PreviousLevel();
    
    virtual void enter(void*);
    virtual void update(void*, btScalar deltaTimeStep);
    virtual void render();
    virtual void exit(void*);
    virtual bool onMessage(void*, const Telegram&);
private:
    IDType m_timerID;
};

#endif /* defined(__MazeADay__MazeGameState_PreviousLevel__) */
