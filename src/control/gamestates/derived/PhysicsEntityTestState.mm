//
//  PhysicsEntityTestState.cpp
//  GameAsteroids
//
//  Created by James Folk on 3/21/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "PhysicsEntityTestState.h"


#include "RigidEntity.h"

//#include "ViewObjectFactory.h"
#include "BaseViewObject.h"
//#include "ViewObjectTypes.h"

#include "CameraFactory.h"
#include "CameraPhysicsEntity.h"
#include "CameraEntity.h"

#include "WorldPhysics.h"
#include "ShaderFactory.h"
#include "TextureFactory.h"
#include "CollisionShapeFactory.h"
#include "AnimationControllerFactory.h"
#include "SteeringBehaviorFactory.h"
#include "EntityStateMachineFactory.h"
#include "FrameCounter.h"
//#include "PlayerInput.h"

#include "GameStateMachine.h"


#include "CameraSteeringEntity.h"
#include "RigidEntity.h"
#include "EntityFactory.h"

PhysicsEntityTestState::PhysicsEntityTestState() :
m_pCameraEntity(NULL),
m_pPlane(NULL)

{
    
}

PhysicsEntityTestState::~PhysicsEntityTestState()
{
    
}
void PhysicsEntityTestState::render_specific()
{
    
}
void PhysicsEntityTestState::update_specific(btScalar deltaTimeStep)
{
//    if(m_Entities.size() > 0)
//    {
//        getCamera()->lookAt(getCurrentEntity()->getOrigin());
//    }
//    else
//    {
//        getCamera()->lookAt(getPlane()->getOrigin());
//    }

    getCamera()->lookAt(getPlane()->getOrigin());
    
}
void PhysicsEntityTestState::enter_specific()
{
    
    
    m_pCameraEntity = createCamera();
    
    CameraFactory::getInstance()->setCurrentCamera(getCamera());
    getCamera()->setOrigin(btVector3(0, 20, 20.0f));
    getCamera()->hide();
    
    m_pPlane = createPlane();
    getPlane()->setKinematicPhysics();
    getPlane()->setOrigin(btVector3(0.f, 0.f, 0.f));
//    getPlane()->setRotation(btQuaternion(DEGREES_TO_RADIANS(0.0f),
//                                         DEGREES_TO_RADIANS(180.0f),
//                                         DEGREES_TO_RADIANS(0.0f)));
    getPlane()->show();
}
void PhysicsEntityTestState::exit_specific()
{
    
}

//void PhysicsEntityTestState::touchesBegan()
//{
//    createDynamicEntity();
//}
//void PhysicsEntityTestState::touchesMoved()
//{
////    Touch touch;
////    for(int i = 0; i < PlayerInput::getInstance()->getNumTouches(); i++)
////    {
////        PlayerInput::getInstance()->getTouchByIndex(i, touch);
////        touch.printDebug();
////    }
//}
//void PhysicsEntityTestState::touchesEnded()
//{
////    Touch touch;
////    for(int i = 0; i < PlayerInput::getInstance()->getNumTouches(); i++)
////    {
////        PlayerInput::getInstance()->getTouchByIndex(i, touch);
////        touch.printDebug();
////    }
//}
//void PhysicsEntityTestState::touchesCancelled()
//{
////    Touch touch;
////    for(int i = 0; i < PlayerInput::getInstance()->getNumTouches(); i++)
////    {
////        PlayerInput::getInstance()->getTouchByIndex(i, touch);
////        touch.printDebug();
////    }
//}


void PhysicsEntityTestState::createDynamicEntity()
{
    RigidEntityInfo *cInfo = NULL;
    
    switch (randomIntegerRange(0, 4))
    {
        case 0:
            cInfo = new RigidEntityInfo(m_mesh_cone, 0, 0, false, m_shape_cone, 1);
            break;
        case 1:
            cInfo = new RigidEntityInfo(m_mesh_cube, 0, 0, false, m_shape_cube, 1);
            break;
        case 2:
            cInfo = new RigidEntityInfo(m_mesh_cylinder, 0, 0, false, m_shape_cylinder, 1);
            break;
        case 3:default:
            cInfo = new RigidEntityInfo(m_mesh_icosphere, 0, 0, false, m_shape_sphere, 1);
            break;
        case 4:cInfo = new RigidEntityInfo(m_mesh_sphere, 0, 0, false, m_shape_sphere, 1);break;
    }
    
    RigidEntity *p = EntityFactory::createEntity<RigidEntity, RigidEntityInfo>(cInfo);
    delete cInfo;
    
    p->setOrigin(btVector3(randomScalarInRange(-1.0f, 1.0f), 5.0f, randomScalarInRange(-1.0f, 1.0f)));
    
    m_Entities.push_back(p->getID());
    
    
}

CameraEntity *PhysicsEntityTestState::getCamera()
{
    return m_pCameraEntity;
}
RigidEntity *PhysicsEntityTestState::getPlane()
{
    return m_pPlane;
}
RigidEntity *PhysicsEntityTestState::getCurrentEntity()
{
    if(m_Entities.size() > 0)
        return getEntity(m_Entities.size() - 1);
    return NULL;
}
RigidEntity *PhysicsEntityTestState::getEntity(size_t index)
{
    if(index < m_Entities.size())
        return EntityFactory::getEntity<RigidEntity>(m_Entities.at(index));
    return NULL;
}

