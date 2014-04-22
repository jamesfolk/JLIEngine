//
//  PhysicsEntityTestState.h
//  GameAsteroids
//
//  Created by James Folk on 3/21/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__PhysicsEntityTestState__
#define __GameAsteroids__PhysicsEntityTestState__

#include "BaseTestState.h"

class CameraSteeringEntity;

class PhysicsEntityTestState : public BaseTestState
{
public:
    PhysicsEntityTestState();
    virtual ~PhysicsEntityTestState();
    
    virtual void update_specific(btScalar deltaTimeStep);
    virtual void enter_specific();
    virtual void exit_specific();
    virtual void render_specific();
    
//    virtual void touchesBegan();
//    virtual void touchesMoved();
//    virtual void touchesEnded();
//    virtual void touchesCancelled();
private:
    
    void createDynamicEntity();
    
    CameraEntity *getCamera();
    RigidEntity *getPlane();
    RigidEntity *getCurrentEntity();
    RigidEntity *getEntity(size_t index);
    
    CameraEntity *m_pCameraEntity;
    RigidEntity *m_pPlane;
    btAlignedObjectArray<IDType> m_Entities;
    
    
    
};

#endif /* defined(__GameAsteroids__PhysicsEntityTestState__) */
