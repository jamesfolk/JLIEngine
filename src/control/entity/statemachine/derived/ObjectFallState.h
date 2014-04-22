//
//  ObjectFallState.h
//  MazeADay
//
//  Created by James Folk on 1/26/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#ifndef __MazeADay__ObjectFallState__
#define __MazeADay__ObjectFallState__

#include "BaseEntityState.h"
#include "SteeringEntity.h"

class ObjectFallState : public BaseEntityState
{
public:
    ObjectFallState();
    virtual ~ObjectFallState();
    
    virtual void enter(BaseEntity*);
    
    virtual void update(BaseEntity*, btScalar deltaTimeStep);
    
    //this will execute when the state is exited.
    virtual void exit(BaseEntity*);
    
    //this executes if the agent receives a message from the
    //message dispatcher
    virtual bool onMessage(BaseEntity*, const Telegram&);
    
};

#endif /* defined(__MazeADay__ObjectFallState__) */
