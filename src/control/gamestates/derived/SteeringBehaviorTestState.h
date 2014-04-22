//
//  SteeringBehaviorTestState.h
//  GameAsteroids
//
//  Created by James Folk on 4/2/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__SteeringBehaviorTestState__
#define __GameAsteroids__SteeringBehaviorTestState__

#include "BaseTestState.h"

class RigidEntity;
class SteeringEntity;

class SteeringBehaviorTestState : public BaseTestState
{
public:
    SteeringBehaviorTestState();
    virtual ~SteeringBehaviorTestState();
    
    virtual void update_specific(btScalar deltaTimeStep);
    virtual void enter_specific();
    virtual void exit_specific();
    
//    virtual void touchesBegan();
//    virtual void touchesMoved();
//    virtual void touchesEnded();
//    virtual void touchesCancelled();
    
//    SteeringEntity *box;
//    SteeringEntity *sphere;
//    
//    RigidEntity *pPhysicsEntity;
//    SteeringEntity *pSteeringEntity;
//    
//    SteeringEntity *pCurrentWanderer;
//    
//    CameraSteeringEntity *pCameraSteeringEntity;
//    
//    btScalar m_Rotate;
    
private:
    
    CameraEntity *m_pCameraEntity;
    btAlignedObjectArray<RigidEntity*> m_Walls;
    //RigidEntity *m_pWalls[6];
    
    CameraEntity *getCamera();
    RigidEntity *getBoxWall(size_t index);
    
    
    
    
    
    typedef std::vector<SteeringEntity*> SteeringEntityVector;
    
    SteeringEntity *createWanderEntity();
    SteeringEntityVector m_WanderEntities;
    
    SteeringEntity *createPursuitEntity(SteeringEntity *);
    SteeringEntityVector m_PursuitEntities;
    
    SteeringEntity *createEvadeEntity(SteeringEntity *);
    SteeringEntityVector m_EvadeEntities;
//
//    RigidEntity *pCurrentFocus;
    
    
};

#endif /* defined(__GameAsteroids__SteeringBehaviorTestState__) */
