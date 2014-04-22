//
//  CameraAndControlTestState.h
//  GameAsteroids
//
//  Created by James Folk on 4/12/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__CameraAndControlTestState__
#define __GameAsteroids__CameraAndControlTestState__

#include "BaseTestState.h"


class CameraAndControlTestState : public BaseTestState
{
public:
    CameraAndControlTestState();
    virtual ~CameraAndControlTestState();
    
    virtual void update_specific(btScalar deltaTimeStep);
    virtual void enter_specific();
    virtual void exit_specific();
    
//    virtual void touchesBegan();
//    virtual void touchesMoved();
//    virtual void touchesEnded();
//    virtual void touchesCancelled();
    
    RigidEntity *pPlayer;
    
    CameraSteeringEntity *pCamera;
    
private:
    
    
    btVector3 getPlayerControlTouchPosition()const;
    

    
    void createPlayer();
    void createCamera();
    
    btVector3 m_TouchStart;
    btScalar m_TouchStartTime;
    
};

#endif /* defined(__GameAsteroids__CameraAndControlTestState__) */
