//
//  LoadGameState.h
//  BaseProject
//
//  Created by library on 8/28/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __BaseProject__LoadGameState__
#define __BaseProject__LoadGameState__

#include "BaseGameState.h"
#include <string>
#include "AbstractFactoryIncludes.h"
#include "btAlignedObjectArray.h"

class CameraEntity;

class LoadGameState : public BaseGameState
{
public:
    LoadGameState();
    virtual ~LoadGameState();
    
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
    
    void setZipFile(const std::string &filename);
    void setOnFinishedState(const IDType ID);
private:
    std::string m_Filename;
    BaseGameState *m_NextState;
    std::string m_Percentage;
    std::string m_File;
    
//    btAlignedObjectArray<IDType> m_ObjectDrawingText;
//    btAlignedObjectArray<IDType> m_PercentageDrawingText;
//    
//    CameraEntity *m_pOrthoCamera;
};

#endif /* defined(__BaseProject__LoadGameState__) */
