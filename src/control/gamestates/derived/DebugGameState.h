//
//  DebugGameState.h
//  BaseProject
//
//  Created by library on 9/18/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __BaseProject__DebugGameState__
#define __BaseProject__DebugGameState__

#include "BaseGameState.h"
#include "AbstractFactoryIncludes.h"

class CameraSteeringEntity;
class CameraEntity;
class BaseCamera;
class btVector3;

class DebugGameState : public BaseGameState
{
public:
    DebugGameState();
    virtual ~DebugGameState();
    
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
    
    const BaseGameState*	getGameState() const;
    BaseGameState*	getGameState();
    void setGameState(const IDType ID);
private:
    BaseGameState *m_pBaseGameState;
    
    IDType m_bricksTextureID;
    IDType m_sphereViewObjectID;
    IDType m_collisionShapeID;
    IDType m_steeringBehaviorID;
    CameraEntity *m_pCamera;
    //CameraSteeringEntity *m_pCameraSteeringEntity;
    
    BaseCamera *m_pGameCamera;
    
    bool m_AttachedToGameCamera;
    btVector3 *m_AttachedOffset;
    
    btVector3 *m_CameraRotationAxis;
    btScalar m_CameraRotationAngle;
    btVector3 *m_CameraPivotPoint;
    
};

#endif /* defined(__BaseProject__DebugGameState__) */
