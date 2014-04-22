//
//  CameraAndControlTestState.mm
//  GameAsteroids
//
//  Created by James Folk on 4/12/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "CameraAndControlTestState.h"

#include "UtilityFunctions.h"

//#include "RigidEntity.h"
#include "SteeringEntity.h"

#include "CameraPhysicsEntity.h"
#include "CameraSteeringEntity.h"

//#include "ShaderFactoryIncludes.h"
//#include "CameraFactoryIncludes.h"
//#include "ViewObjectFactoryIncludes.h"

#include "ShaderFactory.h"
//#include "ViewObjectFactory.h"
#include "CameraFactory.h"
//#include "PlayerInput.h"
#include "EntityFactory.h"
#include "AbstractFactoryIncludes.h"

CameraAndControlTestState::CameraAndControlTestState() :
m_TouchStart(btVector3(0, 0, 0))
{
    
}

CameraAndControlTestState::~CameraAndControlTestState()
{
    
}

void CameraAndControlTestState::update_specific(btScalar deltaTimeStep)
{
//    btVector3 cameraLookAtPosition(pPlayer->getOrigin());
//    btVector3 cameraArrivePosition(pPlayer->getOrigin());
//    
//    btVector3 offset(pPlayer->getLinearVelocityHeading() * pPlayer->getLinearSpeed());
//    
//    //cameraLookAtPosition += (offset);
//    
//    cameraArrivePosition += (-offset);
//    cameraArrivePosition.setY(cameraArrivePosition.y() + 5.0f);
//    
//    //DebugString::log(DebugString::btVectorStr(cameraArrivePosition) + "\n");
//    
//    pCamera->lookAt(cameraLookAtPosition);
//    pCamera->getSteeringBehavior()->setArriveOn(cameraArrivePosition);
}
void CameraAndControlTestState::enter_specific()
{
//    btVector3 heading(g_vHeadingVector);
//    btScalar headings[360];
//    
//    for(int angle = 0; angle < 360; angle++)
//    {
//        headings[angle] = btDegrees(heading.angle(g_vHeadingVector));
//        heading = g_vHeadingVector.rotate(g_vUpVector, btRadians(angle));
//    }
//    
//    ShaderFactoryKey key(VERTEX_SHADER, FRAGMENT_SHADER);
//    
//    RigidEntity *plane = NULL;
//    
//    //floor
//    plane = createPhysicsEntity(key, Mesh::ViewObjectType_Plane, CollisionShapeType_ConvexHull, 0.0f);
//    plane->setOrigin(btVector3(0, 0, 0));
//    plane->setRotation(btQuaternion(DEGREES_TO_RADIANS(0.0f), DEGREES_TO_RADIANS(0.0f), DEGREES_TO_RADIANS(0.0f)));
//    
//    //ceiling
////    plane = createPhysicsEntity(key, Mesh::ViewObjectType_Plane, CollisionShapeType_ConvexHull, 0.0f);
////    plane->setOrigin(btVector3(0, 80, 0));
////    plane->setRotation(btQuaternion(DEGREES_TO_RADIANS(0.0f), DEGREES_TO_RADIANS(180.0f), DEGREES_TO_RADIANS(0.0f)));
//    
//    
//    plane = createPhysicsEntity(key, Mesh::ViewObjectType_Plane, CollisionShapeType_ConvexHull, 0.0f);
//    plane->setOrigin(btVector3(0, 40, 40));
//    plane->setRotation(btQuaternion(DEGREES_TO_RADIANS(0.0f), DEGREES_TO_RADIANS(90.0f), DEGREES_TO_RADIANS(0.0f)));
//    
//    plane = createPhysicsEntity(key, Mesh::ViewObjectType_Plane, CollisionShapeType_ConvexHull, 0.0f);
//    plane->setOrigin(btVector3(0, 40, -40));
//    plane->setRotation(btQuaternion(DEGREES_TO_RADIANS(0.0f), DEGREES_TO_RADIANS(-90.0f), DEGREES_TO_RADIANS(0.0f)));
//    
//    
//    plane = createPhysicsEntity(key, Mesh::ViewObjectType_Plane, CollisionShapeType_ConvexHull, 0.0f);
//    plane->setOrigin(btVector3(40, 40, 0));
//    plane->setRotation(btQuaternion(DEGREES_TO_RADIANS(0.0f), DEGREES_TO_RADIANS(0.0f), DEGREES_TO_RADIANS(90.0f)));
//    
//    plane = createPhysicsEntity(key, Mesh::ViewObjectType_Plane, CollisionShapeType_ConvexHull, 0.0f);
//    plane->setOrigin(btVector3(-40, 40, 0));
//    plane->setRotation(btQuaternion(DEGREES_TO_RADIANS(0.0f), DEGREES_TO_RADIANS(0.0f), DEGREES_TO_RADIANS(-90.0f)));
//    
//    createCamera();
//    createPlayer();
    
    
}
void CameraAndControlTestState::exit_specific()
{
    
}

void CameraAndControlTestState::createPlayer()
{
//    ShaderFactoryKey key(VERTEX_SHADER, FRAGMENT_SHADER);
//    
//    pPlayer = createPhysicsEntity(key, Mesh::ViewObjectType_Sphere, CollisionShapeType_Sphere, 10);
//    pPlayer->setOrigin(btVector3(0, 10, 0));
//    
//    pPlayer->getRigidBody()->setRestitution(0.0f);
//    
//    pPlayer->getRigidBody()->setActivationState(DISABLE_DEACTIVATION);
//    
//    IDType _id = pPlayer->getID();
//    pPlayer = NULL;
//    
//    pPlayer = dynamic_cast<RigidEntity*>(EntityFactory::getInstance()->getEntity(_id)) ;
}
void CameraAndControlTestState::createCamera()
{
//    CameraSteeringEntityInfo _CameraSteeringEntityInfo;
//    Mesh::ViewObjectInfo viewConstructionInfo;
//    
//    viewConstructionInfo.m_ViewObjectType = Mesh::ViewObjectType_Icosphere;
//    viewConstructionInfo.m_CollisionShapeType = CollisionShapeType_Sphere;
//    
//    ShaderFactoryKey shaderKey(VERTEX_SHADER, FRAGMENT_SHADER);
//    
//    IDType ID;
//    ShaderFactory::getInstance()->create(&shaderKey, ID);
//    viewConstructionInfo.m_programHandle = *ShaderFactory::getInstance()->get(ID);
//    
//    _CameraSteeringEntityInfo.m_ViewInfo = viewConstructionInfo;
//    _CameraSteeringEntityInfo.m_smType = StateMachineTypes_NONE;
//    _CameraSteeringEntityInfo.m_acType = AnimationControllerTypes_NONE;
//    _CameraSteeringEntityInfo.m_sbType  = SteeringBehaviorTypes_Weighted;
//    _CameraSteeringEntityInfo.m_mass = 10.0f;
//    
//    _CameraSteeringEntityInfo.m_CameraType = CameraTypes_SteeringEntity;
//    
//    pCamera = dynamic_cast<CameraSteeringEntity*>(CameraFactory::getInstance()->createObject(&_CameraSteeringEntityInfo));
//    
//    CameraFactory::getInstance()->setCurrentCamera(pCamera);
//    
//    pCamera->setOrigin(btVector3(0.0f, 15.0f, -38.0f));
//    //m_HoldPosition = false;
//    
//    
//    pCamera->getRigidBody()->setRestitution(0.0f);
//    
//    pCamera->setMaxLinearForce(100.0f);
//    pCamera->setMaxLinearSpeed(100.0f);
//    
//    pCamera->getRigidBody()->setGravity(btVector3(0, 0, 0));
//    
//    pCamera->hide();
    
}

btVector3 CameraAndControlTestState::getPlayerControlTouchPosition()const
{
//    Touch _touch;
//    PlayerInput::getInstance()->getTouchByIndex(0, _touch);
//    btVector3 touch(_touch.getX(), _touch.getY(), 0.0f);
//    touch.setX(-touch.x());
//    touch.setZ(touch.y());
//    touch.setY(0.0f);
//    return touch;
}

//void CameraAndControlTestState::touchesBegan()
//{
////    m_TouchStart = getPlayerControlTouchPosition();
////    m_TouchStartTime = FrameCounter::getInstance()->getCurrentTime();
//    
//}

//void CameraAndControlTestState::touchesMoved()
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
////    btScalar impulseMagnitude(impulseConstant * timeInterval);    
////    pPlayer->getRigidBody()->applyCentralImpulse(impulseVector * impulseMagnitude);
//}

//void CameraAndControlTestState::touchesEnded()
//{
//    
//}
//
//void CameraAndControlTestState::touchesCancelled()
//{
//}
