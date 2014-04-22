//
//  MazeTestState.cpp
//  GameAsteroids
//
//  Created by James Folk on 3/28/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "MazeTestState.h"


#include "UtilityFunctions.h"

#include "RigidEntity.h"
#include "SteeringEntity.h"

#include "CameraSteeringEntity.h"

#include "ShaderFactory.h"
#include "ViewObjectFactory.h"
#include "CameraFactory.h"
//#include "PlayerInput.h"


#include "MeshMazeCreator.h"
#include "GhostEntity.h"

#include "AbstractFactoryIncludes.h"

int MazeTestState::s_BoardSize = 2;

MazeTestState::MazeTestState()
{
    
}

MazeTestState::~MazeTestState()
{
    
}

void MazeTestState::update_specific(btScalar deltaTimeStep)
{
//    btVector3 cameraMinimumUpOffset(pPlayer->getUpVector() * 10.0f);
//    
//    btVector3 cameraUpOffset(pPlayer->getLinearSpeed() * pPlayer->getUpVector());
//    btVector3 cameraHeadingOffset(pPlayer->getLinearSpeed() * pPlayer->getLinearVelocityHeading());
//    
//    btVector3 cameraPosition;
//    //cameraPosition -= cameraHeadingOffset;
//    //cameraPosition += cameraMinimumUpOffset;
//    
//    cameraPosition.setX(pPlayer->getOrigin().x());
//    cameraPosition.setY(pPlayer->getOrigin().y() + 100.0f);
//    cameraPosition.setZ(pPlayer->getOrigin().z() - 10.0f);
//    
//    
//    btVector3 cameraLookAtPosition(pPlayer->getOrigin());
//    
////    cameraLookAtPosition.setZ(cameraLookAtPosition.z() +
////                              (pPlayer->getLinearVelocityHeading().z() * pPlayer->getLinearSpeed()));
//    //cameraLookAtPosition += cameraHeadingOffset;
//    
//    
//    
//    
//    pCamera->lookAt(cameraLookAtPosition);
//    pCamera->setOrigin(cameraPosition);
//    //pCamera->getSteeringBehavior()->setArriveOn(playerPosition);
//    //pCamera->getSteeringBehavior()->setSeekOn(pPlayer->getOrigin() + m_CameraOffset);
    
    
}
void MazeTestState::enter_specific()
{
//    MazeCreator::createInstance();
//    
//    unsigned int row_count =s_BoardSize;
//    unsigned int column_count = s_BoardSize;
//    MazeRenderType type = MazeRenderType_Mesh;
//    
//    
//    time_t rawtime;
//    struct tm * ptm;
//    
//    time ( &rawtime );
//    
//    ptm = gmtime ( &rawtime );
//    
//    unsigned int seed = ptm->tm_year + ptm->tm_yday;
//    
//    //m_TranslatedEntities->clear();
//    
//    MeshMazeCreator *pMazeHTML = dynamic_cast<MeshMazeCreator*>(MazeCreator::getInstance()->CreateNew(row_count, column_count, type, seed));
//    
//    pMazeHTML->SolveMaze();
//    pMazeHTML->DrawMaze(btVector3(0, 0, 0));
//    
//    createPlayer();
//    
//    
//    unsigned int row, column;
//    
//    pMazeHTML->getBeginningCoord(row, column);
//    btVector3 origin(pMazeHTML->getOriginOfTile(row, column));
//    
//    btVector3 aabbMin, aabbMax;
//    pPlayer->getRigidBody()->getCollisionShape()->getAabb(btTransform::getIdentity(), aabbMin, aabbMax);
//    origin.setY(origin.y() + aabbMax.y() + 2.0f);
//    pPlayer->setOrigin(origin);
//    //pPlayer->hide();
//    
//    
//    
//    ShaderFactoryKey key(VERTEX_SHADER, FRAGMENT_SHADER);
//    
//    pMazeHTML->getEndCoord(row, column);
//    btVector3 ghostOrigin(pMazeHTML->getOriginOfTile(row, column));
//    
//    ghostOrigin.setY(0.0f);
//    btTransform startTransform(btQuaternion::getIdentity(), ghostOrigin);
//    btVector3 halfExtends(5.0f, 5.0f, 5.0f);
//    pGhostEntity = createGhostEntity(key, halfExtends, startTransform, CollisionShapeType_Cube);
//    
//    delete pMazeHTML;
//    
//    MazeCreator::destroyInstance();
//    
//    createCamera();
//    //pCamera->hide();
//    
//    m_CameraOffset = btVector3(-10.0f, 45.0f, -60.0f);
//    
//    pCamera->setOrigin(pPlayer->getOrigin() + m_CameraOffset);
//    //pCamera->getSteeringBehavior()->setSeekOn(pPlayer->getOrigin() + m_CameraOffset);
//    pCamera->setMaxLinearForce(100.0f);
//    pCamera->setMaxLinearSpeed(100.0f);
//    pCamera->hide();
//    
//    RigidEntity *pEntity = createPhysicsEntity(key, ViewObjectType_Skybox, CollisionShapeType_NONE, 0.0f);
//    pEntity->setOrigin(btVector3(0,0,0));
}
void MazeTestState::exit_specific()
{
//    s_BoardSize++;
}

//void MazeTestState::touchesBegan()
//{
////    m_TouchStart = getPlayerControlTouchPosition();
////    m_TouchStartTime = FrameCounter::getInstance()->getCurrentTime();
//}
//void MazeTestState::touchesMoved()
//{
////    btVector3 end(getPlayerControlTouchPosition());
////    btScalar endTime(FrameCounter::getInstance()->getCurrentTime());
////    float timeInterval = endTime - m_TouchStartTime;
////    
////    static btScalar impulseConstant = 500.0f;
////    
////    btVector3 impulseVector(end - m_TouchStart);
////    impulseVector.normalize();
////    
////    m_TouchStart = end;
////    m_TouchStartTime = FrameCounter::getInstance()->getCurrentTime();
////    
////    btMatrix3x3 _btMatrix3x3(CameraFactory::getInstance()->getCurrentCamera()->getRotation().inverse());
////    
////    impulseVector = -impulseVector * _btMatrix3x3;
////    
////    impulseVector.setY(0.0f);
////    impulseVector.normalize();
////    
////    btScalar impulseMagnitude(impulseConstant * timeInterval);
////    btVector3 impulse(impulseVector * impulseMagnitude);
////    
////    pPlayer->getRigidBody()->applyCentralImpulse(impulse);
////    
//////    btScalar temp(impulse.x());
//////    impulse.setX(impulse.z());
//////    impulse.setZ(temp);
//////    
//////    pPlayer->getRigidBody()->applyTorqueImpulse(impulse);
//}
//void MazeTestState::touchesEnded()
//{
//    
//}
//void MazeTestState::touchesCancelled()
//{
//    
//}

void MazeTestState::createCamera()
{
//    CameraSteeringEntityInfo _CameraSteeringEntityInfo;
//    ViewObjectInfo viewConstructionInfo;
//    
//    viewConstructionInfo.m_ViewObjectType = ViewObjectType_Icosphere;
//    viewConstructionInfo.m_CollisionShapeType = CollisionShapeType_Sphere;
//    
//    ShaderFactoryKey shaderKey(VERTEX_SHADER, FRAGMENT_SHADER);
//    
//    IDType ID;
//    ShaderFactory::getInstance()->create(&shaderKey, ID);
//    viewConstructionInfo.m_programHandle = *ShaderFactory::getInstance()->get(ID);
//    
//    //BaseViewObject *pVBO = ViewObjectFactory::getInstance()->createObject(&viewConstructionInfo);
//    
//    //    btTransform _btTransform = btTransform::getIdentity();
//    //    _btTransform.setOrigin(btVector3(0.0f, 10.0f, -40.0f));
//    //    pVBO->setInitialTransform(_btTransform);
//    
//    _CameraSteeringEntityInfo.m_ViewInfo = viewConstructionInfo;
//    _CameraSteeringEntityInfo.m_smType = StateMachineTypes_NONE;
//    _CameraSteeringEntityInfo.m_acType = AnimationControllerTypes_NONE;
//    _CameraSteeringEntityInfo.m_mass = 1000.0f;
//    _CameraSteeringEntityInfo.m_sbType = SteeringBehaviorTypes_Weighted;
//    
//    _CameraSteeringEntityInfo.m_CameraType = CameraTypes_SteeringEntity;
//    
//    pCamera = dynamic_cast<CameraSteeringEntity*>(CameraFactory::getInstance()->createObject(&_CameraSteeringEntityInfo));
//    
//    CameraFactory::getInstance()->setCurrentCamera(pCamera);
//    
//    
//    pCamera->getRigidBody()->setRestitution(0.0f);
//    
//    pCamera->getRigidBody()->setActivationState(DISABLE_DEACTIVATION);
//    
//    pCamera->getRigidBody()->setLinearFactor(btVector3(1.0f, 0.0f, 1.0f));
//    pCamera->hide();
}

btVector3 MazeTestState::getPlayerControlTouchPosition()const
{
//    Touch _touch;
//    PlayerInput::getInstance()->getTouchByIndex(0, _touch);
//    
//    btVector3 touch(_touch.getX(), _touch.getY(), 0.0f);
//    touch.setX(-touch.x());
//    touch.setZ(touch.y());
//    touch.setY(0.0f);
//    return touch;
}

//btVector3 MazeTestState::getPlayerLinearImpulseFromInput(const btVector3 &end)const
//{
//    btVector3 vTouchHeading(end - m_TouchStart);
//    vTouchHeading.normalize();
//    
//    return vTouchHeading;
//}

void MazeTestState::createPlayer()
{
//    ShaderFactoryKey key(VERTEX_SHADER, FRAGMENT_SHADER);
//    
//    pPlayer = createPhysicsEntity(key, ViewObjectType_Sphere, CollisionShapeType_Sphere, 10);
//    
//    //pPlayer->getSteeringBehavior();
//    //pPlayer->setMaxLinearSpeed(10.0f);
//    //pPlayer->setMaxLinearForce(10.0f);
//    
//    
//    //pPlayer->getSteeringBehavior()->setLinearFactor(btVector3(1.0f, 0.0f, 1.0f));
//    
//    //pPlayer->getRigidBody()->setLinearFactor(btVector3(1.0f, 0.0f, 1.0f));
//    
//    pPlayer->getRigidBody()->setActivationState(DISABLE_DEACTIVATION);
//    
//    pPlayer->getRigidBody()->setRestitution(0.0f);
    
}
