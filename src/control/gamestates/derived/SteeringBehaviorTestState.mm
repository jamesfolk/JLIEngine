//
//  SteeringBehaviorTestState.mm
//  GameAsteroids
//
//  Created by James Folk on 4/2/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "SteeringBehaviorTestState.h"

//DiffuseRimLighting

#include "CameraPhysicsEntity.h"
#include "UtilityFunctions.h"
#include "GameStateMachine.h"
//#include "PlayerInput.h"
#include "SteeringEntity.h"
#include "CameraFactory.h"
#include "CameraSteeringEntity.h"
#include "CameraEntity.h"
#include "EntityFactory.h"
#include "SteeringEntity.h"
#include "SteeringBehaviorFactory.h"

SteeringBehaviorTestState::SteeringBehaviorTestState()
{
    
}

SteeringBehaviorTestState::~SteeringBehaviorTestState()
{
    
}

void SteeringBehaviorTestState::update_specific(btScalar deltaTimeStep)
{
    getCamera()->lookAt(btVector3(0,0,0));
    
//    m_Rotate += (deltaTimeStep * 0.5);
//    if(m_Rotate > DEGREES_TO_RADIANS(360))
//        m_Rotate = 0;
//    
//    //pCameraSteeringEntity->lookAt(pCameraSteeringEntity->getOrigin() + pCameraSteeringEntity->getHeadingVector());
//    pCameraSteeringEntity->setOrigin(btVector3(0.0f, 30.0f, 40.0f));
//    pCameraSteeringEntity->lookAt(pCurrentFocus->getOrigin());
//    
//    btVector3 at = CameraFactory::getInstance()->getCurrentCamera()->getHeadingVector();
//    btVector3 up = CameraFactory::getInstance()->getCurrentCamera()->getUpVector();
//    btVector3 side = CameraFactory::getInstance()->getCurrentCamera()->getSideVector();
//    btVector3 origin = CameraFactory::getInstance()->getCurrentCamera()->getOrigin();
//    
////    NSLog(@"\npos: %f, %f, %f\n", origin.getX(), origin.getY(), origin.getZ());
////    NSLog(@"\nheading: %f, %f, %f\nup: %f, %f, %f\nside: %f, %f, %f\n",
////          at.getX(), at.getY(), at.getZ(),
////          up.getX(), up.getY(), up.getZ(),
////          side.getX(), side.getY(), side.getZ());
////    NSLog(@"\nforward.up = %f\nforward.side = %f\nside.up = %f\nside.forward = %f\nup.side = %f\nup.at = %f\n\n",
////          RADIANS_TO_DEGREES(at.angle(up)),
////          RADIANS_TO_DEGREES(at.angle(side)),
////          RADIANS_TO_DEGREES(side.angle(up)),
////          RADIANS_TO_DEGREES(side.angle(at)),
////          RADIANS_TO_DEGREES(up.angle(side)),
////          RADIANS_TO_DEGREES(up.angle(at)));
//    
//    //if(PlayerInput::getInstance()->getNumTouches() == 1)
//    {
//        //if(PlayerInput::getInstance()->getTouch(0).m_type == TouchType_Begin)
//        {
//            //GameStateMachine::getInstance()->changeState(this);
//            
//            //pCurrentWanderer = createWanderEntity();
//            
//            //createPursuitEntity(pCurrentWanderer);
//            //createEvadeEntity(pCurrentWanderer);
//            
////            ShaderFactoryKey key(VERTEX_SHADER, FRAGMENT_SHADER);
////            
////            sphere = createSteeringEntity(key, ViewObjectType_Icosphere, CollisionShapeType_Sphere,100.0f);
////            sphere->setOrigin(btVector3(0, 40, 0));
////            
////            sphere->setMaxLinearSpeed(1000.0f);
////            sphere->setMaxLinearForce(1000.0f);
////            
////            sphere->getSteeringBehavior()->setWanderOn();
////            
//            //m_CurrentBox->setRotation(btQuaternion(DEGREES_TO_RADIANS(0.0f), DEGREES_TO_RADIANS(0.0f), DEGREES_TO_RADIANS(0.0f)));
//            
//        }
//    }
}
void SteeringBehaviorTestState::enter_specific()
{
    m_pCameraEntity = createCamera();
    
    CameraFactory::getInstance()->setCurrentCamera(getCamera());
    getCamera()->setOrigin(btVector3(0, 30, 40.0f));
    getCamera()->hide();
    
    //createBox(&m_Walls);
    for(int i = 0; i < m_Walls.size(); i++)
    {
        getBoxWall(i)->enableDebugDraw(false);
    }
    
}
void SteeringBehaviorTestState::exit_specific()
{
    
}

SteeringEntity *SteeringBehaviorTestState::createWanderEntity()
{
    SteeringBehaviorInfo *scInfo = new SteeringBehaviorInfo();
    IDType steeringBehaviorID = SteeringBehaviorFactory::getInstance()->create(scInfo);
    delete scInfo;
    
    SteeringEntityInfo *cInfo = new SteeringEntityInfo(m_mesh_icosphere,
                                                       0,
                                                       0,
                                                       false,
                                                       m_shape_sphere,
                                                       randomScalarInRange(10.0f, 100.0f),
                                                       steeringBehaviorID);
    SteeringEntity *pSteeringEntity = EntityFactory::createEntity<SteeringEntity, SteeringEntityInfo>(cInfo);
    delete cInfo;
    
    pSteeringEntity->setOrigin(btVector3(0, 10, 0));
    //pSteeringEntity->getRigidBody()->applyCentralImpulse(btVector3(-5, 0, -5));
    pSteeringEntity->setMaxLinearSpeed(1.0f);
    pSteeringEntity->setMaxLinearForce(1.0f);
//    pSteeringEntity->getSteeringBehavior()->setWanderOn();
    pSteeringEntity->getWanderInfo()->setJitter(randomScalarInRange(1.0f, 100.0f));
    pSteeringEntity->getWanderInfo()->setRadius(10.5f);
    pSteeringEntity->getWanderInfo()->setDistance(randomScalarInRange(1.0f, 10.0f));
    pSteeringEntity->getSteeringBehavior()->setLinearFactor(btVector3(1.0f, 0.0f, 1.0f));
    pSteeringEntity->getRigidBody()->setFriction(1.0f);
    pSteeringEntity->getRigidBody()->setRestitution(0.9f);
    
    m_WanderEntities.push_back(pSteeringEntity);
    
    return pSteeringEntity;
}

SteeringEntity *SteeringBehaviorTestState::createPursuitEntity(SteeringEntity *prey)
{
//    ShaderFactoryKey key(VERTEX_SHADER, FRAGMENT_SHADER);
//    
//    SteeringEntity *s = createSteeringEntity(key, ViewObjectType_Cylinder, CollisionShapeType_Sphere, 100);
//    s->setOrigin(btVector3(0, 10, 0));
//    s->setMaxLinearSpeed(10.0f);
//    //s->setMaxLinearForce(10.0f);
//    s->getSteeringBehavior()->setPursuitOn(prey);
//    
//    
//    s->getSteeringBehavior()->setLinearFactor(btVector3(1.0f, 0.0f, 1.0f));
//    
//    s->getRigidBody()->setFriction(0.0f);
//    s->getRigidBody()->setRestitution(0.0f);
//    
//    m_PursuitEntities.push_back(s);
//    return s;
}

SteeringEntity *SteeringBehaviorTestState::createEvadeEntity(SteeringEntity *predator)
{
//    ShaderFactoryKey key(VERTEX_SHADER, FRAGMENT_SHADER);
//    
//    SteeringEntity *s = createSteeringEntity(key, ViewObjectType_Icosphere, CollisionShapeType_Sphere, 100);
//    s->setOrigin(btVector3(0, 10, 0));
//    s->setMaxLinearSpeed(10.0f);
//    //s->setMaxLinearForce(10.0f);
//    s->getSteeringBehavior()->setEvadeOn(predator);
//    
//    
//    s->getSteeringBehavior()->setLinearFactor(btVector3(1.0f, 0.0f, 1.0f));
//    
//    s->getRigidBody()->setFriction(0.0f);
//    s->getRigidBody()->setRestitution(0.0f);
//    
//    m_EvadeEntities.push_back(s);
//    return s;
    
}


//void SteeringBehaviorTestState::touchesBegan()
//{
//    createWanderEntity();
////    Touch touch;
////    for(int i = 0; i < PlayerInput::getInstance()->getNumTouches(); i++)
////    {
////        PlayerInput::getInstance()->getTouchByIndex(i, touch);
////        touch.printDebug();
////    }
//}
//void SteeringBehaviorTestState::touchesMoved()
//{
////    Touch touch;
////    for(int i = 0; i < PlayerInput::getInstance()->getNumTouches(); i++)
////    {
////        PlayerInput::getInstance()->getTouchByIndex(i, touch);
////        touch.printDebug();
////    }
//}
//void SteeringBehaviorTestState::touchesEnded()
//{
////    Touch touch;
////    for(int i = 0; i < PlayerInput::getInstance()->getNumTouches(); i++)
////    {
////        PlayerInput::getInstance()->getTouchByIndex(i, touch);
////        touch.printDebug();
////    }
//}
//void SteeringBehaviorTestState::touchesCancelled()
//{
////    Touch touch;
////    for(int i = 0; i < PlayerInput::getInstance()->getNumTouches(); i++)
////    {
////        PlayerInput::getInstance()->getTouchByIndex(i, touch);
////        touch.printDebug();
////    }
//}

CameraEntity *SteeringBehaviorTestState::getCamera()
{
    return m_pCameraEntity;
}
RigidEntity *SteeringBehaviorTestState::getBoxWall(size_t index)
{
    if(index < m_Walls.size())
        return m_Walls.at(index);
    return NULL;
}
