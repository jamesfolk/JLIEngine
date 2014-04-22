//
//  PathTestState.cpp
//  GameAsteroids
//
//  Created by James Folk on 7/26/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "PathTestState.h"
#include "Path.h"
#include "CameraFactory.h"
#include "BaseCamera.h"
#include "CameraEntity.h"
#include "CameraSteeringEntity.h"

#include "ShaderFactory.h"
#include "GLDebugDrawer.h"

#include "TextureFactory.h"
#include "TextureFactoryIncludes.h"

#include "CollisionShapeFactory.h"
#include "CollisionShapeFactoryIncludes.h"

#include "SteeringBehaviorFactory.h"
#include "SteeringBehaviorFactoryIncludes.h"

#include "EntityFactory.h"

#include "SteeringEntity.h"

PathTestState::PathTestState() :
m_pPath(NULL),
m_pSteeringCamera(NULL),
m_currentPathIndex(0)
{
    
}

PathTestState::~PathTestState()
{
    
}

void PathTestState::update_specific(btScalar deltaTimeStep)
{
    m_Rotate += (deltaTimeStep * 1.0f);
    if(m_Rotate > DEGREES_TO_RADIANS(360))
        m_Rotate = 0;
    
    m_pCameraEntity->lookAt(m_pPath->getOrigin());
    
    //m_pPath->setRotation(btQuaternion(m_Rotate, m_Rotate, m_Rotate));
    
//    btVector3 aabbMax, aabbMin;
//    m_pRigidEnity->getRigidBody()->getCollisionShape()->getAabb(btTransform::getIdentity(), aabbMin, aabbMax);
//    m_pRigidEnity->rotate(btQuaternion(m_Rotate, 0, 0), btVector3(3,0,0));
//    //m_pRigidEnity->setRotation(btQuaternion(m_Rotate, 0, 0), aabbMax);
//    
//    DebugString::log("rigid body " + DebugString::btVectorStr(m_pRigidEnity->getOrigin()));
    
}
void PathTestState::enter_specific()
{
    m_Rotate = 0;
    
    
    
    createPath();
    
    createShader();
    createTextures();
    createViewObjects();
    createCollisionShapes();
    createSteeringBehavior();
    createSteeringEntity();
    createRigidEntity();
    
    
    createCamera();
    
    
    if(GLDebugDrawer::getInstance())
    {
        GLDebugDrawer::getInstance()->setShaderFactoryID(ShaderFactory::getInstance()->getCurrentShaderID());
    }
    
    btVector3 aabbMin, aabbMax;
    m_pRigidEnity->getRigidBody()->getCollisionShape()->getAabb(btTransform::getIdentity(), aabbMin, aabbMax);
    btVector3 offset(0,aabbMax.y(), 0);
    
    m_pPath->attachToEntity(m_pRigidEnity, m_pPath->getNumberOfWayPoints() - 1, offset);
    
    //WorldPhysics::getInstance()->setGravity(btVector3(0,0,0));
}
void PathTestState::exit_specific()
{
    
}
void PathTestState::render_specific()
{
    
}
//void PathTestState::touchesBegan()
//{
//    
//}
//void PathTestState::touchesMoved()
//{
//    
//}
//void PathTestState::touchesEnded()
//{
//    m_pRigidEnity->getRigidBody()->applyCentralImpulse(btVector3(0,1,0));
//}
//void PathTestState::touchesCancelled()
//{
//    
//}

void PathTestState::createPath()
{
    PathInfo *info = new PathInfo();
    info->m_curveName = "camerapath";
    m_pPath = new Path(*info);
    m_pPath->enableLoop();
    m_pPath->setLoopType(LoopType_Linear);
    m_pPath->enableAutomaticIncrement();
    delete info;
}

//void PathTestState::createCamera()
//{
//    CameraEntityInfo *constructionInfo = new CameraEntityInfo(false);
//    
//    constructionInfo->m_nearZ = 0.01f;
//    constructionInfo->m_farZ = 1000.0f;
//    m_pCamera = CameraFactory::createCameraEntity(constructionInfo);
//    delete constructionInfo;
//    
//    CameraFactory::getInstance()->setCurrentCamera(m_pCamera);
//    
//    m_pCamera->setOrigin(btVector3(0, 0, -20.0f));
//    m_pCamera->hide();
//}

void PathTestState::createCamera()
{
    CameraEntityInfo *info = new CameraEntityInfo();
    info->m_nearZ = 0.01f;
    info->m_farZ = 1000.0f;
    m_pCameraEntity = CameraFactory::createCameraEntity<CameraEntity, CameraEntityInfo>(info);
    delete info;
    CameraFactory::getInstance()->setCurrentCamera(m_pCameraEntity);
    m_pCameraEntity->setOrigin(btVector3(0, 0, 40.0f));
    m_pCameraEntity->hide();
    
//    CameraSteeringEntityInfo *constructionInfo = new CameraSteeringEntityInfo(/*bool isOrthographicCamera = */false,
//                                                                              m_sphereViewObjectID,
//                                                                              /*IDType stateMachineFactoryID = */0,
//                                                                              /*IDType animationFactoryID = */0,
//                                                                              /*bool isOrthographicEntity = */false,
//                                                                              m_sphereCollisionShapeID,
//                                                                              /*btScalar mass = */0.0,
//                                                                              m_steeringBehaviorID,
//                                                                              /*const WanderInfo &wanderInfo = */WanderInfo());
//    
//    constructionInfo->m_nearZ = 0.01f;
//    constructionInfo->m_farZ = 1000.0f;
//    //m_pCamera = CameraFactory::createCameraEntity(constructionInfo);
//    m_pSteeringCamera = CameraFactory::createCameraEntity<CameraSteeringEntity, CameraSteeringEntityInfo>(constructionInfo);
//    delete constructionInfo;
//    
//    CameraFactory::getInstance()->setCurrentCamera(m_pSteeringCamera);
//    
//    m_pSteeringCamera->setOrigin(btVector3(0, 0, -60.0f));
//    m_pSteeringCamera->hide();
//    
//    //m_pSteeringCamera->getSteeringBehavior()->setFollowPathOn(m_pPath);
//    
//    //m_pSteeringCamera->setMaxLinearSpeed(10.0f);
//    
//    m_pSteeringCamera->enableCollision(false);
}

void PathTestState::createShader()
{
    //    ShaderFactoryKey key(VERTEX_SHADER, FRAGMENT_SHADER);
    //    shaderFactoryID = ShaderFactory::getInstance()->create(&key);
    //m_shaderFactoryID = ShaderFactory::getInstance()->getCurrentShaderID();
}

void PathTestState::createTextures()
{
    TextureFactoryInfo info;
    std::string bricksFilename = "Bricks.png";
    info.right = bricksFilename;
    m_bricksTextureID = TextureFactory::getInstance()->create(&info);
}

void PathTestState::createViewObjects()
{
    btAlignedObjectArray<GLushort> indiceData;
    btAlignedObjectArray<VertexAttributes_Vertex_Normal_Color_UVLayer1> vertexData;
    IDType textureFactoryIDs[1];
    BaseViewObjectInfo *constructionInfo = NULL;
    BaseViewObject *vo = NULL;
    
    VertexAttributeLoader::getInstance()->createbtAlignedObjectArray("cone", indiceData, vertexData);
    textureFactoryIDs[0] = m_bricksTextureID;
    constructionInfo = new BaseViewObjectInfo(ShaderFactory::getInstance()->getCurrentShaderID(), "cone", textureFactoryIDs, 1);
    m_coneViewObjectID = ViewObjectFactory::getInstance()->create(constructionInfo);
    vo = ViewObjectFactory::getInstance()->get(m_coneViewObjectID);
    VertexAttributeLoader::getInstance()->load(vo, indiceData, vertexData);
    delete constructionInfo;
    
    
    
    VertexAttributeLoader::getInstance()->createbtAlignedObjectArray("sphere", indiceData, vertexData);
    textureFactoryIDs[0] = m_bricksTextureID;
    constructionInfo = new BaseViewObjectInfo(ShaderFactory::getInstance()->getCurrentShaderID(), "sphere", textureFactoryIDs, 1);
    m_sphereViewObjectID = ViewObjectFactory::getInstance()->create(constructionInfo);
    vo = ViewObjectFactory::getInstance()->get(m_sphereViewObjectID);
    VertexAttributeLoader::getInstance()->load(vo, indiceData, vertexData);
    delete constructionInfo;
}
void PathTestState::createCollisionShapes()
{
//    CollisionShapeInfo *constructionInfo = NULL;
//    
//    constructionInfo = new CollisionShapeInfo(CollisionShapeType_ConeY, ViewObjectFactory::getInstance()->get(m_coneViewObjectID));
//    m_coneCollisionShapeID = CollisionShapeFactory::getInstance()->create(constructionInfo);
//    delete constructionInfo;
//    
//    constructionInfo = new CollisionShapeInfo(CollisionShapeType_Sphere, ViewObjectFactory::getInstance()->get(m_sphereViewObjectID));
//    m_sphereCollisionShapeID = CollisionShapeFactory::getInstance()->create(constructionInfo);
//    delete constructionInfo;
}

void PathTestState::createSteeringBehavior()
{
    SteeringBehaviorInfo *constructionInfo = new SteeringBehaviorInfo();

    m_steeringBehaviorID = SteeringBehaviorFactory::getInstance()->create(constructionInfo);
    
    delete constructionInfo;
}

void PathTestState::createSteeringEntity()
{
    SteeringEntityInfo *constructionInfo = new SteeringEntityInfo(m_coneViewObjectID,
                                                                  /*IDType stateMachineFactoryID =*/ 0,
                                                                  /*IDType animationFactoryID = */0,
                                                                  /*bool isOrthographicEntity = */false,
                                                                  m_coneCollisionShapeID,
                                                                  1.0f,
                                                                  m_steeringBehaviorID/*,
                                                                  const WanderInfo &wanderInfo = WanderInfo(),
                                                                                       const FollowPathInfo &followPathInfo = FollowPathInfo()*/);
    
    m_pSteeringEntity = EntityFactory::createEntity<SteeringEntity, SteeringEntityInfo>(constructionInfo);
    m_pSteeringEntity->setOrigin(btVector3(0,0,0));
    
//    m_pSteeringEntity->getSteeringBehavior()->setFollowPathOn(m_pPath);
    m_pSteeringEntity->setMaxLinearSpeed(30.0f);
    
}
void PathTestState::createRigidEntity()
{
    RigidEntityInfo *constructionInfo = new RigidEntityInfo(m_sphereViewObjectID,
                                                            0,
                                                            0,
                                                            false,
                                                            m_sphereCollisionShapeID,
                                                            1.0f);
    m_pRigidEnity = EntityFactory::createEntity<RigidEntity, RigidEntityInfo>(constructionInfo);
    m_pRigidEnity->setOrigin(btVector3(0,0,0));
    m_pRigidEnity->enableCollision(false);
    
//    m_pRigidEnity2 = EntityFactory::createEntity<RigidEntity, RigidEntityInfo>(constructionInfo);
//    
//    m_pRigidEnity->setEntityDecorator(m_pRigidEnity2->getID());
//    //m_pRigidEnity2->setOrigin(btVector3(0,2,0));
//    m_pRigidEnity2->setOriginOffset(btVector3(0,2,0));
//    m_pRigidEnity2->enableCollision(false);
}