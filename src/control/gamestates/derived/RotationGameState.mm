//
//  RotationGameState.cpp
//  MazeADay
//
//  Created by James Folk on 1/27/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#include "RotationGameState.h"

#include "EntityFactory.h"
#include "CameraEntity.h"
#include "RigidEntity.h"
#include "UtilityFunctions.h"
#include "GLDebugDrawer.h"

RotationGameState::RotationGameState(){}
RotationGameState::~RotationGameState(){}


void RotationGameState::update_specific(btScalar deltaTimeStep)
{
    m_Rotate = (deltaTimeStep);
    if(m_Rotate > DEGREES_TO_RADIANS(360))
        m_Rotate = 0;
    
//    btQuaternion cam_rot(m_Rotate, 0, 0);
//    m_pCameraEntity->rotate(cam_rot, btVector3(0,0,0));
    
    
    
    for(int i = 0; i < m_Spheres.size(); i++)
    {
        //m_Spheres[i]->rotate(m_Rotations[i], m_Pivots[i]);
    }
}

void RotationGameState::enter_specific()
{
    m_Rotate = 0;
    
    m_pCameraEntity = createCamera();
    
    
    CameraFactory::getInstance()->setCurrentCamera(m_pCameraEntity);
    
    m_pCameraEntity->setOrigin(btVector3(50, 0, 50.0f));
    m_pCameraEntity->lookAt(btVector3(0,0,0));
    m_pCameraEntity->hide();
    

    btVector3 aabMin(btVector3(0,0,0)), aabMax(btVector3(0,0,0));
    
    
    RigidEntity *pRigidEntity = NULL;
    
    int count = 2;
    
    for (int i = 0; i < count; i++) {
        pRigidEntity = createSphere();
        pRigidEntity->setOrigin(aabMax * 5);
        m_Spheres.push_back(pRigidEntity);
        pRigidEntity->getRigidBody()->getAabb(aabMin, aabMax);
        
        //aabMax.setX(0);
        aabMax.setY(0);
        aabMax.setZ(0);
        
        m_Rotations.push_back(btQuaternion(0.07, 0, 0));
        m_Pivots.push_back(btVector3(6.f * i, 0, 0));
    }
    
    m_transitionQuaternion = btQuaternion::getIdentity();
    m_pCameraEntity->lookAt(btVector3(0,0,0));
}

void RotationGameState::exit_specific()
{
    
}

void RotationGameState::render_specific()
{
    btVector3 axis;
    for (int i = 0; i < m_Spheres.size(); i++)
    {
        axis = m_Rotations[i].getAxis();
        GLDebugDrawer::getInstance()->drawLine(m_Pivots[i] + (axis * -1000.0),
                                               m_Pivots[i] + (axis * 1000.0),
                                               btVector3(1,0,0));
    }
    
    WorldPhysics::getInstance()->debugDrawWorld();
}

void RotationGameState::touchRespond(const DeviceTouch &input){}
void RotationGameState::tapGestureRespond(const DeviceTapGesture &input){}
void RotationGameState::pinchGestureRespond(const DevicePinchGesture &input){}
void RotationGameState::panGestureRespond(const DevicePanGesture &input){}
void RotationGameState::swipeGestureRespond(const DeviceSwipeGesture &input){}
void RotationGameState::rotationGestureRespond(const DeviceRotationGesture &input){}
void RotationGameState::longPressGestureRespond(const DeviceLongPressGesture &input){}
void RotationGameState::accelerometerRespond(const DeviceAccelerometer &input){}
void RotationGameState::motionRespond(const DeviceMotion &input)
{
    //QInitial * QTransition = QFinal
    //QTransition = QFinal * QInitial^{-1}
    
    
    btQuaternion yaw(g_vYawAxis, input.getAttitude().getYaw());
    btQuaternion pitch(g_vPitchAxis, input.getAttitude().getPitch());
    btQuaternion roll(g_vRollAxis, input.getAttitude().getRoll());
    
    btQuaternion rotation = yaw;
    
    m_Spheres[1]->rotate(rotation * m_transitionQuaternion, btVector3(0,0,0));
    //m_pCameraEntity->rotate(rotation * m_transitionQuaternion, btVector3(0,0,0));
    
    m_transitionQuaternion = rotation.inverse();
}
void RotationGameState::gyroRespond(const DeviceGyro &input){}
void RotationGameState::magnetometerRespond(const DeviceMagnetometer &input){}
