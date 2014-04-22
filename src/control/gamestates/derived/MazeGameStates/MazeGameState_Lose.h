//
//  MazeGameState_Lose.h
//  MazeADay
//
//  Created by James Folk on 11/15/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __MazeADay__MazeGameState_Lose__
#define __MazeADay__MazeGameState_Lose__

#include "BaseGameState.h"

class MazeGameState_Lose: public BaseGameState
{
public:
    MazeGameState_Lose();
    virtual ~MazeGameState_Lose();
    
    virtual void enter(void*);
    virtual void update(void*, btScalar deltaTimeStep);
    virtual void render();
    virtual void exit(void*);
    virtual bool onMessage(void*, const Telegram&);
};

#endif /* defined(__MazeADay__MazeGameState_Lose__) */
