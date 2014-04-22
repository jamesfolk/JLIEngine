//
//  MazeGameState_Play.cpp
//  MazeADay
//
//  Created by James Folk on 11/15/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "MazeGameState_Play.h"
#include "MazeGameState.h"
#include "FrameCounter.h"
#include "btMatrix3x3.h"
#include "CameraFactory.h"
#include "RigidEntity.h"
#include "MeshMazeCreator.h"
#include "CameraSteeringEntity.h"
#include "Path.h"
#include "MazeMiniMapFBO.h"

MazeGameState_Play::MazeGameState_Play():
m_TouchStartTime(0),
m_InitalizeTouch(false),
m_TouchStart(new btVector3(0,0,0)),

m_ImpulseContant(100000.0f),
m_MaxTouchDistance(40.0)
{
    
}
MazeGameState_Play::~MazeGameState_Play()
{
    delete m_TouchStart;
    m_TouchStart = NULL;
}

void MazeGameState_Play::enter(void*)
{
    if(MazeGameState::getMazeMiniMapSprite())
        MazeGameState::getMazeMiniMapSprite()->show();
    
    if(MazeGameState::getMazeMeshCreator() &&
       MazeGameState::getMazeMeshCreator()->getMaze())
        MazeGameState::getMazeMeshCreator()->getMaze()->show();
    
    if(MazeGameState::getGamePlayer())
        MazeGameState::getGamePlayer()->show();
    
    if(MazeGameState::getGameGoal())
        MazeGameState::getGameGoal()->show();
}
void MazeGameState_Play::update(void*, btScalar deltaTimeStep)
{
    MazeGameState::lookAtPlayerCenter();
    
    if(isPaused())
        return;
}
void MazeGameState_Play::render()
{
    
}
void MazeGameState_Play::exit(void*)
{
    
}
bool MazeGameState_Play::onMessage(void*, const Telegram&)
{
    
}

void MazeGameState_Play::touchRespond(const DeviceTouch &touch)
{
    if(isPaused())
        return;
    switch (touch.getTouchPhase())
    {
        case DeviceTouchPhaseBegan:
        {
            *m_TouchStart = getPlayerControlTouchPosition(touch);
            m_TouchStartTime = FrameCounter::getInstance()->getCurrentTime();
            m_InitalizeTouch = true;
        }
            break;
        case DeviceTouchPhaseMoved:
        {
            if(m_InitalizeTouch)
            {
                applyAngularForceOnPlayer(touch);
            }
            else
            {
                *m_TouchStart = getPlayerControlTouchPosition(touch);
                m_TouchStartTime = FrameCounter::getInstance()->getCurrentTime();
                
                m_InitalizeTouch = true;
            }
        }
            break;
    
        case DeviceTouchPhaseEnded:
        case DeviceTouchPhaseCancelled:
            break;
        default:
            break;
    }
}

void MazeGameState_Play::pinchGestureRespond(const DevicePinchGesture &input)
{
}

void MazeGameState_Play::gyroRespond(const DeviceGyro &input)
{
}

void MazeGameState_Play::motionRespond(const DeviceMotion &input)
{
    if(isPaused())
        return;
    
    btScalar magnitude = 2000.f;
    
    applyTorqueToPlayer(btVector3(input.getAttitude().getRoll(), 0.0f, input.getAttitude().getPitch()).normalized() * -magnitude);
}

btVector3 MazeGameState_Play::getPlayerControlTouchPosition(const DeviceTouch &touch)const
{
    btVector3 _touch(touch.getPosition().x(), touch.getPosition().y(), 0.0f);
    
    _touch.setX(-_touch.x());
    _touch.setZ(_touch.y());
    _touch.setY(0.0f);
    
    return _touch;
}
btScalar MazeGameState_Play::getPlayerControlTouchDistance(const DeviceTouch &touch)const
{
    btVector3 _touch(touch.getPosition().x() - touch.getPreviousPosition().x(),
                     touch.getPosition().y() - touch.getPreviousPosition().y(),
                     0.0f);
    
    _touch.setX(-_touch.x());
    _touch.setZ(_touch.y());
    _touch.setY(0.0f);
    
    return _touch.length();
}
void MazeGameState_Play::applyAngularForceOnPlayer(const DeviceTouch &touch)
{
    btVector3 end(getPlayerControlTouchPosition(touch));
    btScalar dist(getPlayerControlTouchDistance(touch));
    btScalar endTime(FrameCounter::getInstance()->getCurrentTime());
    float timeInterval = endTime - m_TouchStartTime;


    if(dist > m_MaxTouchDistance)
    dist = m_MaxTouchDistance;
    btScalar scale = dist / m_MaxTouchDistance;

    btScalar impulseConstant = m_ImpulseContant * scale;//

    btVector3 forwardVector(end - *m_TouchStart);
    forwardVector.normalize();
    btVector3 touchVector(forwardVector);

    *m_TouchStart = end;
    m_TouchStartTime = FrameCounter::getInstance()->getCurrentTime();

    btMatrix3x3 _btMatrix3x3(CameraFactory::getInstance()->getCurrentCamera()->getRotation().inverse());

    forwardVector = -forwardVector * _btMatrix3x3;

    forwardVector.setY(0.0f);
    forwardVector.normalize();

    btVector3 sideVector(forwardVector.cross(MazeGameState::getGamePlayer()->getUpVector()));

    btScalar impulseMagnitude(impulseConstant * timeInterval);

    btVector3 test(touchVector.z() * impulseMagnitude, 0.0f, -touchVector.x() * impulseMagnitude);

    //NSLog(@"%f\n", test.length());
    applyTorqueToPlayer(test);
}

void MazeGameState_Play::applyTorqueToPlayer(const btVector3 &torque)
{
    if(!torque.isZero())
    {
        if(MazeGameState::getCurrentStopWatch()->isStopped())
        {
            MazeGameState::getCurrentStopWatch()->start();
        }

        MazeGameState::getGamePlayer()->getRigidBody()->applyTorqueImpulse(torque);
    }
}
