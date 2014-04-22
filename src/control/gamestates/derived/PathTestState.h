//
//  PathTestState.h
//  GameAsteroids
//
//  Created by James Folk on 7/26/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__PathTestState__
#define __GameAsteroids__PathTestState__

#include "BaseTestState.h"

class PathTestState;
class CameraEntity;
class Path;

class PathTestState : public BaseTestState
{
public:
    PathTestState();
    virtual ~PathTestState();
    
    virtual void update_specific(btScalar deltaTimeStep);
    virtual void enter_specific();
    virtual void exit_specific();
    virtual void render_specific();
    
//    virtual void touchesBegan();
//    virtual void touchesMoved();
//    virtual void touchesEnded();
//    virtual void touchesCancelled();
    
private:
    
    
    void createPath();
    Path *m_pPath;
    
    void createCamera();
    CameraSteeringEntity *m_pSteeringCamera;
    CameraEntity *m_pCameraEntity;
    btScalar m_Rotate;
    
    void createShader();
    //IDType m_shaderFactoryID;
    
    void createTextures();
    IDType m_bricksTextureID;
    
    void createViewObjects();
    IDType m_coneViewObjectID;
    IDType m_sphereViewObjectID;
    
    void createCollisionShapes();
    IDType m_coneCollisionShapeID;
    IDType m_sphereCollisionShapeID;
    
    void createSteeringBehavior();
    IDType m_steeringBehaviorID;
    
    void createSteeringEntity();
    SteeringEntity *m_pSteeringEntity;
    
    void createRigidEntity();
    RigidEntity *m_pRigidEnity;
    RigidEntity *m_pRigidEnity2;
    
    int m_currentPathIndex;

};

#endif /* defined(__GameAsteroids__PathTestState__) */
