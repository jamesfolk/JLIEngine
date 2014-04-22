//
//  ViewEntityTestState.h
//  GameAsteroids
//
//  Created by James Folk on 4/29/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__ViewEntityTestState__
#define __GameAsteroids__ViewEntityTestState__

#include "BaseTestState.h"
#include "BaseTextViewObject.h"

class CameraSteeringEntity;
class RigidEntity;
class ViewEntityTestState;
class Path;


class ViewEntityTestState : public BaseTestState
{
public:
    ViewEntityTestState();
    virtual ~ViewEntityTestState();
    
    virtual void update_specific(btScalar deltaTimeStep);
    virtual void enter_specific();
    virtual void exit_specific();
    virtual void render_specific();
    
//    virtual void touchesBegan();
//    virtual void touchesMoved();
//    virtual void touchesEnded();
//    virtual void touchesCancelled();
    
    void initViewObjects();
    void initCollisionShapes();
    
    void createCamera();
    void createPlane();
    void createCube();
    void createSphere();
    
    CameraSteeringEntity *m_pSteeringCamera;
    RigidEntity *pSphere;
    IDType sphereViewObjectID;
    
    IDType planeViewObjectID;
    RigidEntity *pPlane;
    
    IDType cubeViewObjectID;
    RigidEntity *pCube;
    RigidEntity *pCurrentEntity;
    
    
    
    //btAlignedObjectArray<RigidEntity*> m_Entities;
    
    IDType sphereCollisionShapeID;
    IDType cubeCollisionShapeID;
    IDType planeCollisionShapeID;
    
    IDType shaderFactoryID;
    IDType bricksTextureID;
    IDType bricksTextureCubeID;
    
    IDType spriteViewObjectID;
    
private:
    int touchcount;
    
    unsigned int getSeed()const;
    void createMaze();
    
    RigidEntity *m_pMaze;
    //btScalar m_Rotate;
    btVector3 m_MazeStartOrigin;
    btVector3 m_MazeEndOrigin;
    
    void createPlayer();
    RigidEntity *m_pPlayer;
    
    void createSoftPlayer();
    SoftEntity *m_pSoftPlayer;
    
    btVector3 getPlayerControlTouchPosition()const;
    btVector3 m_TouchStart;
    btScalar m_TouchStartTime;
    
    void createEndTrigger();
    GhostEntity *m_pEndTrigger;
    
    //void createSprite();
    //BaseEntity *m_pSprite;
    
    BaseTextViewObject *m_pBaseTextViewObject;
    
    btScalar m_Rotate;
    
    bool m_InitalizeTouch;
    
    Path *m_pPath;
    
    btVector3 m_BoardNormal;
public:
    static bool increaseBoardSize();
private:
    static int s_BoardSize;
    
    void applyLinearForceOnPlayer();
    void applyAngularForceOnPlayer();
};



#endif /* defined(__GameAsteroids__ViewEntityTestState__) */
