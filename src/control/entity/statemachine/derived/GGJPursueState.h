//
//  GGJPursueState.h
//  MazeADay
//
//  Created by James Folk on 1/26/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#ifndef __MazeADay__GGJPursueState__
#define __MazeADay__GGJPursueState__

#include "BaseEntityState.h"
#include "SteeringEntity.h"

class GGJPursueState : public BaseEntityState
{
public:
    GGJPursueState();
    virtual ~GGJPursueState();
    
    virtual void enter(BaseEntity*);
    
    virtual void update(BaseEntity*, btScalar deltaTimeStep);
    
    //this will execute when the state is exited.
    virtual void exit(BaseEntity*);
    
    //this executes if the agent receives a message from the
    //message dispatcher
    virtual bool onMessage(BaseEntity*, const Telegram&);
    
};

#endif /* defined(__MazeADay__GGJPursueState__) */
