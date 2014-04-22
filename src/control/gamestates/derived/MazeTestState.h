//
//  MazeTestState.h
//  GameAsteroids
//
//  Created by James Folk on 3/28/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__MazeTestState__
#define __GameAsteroids__MazeTestState__

#include "BaseTestState.h"

class GhostEntity;

class MazeTestState : public BaseTestState
{
public:
    MazeTestState();
    virtual ~MazeTestState();
    
    virtual void update_specific(btScalar deltaTimeStep);
    virtual void enter_specific();
    virtual void exit_specific();
    
//    virtual void touchesBegan();
//    virtual void touchesMoved();
//    virtual void touchesEnded();
//    virtual void touchesCancelled();
private:
    
    void createCamera();
    CameraSteeringEntity *pCamera;
    
    btVector3 getPlayerControlTouchPosition()const;
    //btVector3 getPlayerLinearImpulseFromInput(const btVector3 &end)const;
    void createPlayer();
    RigidEntity *pPlayer;
    
    btVector3 m_TouchStart;
    btScalar m_TouchStartTime;
    
    btVector3 m_CameraOffset;
    
    GhostEntity *pGhostEntity;
    
    static int s_BoardSize;
};

#endif /* defined(__GameAsteroids__MazeTestState__) */
