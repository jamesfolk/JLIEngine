//
//  SkyboxTestState.cpp
//  MazeADay
//
//  Created by James Folk on 12/22/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "SkyboxTestState.h"
#include "EntityFactory.h"
#include "CameraEntity.h"
#include "RigidEntity.h"
#include "UtilityFunctions.h"

SkyboxTestState::SkyboxTestState(){}
SkyboxTestState::~SkyboxTestState(){}


void SkyboxTestState::update_specific(btScalar deltaTimeStep)
{
    
}

void SkyboxTestState::enter_specific()
{
    m_pCameraEntity = createCamera();
    
    CameraFactory::getInstance()->setCurrentCamera(getCamera());
    getCamera()->setOrigin(btVector3(0, 0, 0.0f));
    getCamera()->hide();
    
    m_pSkybox = createBox();
//    m_pPlane = createPlane();
//    getPlane()->setKinematicPhysics();
//    getPlane()->setOrigin(btVector3(0.f, 0.f, 0.f));
//    getPlane()->show();
    
    //getCamera()->lookAt(getPlane()->getOrigin());
}

void SkyboxTestState::exit_specific()
{
    
}

void SkyboxTestState::render_specific()
{
    
}

void SkyboxTestState::touchRespond(const DeviceTouch &input){}
void SkyboxTestState::tapGestureRespond(const DeviceTapGesture &input){}
void SkyboxTestState::pinchGestureRespond(const DevicePinchGesture &input){}
void SkyboxTestState::panGestureRespond(const DevicePanGesture &input){}
void SkyboxTestState::swipeGestureRespond(const DeviceSwipeGesture &input){}
void SkyboxTestState::rotationGestureRespond(const DeviceRotationGesture &input){}
void SkyboxTestState::longPressGestureRespond(const DeviceLongPressGesture &input){}
void SkyboxTestState::accelerometerRespond(const DeviceAccelerometer &input){}
void SkyboxTestState::motionRespond(const DeviceMotion &input)
{
    float y = input.getAttitude().getYaw();
    float p = input.getAttitude().getPitch();
    float r = input.getAttitude().getRoll();
    
    btQuaternion roll(-g_vPitchAxis, r);
    btQuaternion pitch(-g_vYawAxis, p);
    btQuaternion yaw(-g_vRollAxis, y);
    
    getCamera()->setRotation(yaw * pitch * roll);
}
void SkyboxTestState::gyroRespond(const DeviceGyro &input){}
void SkyboxTestState::magnetometerRespond(const DeviceMagnetometer &input){}

CameraEntity *SkyboxTestState::getCamera()
{
    return m_pCameraEntity;
}
RigidEntity *SkyboxTestState::getSkybox()
{
    return m_pSkybox;
}
