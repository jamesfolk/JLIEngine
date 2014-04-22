//
//  MazeGameState.cpp
//  MazeADay
//
//  Created by James Folk on 11/15/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "MazeGameState.h"

#include "TextureFactory.h"
#include "ViewObjectFactory.h"
#include "CollisionShapeFactory.h"
#include "CollisionResponseBehaviorFactory.h"
//#include "CollisionFilterBehaviorFactory.h"
//#include "UpdateBehaviorFactory.h"
#include "SteeringBehaviorFactory.h"
#include "Path.h"
#include "CameraFactory.h"
#include "EntityFactory.h"


//#include "PlayerCollisionResponseBehavior.h"
//#include "FinishLevelCollisionResponseBehavior.h"
//#include "PlayerCollisionFilterBehavior.h"
//#include "FinishLevelCollisionFilterBehavior.h"
//#include "PlayerUpdateBehavior.h"
#include "CameraSteeringEntity.h"

#include "HeadingSmoother.h"
#include "MazeCreator.h"
#include "MeshMazeCreator.h"
#include "UserSettingsSingleton.h"

#include "MazeMiniMapFBO.h"
#include "TextureBufferObjectFactory.h"

#include "GameStateMachine.h"
#include "VertexAttributeLoader.h"
#include "CameraEntity.h"

//#include "PlayerInput.h"

#include "TextViewObjectFactory.h"
#import "AppDelegate.h"

#import <dispatch/dispatch.h>


const int s_BoardSizeMax = 45;

const int s_InitialBoardSize = 2;

int MazeGameState::s_BoardSize = s_InitialBoardSize;
CameraSteeringEntity *MazeGameState::s_pCamera = NULL;
RigidEntity *MazeGameState::s_pPlayerAvatar = NULL;
GhostEntity *MazeGameState::s_pGoalTrigger = NULL;
StopWatch *MazeGameState::s_pCurrentStopWatch = NULL;
StopWatch *MazeGameState::s_pGamePlayTimer = NULL;
//Timer *MazeGameState::s_pUtilityTimer = NULL;
Path *MazeGameState::s_pPath = NULL;
IDType MazeGameState::s_mazeTextureID = 0;
MeshMazeCreator *MazeGameState::s_pMazeMesh = NULL;
IDType MazeGameState::s_MazeMiniMapTextureBehaviorFactoryID = 0;
IDType MazeGameState::s_MazeMiniMapSpriteViewObjectID = 0;
IDType MazeGameState::s_MazeMiniMapSpriteFactoryID = 0;
IDType MazeGameState::s_MazeMiniMapTextureBufferObject = 0;
btVector3 *MazeGameState::s_MazeStartOrigin = 0;
btVector3 *MazeGameState::s_MazeEndOrigin = 0;
IDType MazeGameState::s_readySetGoGameStateID = 0;
IDType MazeGameState::s_playGameStateID = 0;
IDType MazeGameState::s_loseGameStateID = 0;
IDType MazeGameState::s_winGameStateID = 0;

IDType MazeGameState::s_previousLevelGameStateID = 0;
IDType MazeGameState::s_nextLevelGameStateID = 0;


dispatch_queue_t MazeGameState::backgroundQueue = nil;

std::vector<MazeLevelData*> *MazeGameState::MazeLevelDataVector = NULL;

MazeGameState::MazeGameState() :
//m_mazeTextureID(0),
m_bricksTextureID(0),
m_tarsierTextureID(0),
m_sphereViewObjectID(0),
m_cubeViewObjectID(0),
m_sphereCollisionShapeID(0),

m_cubeCollisionShapeID(0),
m_playercollisionResponseID(0),
m_finishLevelCollisionResponseFactoryID(0),
m_playercollisionFilterID(0),
m_finishLevelcollisionFilterID(0),
m_playerUpdateBehaviorInfoID(0),
m_cameraSteeringBehaviorID(0),

//m_TouchStartTime(0),
//m_InitalizeTouch(false),
//m_TouchStart(new btVector3(0,0,0)),
//m_bCanMovePlayer(false),
//m_ImpulseContant(100000.0f),
//m_MaxTouchDistance(40.0),
m_currentStopWatchID(0),
m_savedTimeStopWatchID(0)//,
//m_timerID(0)
{
    
}
MazeGameState::~MazeGameState()
{
    //delete m_TouchStart;
    //dispatch_release(backgroundQueue);
}

void MazeGameState::enter(void*)
{
    createAssets();
    setup();
    
    createGameStates();
    
    
    
    GameStateMachine::getInstance()->pushCurrentState(MazeGameState::getGameState(GameStateType_MazeGameState_ReadySetGo));
}

void MazeGameState::pause_reaction(bool paused)
{
    if(paused)
    {
//        if(MazeGameState::getMazeMiniMapSprite())
//            MazeGameState::getMazeMiniMapSprite()->hide();
        
        if(MazeGameState::getMazeMeshCreator() &&
           MazeGameState::getMazeMeshCreator()->getMaze())
            MazeGameState::getMazeMeshCreator()->getMaze()->hide();
        
        if(MazeGameState::getGamePlayer())
            MazeGameState::getGamePlayer()->hide();
        
        if(MazeGameState::getGameGoal())
            MazeGameState::getGameGoal()->hide();
    }
    else
    {
        if(MazeGameState::getMazeMiniMapSprite())
            MazeGameState::getMazeMiniMapSprite()->show();
        
        if(MazeGameState::getMazeMeshCreator() &&
           MazeGameState::getMazeMeshCreator()->getMaze())
            MazeGameState::getMazeMeshCreator()->getMaze()->show();
        
        if(MazeGameState::getGamePlayer())
            MazeGameState::getGamePlayer()->show();
        
        if(MazeGameState::getGameGoal())
            MazeGameState::getGameGoal()->show();
    }
}

void MazeGameState::update(void*, btScalar deltaTimeStep)
{
    CameraFactory::getInstance()->getOrthoCamera()->lookAt(btVector3(0,0,0));
    
    if(MazeGameState::getMazeMiniMapTBO())
        MazeGameState::getMazeMiniMapTBO()->update();
    
    TextViewObjectFactory::getInstance()->updateDrawText(MazeGameState::getCurrentStopWatch()->toString(),
                                                         LocalizedTextViewObjectType_Helvetica_128pt,
                                                         btVector3(0,
                                                                   CameraFactory::getScreenHeight() - 80,
                                                                   200),
                                                         m_GameTimerDrawingText,
                                                         btVector3(1.0f, 0.0f, 0.0f));
    
    TextViewObjectFactory::getInstance()->updateDrawText(MazeGameState::getSavedStopWatch()->toString(),
                                                         LocalizedTextViewObjectType_Helvetica_64pt,
                                                         btVector3(0,
                                                                   (CameraFactory::getScreenHeight() - 45) - 80,
                                                                   200),
                                                         m_StopWatchDrawingText,
                                                         btVector3(1.0f, 0.0f, 0.0f));
    char level[32] = "";
    
    sprintf(level, "LEVEL:%d", getCurrentLevel());
    TextViewObjectFactory::getInstance()->updateDrawText(std::string(level),
                                                         LocalizedTextViewObjectType_Helvetica_32pt,
                                                         btVector3(0, ((CameraFactory::getScreenHeight() - 22) - 45) - 80, 200),
                                                         m_LevelDrawingText,
                                                         btVector3(1.0f, 0.0f, 0.0f));
    
    
//    float x = MazeGameState::getGameCamera()->getSteeringBehavior()->getPath()->getRotation().x();
//    float y = MazeGameState::getGameCamera()->getSteeringBehavior()->getPath()->getRotation().y();
//    float z = MazeGameState::getGameCamera()->getSteeringBehavior()->getPath()->getRotation().z();
//    float w = MazeGameState::getGameCamera()->getSteeringBehavior()->getPath()->getRotation().w();
//    printf("(%.1f, %.1f, %.1f, %.1f)\n", x, y, z, w);
}
void MazeGameState::render()
{
//    MazeGameState::getMazeMiniMapSprite()->getVBO()->loadTextureName(0, MazeGameState::getMazeMiniMapTBO()->name());
}
void MazeGameState::exit(void*)
{
   // destroyGameStates();
    destroyAssets();
    MazeGameState::destroyMaze();
}
bool MazeGameState::onMessage(void*, const Telegram&)
{
    
}

void MazeGameState::touchRespond(const DeviceTouch &input)
{
    if(input.getTouchPhase() == DeviceTouchPhaseBegan)
    {
        MazeGameState::getGameCamera()->setMaxLinearSpeed(40.0f);
    }
//    std::string s(input);
//    NSLog(@"%s\n", s.c_str());
}
void MazeGameState::tapGestureRespond(const DeviceTapGesture &input)
{
}
void MazeGameState::pinchGestureRespond(const DevicePinchGesture &input)
{
    MazeGameState::getGameCamera()->setMaxLinearSpeed(40.0f * fabsf(input.getVelocity()));
    
    if(input.getVelocity() > 0.0f)
    {
        MazeGameState::getGameCamera()->getSteeringBehavior()->getPath()->setPathIncrement(PathIncrement_Positive);
    }
    else if(input.getVelocity() < 0.0f)
    {
        MazeGameState::getGameCamera()->getSteeringBehavior()->getPath()->setPathIncrement(PathIncrement_Negative);
    }
}
void MazeGameState::panGestureRespond(const DevicePanGesture &input)
{
}
void MazeGameState::swipeGestureRespond(const DeviceSwipeGesture &input)
{
}
void MazeGameState::rotationGestureRespond(const DeviceRotationGesture &input)
{
}
void MazeGameState::longPressGestureRespond(const DeviceLongPressGesture &input)
{
}
void MazeGameState::accelerometerRespond(const DeviceAccelerometer &input)
{
}
void MazeGameState::motionRespond(const DeviceMotion &input)
{
    //MazeGameState::getMazeMeshCreator()->getMaze()->setRotation(input.getAttitude().getQuaternion());
}
void MazeGameState::gyroRespond(const DeviceGyro &input)
{
    
}
void MazeGameState::magnetometerRespond(const DeviceMagnetometer &input)
{
}


void MazeGameState::saveDefaultData()
{
    if(!didQuit())
    {
        
        UserSettingsSingleton::getInstance()->setFloat("player_x",
                                                       MazeGameState::getGamePlayer()->getOrigin().x());
        UserSettingsSingleton::getInstance()->setFloat("player_y",
                                                       MazeGameState::getGamePlayer()->getOrigin().y());
        UserSettingsSingleton::getInstance()->setFloat("player_z",
                                                       MazeGameState::getGamePlayer()->getOrigin().z());
    }
}

void MazeGameState::loadDefaultData()
{
    float x = UserSettingsSingleton::getInstance()->getFloat("player_x");
    float y = UserSettingsSingleton::getInstance()->getFloat("player_y");
    float z = UserSettingsSingleton::getInstance()->getFloat("player_z");
    if(MazeGameState::getGamePlayer())
    MazeGameState::getGamePlayer()->setOrigin(btVector3(x, y, z));
}

void MazeGameState::enablePause(bool pause)
{
    BaseGameState::enablePause(pause);
    
    if(pause)
    {
        NSLog(@"show pause screen");
    }
    else
    {
        NSLog(@"hide pause screen");
    }
}

int MazeGameState::getCurrentLevel()
{
    return (s_BoardSize - s_InitialBoardSize) + 1;
}

int MazeGameState::getMinimumLevel()
{
    return 1;
}
int MazeGameState::getMaximumLevel()
{
    return (s_InitialBoardSize + s_BoardSizeMax);
}


void MazeGameState::setCompletedLevel(int level)
{
    if(level <= MazeGameState::getMaximumLevel() &&
       level >= 1)
    {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        long current_time = std::numeric_limits<long>::max() - 1;
        [appDelegate addMazeEntry:[NSDate date]
                         theLevel:level
                     theTotalTime:current_time];
    }
}

bool MazeGameState::completedLevel( int level)
{
    bool ret = false;
    
    if(level <= MazeGameState::getMaximumLevel() &&
       level >= 1)
    {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

        long time = [appDelegate getMazeEntry:[NSDate date] theLevel:level];
        
        ret = (time != std::numeric_limits<long>::max());
    }
    return ret;
}

long MazeGameState::getTotalTime()
{
    return MazeGameState::getCurrentStopWatch()->getMilliseconds();
}

void MazeGameState::setup()
{
    MazeGameState::getGameCameraPath()->setPathIncrement(PathIncrement_None);
    
    //:!!!: setup camera
    
    MazeGameState::getGameCamera()->hide();
//    MazeGameState::getGameCamera()->getSteeringBehavior()->setFollowPathOn(MazeGameState::getGameCameraPath());
    MazeGameState::getGameCamera()->setMaxLinearSpeed(40.0f);
    
    MazeGameState::getGameCamera()->enableCollision(false);
    
    
    
    
    //:!!!: setup player
    
    MazeGameState::getGamePlayer()->getRigidBody()->setActivationState(DISABLE_DEACTIVATION);
    
    MazeGameState::getGamePlayer()->getRigidBody()->setRestitution(0.0f);
    MazeGameState::getGamePlayer()->getRigidBody()->setFriction(10.0f);
    
    
    
    MazeGameState::getGamePlayer()->enableHandleCollision();
    //MazeGameState::getGamePlayer()->setCollisionFilterBehavior(m_playercollisionFilterID);
    MazeGameState::getGamePlayer()->setCollisionResponseBehavior(m_playercollisionResponseID);
    //MazeGameState::getGamePlayer()->setUpdateBehavior(m_playerUpdateBehaviorInfoID);
    
    MazeGameState::getGamePlayer()->getRigidBody()->clearForces();
    
    
    
    
    
    
    //:!!!: setup goal trigger
    
    
    
    
    
    
    btVector3 aabbMin, aabbMax;
    
    
    //m_TouchStartTime = FrameCounter::getInstance()->getCurrentTime();
    
    MazeGameState::getGamePlayer()->getRigidBody()->getCollisionShape()->getAabb(btTransform::getIdentity(), aabbMin, aabbMax);
    
    btVector3 offset(0,aabbMax.y() + 0.0f, aabbMin.z() - 0.0f);
    
    MazeGameState::getGameCameraPath()->attachToEntity(MazeGameState::getGamePlayer(), MazeGameState::getGameCameraPath()->getNumberOfWayPoints() - 1, offset);
    
    MazeGameState::getGameCamera()->setOrigin(MazeGameState::getGameCameraPath()->getWayPoint(0));
    MazeGameState::getGameCamera()->getFolowPathInfo()->setWayPointSeekDistance(MazeGameState::getGameCameraPath()->getAverageDistanceBetweenPoints() / 2.0f);
    
//    MazeGameState::getMazeMiniMapSprite()->setOrigin(btVector3(CameraFactory::getScreenWidth() - 128, CameraFactory::getScreenHeight() - 128,0));
    
    
    
    CameraFactory::getInstance()->getOrthoCamera()->setOrigin(btVector3(0, 0, 10));
    
    
    
    
    //m_bCanMovePlayer = false;
    
    
    
    MazeGameState::getGameGoal()->setCollisionResponseBehavior(m_finishLevelCollisionResponseFactoryID);
    //MazeGameState::getGameGoal()->setCollisionFilterBehavior(m_finishLevelcollisionFilterID);
    
    
    
    
}

void MazeGameState::createAssets()
{
    createOrthoCamera();
    createTextureObjects();
    createViewObjects();
    createTextViewObjects();
    createCollisionShapes();
    createCollisionResponseObjects();
    createCollisionFilterObjects();
    createUpdateBehaviorObjects();
    createSteeringBehaviors();
    createPath();
    createCamera();
    createPlayerEntity();
    createGoalEntity();
    createFrameTimers();
}

void MazeGameState::createOrthoCamera()
{
    CameraEntityInfo *constructionInfo = new CameraEntityInfo(true);
    constructionInfo->m_nearZ = -1024;
    constructionInfo->m_farZ = 1024;
    
    CameraEntity *orthoCamera = CameraFactory::createCameraEntity<CameraEntity, CameraEntityInfo>(constructionInfo);
    delete constructionInfo;
    
    orthoCamera->hide();
    CameraFactory::getInstance()->setOrthoCamera(orthoCamera);
}

void MazeGameState::createTextureObjects()
{
    //m_mazeTextureID = TextureFactory::createTextureFromData("temp");
    m_bricksTextureID = TextureFactory::createTextureFromData("bricks");
    m_tarsierTextureID = TextureFactory::createTextureFromData("tarsier");
}


void MazeGameState::createViewObjects()
{
    m_sphereViewObjectID = ViewObjectFactory::createViewObject("sphere",
                                                               &m_bricksTextureID,
                                                               1);
    m_cubeViewObjectID = ViewObjectFactory::createViewObject("cube",
                                                             &m_tarsierTextureID,
                                                             1);
}
void MazeGameState::createTextViewObjects()
{
    BaseTextViewInfo *info = NULL;
    
    const size_t size = 32;
    
    info = new BaseTextViewInfo(ShaderFactory::getInstance()->getCurrentShaderID());
    for(size_t i = 0; i < size; i++)
    {
        m_StopWatchDrawingText.push_back(TextViewObjectFactory::getInstance()->create(info));
    }
    delete info;
    
//    info = new BaseTextViewInfo(ShaderFactory::getInstance()->getCurrentShaderID());
//    for(size_t i = 0; i < size; i++)
//    {
//        m_TimerWatchDrawingText.push_back(TextViewObjectFactory::getInstance()->create(info));
//    }
//    delete info;
    
    info = new BaseTextViewInfo(ShaderFactory::getInstance()->getCurrentShaderID());
    for(size_t i = 0; i < size; i++)
    {
        m_GameTimerDrawingText.push_back(TextViewObjectFactory::getInstance()->create(info));
    }
    delete info;
    
    info = new BaseTextViewInfo(ShaderFactory::getInstance()->getCurrentShaderID());
    for(size_t i = 0; i < size; i++)
    {
        m_LevelDrawingText.push_back(TextViewObjectFactory::getInstance()->create(info));
    }
    delete info;
}


void MazeGameState::createCollisionShapes()
{
    m_sphereCollisionShapeID = CollisionShapeFactory::createShape(m_sphereViewObjectID,
                                                                  CollisionShapeType_Sphere);
    m_cubeCollisionShapeID = CollisionShapeFactory::createShape(m_cubeViewObjectID,
                                                                CollisionShapeType_Cube);
}


void MazeGameState::createCollisionResponseObjects()
{
//    PlayerCollisionResponseBehaviorInfo *pinfo = new PlayerCollisionResponseBehaviorInfo();
//    m_playercollisionResponseID = CollisionResponseBehaviorFactory::getInstance()->create(pinfo);
//    delete pinfo;
//    
//    FinishLevelResponseBehaviorInfo *finfo = new FinishLevelResponseBehaviorInfo();
//    m_finishLevelCollisionResponseFactoryID = CollisionResponseBehaviorFactory::getInstance()->create(finfo);
//    delete finfo;
}

void MazeGameState::createCollisionFilterObjects()
{
//    PlayerFilterBehaviorInfo *pcolInfo = new PlayerFilterBehaviorInfo();
//    m_playercollisionFilterID = CollisionFilterBehaviorFactory::getInstance()->create(pcolInfo);
//    delete pcolInfo;
//    
//    FinishLevelFilterBehaviorInfo *fcolInfo = new FinishLevelFilterBehaviorInfo();
//    m_finishLevelcollisionFilterID = CollisionFilterBehaviorFactory::getInstance()->create(fcolInfo);
//    delete fcolInfo;
}



void MazeGameState::createUpdateBehaviorObjects()
{
//    PlayerUpdateBehaviorInfo *puinfo = new PlayerUpdateBehaviorInfo();
//    m_playerUpdateBehaviorInfoID = UpdateBehaviorFactory::getInstance()->create(puinfo);
//    delete puinfo;
}

void MazeGameState::createSteeringBehaviors()
{
    SteeringBehaviorInfo *sconstructionInfo = new SteeringBehaviorInfo();
    
    m_cameraSteeringBehaviorID = SteeringBehaviorFactory::getInstance()->create(sconstructionInfo);
    
    delete sconstructionInfo;
}
void MazeGameState::createPath()
{
    PathInfo *info = new PathInfo();
    info->m_curveName = "camerapath";
    
    MazeGameState::setGameCameraPath(new Path(*info));
    
    delete info;
}



void MazeGameState::createCamera()
{
    
    
    CameraSteeringEntityInfo *constructionInfo =
        new CameraSteeringEntityInfo(false,
                                     m_sphereViewObjectID,
                                     0,
                                     0,
                                     false,
                                     m_sphereCollisionShapeID,
                                     1.0,
                                     m_cameraSteeringBehaviorID,
                                     WanderInfo());
    
    constructionInfo->m_nearZ = 0.01f;
    constructionInfo->m_farZ = 1000.0f;
    
    MazeGameState::setGameCamera(CameraFactory::createCameraEntity<CameraSteeringEntity, CameraSteeringEntityInfo>(constructionInfo));
    delete constructionInfo;
    CameraFactory::getInstance()->setCurrentCamera(MazeGameState::getGameCamera());
}


void MazeGameState::createPlayerEntity()
{
    
    RigidEntityInfo *constructionInfo = new RigidEntityInfo(m_sphereViewObjectID,
                                                            0,
                                                            0,
                                                            false,
                                                            m_sphereCollisionShapeID,
                                                            50.0f);
    
    MazeGameState::setGamePlayer(EntityFactory::createEntity<RigidEntity, RigidEntityInfo>(constructionInfo));
    delete constructionInfo;
    
    
}
void MazeGameState::createGoalEntity()
{
    GhostEntityInfo *constructionInfo = new GhostEntityInfo(m_cubeViewObjectID,
                                                            0,
                                                            0,
                                                            false,
                                                            m_cubeCollisionShapeID);
    
    MazeGameState::setGameGoal(EntityFactory::createEntity<GhostEntity, GhostEntityInfo>(constructionInfo));
    
    
}

void MazeGameState::createFrameTimers()
{
    TimerInfo timerInfo;
    
    timerInfo.m_timerType = TimerType_StopWatch;
    m_currentStopWatchID = FrameCounter::getInstance()->create(&timerInfo);
    
    timerInfo.m_timerType = TimerType_StopWatch;
    m_savedTimeStopWatchID = FrameCounter::getInstance()->create(&timerInfo);
    
    MazeGameState::setSavedStopWatch(dynamic_cast<StopWatch*>(FrameCounter::getInstance()->get(m_savedTimeStopWatchID)));
    
    MazeGameState::setCurrentStopWatch(dynamic_cast<StopWatch*>(FrameCounter::getInstance()->get(m_currentStopWatchID)));
}



void MazeGameState::destroyAssets()
{
    destroyOrthoCamera();
    destroyTextureObjects();
    destroyViewObjects();
    destroyTextViewObjects();
    destroyCollisionShapes();
    destroyCollisionResponseObjects();
    destroyCollisionFilterObjects();
    destroyUpdateBehaviorObjects();
    destroySteeringBehaviors();
    destroyPath();
    destroyCamera();
    destroyPlayerEntity();
    destroyGoalEntity();
    destroyFrameTimers();
    
    
    //MazeGameState::destroyMaze();
    //MazeGameState::destroyMiniMap();
    
    setGameCamera(NULL);
    setGamePlayer(NULL);
    setGameGoal(NULL);
    setCurrentStopWatch(NULL);
    setSavedStopWatch(NULL);
    //setGameUtilityTimer(NULL);
    setGameCameraPath(NULL);
}














void MazeGameState::destroyOrthoCamera()
{
    if(CameraFactory::getInstance()->getOrthoCamera())
    {
        IDType _id = CameraFactory::getInstance()->getOrthoCamera()->getID();
        CameraFactory::getInstance()->destroy(_id);
    }
    CameraFactory::getInstance()->setOrthoCamera(NULL);
}

void MazeGameState::destroyTextureObjects()
{
    //TextureFactory::getInstance()->destroy(m_mazeTextureID);
    TextureFactory::getInstance()->destroy(m_bricksTextureID);
    TextureFactory::getInstance()->destroy(m_tarsierTextureID);
}


void MazeGameState::destroyViewObjects()
{
    ViewObjectFactory::getInstance()->destroy(m_sphereViewObjectID);
    ViewObjectFactory::getInstance()->destroy(m_cubeViewObjectID);
}
void MazeGameState::destroyTextViewObjects()
{
    for(int i = 0; i < m_StopWatchDrawingText.size(); i++)
    {
        TextViewObjectFactory::getInstance()->destroy(m_StopWatchDrawingText.at(i));
    }
    m_StopWatchDrawingText.clear();
    
    
//    for(int i = 0; i < m_TimerWatchDrawingText.size(); i++)
//    {
//        TextViewObjectFactory::getInstance()->destroy(m_TimerWatchDrawingText.at(i));
//    }
//    m_TimerWatchDrawingText.clear();
    
    
    
    for(int i = 0; i < m_GameTimerDrawingText.size(); i++)
    {
        TextViewObjectFactory::getInstance()->destroy(m_GameTimerDrawingText.at(i));
    }
    m_GameTimerDrawingText.clear();
    
    
    
    for(int i = 0; i < m_LevelDrawingText.size(); i++)
    {
        TextViewObjectFactory::getInstance()->destroy(m_LevelDrawingText.at(i));
    }
    m_LevelDrawingText.clear();
}


void MazeGameState::destroyCollisionShapes()
{
    CollisionShapeFactory::getInstance()->destroy(m_sphereCollisionShapeID);
    CollisionShapeFactory::getInstance()->destroy(m_cubeCollisionShapeID);
}


void MazeGameState::destroyCollisionResponseObjects()
{
//    CollisionResponseBehaviorFactory::getInstance()->destroy(m_playercollisionResponseID);
//    CollisionResponseBehaviorFactory::getInstance()->destroy(m_finishLevelCollisionResponseFactoryID);
}

void MazeGameState::destroyCollisionFilterObjects()
{
//    CollisionFilterBehaviorFactory::getInstance()->destroy(m_playercollisionFilterID);
//    CollisionFilterBehaviorFactory::getInstance()->destroy(m_finishLevelcollisionFilterID);
}



void MazeGameState::destroyUpdateBehaviorObjects()
{
    //UpdateBehaviorFactory::getInstance()->destroy(m_playerUpdateBehaviorInfoID);
}

void MazeGameState::destroySteeringBehaviors()
{
    SteeringBehaviorFactory::getInstance()->destroy(m_cameraSteeringBehaviorID);
}
void MazeGameState::destroyPath()
{
    delete MazeGameState::getGameCameraPath();
}



void MazeGameState::destroyCamera()
{
    if(MazeGameState::getGameCamera())
    {
        IDType _id = MazeGameState::getGameCamera()->getID();
        
        CameraFactory::getInstance()->destroy(_id);
        CameraFactory::getInstance()->setCurrentCamera(NULL);
    }
}


void MazeGameState::destroyPlayerEntity()
{
    if(MazeGameState::getGamePlayer())
    {
        IDType _id = MazeGameState::getGamePlayer()->getID();
        
        EntityFactory::getInstance()->destroy(_id);
    }
}
void MazeGameState::destroyGoalEntity()
{
    if(MazeGameState::getGameGoal())
    {
        IDType _id = MazeGameState::getGameGoal()->getID();
        
        EntityFactory::getInstance()->destroy(_id);
    }
}

void MazeGameState::destroyFrameTimers()
{
    FrameCounter::getInstance()->destroy(m_currentStopWatchID);
    //FrameCounter::getInstance()->destroy(m_timerID);
    FrameCounter::getInstance()->destroy(m_savedTimeStopWatchID);
}


void MazeGameState::lookAtPlayerCenter()
{
    btVector3 desiredHeading(MazeGameState::getGamePlayer()->getOrigin() - MazeGameState::getGameCamera()->getOrigin());
    
    HeadingSmoother::getInstance()->addHeading(MazeGameState::getGameCamera()->getID(), desiredHeading);
    desiredHeading = HeadingSmoother::getInstance()->getHeadingVector(MazeGameState::getGameCamera()->getID());
    
//    MazeGameState::getGameCamera()->setHeadingVector(desiredHeading);
    MazeGameState::getGameCamera()->lookAtHeading();
}

void MazeGameState::lookAtMazeCenter()
{
    btVector3 desiredHeading(MazeGameState::getMazeMeshCreator()->getMaze()->getOrigin() - MazeGameState::getGameCamera()->getOrigin());
    
    HeadingSmoother::getInstance()->addHeading(MazeGameState::getGameCamera()->getID(), desiredHeading);
    desiredHeading = HeadingSmoother::getInstance()->getHeadingVector(MazeGameState::getGameCamera()->getID());
    
//    MazeGameState::getGameCamera()->setHeadingVector(desiredHeading);
    MazeGameState::getGameCamera()->lookAtHeading();
}



void MazeGameState::setBoardSize(const int size)
{
    s_BoardSize = size;
}

int MazeGameState::getBoardSize()
{
    return s_BoardSize;
}

void MazeGameState::resetBoard()
{
    s_BoardSize = s_InitialBoardSize;
}

bool MazeGameState::decreaseBoardSize()
{
    bool ret = true;
    
    s_BoardSize--;
    if(s_BoardSize < s_InitialBoardSize)
    {
        s_BoardSize = s_InitialBoardSize;
        ret = false;
    }
    
    return ret;
}

bool MazeGameState::increaseBoardSize()
{
    bool ret = true;
    
    s_BoardSize++;
    if(s_BoardSize > s_BoardSizeMax)
    {
        s_BoardSize = s_BoardSizeMax;
        ret = false;
    }
    
    return ret;
}

//int MazeGameState::getMazeCurrentLevel()
//{
//    MazeGameState *pMazeGameState = dynamic_cast<MazeGameState*>(GameStateMachine::getInstance()->getCurrentState());
//    int level = 0;
//    if(pMazeGameState)
//    {
//        level = pMazeGameState->getCurrentLevel();
//    }
//    return level;
//}
//
//long MazeGameState::getMazeTotalTime()
//{
//    MazeGameState *pMazeGameState = dynamic_cast<MazeGameState*>(GameStateMachine::getInstance()->getCurrentState());
//    
//    double totalTime = 0.0;
//    if(pMazeGameState)
//    {
//        totalTime = pMazeGameState->getTotalTime();
//    }
//    return totalTime;
//}

unsigned int MazeGameState::getSeed()
{
    time_t rawtime;
    struct tm * ptm;
    
    time ( &rawtime );
    
    ptm = gmtime ( &rawtime );
    
    return ptm->tm_yday;
}

void MazeGameState::createMaze(unsigned int board_size, unsigned int seed, bool solve)
{
    s_mazeTextureID = TextureFactory::createTextureFromData("temp");
    
    MazeCreator::createInstance();
    
    UserSettingsSingleton::getInstance()->setInteger("board_size", board_size);
    UserSettingsSingleton::getInstance()->setInteger("seed", seed);
    
    unsigned int row_count = board_size;
    unsigned int column_count = board_size;
    MazeRenderType type = MazeRenderType_Mesh;
    
    s_pMazeMesh = dynamic_cast<MeshMazeCreator*>(MazeCreator::getInstance()->CreateNew(row_count, column_count, type, seed));
    
    
    s_pMazeMesh->DrawMaze("mazeblock2", s_mazeTextureID);
    
    unsigned int row, column;
    
    s_pMazeMesh->getBeginningCoord(row, column);
    btVector3 mazePositionOffset(-btVector3(s_pMazeMesh->getOriginOfTile(row, column)));
    
    s_MazeStartOrigin = new btVector3(0,0,0);
    
    s_pMazeMesh->getEndCoord(row, column);
    s_MazeEndOrigin = new btVector3(s_pMazeMesh->getOriginOfTile(row, column) + mazePositionOffset);
    
    s_pMazeMesh->getMaze()->setKinematicPhysics();
    s_pMazeMesh->getMaze()->enableHandleCollision();
    
    s_pMazeMesh->getMaze()->getRigidBody()->setFriction(10.0f);
    s_pMazeMesh->getMaze()->setOrigin(mazePositionOffset);
    
    s_pMazeMesh->getMaze()->hide();
    
    createMiniMap(board_size, seed, s_pMazeMesh->getBoardHalfExtends(), s_pMazeMesh->getTileHalfExtends(), solve);
    
    MazeCreator::destroyInstance();
}

void MazeGameState::createMiniMap(unsigned int size,
                                  unsigned int maze_seed,
                                  const btVector3 &boardHalfExtends,
                                  const btVector3 &tileHalfExtends, bool solve)
{
    MazeMiniMapFBOInfo *fbo = new MazeMiniMapFBOInfo(512, 512,
                                                     size,
                                                     size,
                                                     maze_seed,
                                                     boardHalfExtends,
                                                     tileHalfExtends,
                                                     MazeGameState::getGamePlayer(),
                                                     solve);
    fbo->m_Type = TextureBufferObjectFactory_MiniMaze;
    
    s_MazeMiniMapTextureBufferObject = TextureBufferObjectFactory::getInstance()->create(fbo);
    
    TextureBufferObjectFactory::getInstance()->get(s_MazeMiniMapTextureBufferObject)->load();
    delete fbo;
    
    BaseViewObjectInfo *constructionInfo = NULL;
    BaseViewObject *vo = NULL;
    
    TextureBehaviorInfo *tbInfo = new TextureBehaviorInfo();
    s_MazeMiniMapTextureBehaviorFactoryID = TextureBehaviorFactory::getInstance()->create(tbInfo);
    delete tbInfo;
    
    constructionInfo = new BaseViewObjectInfo(ShaderFactory::getInstance()->getCurrentShaderID(),
                                              "sprite",
                                              0, 0,
                                              &s_MazeMiniMapTextureBehaviorFactoryID, 1);
    s_MazeMiniMapSpriteViewObjectID = ViewObjectFactory::getInstance()->create(constructionInfo);
    delete constructionInfo;
    
    
    
    vo = ViewObjectFactory::getInstance()->get(s_MazeMiniMapSpriteViewObjectID);
    btAlignedObjectArray<GLushort> indiceData;
    btAlignedObjectArray<VertexAttributes_Vertex_Normal_Color_UVLayer1> vertexData;
    VertexAttributeLoader::getInstance()->createSpriteVertices(indiceData, vertexData);
    VertexAttributeLoader::getInstance()->load(vo, indiceData, vertexData);
    
    
    
    BaseEntityInfo *entityCInfo = new BaseEntityInfo(s_MazeMiniMapSpriteViewObjectID,
                                                     0,
                                                     0,
                                                     true);
    
    BaseEntity *mazeMiniMapSprite = EntityFactory::createEntity<BaseEntity, BaseEntityInfo>(entityCInfo);
    
    s_MazeMiniMapSpriteFactoryID = mazeMiniMapSprite->getID();
    
    
    
    
    
    
    delete entityCInfo;
    
    
    
    
    
    
    
    vo = ViewObjectFactory::getInstance()->get(s_MazeMiniMapSpriteViewObjectID);
    
    struct vertexclass_s
    {
        GLuint width;
        GLuint height;
        
        void operator() (int i, btVector3 &to, const btVector3 &from)
        {
            to = btVector3(from.x() * width,
                           from.y() * height,
                           from.z());
        }
    } vertexclass;
    
    vertexclass.width = 256;
    vertexclass.height = 256;
    
    
    vo->getTextureBehavior(0)->setXOffset(0);
    vo->getTextureBehavior(0)->setYOffset(0);
    vo->getTextureBehavior(0)->setWidthOfSubTexture(256);
    vo->getTextureBehavior(0)->setHeightOfSubTexture(256);
    vo->getTextureBehavior(0)->setWidthOfTexture(256);
    vo->getTextureBehavior(0)->setHeightOfTexture(256);
    
    size_t offset_position = reinterpret_cast<size_t>(vo->getPositionOffset());
    vo->set_each_attribute<vertexclass_s, btVector3>(vertexclass, offset_position);
 
    //getMazeMiniMapSprite()->hide();
}

MazeLevelData *MazeGameState::createMazeLevelData(unsigned int board_size, unsigned int seed, bool solve)
{
    MazeLevelData *data = new MazeLevelData;
    
    
    data->s_mazeTextureID = TextureFactory::createTextureFromData("temp");
    
    MazeCreator::createInstance();
    
    //UserSettingsSingleton::getInstance()->setInteger("board_size", board_size);
    //UserSettingsSingleton::getInstance()->setInteger("seed", seed);
    
    unsigned int row_count = board_size;
    unsigned int column_count = board_size;
    MazeRenderType type = MazeRenderType_Mesh;
    
    data->s_pMazeMesh = dynamic_cast<MeshMazeCreator*>(MazeCreator::getInstance()->CreateNew(row_count, column_count, type, seed));
    
    
    data->s_pMazeMesh->DrawMaze("mazeblock2", data->s_mazeTextureID);
    
    unsigned int row, column;
    
    data->s_pMazeMesh->getBeginningCoord(row, column);
    btVector3 mazePositionOffset(-btVector3(data->s_pMazeMesh->getOriginOfTile(row, column)));
    
    data->s_MazeStartOrigin = new btVector3(0,0,0);
    
    data->s_pMazeMesh->getEndCoord(row, column);
    data->s_MazeEndOrigin = new btVector3(data->s_pMazeMesh->getOriginOfTile(row, column) + mazePositionOffset);
    
    data->s_pMazeMesh->getMaze()->setKinematicPhysics();
    data->s_pMazeMesh->getMaze()->enableHandleCollision();
    
    data->s_pMazeMesh->getMaze()->getRigidBody()->setFriction(10.0f);
    data->s_pMazeMesh->getMaze()->setOrigin(mazePositionOffset);
    
    data->s_pMazeMesh->getMaze()->hide();
    
    createMiniMapLevelData(board_size, seed, data->s_pMazeMesh->getBoardHalfExtends(), data->s_pMazeMesh->getTileHalfExtends(), solve, *data);
    
    MazeCreator::destroyInstance();
    
    return data;
}

void MazeGameState::createMiniMapLevelData(unsigned int size,
                                   unsigned int maze_seed,
                                   const btVector3 &boardHalfExtends,
                                   const btVector3 &tileHalfExtends,
                                   bool solve,
                                   MazeLevelData &mazeLevelData)
{
    MazeMiniMapFBOInfo *fbo = new MazeMiniMapFBOInfo(512, 512,
                                                     size,
                                                     size,
                                                     maze_seed,
                                                     boardHalfExtends,
                                                     tileHalfExtends,
                                                     MazeGameState::getGamePlayer(),
                                                     solve);
    fbo->m_Type = TextureBufferObjectFactory_MiniMaze;
    
    mazeLevelData.s_MazeMiniMapTextureBufferObject = TextureBufferObjectFactory::getInstance()->create(fbo);
    
    TextureBufferObjectFactory::getInstance()->get(mazeLevelData.s_MazeMiniMapTextureBufferObject)->load();
    delete fbo;
    
    BaseViewObjectInfo *constructionInfo = NULL;
    BaseViewObject *vo = NULL;
    
    TextureBehaviorInfo *tbInfo = new TextureBehaviorInfo();
    mazeLevelData.s_MazeMiniMapTextureBehaviorFactoryID = TextureBehaviorFactory::getInstance()->create(tbInfo);
    delete tbInfo;
    
    constructionInfo = new BaseViewObjectInfo(ShaderFactory::getInstance()->getCurrentShaderID(),
                                              "sprite",
                                              0, 0,
                                              &mazeLevelData.s_MazeMiniMapTextureBehaviorFactoryID, 1);
    mazeLevelData.s_MazeMiniMapSpriteViewObjectID = ViewObjectFactory::getInstance()->create(constructionInfo);
    delete constructionInfo;
    
    
    
    vo = ViewObjectFactory::getInstance()->get(mazeLevelData.s_MazeMiniMapSpriteViewObjectID);
    btAlignedObjectArray<GLushort> indiceData;
    btAlignedObjectArray<VertexAttributes_Vertex_Normal_Color_UVLayer1> vertexData;
    VertexAttributeLoader::getInstance()->createSpriteVertices(indiceData, vertexData);
    VertexAttributeLoader::getInstance()->load(vo, indiceData, vertexData);
    
    
    
    BaseEntityInfo *entityCInfo = new BaseEntityInfo(mazeLevelData.s_MazeMiniMapSpriteViewObjectID,
                                                     0,
                                                     0,
                                                     true);
    
    BaseEntity *mazeMiniMapSprite = EntityFactory::createEntity<BaseEntity, BaseEntityInfo>(entityCInfo);
    
    mazeLevelData.s_MazeMiniMapSpriteFactoryID = mazeMiniMapSprite->getID();
    
    
    
    
    
    
    delete entityCInfo;
    
    
    
    
    
    
    
    vo = ViewObjectFactory::getInstance()->get(mazeLevelData.s_MazeMiniMapSpriteViewObjectID);
    
    struct vertexclass_s
    {
        GLuint width;
        GLuint height;
        
        void operator() (int i, btVector3 &to, const btVector3 &from)
        {
            to = btVector3(from.x() * width,
                           from.y() * height,
                           from.z());
        }
    } vertexclass;
    
    vertexclass.width = 256;
    vertexclass.height = 256;
    
    
    vo->getTextureBehavior(0)->setXOffset(0);
    vo->getTextureBehavior(0)->setYOffset(0);
    vo->getTextureBehavior(0)->setWidthOfSubTexture(256);
    vo->getTextureBehavior(0)->setHeightOfSubTexture(256);
    vo->getTextureBehavior(0)->setWidthOfTexture(256);
    vo->getTextureBehavior(0)->setHeightOfTexture(256);
    
    size_t offset_position = reinterpret_cast<size_t>(vo->getPositionOffset());
    vo->set_each_attribute<vertexclass_s, btVector3>(vertexclass, offset_position);
}

void MazeGameState::destroyMaze()
{
    destroyMiniMap();
    
    if(s_MazeStartOrigin)
        delete s_MazeStartOrigin;
    s_MazeStartOrigin = NULL;
    
    if(s_MazeEndOrigin)
        delete s_MazeEndOrigin;
    s_MazeEndOrigin = NULL;
    
    if(s_pMazeMesh)
        delete s_pMazeMesh;
    s_pMazeMesh = NULL;
    
    TextureFactory::getInstance()->destroy(s_mazeTextureID);
}

void MazeGameState::destroyMiniMap()
{
    TextureBufferObjectFactory::getInstance()->destroy(s_MazeMiniMapTextureBufferObject);
    
    TextureBehaviorFactory::getInstance()->destroy(s_MazeMiniMapTextureBehaviorFactoryID);
    
    ViewObjectFactory::getInstance()->destroy(s_MazeMiniMapSpriteViewObjectID);
    
    EntityFactory::getInstance()->destroy(s_MazeMiniMapSpriteFactoryID);
}

MeshMazeCreator *MazeGameState::getMazeMeshCreator()
{
    return s_pMazeMesh;
}

BaseEntity *MazeGameState::getMazeMiniMapSprite()
{
    return EntityFactory::getInstance()->get(s_MazeMiniMapSpriteFactoryID);
}

MazeMiniMapFBO *MazeGameState::getMazeMiniMapTBO()
{
    return dynamic_cast<MazeMiniMapFBO*>(TextureBufferObjectFactory::getInstance()->get(s_MazeMiniMapTextureBufferObject));
}

btVector3 MazeGameState::getMazeStartOrigin()
{
    return *s_MazeStartOrigin;
}

btVector3 MazeGameState::getMazeEndOrigin()
{
    return *s_MazeEndOrigin;
}

BaseGameState *MazeGameState::getGameState(GameStateType_e state)
{
    
    
    BaseGameState *p = NULL;
    
    switch (state)
    {
        case GameStateType_MazeGameState_ReadySetGo:
            p = GameStateFactory::getInstance()->get(s_readySetGoGameStateID);
            break;
        case GameStateType_MazeGameState_Play:
            p = GameStateFactory::getInstance()->get(s_playGameStateID);
            break;
        case GameStateType_MazeGameState_Lose:
            p = GameStateFactory::getInstance()->get(s_loseGameStateID);
            break;
        case GameStateType_MazeGameState_PreviousLevel:
            p = GameStateFactory::getInstance()->get(s_previousLevelGameStateID);
            break;
        case GameStateType_MazeGameState_NextLevel:
            p = GameStateFactory::getInstance()->get(s_nextLevelGameStateID);
            break;
        case GameStateType_MazeGameState_Win:
            p = GameStateFactory::getInstance()->get(s_winGameStateID);
            break;
        default:
            break;
    }
    return p;
}

void MazeGameState::createGameStates()
{
    BaseGameStateInfo *bgsi = NULL;
    
    bgsi = new BaseGameStateInfo();
    
    bgsi->gametype = GameStateType_MazeGameState_ReadySetGo;
    s_readySetGoGameStateID = GameStateFactory::getInstance()->create(bgsi);
    
    bgsi->gametype = GameStateType_MazeGameState_Play;
    s_playGameStateID = GameStateFactory::getInstance()->create(bgsi);
    
    
    bgsi->gametype = GameStateType_MazeGameState_Lose;
    s_loseGameStateID = GameStateFactory::getInstance()->create(bgsi);
    
    
    bgsi->gametype = GameStateType_MazeGameState_Win;
    s_winGameStateID = GameStateFactory::getInstance()->create(bgsi);
    
    bgsi->gametype = GameStateType_MazeGameState_PreviousLevel;
    s_previousLevelGameStateID = GameStateFactory::getInstance()->create(bgsi);
    
    bgsi->gametype = GameStateType_MazeGameState_NextLevel;
    s_nextLevelGameStateID = GameStateFactory::getInstance()->create(bgsi);
    
    delete bgsi;
    bgsi = NULL;
}
void MazeGameState::destroyGameStates()
{
    GameStateFactory::getInstance()->destroy(s_winGameStateID);
    GameStateFactory::getInstance()->destroy(s_loseGameStateID);
    GameStateFactory::getInstance()->destroy(s_playGameStateID);
    GameStateFactory::getInstance()->destroy(s_readySetGoGameStateID);
    
    GameStateFactory::getInstance()->destroy(s_previousLevelGameStateID);
    GameStateFactory::getInstance()->destroy(s_nextLevelGameStateID);
}


void MazeGameState::createLevels(unsigned int seed)
{
    MazeLevelDataVector = new std::vector<MazeLevelData*>();
    
    backgroundQueue = dispatch_queue_create("com.razeware.imagegrabber.bgqueue", NULL);
    
    for (int i = MazeGameState::getMinimumLevel(); i <= MazeGameState::getMaximumLevel(); i++)
    {
        MazeLevelDataVector->push_back(NULL);
    }
    
    unsigned int index = 0;
    
    dispatch_async(backgroundQueue, ^(void) {
        MazeGameState::createLevel(index, s_InitialBoardSize, seed);
    });
}

void MazeGameState::destoryLevels()
{
    backgroundQueue = nil;
    delete MazeLevelDataVector;
}

void MazeGameState::createLevel(unsigned int index, unsigned int size, unsigned int seed)
{
    (*MazeLevelDataVector)[index] = createMazeLevelData(size, seed, false);
    
    if(size + 1 < s_BoardSizeMax)
    {
        MazeGameState::createLevel(index + 1, size + 1, seed);
    }
}