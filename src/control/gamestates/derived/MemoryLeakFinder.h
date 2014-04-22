//
//  MemoryLeakFinder.h
//  BaseProject
//
//  Created by library on 10/6/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __BaseProject__MemoryLeakFinder__
#define __BaseProject__MemoryLeakFinder__

#include "BaseGameState.h"

class CameraEntity;
class BaseCamera;
class btVector3;

class MemoryLeakFinder : public BaseGameState
{
public:
    MemoryLeakFinder();
    virtual ~MemoryLeakFinder();
    
    virtual void enter(void*);
    
    //this is the states normal update function
    virtual void update(void*, btScalar deltaTimeStep);
    
    //call this to update the FSM
    virtual void  render();
    
    //this will execute when the state is exited.
    virtual void exit(void*);
    
    //this executes if the agent receives a message from the
    //message dispatcher
    virtual bool onMessage(void*, const Telegram&);
    
//    virtual void touchesBegan();
//    virtual void touchesMoved();
//    virtual void touchesEnded();
//    virtual void touchesCancelled();
private:
    CameraEntity *m_pCameraEntity;
    
};

#endif /* defined(__BaseProject__MemoryLeakFinder__) */
