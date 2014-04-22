//
//  MazeGameState_Win.h
//  MazeADay
//
//  Created by James Folk on 11/15/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __MazeADay__MazeGameState_Win__
#define __MazeADay__MazeGameState_Win__

#include "BaseGameState.h"

class MazeGameState_Win: public BaseGameState
{
public:
    MazeGameState_Win();
    virtual ~MazeGameState_Win();
    
    virtual void enter(void*);
    virtual void update(void*, btScalar deltaTimeStep);
    virtual void render();
    virtual void exit(void*);
    virtual bool onMessage(void*, const Telegram&);
private:
    IDType m_timerID;
    bool m_betterTime;
};

#endif /* defined(__MazeADay__MazeGameState_Win__) */
