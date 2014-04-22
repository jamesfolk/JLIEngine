//
//  MazeGameState.cpp
//  GameAsteroids
//
//  Created by James Folk on 6/5/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//


#define SIMULATE_NEW_DAY

#include "MazeGameState.h"

#include "TextureBehaviorFactoryIncludes.h"
#include "TextureFactory.h"

#include "ViewObjectFactoryIncludes.h"
#include "ViewObjectFactory.h"

#include "ShaderFactory.h"

#include "ZipFileResourceLoader.h"

#include "CollisionShapeFactory.h"
//#include "CollisionFilterBehaviorFactory.h"

#include "CollisionResponseBehaviorFactory.h"
//#include "UpdateBehaviorFactory.h"

#include "SteeringBehaviorFactoryIncludes.h"
#include "Path.h"

//#include "PlayerCollisionFilterBehavior.h"
//#include "PlayerCollisionResponseBehavior.h"
//#include "PlayerUpdateBehavior.h"
//#include "FinishLevelCollisionFilterBehavior.h"
//#include "FinishLevelCollisionResponseBehavior.h"

#include "SteeringBehaviorFactory.h"

#include "CameraSteeringEntity.h"
#include "CameraFactory.h"

#include "MeshMazeCreator.h"
#include "EntityFactory.h"
#include "RigidEntity.h"

//#import "SingletonSoundManager.h"
//extern SingletonSoundManager *sharedSoundManager;

#include "ParticleEmitterBehaviorFactory.h"
#include "AnimationControllerFactory.h"
#include "EntityStateMachineFactory.h"

#include "BaseCamera.h"
#include "CameraEntity.h"

//#include "PlayerInput.h"

#include "TextViewObjectFactoryIncludes.h"
#include "TextViewObjectFactory.h"

#include "GLDebugDrawer.h"
#include "HeadingSmoother.h"
#include "UserSettingsSingleton.h"

#include "DebugVariableFactory.h"
#include "FrictionDebugVariable.h"
#include "MassDebugVariable.h"
#include "MazeDebugVariable.h"
#include "MazeDebugVariable2.h"
#include "RestitutionDebugVariable.h"
#include "AngularDampingDebugVariable.h"
#include "LinearDampingDebugVariable.h"

#include "VertexAttributeLoader.h"

#include "TextureBufferObjectFactory.h"
#include "EntityTextureBufferObject.h"

#include "ImageFileEditor.h"
#include "btVector3.h"
#include "MazeMiniMapFBO.h"

#include "GameStateMachine.h"

const int s_BoardSizeMax = 45;

const int s_InitialBoardSize = 2;

int MazeGameState::s_BoardSize = s_InitialBoardSize;
bool MazeGameState::s_LeveledUp = false;



MazeGameState::MazeGameState():
m_mazeTextureID(0),
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
m_pPath(NULL),
m_pMazeSteeringCamera(NULL),
m_pMaze(NULL),
m_MazeStartOrigin(new btVector3(0,0,0)),
m_MazeEndOrigin(new btVector3(0,0,0)),
m_MazePositionOffset(new btVector3(0,0,0)),
m_pPlayerAvatar(NULL),
m_pGoalTrigger(NULL),
m_pOrthoCamera(NULL),
m_TouchStartTime(0),
m_InitalizeTouch(false),
m_TouchStart(new btVector3(0,0,0)),
m_stopWatchID(0),
m_gameTimerID(0),
m_ImpulseContant(100000.0f),
m_MaxTouchDistance(40.0)
{
    
}

MazeGameState::~MazeGameState()
{
    destroyGameData();
    
    delete m_TouchStart;
    m_TouchStart = NULL;
    
    delete m_MazePositionOffset;
    m_MazePositionOffset = NULL;
    
    delete m_MazeEndOrigin;
    m_MazeEndOrigin = NULL;
    
    delete m_MazeStartOrigin;
    m_MazeStartOrigin = NULL;
}

void MazeGameState::enter(void*)
{
    
    createGameData();
    
    createLevelData();
    
    //test();

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    std::vector<IDType> m_TextureFactoryObjects;
//    std::vector<IDType> m_ViewObjectFactoryObjects;
//    std::vector<IDType> m_CollisionShapeFactoryObjects;
//    std::vector<IDType> m_CollisionResponseBehaviorFactoryObjects;
//    std::vector<IDType> m_CollisionFilterBehaviorFactoryObjects;
//    std::vector<IDType> m_UpdateBehaviorFactoryObjects;
//    std::vector<IDType> m_SteeringBehaviorFactoryObjects;
//    std::vector<IDType>
    
    
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
    
    createMazeEntity();
    
    btVector3 origin(*m_MazeStartOrigin);
    origin.setY(origin.y() + 2.0f);
    
    btVector3 aabbMin, aabbMax;
    m_pPlayerAvatar->getRigidBody()->getCollisionShape()->getAabb(btTransform::getIdentity(),
                                                                  aabbMin, aabbMax);
    origin.setY(origin.y() + aabbMax.y() );
    m_pPlayerAvatar->setOrigin(origin);
    
    createGoalEntity();
    
    createMap();
    
    
    
    
    m_TouchStartTime = FrameCounter::getInstance()->getCurrentTime();
    
    m_pPlayerAvatar->getRigidBody()->getCollisionShape()->getAabb(btTransform::getIdentity(), aabbMin, aabbMax);
    
    btVector3 offset(0,aabbMax.y() + 0.0f, aabbMin.z() - 0.0f);
    m_pPath->attachToEntity(m_pPlayerAvatar, m_pPath->getNumberOfWayPoints() - 1, offset);
    
    m_pMazeSteeringCamera->setOrigin(m_pPath->getWayPoint(0));
    m_pMazeSteeringCamera->getFolowPathInfo()->setWayPointSeekDistance(m_pPath->getAverageDistanceBetweenPoints() / 2.0f);
    
    m_pMaze->enableDebugDraw(false);
    m_pMazeSteeringCamera->enableDebugDraw(false);
    m_pGoalTrigger->enableDebugDraw(false);
    

    loadDefaultData();
    
    m_timer->start(4 * 1000);
    m_bCanMovePlayer = false;
    
    allowPause(false);
    
    
    
    
    FrictionDebugVariableInfo *frictionDebugVariableInfo = new FrictionDebugVariableInfo();
    
    frictionDebugVariableInfo->m_Label = "Ball Friction";
    frictionDebugVariableInfo->pRigidEntity = m_pPlayerAvatar;
    DebugVariableFactory::getInstance()->create(frictionDebugVariableInfo);
    
    frictionDebugVariableInfo->m_Label = "Maze Friction";
    frictionDebugVariableInfo->pRigidEntity = m_pMaze;
    DebugVariableFactory::getInstance()->create(frictionDebugVariableInfo);
    
    delete frictionDebugVariableInfo;
    
    MassDebugVariableInfo *massDebugVariableInfo = new MassDebugVariableInfo();
    
    massDebugVariableInfo->m_Label = "Bass Mass";
    massDebugVariableInfo->pRigidEntity = m_pPlayerAvatar;
    DebugVariableFactory::getInstance()->create(massDebugVariableInfo);
    
    delete massDebugVariableInfo;
    
    
    MazeDebugVariableInfo *mazeDebugVariableInfo = new MazeDebugVariableInfo();
    
    mazeDebugVariableInfo->m_Label = "Ball Impulse Constant";
    mazeDebugVariableInfo->pMazeGameState = this;
    DebugVariableFactory::getInstance()->create(mazeDebugVariableInfo);
    delete mazeDebugVariableInfo;
    
    MazeDebugVariable2Info *mazeDebugVariable2Info = new MazeDebugVariable2Info();
    mazeDebugVariable2Info->m_Label = "Ball max touch distance";
    mazeDebugVariable2Info->pMazeGameState = this;
    DebugVariableFactory::getInstance()->create(mazeDebugVariable2Info);
    delete mazeDebugVariable2Info;
    
    RestitutionDebugVariableInfo *restitutionDebugVariableInfo = new RestitutionDebugVariableInfo();
    
    restitutionDebugVariableInfo->m_Label = "Ball Restitution";
    restitutionDebugVariableInfo->pRigidEntity = m_pPlayerAvatar;
    DebugVariableFactory::getInstance()->create(restitutionDebugVariableInfo);
    
    restitutionDebugVariableInfo->m_Label = "Maze Restitution";
    restitutionDebugVariableInfo->pRigidEntity = m_pMaze;
    DebugVariableFactory::getInstance()->create(restitutionDebugVariableInfo);
    
    delete restitutionDebugVariableInfo;
    
    
    LinearDampingDebugVariableInfo *linearDampingDebugVariableInfo = new LinearDampingDebugVariableInfo();
    linearDampingDebugVariableInfo->m_Label = "Ball Linear Damping";
    linearDampingDebugVariableInfo->pRigidEntity = m_pPlayerAvatar;
    DebugVariableFactory::getInstance()->create(linearDampingDebugVariableInfo);
    delete linearDampingDebugVariableInfo;
    
    AngularDampingDebugVariableInfo *angularDampingDebugVariableInfo = new AngularDampingDebugVariableInfo();
    angularDampingDebugVariableInfo->m_Label = "Ball Angular Damping";
    angularDampingDebugVariableInfo->pRigidEntity = m_pPlayerAvatar;
    DebugVariableFactory::getInstance()->create(angularDampingDebugVariableInfo);
    delete angularDampingDebugVariableInfo;
    
}

void MazeGameState::update(void*, btScalar deltaTimeStep)
{
    m_pOrthoCamera->lookAt(btVector3(0,0,0));
//    m_Rotate += (deltaTimeStep * 5);
//    if(m_Rotate > DEGREES_TO_RADIANS(360))
//        m_Rotate = 0;
//
    
    
    std::string text = "";
    if (m_timer->getMilliseconds() > 2000)
    {
        text = "Ready...";
    }
    else if(m_timer->getMilliseconds() > 1000)
    {
        text = "Set...";
    }
    else if(m_timer->getMilliseconds() > 0)
    {
        text = "GO!!!";
        m_bCanMovePlayer = true;
    }
    else
    {
        m_bCanMovePlayer = true;
        allowPause(true);
        text = "";
        
        
        
        
        
        
        
    }
    
    TextViewObjectFactory::getInstance()->updateDrawText(m_gameTimer->toString(),
                                                         LocalizedTextViewObjectType_Helvetica_128pt,
                                                         btVector3(0, CameraFactory::getScreenHeight() - 80, 200),
                                                         m_GameTimerDrawingText,
                                                         btVector3(1.0f, 0.0f, 0.0f));
    
    TextViewObjectFactory::getInstance()->updateDrawText(m_stop_watch->toString(),
                                                         LocalizedTextViewObjectType_Helvetica_64pt,
                                                         btVector3(0, (CameraFactory::getScreenHeight() - 45) - 80, 200),
                                                         m_StopWatchDrawingText,
                                                         btVector3(1.0f, 0.0f, 0.0f));
    char level[8] = "";
    
    sprintf(level, "LEVEL:%d", getCurrentLevel());
    TextViewObjectFactory::getInstance()->updateDrawText(std::string(level),
                                                         LocalizedTextViewObjectType_Helvetica_32pt,
                                                         btVector3(0, ((CameraFactory::getScreenHeight() - 22) - 45) - 80, 200),
                                                         m_LevelDrawingText,
                                                         btVector3(1.0f, 0.0f, 0.0f));
    
    
    if(isPaused())
    {
        text = "PAUSED";
        if(m_pSprite)
            m_pSprite->hide();
        m_pMaze->hide();
        m_pPlayerAvatar->hide();
        m_pGoalTrigger->hide();
    }
    else
    {
        if(m_pSprite)
            m_pSprite->show();
        m_pMaze->show();
        m_pPlayerAvatar->show();
        m_pGoalTrigger->show();
    }
    
    
    
    
    
    
    TextViewObjectFactory::getInstance()->updateDrawText(text,
                                                         LocalizedTextViewObjectType_Helvetica_128pt,
                                                         btVector3(0, CameraFactory::getScreenHeight() * .5f, 200),
                                                         m_TimerWatchDrawingText,
                                                         btVector3(1.0f, 0.0f, 0.0f));
    
    
    updateLookatVector();
    
//    if(PlayerInput::getInstance()->isPinchGesturing())
//    {
//        btScalar scale = [PlayerInput::getInstance()->getPinchGestureRecognizer() scale];
//        btScalar velocity = [PlayerInput::getInstance()->getPinchGestureRecognizer() velocity];
//        
//        //printf("scale: %.3f velocity: %.3f\n", scale, velocity);
//        if(velocity > 0)
//        {
//            m_pMazeSteeringCamera->getSteeringBehavior()->getPath()->setPathIncrement(PathIncrement_Positive);
//        }
//        else if(velocity < 0)
//        {
//            m_pMazeSteeringCamera->getSteeringBehavior()->getPath()->setPathIncrement(PathIncrement_Negative);
//        }
//    }
    //btVector3 impulse(PlayerInput::getInstance()->getGyroChangeValue());
    btScalar magnitude = 5000.0f;
    
    //applyTorqueToPlayer(btVector3(impulse.y(), 0, impulse.z()) * magnitude);
    //m_pPlayerAvatar->getRigidBody()->applyTorqueImpulse(btVector3(impulse.y(), 0, impulse.z()) * magnitude);
    
    
    
    if(!m_bCanMovePlayer)
    {
        m_pPlayerAvatar->getRigidBody()->clearForces();
        m_pPlayerAvatar->getRigidBody()->setLinearVelocity(btVector3(0,0,0));
        m_pPlayerAvatar->getRigidBody()->setAngularVelocity(btVector3(0,0,0));
        
        float x = UserSettingsSingleton::getInstance()->getFloat("player_x");
        float y = UserSettingsSingleton::getInstance()->getFloat("player_y");
        float z = UserSettingsSingleton::getInstance()->getFloat("player_z");
        if(m_pPlayerAvatar)
            m_pPlayerAvatar->setOrigin(btVector3(x, y, z));
    }
    

    m_pMazeMiniMapFBO->update();
}

void  MazeGameState::render()
{
    BaseTextureBufferObject *p = TextureBufferObjectFactory::getInstance()->get(m_textureBufferObject);
    BaseViewObject *vo = ViewObjectFactory::getInstance()->get(spriteViewObjectID);
    
    if(p && vo)
        vo->loadTexture(0, p->name());
}



void MazeGameState::exit(void*)
{
    saveDefaultData();
    destroyGameData();
    
    for(size_t i = 0; i < 32; ++i)
    {
        TextViewObjectFactory::getInstance()->destroy(m_LevelDrawingText[i]);
    }
    m_LevelDrawingText.clear();
    
    for (size_t i = 0; i < 32; ++i)
    {
        TextViewObjectFactory::getInstance()->destroy(m_StopWatchDrawingText[i]);
    }
    m_StopWatchDrawingText.clear();
    m_stop_watch = NULL;
    FrameCounter::getInstance()->destroy(m_stopWatchID);
    
    for(size_t i = 0; i < 32;i++)
    {
        TextViewObjectFactory::getInstance()->destroy(m_TimerWatchDrawingText[i]);
    }
    m_TimerWatchDrawingText.clear();
    m_timer = NULL;
    FrameCounter::getInstance()->destroy(m_timerID);
    
    
    
    for(size_t i = 0; i < 32;i++)
    {
        TextViewObjectFactory::getInstance()->destroy(m_GameTimerDrawingText[i]);
    }
    m_GameTimerDrawingText.clear();
    m_gameTimer = NULL;
    FrameCounter::getInstance()->destroy(m_gameTimerID);
    
    
    
    
    if(m_pOrthoCamera)
    {
        IDType camID = m_pOrthoCamera->getID();
        CameraFactory::getInstance()->destroy(camID);
    }
    m_pOrthoCamera = NULL;
    
    TextureFactory::getInstance()->destroy(m_mazeTextureID);
    TextureFactory::getInstance()->destroy(m_bricksTextureID);
    TextureFactory::getInstance()->destroy(m_tarsierTextureID);
    
    ViewObjectFactory::getInstance()->destroy(m_sphereViewObjectID);
    ViewObjectFactory::getInstance()->destroy(m_cubeViewObjectID);
    ViewObjectFactory::getInstance()->destroy(m_mazeViewObjectID);
    
    CollisionShapeFactory::getInstance()->destroy(m_sphereCollisionShapeID);
    CollisionShapeFactory::getInstance()->destroy(m_cubeCollisionShapeID);
    
//    CollisionResponseBehaviorFactory::getInstance()->destroy(m_playercollisionResponseID);
//    CollisionResponseBehaviorFactory::getInstance()->destroy(m_finishLevelCollisionResponseFactoryID);
    
    //CollisionFilterBehaviorFactory::getInstance()->destroy(m_playercollisionFilterID);
    //CollisionFilterBehaviorFactory::getInstance()->destroy(m_finishLevelcollisionFilterID);
    
    UpdateBehaviorFactory::getInstance()->destroy(m_playerUpdateBehaviorInfoID);
    
    SteeringBehaviorFactory::getInstance()->destroy(m_cameraSteeringBehaviorID);
    
    delete m_pPath;
    m_pPath = NULL;
    
    IDType camID2 = m_pMazeSteeringCamera->getID();
    CameraFactory::getInstance()->destroy(camID2);
    
    IDType mazeID = m_pMaze->getID();
    EntityFactory::getInstance()->destroy(mazeID);
    
    IDType playerID = m_pPlayerAvatar->getID();
    EntityFactory::getInstance()->destroy(playerID);
    
    IDType goalID = m_pGoalTrigger->getID();
    EntityFactory::getInstance()->destroy(goalID);
    
    DebugVariableFactory::getInstance()->destroyAll();
    
    ViewObjectFactory::getInstance()->destroy(spriteViewObjectID);
    if(m_pSprite)
    {
        IDType _id = m_pSprite->getID();
        EntityFactory::getInstance()->destroy(_id);
    }
    
    TextureBufferObjectFactory::getInstance()->destroy(m_textureBufferObject);
    
    
//    [sharedSoundManager stopBGMWithKey:@"game" fadeOut:NO];
//    [sharedSoundManager unLoadBGMWithKey:@"game"];
    
    
}

bool MazeGameState::onMessage(void*, const Telegram&)
{
    return false;
}


//void MazeGameState::touchesBegan()
//{
//    *m_TouchStart = getPlayerControlTouchPosition();
//    m_TouchStartTime = FrameCounter::getInstance()->getCurrentTime();
//    
//    m_InitalizeTouch = true;
//}
//
//void MazeGameState::touchesMoved()
//{
//    if(m_InitalizeTouch)
//    {
//        //applyLinearForceOnPlayer();
//        applyAngularForceOnPlayer();
//    }
//}
//
//void MazeGameState::touchesEnded()
//{
//    m_InitalizeTouch = false;
//}
//
//void MazeGameState::touchesCancelled()
//{
//    m_InitalizeTouch = false;
//}

void MazeGameState::saveDefaultData()
{
    if(s_LeveledUp)
    {
        m_stop_watch->reset();
        s_LeveledUp = false;
    }
    else
    {
        if(!didQuit())
        {
            char buffer[64];
            sprintf(buffer, "%ld", getTotalTime());
            UserSettingsSingleton::getInstance()->setString("current_time", buffer);
            
            UserSettingsSingleton::getInstance()->setFloat("player_x",
                                                           m_pPlayerAvatar->getOrigin().x());
            UserSettingsSingleton::getInstance()->setFloat("player_y",
                                                           m_pPlayerAvatar->getOrigin().y());
            UserSettingsSingleton::getInstance()->setFloat("player_z",
                                                           m_pPlayerAvatar->getOrigin().z());
        }
    }
}

void MazeGameState::loadDefaultData()
{
    float x = UserSettingsSingleton::getInstance()->getFloat("player_x");
    float y = UserSettingsSingleton::getInstance()->getFloat("player_y");
    float z = UserSettingsSingleton::getInstance()->getFloat("player_z");
    if(m_pPlayerAvatar)
        m_pPlayerAvatar->setOrigin(btVector3(x, y, z));
    
    std::string _current_time = UserSettingsSingleton::getInstance()->getString("current_time");
    m_stop_watch->setMilliseconds(atol(_current_time.c_str()));
}

int MazeGameState::getCurrentLevel()
{
    return s_BoardSize - 1;
}

double MazeGameState::getTotalTime()
{
    return m_stop_watch->getMilliseconds();
}
//void MazeGameState::quit()
//{
//    BaseGameState::quit();
//    //resetBoard();
//}


void MazeGameState::createTextureObjects()
{
    m_mazeTextureID = TextureFactory::createTextureFromData("temp");
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
    m_pPath = new Path(*info);
    m_pPath->setPathIncrement(PathIncrement_None);
    delete info;
}

void MazeGameState::createCamera()
{
    
    
    CameraSteeringEntityInfo *constructionInfo = new CameraSteeringEntityInfo(/*bool isOrthographicCamera = */false,
                                                                              m_sphereViewObjectID,
                                                                              /*IDType stateMachineFactoryID = */0,
                                                                              /*IDType animationFactoryID = */0,
                                                                              /*bool isOrthographicEntity = */false,
                                                                              m_sphereCollisionShapeID,
                                                                              /*btScalar mass = */1.0,
                                                                              m_cameraSteeringBehaviorID,
                                                                              /*const WanderInfo &wanderInfo = */WanderInfo());
    
    constructionInfo->m_nearZ = 0.01f;
    constructionInfo->m_farZ = 1000.0f;
    //m_pCamera = CameraFactory::createCameraEntity(constructionInfo);
    m_pMazeSteeringCamera = CameraFactory::createCameraEntity<CameraSteeringEntity, CameraSteeringEntityInfo>(constructionInfo);
    delete constructionInfo;
    
//    m_pMazeSteeringCamera->setVBOID(m_sphereViewObjectID);
//    m_pMazeSteeringCamera->setCollisionShape(m_sphereCollisionShapeID);
//    m_pMazeSteeringCamera->setSteeringBehavior(m_cameraSteeringBehaviorID);

    
    CameraFactory::getInstance()->setCurrentCamera(m_pMazeSteeringCamera);
    
    m_pMazeSteeringCamera->hide();
    
    
    m_pMazeSteeringCamera->getSteeringBehavior()->setFollowPathOn(m_pPath);
    //m_pMazeSteeringCamera->getSteeringBehavior()->setArriveOn(btVector3(0,0,0));
    m_pMazeSteeringCamera->setMaxLinearSpeed(40.0f);
    
    m_pMazeSteeringCamera->enableCollision(false);
    
    
    
    
    

}

unsigned int MazeGameState::getSeed()const
{
    time_t rawtime;
    struct tm * ptm;
    
    time ( &rawtime );
    
    ptm = gmtime ( &rawtime );
    
    return ptm->tm_yday;
}
void MazeGameState::createMazeEntity()
{
    MazeCreator::createInstance();
    
    int _board_size = MazeGameState::getBoardSize();
    int user_board_size = UserSettingsSingleton::getInstance()->getInteger("board_size");
    if(_board_size != user_board_size)
    {
        _board_size = user_board_size;
        s_BoardSize = user_board_size;
    }
    UserSettingsSingleton::getInstance()->setInteger("board_size", _board_size);
    
    unsigned int seed = getSeed();
    int user_seed = UserSettingsSingleton::getInstance()->getInteger("seed");
    if(seed != user_seed)
    {
        
        MazeGameState::resetBoard();
        UserSettingsSingleton::getInstance()->setInteger("seed", seed);
        _board_size = MazeGameState::getBoardSize();
    }
    
    unsigned int row_count = _board_size;
    unsigned int column_count = _board_size;
    MazeRenderType type = MazeRenderType_Mesh;
    
//    m_pMazeTexture = dynamic_cast<TextureMazeCreator*>(MazeCreator::getInstance()->CreateNew(row_count, column_count, MazeRenderType_Texture, seed));
//    
//    m_pMazeTexture->SolveMaze();
//    m_pMazeTexture->Draw();
    
    
    //m_pMiniMapImage = m_pMazeTexture->getBallImageFileEditor();
    
    MeshMazeCreator *pMazeMesh = dynamic_cast<MeshMazeCreator*>(MazeCreator::getInstance()->CreateNew(row_count, column_count, type, seed));
    
    
    pMazeMesh->DrawMaze("mazeblock2", ShaderFactory::getInstance()->getCurrentShaderID(), m_mazeTextureID);
    //pMazeMesh->SolveMaze();
    
    unsigned int row, column;
    
    pMazeMesh->getBeginningCoord(row, column);
    //*m_MazeStartOrigin = btVector3(pMazeMesh->getOriginOfTile(row, column));
    *m_MazePositionOffset = -btVector3(pMazeMesh->getOriginOfTile(row, column));
    *m_MazeStartOrigin = btVector3(0,0,0);
    
    pMazeMesh->getEndCoord(row, column);
    *m_MazeEndOrigin = btVector3(pMazeMesh->getOriginOfTile(row, column)) + *m_MazePositionOffset;
    
    m_pMaze = pMazeMesh->getMaze();
    
    m_mazeViewObjectID = pMazeMesh->getViewObjectID();
    
//    m_pMazeTexture->setMeshMazeBoardHalfExtends(pMazeMesh->getBoardHalfExtends());
//    m_pMazeTexture->setMeshMazeTileHalfExtends(pMazeMesh->getTileHalfExtends());
    
    
    
    
    
    
    MazeMiniMapFBOInfo *fbo = new MazeMiniMapFBOInfo(512, 512, pMazeMesh, m_pPlayerAvatar);
    fbo->m_Type = TextureBufferObjectFactory_MiniMaze;
    
    m_textureBufferObject = TextureBufferObjectFactory::getInstance()->create(fbo);
    
    m_pMazeMiniMapFBO = dynamic_cast<MazeMiniMapFBO*>(TextureBufferObjectFactory::getInstance()->get(m_textureBufferObject));
    
    TextureBufferObjectFactory::getInstance()->get(m_textureBufferObject)->load();
    delete fbo;
    
    
    
    
    delete pMazeMesh;
    pMazeMesh = NULL;
    
    m_pMaze->setKinematicPhysics();
    m_pMaze->enableHandleCollision();
    
    MazeCreator::destroyInstance();
    
    m_pMaze->getRigidBody()->setFriction(10.0f);
    m_pMaze->setOrigin(*m_MazePositionOffset);
    
    

    
}

void MazeGameState::createPlayerEntity()
{
    RigidEntityInfo *constructionInfo = new RigidEntityInfo(m_sphereViewObjectID,
                                                            0,
                                                            0,
                                                            false,
                                                            m_sphereCollisionShapeID,
                                                            50.0f);
    
    //m_pPlayerAvatar = EntityFactory::createPhysicsEntity(constructionInfo);
    m_pPlayerAvatar = EntityFactory::createEntity<RigidEntity, RigidEntityInfo>(constructionInfo);
    delete constructionInfo;
    
    m_pPlayerAvatar->getRigidBody()->setActivationState(DISABLE_DEACTIVATION);
    
    m_pPlayerAvatar->getRigidBody()->setRestitution(0.0f);
    m_pPlayerAvatar->getRigidBody()->setFriction(10.0f);
    
    
    
    m_pPlayerAvatar->enableHandleCollision();
    //m_pPlayerAvatar->setCollisionFilterBehavior(m_playercollisionFilterID);
    //m_pPlayerAvatar->setCollisionResponseBehavior(m_playercollisionResponseID);
    m_pPlayerAvatar->setUpdateBehavior(m_playerUpdateBehaviorInfoID);
    
    m_pPlayerAvatar->getRigidBody()->clearForces();
}

void MazeGameState::createGoalEntity()
{
    GhostEntityInfo *constructionInfo = new GhostEntityInfo(m_cubeViewObjectID,
                                                            0,
                                                            0,
                                                            false,
                                                            m_cubeCollisionShapeID);
    
    m_pGoalTrigger = EntityFactory::createEntity<GhostEntity, GhostEntityInfo>(constructionInfo);
    
    btVector3 origin(*m_MazeEndOrigin);
    origin.setY(origin.y());
    
    btVector3 aabbMin, aabbMax;
    m_pGoalTrigger->getGhostObject()->getCollisionShape()->getAabb(btTransform::getIdentity(),
                                                                  aabbMin, aabbMax);
    origin.setY(origin.y() + aabbMax.y());
    m_pGoalTrigger->setOrigin(origin);
    //m_pGoalTrigger->setCollisionResponseBehavior(m_finishLevelCollisionResponseFactoryID);
    //m_pGoalTrigger->setCollisionFilterBehavior(m_finishLevelcollisionFilterID);
}

void MazeGameState::updateLookatVector()
{
    
    
    btVector3 desiredHeading(m_pPlayerAvatar->getOrigin() - m_pMazeSteeringCamera->getOrigin());
    
    HeadingSmoother::getInstance()->addHeading(m_pMazeSteeringCamera->getID(), desiredHeading);
    desiredHeading = HeadingSmoother::getInstance()->getHeadingVector(m_pMazeSteeringCamera->getID());
    
//    m_pMazeSteeringCamera->setHeadingVector(desiredHeading);
    m_pMazeSteeringCamera->lookAtHeading();
}



void MazeGameState::createMap()
{
    
    BaseViewObjectInfo *constructionInfo = NULL;
    BaseViewObject *vo = NULL;
    
    TextureBehaviorInfo *tbInfo = new TextureBehaviorInfo();
    IDType textureBehaviorFactoryID = TextureBehaviorFactory::getInstance()->create(tbInfo);
    delete tbInfo;
    
    constructionInfo = new BaseViewObjectInfo(ShaderFactory::getInstance()->getCurrentShaderID(),
                                              "sprite",
                                              0, 0,
                                              &textureBehaviorFactoryID, 1);
    spriteViewObjectID = ViewObjectFactory::getInstance()->create(constructionInfo);
    delete constructionInfo;
    
    vo = ViewObjectFactory::getInstance()->get(spriteViewObjectID);
    btAlignedObjectArray<GLushort> indiceData;
    btAlignedObjectArray<VertexAttributes_Vertex_Normal_Color_UVLayer1> vertexData;
    VertexAttributeLoader::getInstance()->createSpriteVertices(indiceData, vertexData);
    VertexAttributeLoader::getInstance()->load(vo, indiceData, vertexData);
    
    
    
    BaseEntityInfo *entityCInfo = new BaseEntityInfo(spriteViewObjectID,
                                                          0,
                                                          0,
                                                          true);
    
    m_pSprite = EntityFactory::createEntity<BaseEntity, BaseEntityInfo>(entityCInfo);
    
    m_pSprite->setOrigin(btVector3(CameraFactory::getScreenWidth() - 128, CameraFactory::getScreenHeight() - 128,0));
    
    delete entityCInfo;
    
    
    
    
    
    
    
    vo = ViewObjectFactory::getInstance()->get(spriteViewObjectID);
    
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

int MazeGameState::getBoardSize()
{
    return s_BoardSize;
}

void MazeGameState::resetBoard()
{
    s_BoardSize = s_InitialBoardSize;
    
    UserSettingsSingleton::getInstance()->setInteger("board_size", s_BoardSize);
    UserSettingsSingleton::getInstance()->setFloat("player_x", 0.0f);
    UserSettingsSingleton::getInstance()->setFloat("player_y", 3.5f);
    UserSettingsSingleton::getInstance()->setFloat("player_z", 0.0f);
    UserSettingsSingleton::getInstance()->setString("current_time", "0");
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
    
    UserSettingsSingleton::getInstance()->setInteger("board_size", s_BoardSize);
    UserSettingsSingleton::getInstance()->setFloat("player_x", 0.0f);
    UserSettingsSingleton::getInstance()->setFloat("player_y", 3.5f);
    UserSettingsSingleton::getInstance()->setFloat("player_z", 0.0f);
    UserSettingsSingleton::getInstance()->setString("current_time", "0");
    s_LeveledUp = true;
    
    return ret;
}

int MazeGameState::getMazeCurrentLevel()
{
    MazeGameState *pMazeGameState = dynamic_cast<MazeGameState*>(GameStateMachine::getInstance()->getCurrentState());
    int level = 0;
    if(pMazeGameState)
    {
        level = pMazeGameState->getCurrentLevel();
    }
    return level;
}

double MazeGameState::getMazeTotalTime()
{
    MazeGameState *pMazeGameState = dynamic_cast<MazeGameState*>(GameStateMachine::getInstance()->getCurrentState());
    
    double totalTime = 0.0;
    if(pMazeGameState)
    {
        totalTime = pMazeGameState->getTotalTime();
    }
    return totalTime;
}

btVector3 MazeGameState::getPlayerControlTouchPosition()const
{
    //Touch _touch;
    //PlayerInput::getInstance()->getTouchByIndex(0, _touch);
    
    btVector3 touch(_touch.getX(), _touch.getY(), 0.0f);
    touch.setX(-touch.x());
    touch.setZ(touch.y());
    touch.setY(0.0f);
    return touch;
}
btScalar MazeGameState::getPlayerControlTouchDistance()const
{
    //Touch _touch;
    //PlayerInput::getInstance()->getTouchByIndex(0, _touch);
    
    btVector3 touch(_touch.getDistanceX(), _touch.getDistanceY(), 0.0f);
    touch.setX(-touch.x());
    touch.setZ(touch.y());
    touch.setY(0.0f);
    return touch.length();
}
void MazeGameState::applyAngularForceOnPlayer()
{
    btVector3 end(getPlayerControlTouchPosition());
    btScalar dist(getPlayerControlTouchDistance());
    btScalar endTime(FrameCounter::getInstance()->getCurrentTime());
    float timeInterval = endTime - m_TouchStartTime;
    
    
    if(dist > m_MaxTouchDistance)
        dist = m_MaxTouchDistance;
    btScalar scale = dist / m_MaxTouchDistance;
    
    
    
    //static btVector2 distanceTouch = btVector2(
    
    btScalar impulseConstant = m_ImpulseContant * scale;//
    
    //printf("dist %f - scale %f - impuse %f\n", dist, scale, impulseConstant);
    
    btVector3 forwardVector(end - *m_TouchStart);
    forwardVector.normalize();
    btVector3 touchVector(forwardVector);
    
    *m_TouchStart = end;
    m_TouchStartTime = FrameCounter::getInstance()->getCurrentTime();
    
    btMatrix3x3 _btMatrix3x3(CameraFactory::getInstance()->getCurrentCamera()->getRotation().inverse());
    
    forwardVector = -forwardVector * _btMatrix3x3;
    
    forwardVector.setY(0.0f);
    forwardVector.normalize();
    
    btVector3 sideVector(forwardVector.cross(m_pPlayerAvatar->getUpVector()));
    
    btScalar impulseMagnitude(impulseConstant * timeInterval);
    
    //
    
    btVector3 test(touchVector.z() * impulseMagnitude, 0.0f, -touchVector.x() * impulseMagnitude);
    
    applyTorqueToPlayer(test);
    //m_pPlayerAvatar->getRigidBody()->applyTorqueImpulse(test);
}

void MazeGameState::applyTorqueToPlayer(const btVector3 &torque)
{
    if(!m_bCanMovePlayer)
        return;
    
    if(!torque.isZero())
        if(m_stop_watch->isStopped())
        {
            m_stop_watch->start();
            
            m_gameTimer->start(3 * 1000);
        }
    
    m_pPlayerAvatar->getRigidBody()->applyTorqueImpulse(torque);
}

void MazeGameState::createGameData()
{
#ifdef SIMULATE_NEW_DAY
    UserSettingsSingleton::getInstance()->setInteger("seed", -1);
#endif
    
    if(GLDebugDrawer::hasInstance())
    {
        GLDebugDrawer::getInstance()->setShaderFactoryID(ShaderFactory::getInstance()->getCurrentShaderID());
    }
    
    BaseTextViewInfo *info = NULL;
    
    const size_t size = 32;
    
    info = new BaseTextViewInfo(ShaderFactory::getInstance()->getCurrentShaderID());
    for(size_t i = 0; i < size; i++)
    {
        m_StopWatchDrawingText.push_back(TextViewObjectFactory::getInstance()->create(info));
    }
    delete info;
    
    TimerInfo timerInfo;
    timerInfo.m_timerType = TimerType_StopWatch;
    m_stopWatchID = FrameCounter::getInstance()->create(&timerInfo);
    m_stop_watch = dynamic_cast<StopWatch*>(FrameCounter::getInstance()->get(m_stopWatchID));
    
    
    
    
    
    info = new BaseTextViewInfo(ShaderFactory::getInstance()->getCurrentShaderID());
    for(size_t i = 0; i < size; i++)
    {
        m_TimerWatchDrawingText.push_back(TextViewObjectFactory::getInstance()->create(info));
    }
    delete info;
    
    timerInfo.m_timerType = TimerType_Timer;
    m_timerID = FrameCounter::getInstance()->create(&timerInfo);
    m_timer = dynamic_cast<Timer*>(FrameCounter::getInstance()->get(m_timerID));
    
    
    info = new BaseTextViewInfo(ShaderFactory::getInstance()->getCurrentShaderID());
    for(size_t i = 0; i < size; i++)
    {
        m_GameTimerDrawingText.push_back(TextViewObjectFactory::getInstance()->create(info));
    }
    delete info;
    
    timerInfo.m_timerType = TimerType_Timer;
    m_gameTimerID = FrameCounter::getInstance()->create(&timerInfo);
    m_gameTimer = dynamic_cast<Timer*>(FrameCounter::getInstance()->get(m_gameTimerID));
    
    info = new BaseTextViewInfo(ShaderFactory::getInstance()->getCurrentShaderID());
    for(size_t i = 0; i < size; i++)
    {
        m_LevelDrawingText.push_back(TextViewObjectFactory::getInstance()->create(info));
    }
    delete info;
    
    
    CameraEntityInfo *constructionInfo = new CameraEntityInfo(true);
    constructionInfo->m_nearZ = -1024;
    constructionInfo->m_farZ = 1024;
    m_pOrthoCamera = CameraFactory::createCameraEntity<CameraEntity, CameraEntityInfo>(constructionInfo);
    delete constructionInfo;
    
    CameraFactory::getInstance()->setOrthoCamera(m_pOrthoCamera);
    
    //m_pOrthoCamera->setOrigin(btVector3(0, 0, 10));
    //m_pOrthoCamera->hide();
    
//    [sharedSoundManager loadBGMWithKey:@"game" fileName:@"menu" fileExt:@"mp3"];
//	[sharedSoundManager playBGMWithKey:@"game" timesToRepeat:-1 fadeIn:NO];
//    [sharedSoundManager setBGMVolume:0.0f];
    
    
//    [[SingletonSoundManager sharedSoundManager] loadSFXWithKey:@"laser" fileName:@"laser" fileExt:@"caf" frequency:22050];
    
    FrameCounter::getInstance()->reset();
    FrameCounter::getInstance()->start();
    
    
    
}
void MazeGameState::destroyGameData()
{
    size_t i;
    const size_t size = 32;
    IDType _id;
    
    
    
//    [[SingletonSoundManager sharedSoundManager] unLoadSFXWithKey:@"laser"];
//    
//    [sharedSoundManager unLoadBGMWithKey:@"game"];
    
    CameraFactory::getInstance()->setOrthoCamera(NULL);
    
    _id = m_pOrthoCamera->getID();
    CameraFactory::getInstance()->destroy(_id);
    
    
    
    
    for(i = 0; i < size; i++)
        TextViewObjectFactory::getInstance()->destroy(m_LevelDrawingText.at(i));
    
    FrameCounter::getInstance()->destroy(m_gameTimerID);
    for(i = 0; i < size; i++)
        TextViewObjectFactory::getInstance()->destroy(m_GameTimerDrawingText.at(i));
    
    FrameCounter::getInstance()->destroy(m_timerID);
    for(i = 0; i < size; i++)
        TextViewObjectFactory::getInstance()->destroy(m_TimerWatchDrawingText.at(i));
    
    FrameCounter::getInstance()->destroy(m_stopWatchID);
    for(i = 0; i < size; i++)
        TextViewObjectFactory::getInstance()->destroy(m_StopWatchDrawingText.at(i));
    
}
void MazeGameState::createLevelData()
{
    m_pOrthoCamera->setOrigin(btVector3(0, 0, 10));
    m_pOrthoCamera->hide();
}
void MazeGameState::destroyLevelData()
{
    
}