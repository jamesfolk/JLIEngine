//
//  ViewEntityTestState.cpp
//  GameAsteroids
//
//  Created by James Folk on 4/29/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "ViewEntityTestState.h"

#include "CameraFactory.h"

#include "ShaderFactory.h"

#include "CameraSteeringEntity.h"
#include "CameraEntity.h"
#include "CameraPhysicsEntity.h"
#include "CollisionShapeFactory.h"
//#include "AbstractVertexAttributeView.h"

#include "EntityFactory.h"
#include "CameraFactory.h"



#include "ViewObjectFactory.h"


#include "TextureFactory.h"

#include "MeshMazeCreator.h"

#include "GLDebugDrawer.h"

//#include "PlayerInput.h"

#include "TextureBehaviorFactory.h"
#include "TextViewObjectFactoryIncludes.h"
#include "ParticleEmitterBehaviorFactoryIncludes.h"

#include "ParticleEmitterBehaviorFactory.h"
#include "SoftEntity.h"
//#include "FinishLevelCollisionResponseBehavior.h"
#include "CollisionResponseBehaviorFactory.h"

//#include "PlayerCollisionFilterBehavior.h"
//#include "FinishLevelCollisionFilterBehavior.h"
//#include "CollisionFilterBehaviorFactory.h"

#include "SteeringBehaviorFactory.h"
#include "SteeringBehaviorFactoryIncludes.h"

#include "Path.h"

//#include "PlayerCollisionResponseBehavior.h"


//#include "PlayerUpdateBehavior.h"
//#include "UpdateBehaviorFactory.h"
//#include "UpdateBehaviorFactoryIncludes.h"


#include "ZipFileResourceLoader.h"

const int s_BoardSizeMax = 45;
int ViewEntityTestState::s_BoardSize = 2;

ViewEntityTestState::ViewEntityTestState()
{
    touchcount = 0;
    m_Rotate = 0;
    m_InitalizeTouch = false;
    m_BoardNormal.setValue(0, 1, 0);
}
ViewEntityTestState::~ViewEntityTestState()
{
    delete m_pPath;
}

void ViewEntityTestState::update_specific(btScalar deltaTimeStep)
{
    //m_Rotate += (deltaTimeStep * 5);
    if(m_Rotate > DEGREES_TO_RADIANS(360))
        m_Rotate = 0;
    
    m_pBaseTextViewObject->setRotation(btQuaternion(m_Rotate, m_Rotate, m_Rotate));
    m_pBaseTextViewObject->setOrigin(btVector3(64, 64, 0));
    
    
    m_pSteeringCamera->lookAt(m_pPlayer->getOrigin());
    
    m_pSteeringCamera->getSteeringBehavior()->getPath()->setPathIncrement(PathIncrement_None);
    //if(PlayerInput::getInstance()->isPinchGesturing())
    {
        btScalar scale;// = [PlayerInput::getInstance()->getPinchGestureRecognizer() scale];
        btScalar velocity;// = [PlayerInput::getInstance()->getPinchGestureRecognizer() velocity];
        
        
        if(velocity > 0)
        {
            m_pSteeringCamera->getSteeringBehavior()->getPath()->setPathIncrement(PathIncrement_Positive);
        }
        else if(velocity < 0)
        {
            m_pSteeringCamera->getSteeringBehavior()->getPath()->setPathIncrement(PathIncrement_Negative);
        }
    }
    btVector3 impulse;//(PlayerInput::getInstance()->getGyroChangeValue());
    btScalar magnitude = 5000.0f;
    
    m_pPlayer->getRigidBody()->applyTorqueImpulse(btVector3(impulse.y(), 0, impulse.z()) * magnitude);
    
    
}

void ViewEntityTestState::createCamera()
{
    SteeringBehaviorInfo *sconstructionInfo = new SteeringBehaviorInfo();
    
    IDType steeringBehaviorID = SteeringBehaviorFactory::getInstance()->create(sconstructionInfo);
    
    delete sconstructionInfo;
    
    CameraSteeringEntityInfo *constructionInfo = new CameraSteeringEntityInfo(/*bool isOrthographicCamera = */false,
                                                                              sphereViewObjectID,
                                                                              /*IDType stateMachineFactoryID = */0,
                                                                              /*IDType animationFactoryID = */0,
                                                                              /*bool isOrthographicEntity = */false,
                                                                              sphereCollisionShapeID,
                                                                              /*btScalar mass = */1.0,
                                                                              steeringBehaviorID,
                                                                              /*const WanderInfo &wanderInfo = */WanderInfo());
    
    constructionInfo->m_nearZ = 0.01f;
    constructionInfo->m_farZ = 1000.0f;
    //m_pCamera = CameraFactory::createCameraEntity(constructionInfo);
    m_pSteeringCamera = CameraFactory::createCameraEntity<CameraSteeringEntity, CameraSteeringEntityInfo>(constructionInfo);
    delete constructionInfo;
    
    CameraFactory::getInstance()->setCurrentCamera(m_pSteeringCamera);
    
    //m_pSteeringCamera->setOrigin(btVector3(0, 0, -20.0f));
    m_pSteeringCamera->hide();
    
    
    
    PathInfo *info = new PathInfo();
    info->m_curveName = "camerapath";
    m_pPath = new Path(*info);
    //m_pPath->enableLoop();
    //m_pPath->setLoopType(LoopType_Linear);
    delete info;
    
//    m_pSteeringCamera->getSteeringBehavior()->setFollowPathOn(m_pPath);
    //m_pSteeringCamera->getSteeringBehavior()->setArriveOn(btVector3(0,0,0));
    m_pSteeringCamera->setMaxLinearSpeed(20.0f);
    
    m_pSteeringCamera->enableCollision(false);
}

void ViewEntityTestState::createCube()
{   
    RigidEntityInfo *constructionInfo = new RigidEntityInfo(cubeViewObjectID,
                                                                0,
                                                                0,
                                                                false,
                                                                cubeCollisionShapeID,
                                                                1.0f);
    
    //pCube = EntityFactory::createPhysicsEntity(constructionInfo);
    pCube = EntityFactory::createEntity<RigidEntity, RigidEntityInfo>(constructionInfo);
    delete constructionInfo;
    
    //m_Entities.push_back(pCube);
    
    pCube->setOrigin(btVector3(0, 10, 0));
    
    pCurrentEntity = pCube;
    
    
}

void ViewEntityTestState::createSphere()
{
    RigidEntityInfo *constructionInfo = new RigidEntityInfo(sphereViewObjectID,
                                                                0,
                                                                0,
                                                                false,
                                                                sphereCollisionShapeID,
                                                                1.0f);
    
    pSphere = EntityFactory::createEntity<RigidEntity, RigidEntityInfo>(constructionInfo);
    delete constructionInfo;
    
    pSphere->setOrigin(btVector3(0, 10, 0));
    
    pCurrentEntity = pSphere;
    
}
void ViewEntityTestState::enter_specific()
{
    m_TouchStartTime = FrameCounter::getInstance()->getCurrentTime();
    
    initViewObjects();
    initCollisionShapes();
    
    if(GLDebugDrawer::getInstance())
    {
        GLDebugDrawer::getInstance()->setShaderFactoryID(ShaderFactory::getInstance()->getCurrentShaderID());
    }
    createCamera();
    
    createMaze();
    
    createPlayer();
    
    btVector3 aabbMin, aabbMax;
    m_pPlayer->getRigidBody()->getCollisionShape()->getAabb(btTransform::getIdentity(), aabbMin, aabbMax);
    btVector3 offset(0,aabbMax.y() + 30.0f, aabbMin.z() - 10.0f);
    m_pPath->attachToEntity(m_pPlayer, m_pPath->getNumberOfWayPoints() - 1, offset);
    
    m_pSteeringCamera->setOrigin(m_pPath->getWayPoint(0));
    
    createEndTrigger();
    
    BaseTextViewInfo *info = new BaseTextViewInfo(shaderFactoryID);
    IDType textViewFactoryID = TextViewObjectFactory::getInstance()->create(info);
    m_pBaseTextViewObject = TextViewObjectFactory::getInstance()->get(textViewFactoryID);
    delete info;
    
    m_pBaseTextViewObject->setTextKey("ALPHA_LOW", LocalizedTextViewObjectType_Helvetica_72pt);
    
    ParticleEmitterBehaviorInfo *particleCInfo = new ParticleEmitterBehaviorInfo(shaderFactoryID, 1, 1);
    IDType particleEmitterFactoryID = ParticleEmitterBehaviorFactory::getInstance()->create(particleCInfo);
    delete particleCInfo;
    particleCInfo = NULL;
}
void ViewEntityTestState::exit_specific()
{
    //
}


void ViewEntityTestState::render_specific()
{
    m_pBaseTextViewObject->render();
}
//void ViewEntityTestState::touchesBegan()
//{
//    m_TouchStart = getPlayerControlTouchPosition();
//    m_TouchStartTime = FrameCounter::getInstance()->getCurrentTime();
//    
//    m_InitalizeTouch = true;
//    
//}
//void ViewEntityTestState::touchesMoved()
//{
//    if(m_InitalizeTouch)
//    {
//        //applyLinearForceOnPlayer();
//        applyAngularForceOnPlayer();
//    }
//}
//void ViewEntityTestState::touchesEnded()
//{
//    m_InitalizeTouch = false;
//}
//void ViewEntityTestState::touchesCancelled()
//{
//    m_InitalizeTouch = false;
//}

void ViewEntityTestState::initViewObjects()
{
    IDType textureFactoryIDs[1];
    TextureFactoryInfo info;
    
    //    ShaderFactoryKey key(VERTEX_SHADER, FRAGMENT_SHADER);
    //    shaderFactoryID = ShaderFactory::getInstance()->create(&key);
    shaderFactoryID = ShaderFactory::getInstance()->getCurrentShaderID();
    
    //info.loadFromFile = false;
    std::string bricksFilename = "Bricks.png";
    info.right = bricksFilename;
    bricksTextureID = TextureFactory::getInstance()->create(&info);
    
    std::string tarsierFilename = "Tarsier.png";
    info.right = tarsierFilename;
    IDType tarsierTextureID = TextureFactory::getInstance()->create(&info);    
    
    BaseViewObjectInfo *constructionInfo = NULL;
    BaseViewObject *vo = NULL;
    
    textureFactoryIDs[0] = bricksTextureID;
    constructionInfo = new BaseViewObjectInfo(shaderFactoryID, "sphere", textureFactoryIDs, 1);
    sphereViewObjectID = ViewObjectFactory::getInstance()->create(constructionInfo);
    vo = ViewObjectFactory::getInstance()->get(sphereViewObjectID);
    ZipFileResourceLoader::getInstance()->getMeshObject("sphere")->load(vo);
    delete constructionInfo;
    
    textureFactoryIDs[0] = tarsierTextureID;
    constructionInfo = new BaseViewObjectInfo(shaderFactoryID, "cube", textureFactoryIDs, 1);
    cubeViewObjectID = ViewObjectFactory::getInstance()->create(constructionInfo);
    vo = ViewObjectFactory::getInstance()->get(cubeViewObjectID);
    ZipFileResourceLoader::getInstance()->getMeshObject("cube")->load(vo);
    delete constructionInfo;
    
    textureFactoryIDs[0] = tarsierTextureID;
    constructionInfo = new BaseViewObjectInfo(shaderFactoryID, "plane", textureFactoryIDs, 1);
    planeViewObjectID = ViewObjectFactory::getInstance()->create(constructionInfo);
    vo = ViewObjectFactory::getInstance()->get(planeViewObjectID);
    ZipFileResourceLoader::getInstance()->getMeshObject("plane")->load(vo);
    delete constructionInfo;
    
}
void ViewEntityTestState::initCollisionShapes()
{
//    CollisionShapeInfo *constructionInfo = NULL;
//    
//    constructionInfo = new CollisionShapeInfo(CollisionShapeType_Sphere,
//                                              ViewObjectFactory::getInstance()->get(sphereViewObjectID));
//    sphereCollisionShapeID = CollisionShapeFactory::getInstance()->create(constructionInfo);
//    delete constructionInfo;
//    
//    constructionInfo = new CollisionShapeInfo(CollisionShapeType_Cube,
//                                              ViewObjectFactory::getInstance()->get(cubeViewObjectID));
//    cubeCollisionShapeID = CollisionShapeFactory::getInstance()->create(constructionInfo);
//    delete constructionInfo;
}

unsigned int ViewEntityTestState::getSeed()const
{
    time_t rawtime;
    struct tm * ptm;
    
    time ( &rawtime );
    
    ptm = gmtime ( &rawtime );
    
    return ptm->tm_year + ptm->tm_yday;
}

void ViewEntityTestState::createMaze()
{
    MazeCreator::createInstance();
    
    unsigned int row_count = s_BoardSize;
    unsigned int column_count = s_BoardSize;
    MazeRenderType type = MazeRenderType_Mesh;
    
    unsigned int seed = getSeed();
    NSLog(@"seed: %d", seed);
    MeshMazeCreator *pMazeMesh = dynamic_cast<MeshMazeCreator*>(MazeCreator::getInstance()->CreateNew(row_count, column_count, type, seed));
    
    
    pMazeMesh->DrawMaze("mazeblock", bricksTextureID);
    //pMazeMesh->SolveMaze();
    
    unsigned int row, column;
    
    pMazeMesh->getBeginningCoord(row, column);
    m_MazeStartOrigin = btVector3(pMazeMesh->getOriginOfTile(row, column));
    
    pMazeMesh->getEndCoord(row, column);
    m_MazeEndOrigin = btVector3(pMazeMesh->getOriginOfTile(row, column));
    
    m_pMaze = pMazeMesh->getMaze();
    m_pMaze->setKinematicPhysics();
    
    m_pMaze->enableHandleCollision();
    delete pMazeMesh;
    
    MazeCreator::destroyInstance();
    
    m_pMaze->getRigidBody()->setFriction(10.0f);
    
    //m_pMaze->setRotation(PlayerInput::getInstance()->getGyroValue());
}

void ViewEntityTestState::createPlayer()
{
    RigidEntityInfo *constructionInfo = new RigidEntityInfo(sphereViewObjectID,
                                                                0,
                                                                0,
                                                                false,
                                                                sphereCollisionShapeID,
                                                                50.0f);
    
    //m_pPlayer = EntityFactory::createPhysicsEntity(constructionInfo);
    m_pPlayer = EntityFactory::createEntity<RigidEntity, RigidEntityInfo>(constructionInfo);
    delete constructionInfo;
    
    m_pPlayer->getRigidBody()->setActivationState(DISABLE_DEACTIVATION);
    
    m_pPlayer->getRigidBody()->setRestitution(0.0f);
    m_pPlayer->getRigidBody()->setFriction(10.0f);
    
    btVector3 origin(m_MazeStartOrigin);
    origin.setY(origin.y() + 2.0f);
    
    btVector3 aabbMin, aabbMax;
    m_pPlayer->getRigidBody()->getCollisionShape()->getAabb(btTransform::getIdentity(),
                                                            aabbMin, aabbMax);
    origin.setY(origin.y() + aabbMax.y() );
    m_pPlayer->setOrigin(origin);
    
    
    
    m_pPlayer->enableHandleCollision();
    
//    PlayerFilterBehaviorInfo *colInfo = new PlayerFilterBehaviorInfo();
//    IDType collisionFilterID = CollisionFilterBehaviorFactory::getInstance()->create(colInfo);
//    delete colInfo;
    
    //m_pPlayer->setCollisionFilterBehavior(collisionFilterID);
    
    
//    PlayerCollisionResponseBehaviorInfo *info = new PlayerCollisionResponseBehaviorInfo();
//    IDType playerFactoryID = CollisionResponseBehaviorFactory::getInstance()->create(info);
//    delete info;
//    m_pPlayer->setCollisionResponseBehavior(playerFactoryID);
    
//    PlayerUpdateBehaviorInfo *puinfo = new PlayerUpdateBehaviorInfo();
//    IDType playerUpdateInfoID = UpdateBehaviorFactory::getInstance()->create(puinfo);
//    delete puinfo;
//    m_pPlayer->setUpdateBehavior(playerUpdateInfoID);
}

void ViewEntityTestState::createSoftPlayer()
{
    SoftEntityInfo *cInfo = new SoftEntityInfo();
    cInfo->m_ViewObjectID = cubeViewObjectID;
    cInfo->m_mass = 10.0f;
    
    m_pSoftPlayer = EntityFactory::createEntity<SoftEntity, SoftEntityInfo>(cInfo);
    btTransform transform(btTransform::getIdentity());
    
    btVector3 origin(m_MazeStartOrigin);
    origin.setY(origin.y() + 7.0f);
    transform.setOrigin(origin);
    m_pSoftPlayer->setWorldTransform(transform);
    
    delete cInfo;
}

btVector3 ViewEntityTestState::getPlayerControlTouchPosition()const
{
    //Touch _touch;
    //PlayerInput::getInstance()->getTouchByIndex(0, _touch);
    
    btVector3 touch;//(_touch.getX(), _touch.getY(), 0.0f);
//    touch.setX(-touch.x());
//    touch.setZ(touch.y());
//    touch.setY(0.0f);
    return touch;
}

void ViewEntityTestState::createEndTrigger()
{
    GhostEntityInfo *constructionInfo = new GhostEntityInfo(cubeViewObjectID,
                                                            0,
                                                            0,
                                                            false,
                                                            cubeCollisionShapeID);
    
    m_pEndTrigger = EntityFactory::createEntity<GhostEntity, GhostEntityInfo>(constructionInfo);
    
    btVector3 origin(m_MazeEndOrigin);
    origin.setY(origin.y());
    
    btVector3 aabbMin, aabbMax;
    m_pEndTrigger->getGhostObject()->getCollisionShape()->getAabb(btTransform::getIdentity(),
                                                            aabbMin, aabbMax);
    origin.setY(origin.y() + aabbMax.y());
    m_pEndTrigger->setOrigin(origin);
    
    //m_pEndTrigger->enableCollision();
    
    
//    FinishLevelResponseBehaviorInfo *info = new FinishLevelResponseBehaviorInfo();
//    IDType finishLevelFactoryID = CollisionResponseBehaviorFactory::getInstance()->create(info);
//    delete info;
//    m_pEndTrigger->setCollisionResponseBehavior(finishLevelFactoryID);
    
    delete constructionInfo;
    
    
//    FinishLevelFilterBehaviorInfo *colInfo = new FinishLevelFilterBehaviorInfo();
//    IDType collisionFilterID = CollisionFilterBehaviorFactory::getInstance()->create(colInfo);
//    delete colInfo;
    
    //m_pEndTrigger->setCollisionFilterBehavior(collisionFilterID);
    
}

bool ViewEntityTestState::increaseBoardSize()
{
    s_BoardSize++;
    if(s_BoardSize > s_BoardSizeMax)
        return true;
}

void ViewEntityTestState::applyLinearForceOnPlayer()
{
    btVector3 end(getPlayerControlTouchPosition());
    btScalar endTime(FrameCounter::getInstance()->getCurrentTime());
    float timeInterval = endTime - m_TouchStartTime;
    
    static btScalar impulseConstant = 500.0f;
    
    btVector3 impulseVector(end - m_TouchStart);
    impulseVector.normalize();
    
    m_TouchStart = end;
    m_TouchStartTime = FrameCounter::getInstance()->getCurrentTime();
    
    btMatrix3x3 _btMatrix3x3(CameraFactory::getInstance()->getCurrentCamera()->getRotation().inverse());
    
    impulseVector = -impulseVector * _btMatrix3x3;
    
    impulseVector.setY(0.0f);
    impulseVector.normalize();
    
    btScalar impulseMagnitude(impulseConstant * timeInterval);
    btVector3 impulse(impulseVector * impulseMagnitude);
    
    m_pPlayer->getRigidBody()->applyCentralImpulse(impulse);
}
void ViewEntityTestState::applyAngularForceOnPlayer()
{
    btVector3 end(getPlayerControlTouchPosition());
    btScalar endTime(FrameCounter::getInstance()->getCurrentTime());
    float timeInterval = endTime - m_TouchStartTime;
    
    static btScalar impulseConstant = 10000.0f;
    
    btVector3 forwardVector(end - m_TouchStart);
    forwardVector.normalize();
    btVector3 touchVector(forwardVector);
    
    m_TouchStart = end;
    m_TouchStartTime = FrameCounter::getInstance()->getCurrentTime();
    
    btMatrix3x3 _btMatrix3x3(CameraFactory::getInstance()->getCurrentCamera()->getRotation().inverse());
    
    forwardVector = -forwardVector * _btMatrix3x3;
    
    forwardVector.setY(0.0f);
    forwardVector.normalize();
    
    btVector3 sideVector(forwardVector.cross(m_pPlayer->getUpVector()));
    
    btScalar impulseMagnitude(impulseConstant * timeInterval);
    
    //
    
    btVector3 test(touchVector.z() * impulseMagnitude, 0.0f, -touchVector.x() * impulseMagnitude);
    m_pPlayer->getRigidBody()->applyTorqueImpulse(test);
    
}


