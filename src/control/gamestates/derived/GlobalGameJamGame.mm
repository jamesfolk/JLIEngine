//
//  GlobalGameJamGame.cpp
//  MazeADay
//
//  Created by James Folk on 1/24/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#include "GlobalGameJamGame.h"
#include "EntityStateMachineFactory.h"
#include "SteeringBehaviorFactory.h"
#include "GameStateMachine.h"
//#include "SwitchToEvadeCollisionResponseBehavior.h"
#include "EntityStateFactory.h"
#include "VertexBufferObject.h"
//#include "CollisionFilterBehaviorFactory.h"

//#include "GGJPlayerCollisionFilterBehavior.h"
//#include "GGJPlaneCollisionFilterBehavior.h"
//#include "GGJObjectCollisionFilterBehavior.h"
//#include "GGJConeCollisionFilterBehavior.h"

//#include "GGJPursueCollisionResponse.h"
//#include "GGJEvadeCollisionResponse.h"
//#include "GGJDyingCollisionResponse.h"

//#import "SingletonSoundManager.h"
//extern SingletonSoundManager *sharedSoundManager;

IDType GlobalGameJamGame::sphereViewObjectID = 0;
IDType GlobalGameJamGame::sphereConvexHull = 0;

IDType GlobalGameJamGame::cubeViewObjectID = 0;
IDType GlobalGameJamGame::cubeConvexHull = 0;

IDType GlobalGameJamGame::fallStateID = 0;


IDType GlobalGameJamGame::pursueCollisionResponse = 0;
IDType GlobalGameJamGame::objectFilter = 0;

IDType GlobalGameJamGame::evadeCollisionResponse = 0;
IDType GlobalGameJamGame::dyingCollisionResponse = 0;

IDType GlobalGameJamGame::playerFilter = 0;
IDType GlobalGameJamGame::planeFilter = 0;
IDType GlobalGameJamGame::coneFilter = 0;

IDType GlobalGameJamGame::cameraPlayerID = 0;

GlobalGameJamGame::GlobalGameJamGame()
{
    
}
GlobalGameJamGame::~GlobalGameJamGame()
{
}

void GlobalGameJamGame::enter(void*)
{
//    [sharedSoundManager loadBGMWithKey:@"game" fileName:@"Displacement" fileExt:@"mp3"];
//	[sharedSoundManager playBGMWithKey:@"game" timesToRepeat:-1 fadeIn:NO];
//    [sharedSoundManager setBGMVolume:1.0f];
//    
//    [[SingletonSoundManager sharedSoundManager] loadSFXWithKey:@"laser" fileName:@"laser" fileExt:@"caf" frequency:22050];
    
//    [[SingletonSoundManager sharedSoundManager] loadSFXWithKey:@"change" fileName:@"Changebloop" fileExt:@"caf" frequency:22050];
//    
//    [[SingletonSoundManager sharedSoundManager] loadSFXWithKey:@"die" fileName:@"Death" fileExt:@"caf" frequency:22050];
    
    allowPause();
    
    m_pCameraPhysicsEntity = createCameraPhysicsEntity();
    cameraPlayerID = m_pCameraPhysicsEntity->getID();
    
    m_pPlane = createPlane();
    
    m_pSkybox = createSkybox();
    //m_pSkybox->hide();
    
    m_pCone = createGhostEntity();
    
    createDebugCamera();
    
    
    //createObjectStates();
    
    createCollisionResponses();
    createCollisionFilters();
    
    m_pCameraPhysicsEntity->setCollisionResponseBehavior(dyingCollisionResponse);
    
    CameraFactory::getInstance()->setCurrentCamera(m_pCameraPhysicsEntity);
    //CameraFactory::getInstance()->setCurrentCamera(m_pDebugCamera);
    
    btVector3 halfExtends(m_pCameraPhysicsEntity->getVertexBufferObject()->getHalfExtends());
    
    m_pCameraPhysicsEntity->setOrigin(m_pPlane->getOrigin() + halfExtends);
    m_pCone->setOrigin(m_pCameraPhysicsEntity->getOrigin());
    
    m_Rotate = 0;
    
    
    //m_pCameraPhysicsEntity->setCollisionFilterBehavior(objectFilter);
    
    
    TimerInfo timerInfo;
    
    timerInfo.m_timerType = TimerType_StopWatch;
    m_currentStopWatchID = FrameCounter::getInstance()->create(&timerInfo);
    
    dynamic_cast<StopWatch*>(FrameCounter::getInstance()->get(m_currentStopWatchID))->start();
    
}
void GlobalGameJamGame::update(void*, btScalar deltaTimeStep)
{
    m_pCone->setOrigin(m_pCameraPhysicsEntity->getOrigin());
    
    m_pDebugCamera->lookAt(m_pPlane->getOrigin());
    
    for(int i = 0; i < m_EnemyVector.size(); i++)
    {
        m_EnemyVector[i]->getSteeringBehavior()->setLinearFactor(btVector3(1,1,1));
    }
    
    long milli = dynamic_cast<StopWatch*>(FrameCounter::getInstance()->get(m_currentStopWatchID))->getMilliseconds();
    
    if (milli % 50 == 0)
    {
        createRandomObject();
    }
    
    
}
void GlobalGameJamGame::render()
{
    m_pCameraPhysicsEntity->render();
    
    //WorldPhysics::getInstance()->debugDrawWorld();
}
void GlobalGameJamGame::exit(void*)
{
    TextureFactory::getInstance()->destroy(cubeTextureID);
    ViewObjectFactory::getInstance()->destroy(cubeViewObjectID);
    CollisionShapeFactory::getInstance()->destroy(cubeConvexHull);
    
    TextureFactory::getInstance()->destroy(sphereTextureID);
    ViewObjectFactory::getInstance()->destroy(sphereViewObjectID);
    CollisionShapeFactory::getInstance()->destroy(sphereConvexHull);
    
    TextureFactory::getInstance()->destroy(floorTextureID);
    ViewObjectFactory::getInstance()->destroy(planeViewObjectID);
    CollisionShapeFactory::getInstance()->destroy(triangleMeshShape);
    
    TextureFactory::getInstance()->destroy(coneTextureID);
    ViewObjectFactory::getInstance()->destroy(rayconeViewObjectID);
    CollisionShapeFactory::getInstance()->destroy(rayConvexHullID);
    CollisionResponseBehaviorFactory::getInstance()->destroy(switchToEvadeCRB);
    
    TextureFactory::getInstance()->destroy(debugCameraTextureID);
    ViewObjectFactory::getInstance()->destroy(debugCameraViewObjectID);
    
    IDType _id = 0;
    _id = m_pCameraPhysicsEntity->getID();
    CameraFactory::getInstance()->destroy(_id);
    
    _id = m_pPlane->getID();
    EntityFactory::getInstance()->destroy(_id);
    
    _id = m_pCone->getID();
    EntityFactory::getInstance()->destroy(_id);
    
    _id = m_pDebugCamera->getID();
    CameraFactory::getInstance()->destroy(_id);
    
    CameraFactory::getInstance()->setCurrentCamera(NULL);
    
    SteeringEntity *p = NULL;
    for (int i = 0; i < m_EnemyVector.size(); i++)
    {
        p = m_EnemyVector[i];
        
        _id = p->getStateMachine()->getID();
        EntityStateMachineFactory::getInstance()->destroy(_id);
        
        _id = p->getSteeringBehavior()->getID();
        SteeringBehaviorFactory::getInstance()->destroy(_id);
        
        _id = p->getID();
        EntityFactory::getInstance()->destroy(_id);
    }
    
    ViewObjectFactory::getInstance()->destroy(skyboxViewObjectID);
    CollisionShapeFactory::getInstance()->destroy(skyboxTriangleMeshShape);
    TextureFactory::getInstance()->destroy(wallTextureID);
    
//    [[SingletonSoundManager sharedSoundManager] unLoadSFXWithKey:@"laser"];
//    
//    [sharedSoundManager stopBGMWithKey:@"game" fadeOut:NO];
//    [sharedSoundManager unLoadBGMWithKey:@"game"];
    
    destroyCollisionResponses();
    destroyCollisionFilters();
}

bool GlobalGameJamGame::onMessage(void*, const Telegram&){return false;}

void GlobalGameJamGame::touchRespond(const DeviceTouch &input)
{
    
    switch (input.getTouchPhase()) {
        case DeviceTouchPhaseBegan:
            //
            break;
        case DeviceTouchPhaseMoved:
            break;
        case DeviceTouchPhaseStationary:
            break;
        case DeviceTouchPhaseEnded:
            //createRandomObject();
            
//            if(input.getTouchTotal() == 1)
//            {
//                BaseCamera *cam = CameraFactory::getInstance()->getCurrentCamera();
//                if(cam == m_pDebugCamera)
//                {
//                    CameraFactory::getInstance()->setCurrentCamera(m_pCameraPhysicsEntity);
//                }
//                else
//                {
//                    CameraFactory::getInstance()->setCurrentCamera(m_pDebugCamera);
//                }
//                
//            }
//            else
//            {
//                createRandomObject();
//            }
            break;
        case DeviceTouchPhaseCancelled:
            break;
        default:
            break;
    }
    
    
}
void GlobalGameJamGame::tapGestureRespond(const DeviceTapGesture &input){}
void GlobalGameJamGame::pinchGestureRespond(const DevicePinchGesture &input){}
void GlobalGameJamGame::panGestureRespond(const DevicePanGesture &input){}
void GlobalGameJamGame::swipeGestureRespond(const DeviceSwipeGesture &input){}
void GlobalGameJamGame::rotationGestureRespond(const DeviceRotationGesture &input){}
void GlobalGameJamGame::longPressGestureRespond(const DeviceLongPressGesture &input){}
void GlobalGameJamGame::accelerometerRespond(const DeviceAccelerometer &input){}
void GlobalGameJamGame::motionRespond(const DeviceMotion &input)
{
    if(isPaused())
        return;
    
    btQuaternion yaw(g_vUpVector, input.getAttitude().getYaw());
    
    m_pCameraPhysicsEntity->setRotation(yaw);
    m_pCone->setRotation(yaw);
    
}
void GlobalGameJamGame::gyroRespond(const DeviceGyro &input){}
void GlobalGameJamGame::magnetometerRespond(const DeviceMagnetometer &input){}

CameraPhysicsEntity *GlobalGameJamGame::createCameraPhysicsEntity()
{
    cubeTextureID = TextureFactory::createTextureFromData("cubetexture1");
    cubeViewObjectID = ViewObjectFactory::createViewObject("cube",
                                                             &cubeTextureID,
                                                             1);
    cubeConvexHull = CollisionShapeFactory::createShape(cubeViewObjectID, CollisionShapeType_ConvexHull);
    
    
    
    
    sphereTextureID = TextureFactory::createTextureFromData("spheretexture");
    sphereViewObjectID = ViewObjectFactory::createViewObject("sphere",
                                                                    &sphereTextureID,
                                                                    1);
    sphereConvexHull = CollisionShapeFactory::createShape(sphereViewObjectID, CollisionShapeType_ConvexHull);
    
    CameraPhysicsEntityInfo *cinfo = new CameraPhysicsEntityInfo(false,
                                                                 sphereViewObjectID,
                                                                 0,
                                                                 0,
                                                                 false,
                                                                 sphereConvexHull,
                                                                 1.0f,
                                                                 65.0f,
                                                                 1.0f,
                                                                 100.0f,
                                                                 0.0f,
                                                                 480.0f,
                                                                 320.0f,
                                                                 0.0f);
    
    CameraPhysicsEntity *camera = CameraFactory::createCameraEntity<CameraPhysicsEntity, CameraPhysicsEntityInfo>(cinfo);
    
    
    camera->setKinematicPhysics();
    
    return camera;
}
//CameraEntity *GlobalGameJamGame::createRegularCamera()
//{
//    IDType bricksTextureID = TextureFactory::createTextureFromData("spheretexture");
//    IDType sphereViewObjectID = ViewObjectFactory::createViewObject("sphere",
//                                                                    &bricksTextureID,
//                                                                    1);
//    IDType m_shape_plane = CollisionShapeFactory::createShape(sphereViewObjectID, CollisionShapeType_Cube);
//                                                              
//    CameraEntityInfo *cinfo = new CameraEntityInfo(false,
//                                                   sphereViewObjectID,
//                                                   0,
//                                                   0,
//                                                   false,
//                                                   65.0f,
//                                                   0.01f,
//                                                   1000.0f,
//                                                   0.0f,
//                                                   480.0f,
//                                                   320.0f,
//                                                   0.0f);
//    
//    CameraEntity *camera = CameraFactory::createCameraEntity<CameraEntity, CameraEntityInfo>(cinfo);
//    
//    
//    
//    return camera;
//}

RigidEntity *GlobalGameJamGame::createPlane()
{
    floorTextureID = TextureFactory::createTextureFromData("floor");
    planeViewObjectID = ViewObjectFactory::createViewObject("planeobject", &floorTextureID);
    
    triangleMeshShape = CollisionShapeFactory::createShape(planeViewObjectID, CollisionShapeType_TriangleMesh);
    
    RigidEntityInfo *cInfo = new RigidEntityInfo(planeViewObjectID,
                                                 0,
                                                 0,
                                                 false,
                                                 triangleMeshShape,
                                                 0);
    RigidEntity *p = EntityFactory::createEntity<RigidEntity, RigidEntityInfo>(cInfo);
    delete cInfo;
    
    p->getRigidBody()->setFriction(1.0f);
    p->getRigidBody()->setRestitution(0.0f);
    
    return p;
}

RigidEntity *GlobalGameJamGame::createSkybox()
{
    //walltexture
    wallTextureID = TextureFactory::createTextureFromData("walltexture");
    skyboxViewObjectID = ViewObjectFactory::createViewObject("skybox", &wallTextureID);
    
    skyboxTriangleMeshShape = CollisionShapeFactory::createShape(planeViewObjectID, CollisionShapeType_TriangleMesh);
    
    RigidEntityInfo *cInfo = new RigidEntityInfo(skyboxViewObjectID,
                                                 0,
                                                 0,
                                                 false,
                                                 skyboxTriangleMeshShape,
                                                 0);
    RigidEntity *p = EntityFactory::createEntity<RigidEntity, RigidEntityInfo>(cInfo);
    delete cInfo;
    
    p->setKinematicPhysics();
    
    p->setOrigin(m_pPlane->getOrigin());
    
    return p;
    
}



void GlobalGameJamGame::createObjectStates()
{
//    BaseEntityStateInfo *cinfo = new BaseEntityStateInfo();
//    
//    cinfo->gametype = EntityStateType_ObjectFallState;
//    fallStateID = EntityStateFactory::getInstance()->create(cinfo);
//    
//    delete cinfo;

}


void GlobalGameJamGame::createCollisionResponses()
{
//    GGJPursueCollisionResponseBehaviorInfo *crInfo0 = new GGJPursueCollisionResponseBehaviorInfo();
//    pursueCollisionResponse = CollisionResponseBehaviorFactory::getInstance()->create(crInfo0);
//    delete crInfo0;
//    
//    GGJEvadeCollisionResponseBehaviorInfo *crInfo1 = new GGJEvadeCollisionResponseBehaviorInfo();
//    evadeCollisionResponse = CollisionResponseBehaviorFactory::getInstance()->create(crInfo1);
//    delete crInfo1;
//    
//    GGJDyingCollisionResponseBehaviorInfo *crInfo2 = new GGJDyingCollisionResponseBehaviorInfo();
//    dyingCollisionResponse = CollisionResponseBehaviorFactory::getInstance()->create(crInfo2);
//    delete crInfo2;
}


/*
 #include "GGJPlayerCollisionFilterBehavior.h"
 #include "GGJPlaneCollisionFilterBehavior.h"
 #include "GGJObjectCollisionFilterBehavior.h"
 #include "GGJConeCollisionFilterBehavior.h"
 */

void GlobalGameJamGame::createCollisionFilters()
{
//    GGJPlayerFilterBehaviorInfo *ofbi0 = new GGJPlayerFilterBehaviorInfo();
//    playerFilter = CollisionFilterBehaviorFactory::getInstance()->create(ofbi0);
//    delete ofbi0;
//    
//    GGJPlaneFilterBehaviorInfo *ofbi1 = new GGJPlaneFilterBehaviorInfo();
//    planeFilter = CollisionFilterBehaviorFactory::getInstance()->create(ofbi1);
//    delete ofbi1;
//    
//    GGJObjectFilterBehaviorInfo *ofbi2 = new GGJObjectFilterBehaviorInfo();
//    objectFilter = CollisionFilterBehaviorFactory::getInstance()->create(ofbi2);
//    delete ofbi2;
//    
//    GGJConeFilterBehaviorInfo *ofbi3 = new GGJConeFilterBehaviorInfo();
//    coneFilter = CollisionFilterBehaviorFactory::getInstance()->create(ofbi3);
//    delete ofbi3;
}

void GlobalGameJamGame::destroyCollisionResponses()
{
        
//    CollisionResponseBehaviorFactory::getInstance()->destroy(pursueCollisionResponse);
//    CollisionResponseBehaviorFactory::getInstance()->destroy(evadeCollisionResponse);
//    CollisionResponseBehaviorFactory::getInstance()->destroy(dyingCollisionResponse);
}
void GlobalGameJamGame::destroyCollisionFilters()
{   
//    CollisionFilterBehaviorFactory::getInstance()->destroy(playerFilter);
//    CollisionFilterBehaviorFactory::getInstance()->destroy(planeFilter);
//    CollisionFilterBehaviorFactory::getInstance()->destroy(objectFilter);
//    CollisionFilterBehaviorFactory::getInstance()->destroy(coneFilter);
}

SteeringEntity * GlobalGameJamGame::createCube(const btVector3 &origin)
{
    SteeringBehaviorInfo *scInfo = new SteeringBehaviorInfo();
    IDType steeringBehaviorFactoryID = SteeringBehaviorFactory::getInstance()->create(scInfo);
    delete scInfo;
    
    SteeringEntityInfo *cinfo = new SteeringEntityInfo(cubeViewObjectID,
                                                       0,
                                                       0,
                                                       false,
                                                       cubeConvexHull,
                                                       1.0f,
                                                       steeringBehaviorFactoryID);
    
    SteeringEntity *p = EntityFactory::createEntity<SteeringEntity, SteeringEntityInfo>(cinfo);
    
    p->setOrigin(origin);
    
    return p;
}

SteeringEntity * GlobalGameJamGame::createSphere(const btVector3 &origin)
{
    SteeringBehaviorInfo *scInfo = new SteeringBehaviorInfo();
    IDType steeringBehaviorFactoryID = SteeringBehaviorFactory::getInstance()->create(scInfo);
    delete scInfo;
    
    SteeringEntityInfo *cinfo = new SteeringEntityInfo(sphereViewObjectID,
                                                       0,
                                                       0,
                                                       false,
                                                       sphereConvexHull,
                                                       1.0f,
                                                       steeringBehaviorFactoryID);
    
    SteeringEntity *p = EntityFactory::createEntity<SteeringEntity, SteeringEntityInfo>(cinfo);
    
    p->setOrigin(origin);
    
    return p;
}
//SteeringEntity *GlobalGameJamGame::createObject(const std::string &objectName,
//                                                const std::string &textureName,
//                                                CollisionShapeType shape,
//                                                const btVector3 &origin)
//{
//    IDType m_image_tarsier = TextureFactory::createTextureFromData(textureName);
//    IDType m_mesh = ViewObjectFactory::createViewObject(objectName, &m_image_tarsier);
//    
//    IDType m_shape = CollisionShapeFactory::createShape(m_mesh, shape);
//    
//    SteeringBehaviorInfo *scInfo = new SteeringBehaviorInfo();
//    IDType steeringBehaviorFactoryID = SteeringBehaviorFactory::getInstance()->create(scInfo);
//    delete scInfo;
//
//    SteeringEntityInfo *cinfo = new SteeringEntityInfo(m_mesh,
//                                                       0,
//                                                       0,
//                                                       false,
//                                                       m_shape,
//                                                       1.0f,
//                                                       steeringBehaviorFactoryID);
//    
//    SteeringEntity *p = EntityFactory::createEntity<SteeringEntity, SteeringEntityInfo>(cinfo);
//    
//    p->setOrigin(origin);
//    
//    return p;
//}



GhostEntity *GlobalGameJamGame::createGhostEntity()
{
    coneTextureID = TextureFactory::createTextureFromData("conetexture1");
    rayconeViewObjectID = ViewObjectFactory::createViewObject("raycone", &coneTextureID);
    
    rayConvexHullID = CollisionShapeFactory::createShape(rayconeViewObjectID, CollisionShapeType_ConvexHull);
    
//    SwitchToEvadeCollisionResponseBehaviorInfo *crInfo = new SwitchToEvadeCollisionResponseBehaviorInfo();
//    switchToEvadeCRB = CollisionResponseBehaviorFactory::getInstance()->create(crInfo);
//    delete crInfo;
    
    GhostEntityInfo *cinfo = new GhostEntityInfo(rayconeViewObjectID,
                                                 0,
                                                 0,
                                                 false,
                                                 rayConvexHullID);

    GhostEntity *p = EntityFactory::createEntity<GhostEntity, GhostEntityInfo>(cinfo);
    
    
    
    
    //p->setCollisionResponseBehavior(switchToEvadeCRB);
    
    
    
    return p;
}

void GlobalGameJamGame::createRandomObject()
{
    btVector3 aabMinPlane, aabMaxPlane;
    
    m_pPlane->getRigidBody()->getAabb(aabMinPlane, aabMaxPlane);
    
    
    float buffer = 20.0f;
    
    float x;
    float z;
    
    switch (randomIntegerRange(0, 3))
    {
        default:case 0:
            x = aabMinPlane.x() + buffer;
            z = aabMinPlane.z() + buffer;
            break;
            
        case 1:
            x = aabMinPlane.x() + buffer;
            z = aabMaxPlane.z() - buffer;
            break;
            
        case 2:
            x = aabMaxPlane.x() - buffer;
            z = aabMaxPlane.z() - buffer;
            break;
            
        case 3:
            x = aabMaxPlane.x() - buffer;
            z = aabMinPlane.z() + buffer;
            break;
    }
    
    
    
    SteeringEntity *entity = NULL;
    

    entity = createCube(btVector3(x,10.0,z));
    
    
//    EntityStateMachineInfo *cinfo = new EntityStateMachineInfo();
//    IDType _id = EntityStateMachineFactory::getInstance()->create(cinfo);
//    entity->setStateMachineID(_id);
//    
//    entity->getStateMachine()->pushCurrentState(EntityStateFactory::getInstance()->get(fallStateID));
    
//    entity->getSteeringBehavior()->setPursuitOn(m_pCameraPhysicsEntity);
    //entity->getSteeringBehavior()->PursuitOff();

    entity->setMaxLinearSpeed(5.0f);
    entity->setMaxLinearForce(5.0f);
    
    m_EnemyVector.push_back(entity);
    
}
void GlobalGameJamGame::createDebugCamera()
{
    debugCameraTextureID = TextureFactory::createTextureFromData("bricks");
    debugCameraViewObjectID = ViewObjectFactory::createViewObject("object1",
                                                                    &debugCameraTextureID,
                                                                    1);
    CameraEntityInfo *cinfo = new CameraEntityInfo(false,
                                                   debugCameraViewObjectID,
                                                   0,
                                                   0,
                                                   false,
                                                   65.0f,
                                                   0.01f,
                                                   1000.0f,
                                                   0.0f,
                                                   480.0f,
                                                   320.0f,
                                                   0.0f);
    m_pDebugCamera = CameraFactory::createCameraEntity<CameraEntity, CameraEntityInfo>(cinfo);
    
    m_pDebugCamera->hide();
    
    CameraFactory::getInstance()->setCurrentCamera(m_pDebugCamera);
    
    m_pDebugCamera->setOrigin(btVector3(30, 30, 30));
    m_pDebugCamera->lookAt(m_pPlane->getOrigin());
    
}