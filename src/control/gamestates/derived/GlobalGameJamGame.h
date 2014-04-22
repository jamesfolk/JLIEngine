//
//  GlobalGameJamGame.h
//  MazeADay
//
//  Created by James Folk on 1/24/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#ifndef __MazeADay__GlobalGameJamGame__
#define __MazeADay__GlobalGameJamGame__

#include "BaseGameState.h"

#include "CameraEntity.h"
#include "CameraPhysicsEntity.h"
#include "CameraSteeringEntity.h"
#include "EntityFactory.h"
#include "TextureFactory.h"
#include "ViewObjectFactory.h"
#include "CollisionShapeFactory.h"
#include "SteeringBehaviorFactory.h"
#include "RigidEntity.h"
#include "SteeringEntity.h"
#include "GhostEntity.h"
#include "CollisionResponseBehaviorFactory.h"

class GlobalGameJamGame: public BaseGameState
{
public:
    GlobalGameJamGame();
    virtual ~GlobalGameJamGame();
    
    virtual void enter(void*);
    virtual void update(void*, btScalar deltaTimeStep);
    virtual void render();
    virtual void exit(void*);
    virtual bool onMessage(void*, const Telegram&);
    
    virtual void touchRespond(const DeviceTouch &input);
    virtual void tapGestureRespond(const DeviceTapGesture &input);
    virtual void pinchGestureRespond(const DevicePinchGesture &input);
    virtual void panGestureRespond(const DevicePanGesture &input);
    virtual void swipeGestureRespond(const DeviceSwipeGesture &input);
    virtual void rotationGestureRespond(const DeviceRotationGesture &input);
    virtual void longPressGestureRespond(const DeviceLongPressGesture &input);
    virtual void accelerometerRespond(const DeviceAccelerometer &input);
    virtual void motionRespond(const DeviceMotion &input);
    virtual void gyroRespond(const DeviceGyro &input);
    virtual void magnetometerRespond(const DeviceMagnetometer &input);
    
private:
    void createObjectStates();
    void createCollisionResponses();
    void createCollisionFilters();
    
    void destroyCollisionResponses();
    void destroyCollisionFilters();

    SteeringEntity * createCube(const btVector3 &origin);
    SteeringEntity * createSphere(const btVector3 &origin);
    
    CameraPhysicsEntity *createCameraPhysicsEntity();
    //CameraEntity *createRegularCamera();
    
    //CameraSteeringEntity *createCamera();
    RigidEntity *createPlane();
    RigidEntity *createSkybox();
//    SteeringEntity * createObject(const std::string &objectName,
//                                  const std::string &textureName,
//                                  CollisionShapeType shape,
//                                  const btVector3 &origin);
    
    GhostEntity *createGhostEntity();
    
    void createRandomObject();
    
    //CameraEntity *m_CameraEntity;
    CameraPhysicsEntity *m_pCameraPhysicsEntity;
    
    RigidEntity *m_pPlane;
    RigidEntity *m_pSkybox;
    
    //SteeringEntity *m_pPlayer;
    
    void createDebugCamera();
    CameraEntity *m_pDebugCamera;
    
    std::vector<SteeringEntity*> m_EnemyVector;
    
    GhostEntity *m_pCone;
    
    float m_Rotate;
    
    
    
    IDType sphereTextureID;
    IDType floorTextureID;
    IDType coneTextureID;
    IDType debugCameraTextureID;
    
    
    IDType planeViewObjectID;
    IDType rayconeViewObjectID;
    IDType debugCameraViewObjectID;
    
    
    IDType triangleMeshShape;
    IDType rayConvexHullID;
    
    IDType switchToEvadeCRB;
    
    
    
    IDType cubeTextureID;
    
    
    IDType skyboxViewObjectID;
    IDType skyboxTriangleMeshShape;
    
    IDType wallTextureID;
    
    IDType m_currentStopWatchID;
public:
    static IDType sphereViewObjectID;
    static IDType sphereConvexHull;
    
    static IDType cubeViewObjectID;
    static IDType cubeConvexHull;
    
    static IDType fallStateID;
    
    static IDType pursueCollisionResponse;
    static IDType objectFilter;
    
    static IDType evadeCollisionResponse;
    static IDType dyingCollisionResponse;
    
    static IDType playerFilter;
    static IDType planeFilter;
    static IDType coneFilter;
    
    static IDType cameraPlayerID;


};

#endif /* defined(__MazeADay__GlobalGameJamGame__) */
