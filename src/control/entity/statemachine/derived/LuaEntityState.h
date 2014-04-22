//
//  LuaEntityState.h
//  MazeADay
//
//  Created by James Folk on 2/27/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#ifndef __MazeADay__LuaEntityState__
#define __MazeADay__LuaEntityState__

#include "BaseEntityState.h"

class LuaEntityState : public BaseEntityState
{
public:
    LuaEntityState();
    virtual ~LuaEntityState();
    
    virtual void enter(BaseEntity*);
    
    virtual void update(BaseEntity*, btScalar deltaTimeStep);
    
    //this will execute when the state is exited.
    virtual void exit(BaseEntity*);
    
    //this executes if the agent receives a message from the
    //message dispatcher
    virtual bool onMessage(BaseEntity*, const Telegram&);
    
};

#endif /* defined(__MazeADay__LuaEntityState__) */
