//
//  PlayerInput.cpp
//  GameAsteroids
//
//  Created by James Folk on 3/21/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "PlayerInput.h"

#include "FrameCounter.h"

#import "SingletonSoundManager.h"
extern SingletonSoundManager *sharedSoundManager;


static const int MAX_TOUCHES = 10;

PlayerInput::PlayerInput() :
m_CurrentNumTouches(0),
m_AccelerometerValue(btVector3(0.0f, 0.0f, 0.0f)),
m_GyroValue(btQuaternion::getIdentity()),
m_GyroChange(btVector3(0.0f, 0.0f, 0.0f)),
m_YawPrev(0),
m_PitchPrev(0),
m_RollPrev(0),
m_PinchGesture(nil),
m_IsPinching(false),
m_PinchCurrentScale(1.0f),
m_PinchFailed(false),
m_LastPinchScale(1.0f)
{
    for(int i = 0; i < MAX_TOUCHES; ++i)
        m_TouchIndexMap.insert(btHashInt(i), new Touch());
}
PlayerInput::~PlayerInput()
{
    for(int i = 0; i < MAX_TOUCHES; ++i)
    {
        Touch **t = m_TouchIndexMap.find(i);
        delete *t;
    }
}

int PlayerInput::addTouch(UITouch *touch, float x, float y, unsigned int index, TouchType type)
{
    Touch **touchObject = m_TouchIndexMap.find(index);
    
    btAssert(*touchObject);
    
    //printf("dist touch %f, %f\n", x - (*touchObject)->m_x, y - (*touchObject)->m_y);
    //[touch locationInView:<#(UIView *)#>]
    
    (*touchObject)->m_dx = x - (*touchObject)->m_x;
    (*touchObject)->m_dy = y - (*touchObject)->m_y;
    
    (*touchObject)->m_x = x;
    (*touchObject)->m_y = y;
    
    (*touchObject)->m_timestamp_frame = FrameCounter::getInstance()->getCurrentTime();
    (*touchObject)->m_timestamp_soundtick = [sharedSoundManager getBGMCurrentTime];
    (*touchObject)->m_type = type;
    (*touchObject)->m_address = (int)touch;
    (*touchObject)->m_tapCount = [touch tapCount];
    (*touchObject)->m_touchPhase = [touch phase];
    
#if not defined(USING_ARC) || defined (_USING_ARC)
    m_TouchAddressMap.insert(btHashPtr((const void*)touch), (*touchObject));
#else
    m_TouchAddressMap.insert(btHashPtr((__bridge const void*)touch), (*touchObject));
#endif
    
    m_TouchIndexMap.insert(btHashInt(index), (*touchObject));
    
    return (*touchObject)->m_address;
}

int PlayerInput::touchBegin(UITouch *touch, float x, float y, unsigned int index)
{
    ++m_CurrentNumTouches;
   
    return addTouch(touch, x, y, index, TouchType_Begin);
}

int PlayerInput::touchMoved(UITouch *touch, float x, float y, unsigned int index)
{
    return addTouch(touch, x, y, index, TouchType_Moved);
}

int PlayerInput::touchEnded(UITouch *touch, float x, float y, unsigned int index)
{
    --m_CurrentNumTouches;
    
    return addTouch(touch, x, y, index, TouchType_Ended);
}

int PlayerInput::touchCancelled(UITouch *touch, float x, float y, unsigned int index)
{
    --m_CurrentNumTouches;
    
    return addTouch(touch, x, y, index, TouchType_Cancelled);
}

int PlayerInput::getNumTouches()const
{   
    return m_CurrentNumTouches;
}

bool PlayerInput::getTouchByAddress(const int address, Touch &touch)
{
    Touch **_touch = m_TouchAddressMap.find((void*)address);
    if(NULL == *_touch)
        return false;
    touch = **_touch;
    return true;
}
bool PlayerInput::getTouchByIndex(const unsigned int index, Touch &touch)
{
    Touch **_touch = m_TouchIndexMap.find(index);
    if(NULL == *_touch)
        return false;
    touch = **_touch;
    return true;
}

void PlayerInput::updateAccelerometer(double x, double y, double z)
{
    m_AccelerometerValue.setValue(x, y, z);
}

const btVector3 &PlayerInput::getAccelerometerValue()const
{
    return m_AccelerometerValue;
}

void PlayerInput::initGyro(double yaw, double pitch, double roll)
{
    m_GyroChange.setValue(0, 0, 0);
    
    m_YawPrev = yaw;
    m_PitchPrev = pitch;
    m_RollPrev = roll;
}

void PlayerInput::updateGyro(double yaw, double pitch, double roll)
{
    m_GyroChange.setValue(m_YawPrev - yaw, m_PitchPrev - pitch, m_RollPrev - roll);
    
    m_YawPrev = yaw;
    m_PitchPrev = pitch;
    m_RollPrev = roll;
    
    m_GyroValue.setEuler(yaw, pitch, roll);
}

const btQuaternion &PlayerInput::getGyroValue()const
{
    return m_GyroValue;
}

const btVector3 &PlayerInput::getGyroChangeValue()const
{
    return m_GyroChange;
}




void PlayerInput::updatePinchGesture(UIPinchGestureRecognizer *pinch)
{
    m_PinchCurrentScale += [pinch scale] - m_LastPinchScale;
    m_LastPinchScale = [pinch scale];
}
void PlayerInput::pinchGesturePossible(UIPinchGestureRecognizer *pinch)
{
    m_PinchFailed = false;
    
    updatePinchGesture(pinch);
}
void PlayerInput::pinchGestureBegan(UIPinchGestureRecognizer *pinch)
{
    m_PinchFailed = false;
    m_IsPinching = true;
    
    updatePinchGesture(pinch);
}
void PlayerInput::pinchGestureChanged(UIPinchGestureRecognizer *pinch)
{
    m_PinchFailed = false;
    m_IsPinching = true;
    
    updatePinchGesture(pinch);
}
void PlayerInput::pinchGestureEnded(UIPinchGestureRecognizer *pinch)
{
    m_PinchFailed = false;
    m_IsPinching = false;
    
    updatePinchGesture(pinch);
    m_LastPinchScale = 1.0f;
}
void PlayerInput::pinchGestureCancelled(UIPinchGestureRecognizer *pinch)
{
    m_PinchFailed = false;
    m_IsPinching = false;
    
    updatePinchGesture(pinch);
    m_LastPinchScale = 1.0f;
}
void PlayerInput::pinchGestureFailed(UIPinchGestureRecognizer *pinch)
{
    m_PinchFailed = true;
    m_IsPinching = false;
    
    updatePinchGesture(pinch);
    m_LastPinchScale = 1.0f;
}
bool PlayerInput::isPinchGesturing()const
{
    return m_IsPinching;
}
bool PlayerInput::isPinchGestureFailed()const
{
    return m_PinchFailed;
}

float PlayerInput::getPinchGestureCurrentScale()const
{
    return m_PinchCurrentScale;
}


const UIPinchGestureRecognizer*	PlayerInput::getPinchGestureRecognizer() const
{
    return m_PinchGesture;
}
UIPinchGestureRecognizer*	PlayerInput::getPinchGestureRecognizer()
{
    return m_PinchGesture;
}
void PlayerInput::setPinchGestureRecognizer(UIPinchGestureRecognizer *pinch)
{
    m_PinchGesture = pinch;
}

