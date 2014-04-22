//
//  DebugGameState.mm
//  BaseProject
//
//  Created by library on 9/18/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "DebugGameState.h"
#include "GLDebugDrawer.h"

#include "CameraFactory.h"
#include "CameraSteeringEntity.h"
#include "CameraEntity.h"
#include "CameraFactoryIncludes.h"
#include "ShaderFactory.h"

#include "TextureFactoryIncludes.h"
#include "TextureFactory.h"

#include "ViewObjectFactoryIncludes.h"
#include "ViewObjectFactory.h"

#include "ZipFileResourceLoader.h"

#include "CollisionShapeFactoryIncludes.h"
#include "CollisionShapeFactory.h"

#include "SteeringBehaviorFactoryIncludes.h"
#include "SteeringBehaviorFactory.h"
#include "GameStateFactory.h"

DebugGameState::DebugGameState() :
m_pBaseGameState(NULL),
m_bricksTextureID(0),
m_sphereViewObjectID(0),
m_collisionShapeID(0),
m_steeringBehaviorID(0),
//m_pCameraSteeringEntity(NULL),
m_pCamera(NULL),
m_pGameCamera(NULL),
m_AttachedToGameCamera(true),
m_AttachedOffset(new btVector3(0, 0, 0)),
m_CameraRotationAxis(new btVector3(0, 1, 0)),
m_CameraRotationAngle(0),
m_CameraPivotPoint(new btVector3(0, 0, 0))
{
    GLDebugDrawer::createInstance();
    GLDebugDrawer::getInstance()->setShaderFactoryID(ShaderFactory::getInstance()->getCurrentShaderID());
    GLDebugDrawer::getInstance()->setDebugMode(btIDebugDraw::DBG_MAX_DEBUG_DRAW_MODE);
    
    WorldPhysics::getInstance()->initDebugDrawWorld();
}

DebugGameState::~DebugGameState()
{
    delete m_CameraRotationAxis;
    m_CameraRotationAxis = NULL;
    
    delete m_AttachedOffset;
    m_AttachedOffset = NULL;
    
    GLDebugDrawer::destroyInstance();
    
    //delete m_pBaseGameState;
    //m_pBaseGameState = NULL;
}


void DebugGameState::enter(void*p)
{
    m_pBaseGameState->enter(p);
    
//    m_pGameCamera = CameraFactory::getInstance()->getCurrentCamera();
//    
//    
//    
//    TextureFactoryInfo *info = new TextureFactoryInfo();
//    
//    std::string bricksFilename = "Bricks.png";
//    info->right = bricksFilename;
//    m_bricksTextureID = TextureFactory::getInstance()->create(info);
//    
//    IDType textureFactoryIDs[1] = {0};
//    textureFactoryIDs[0] = m_bricksTextureID;
//    BaseViewObjectInfo *pBaseViewObjectInfo = new BaseViewObjectInfo(ShaderFactory::getInstance()->getCurrentShaderID(), "sphere", textureFactoryIDs, 1);
//    m_sphereViewObjectID = ViewObjectFactory::getInstance()->create(pBaseViewObjectInfo);
//    BaseViewObject *vo = ViewObjectFactory::getInstance()->get(m_sphereViewObjectID);
//    ZipFileResourceLoader::getInstance()->getMeshObject("sphere")->load(vo);
//    delete pBaseViewObjectInfo;
//    
//    
//    CollisionShapeInfo *pCollisionShapeInfo = new CollisionShapeInfo(CollisionShapeType_Sphere,
//                                              ViewObjectFactory::getInstance()->get(m_sphereViewObjectID));
//    m_collisionShapeID = CollisionShapeFactory::getInstance()->create(pCollisionShapeInfo);
//    delete pCollisionShapeInfo;
//    
//    SteeringBehaviorInfo *pSteeringBehaviorInfo = new SteeringBehaviorInfo();
//    m_steeringBehaviorID = SteeringBehaviorFactory::getInstance()->create(pSteeringBehaviorInfo);
//    delete pSteeringBehaviorInfo;
//    
//    
//    
//    CameraEntityInfo *constructionInfo = new CameraEntityInfo();
//    
//    constructionInfo->m_nearZ = 0.01f;
//    constructionInfo->m_farZ = 1000.0f;
//    m_pCamera = CameraFactory::createCameraEntity<CameraEntity, CameraEntityInfo>(constructionInfo);
//    delete constructionInfo;
//    
//    CameraFactory::getInstance()->setCurrentCamera(m_pCamera);
//    
//    
//    
//    
//    m_pCamera->setOrigin(btVector3(0, 40, 60));
//    //m_pCamera->lookAt(btVector3(0, 0, 0));
//   // m_pCamera->getRigidBody()->setLinearVelocity(btVector3(0, 0, 0));
//    
//    m_AttachedToGameCamera = true;
}

//this is the states normal update function

void DebugGameState::update(void*p, btScalar deltaTimeStep)
{
    m_pBaseGameState->update(p, deltaTimeStep);
    
    
    
    
//    if(m_AttachedToGameCamera && m_pGameCamera)
//    {
//        *m_AttachedOffset = (m_pGameCamera->getHeadingVector() * 1);
//        
//        btTransform worldTransform(m_pGameCamera->getWorldTransform());
//        worldTransform.setOrigin(worldTransform.getOrigin() + *m_AttachedOffset);
//        
//        m_pCamera->setWorldTransform(worldTransform);
//        m_pCamera->setHeadingVector(m_pGameCamera->getHeadingVector());
//        m_pCamera->setUpVector(m_pGameCamera->getUpVector());
//    }
//    else
//    {
//        m_CameraRotationAngle = (deltaTimeStep * 1);
//        if(m_CameraRotationAngle > DEGREES_TO_RADIANS(360))
//            m_CameraRotationAngle = 0;
//        
//        
//        m_pCamera->rotate(btQuaternion(*m_CameraRotationAxis, m_CameraRotationAngle),
//                          *m_CameraPivotPoint);
//        m_pCamera->lookAt(*m_CameraPivotPoint);
//    }
}

//call this to update the FSM

void  DebugGameState::render()
{
    m_pBaseGameState->render();
    
    btScalar far = CameraFactory::getInstance()->getCurrentCamera()->getFar();
    
    GLDebugDrawer::getInstance()->drawLine(btVector3(0, 0, 0), btVector3(far, 0, 0), btVector3(1, 0, 0));
    GLDebugDrawer::getInstance()->drawLine(btVector3(0, 0, 0), btVector3(0, far, 0), btVector3(0, 1, 0));
    GLDebugDrawer::getInstance()->drawLine(btVector3(0, 0, 0), btVector3(0, 0, far), btVector3(0, 0, 1));
    
    WorldPhysics::getInstance()->debugDrawWorld();
}

//this will execute when the state is exited.

void DebugGameState::exit(void*p)
{
    TextureFactory::getInstance()->destroy(m_bricksTextureID);
    ViewObjectFactory::getInstance()->destroy(m_sphereViewObjectID);
    CollisionShapeFactory::getInstance()->destroy(m_collisionShapeID);
    SteeringBehaviorFactory::getInstance()->destroy(m_steeringBehaviorID);
    
    m_pBaseGameState->exit(p);
}

//this executes if the agent receives a message from the
//message dispatcher

bool DebugGameState::onMessage(void*p, const Telegram&t)
{
    return m_pBaseGameState->onMessage(p, t);
}


//void DebugGameState::touchesBegan()
//{
//    m_pBaseGameState->touchesBegan();
//}
//
//void DebugGameState::touchesMoved()
//{
//    m_pBaseGameState->touchesMoved();
//}
//
//void DebugGameState::touchesEnded()
//{
//    m_pBaseGameState->touchesEnded();
//}
//
//void DebugGameState::touchesCancelled()
//{
//    m_pBaseGameState->touchesCancelled();
//}

const BaseGameState*	DebugGameState::getGameState() const
{
    return m_pBaseGameState;
}
BaseGameState*	DebugGameState::getGameState()
{
    return m_pBaseGameState;
}
void DebugGameState::setGameState(const IDType ID)
{
    m_pBaseGameState = GameStateFactory::getInstance()->get(ID);
}