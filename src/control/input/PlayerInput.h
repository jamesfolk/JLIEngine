//
//  PlayerInput.h
//  GameAsteroids
//
//  Created by James Folk on 3/21/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__PlayerInput__
#define __GameAsteroids__PlayerInput__

#include "AbstractSingleton.h"
#include <map>
#include <UIKit/UIKit.h>
#include "btAlignedObjectArray.h"
#include <string>

#include "btVector3.h"
#include "btQuaternion.h"

#include "btHashMap.h"

enum TouchType
{
    TouchType_NONE,
    TouchType_Begin,
    TouchType_Moved,
    TouchType_Ended,
    TouchType_Cancelled,
    TouchType_MAX
};

class Touch
{
    friend class PlayerInput;
    
    float m_x;
    float m_y;
    float m_dx;
    float m_dy;
    double m_timestamp_frame;
    double m_timestamp_soundtick;
    TouchType m_type;
    int m_address;
    NSUInteger m_tapCount;
    UITouchPhase m_touchPhase;
public:
    float getX()const{return m_x;}
    float getY()const{return m_y;}
    float getDistanceX()const{return m_dx;}
    float getDistanceY()const{return m_dy;}
    double getFrame()const{return m_timestamp_frame;}
    double getTick()const{return m_timestamp_soundtick;}
    TouchType getTouchType()const{return m_type;}
    int getAddress()const{return m_address;}
    NSUInteger getTapCount()const{return m_tapCount;}
    UITouchPhase getTouchPhase()const{return m_touchPhase;}
    
    Touch(float x = 0,
          float y = 0,
          double timestamp_frame = 0,
          double timestamp_soundtick = 0,
          TouchType type = TouchType_NONE,
          int address = 0,
          NSUInteger tapCount = 0,
          UITouchPhase touchPhase = UITouchPhaseCancelled) :
    m_x(x),
    m_y(y),
    m_dx(0),
    m_dy(0),
    m_timestamp_frame(timestamp_frame),
    m_timestamp_soundtick(timestamp_soundtick),
    m_type(type),
    m_address(address),
    m_tapCount(tapCount),
    m_touchPhase(touchPhase){}
    
    
    
    Touch &operator=(const Touch &rhs)
    {
        if(this != &rhs)
        {
            m_x = rhs.m_x;
            m_y = rhs.m_y;
            m_dx = rhs.m_dx;
            m_dy = rhs.m_dy;
            m_timestamp_frame = rhs.m_timestamp_frame;
            m_timestamp_soundtick = rhs.m_timestamp_soundtick;
            m_type = rhs.m_type;
            m_address = rhs.m_address;
            m_tapCount = rhs.m_tapCount;
            m_touchPhase = rhs.m_touchPhase;
        }
        return *this;
    }
    
    //if the timestamp is older then put it earlier in the list...
    bool operator() (const Touch& lhs, const Touch& rhs) const{return lhs.m_timestamp_frame>rhs.m_timestamp_frame;}
    bool operator== (const Touch& rhs) const
    {
        return m_address==rhs.m_address;
    }
    
    std::string getTouchPhaseName(UITouchPhase phase)
    {
        switch (phase)
        {
            case UITouchPhaseBegan:return std::string("UITouchPhaseBegan");
            case UITouchPhaseMoved:return std::string("UITouchPhaseMoved");
            case UITouchPhaseStationary:return std::string("UITouchPhaseStationary");
            case UITouchPhaseEnded:return std::string("UITouchPhaseEnded");
            case UITouchPhaseCancelled:return std::string("UITouchPhaseCancelled");
        }
        return std::string("undefined");
    }
    std::string getTypeName(TouchType type)
    {
        switch (type)
        {
            case TouchType_NONE:return std::string("TouchType_NONE");
            case TouchType_Begin:return std::string("TouchType_Begin");
            case TouchType_Moved:return std::string("TouchType_Moved");
            case TouchType_Ended:return std::string("TouchType_Ended");
            case TouchType_Cancelled:return std::string("TouchType_Cancelled");
            case TouchType_MAX:return std::string("TouchType_MAX");
        }
        return std::string("undefined");
    }
    void printDebug()
    {
        NSLog(@"Touch Debug\n");
        NSLog(@"\tPos (%f, %f)\n", m_x, m_y);
        NSLog(@"\tFrame %f\n", m_timestamp_frame);
        NSLog(@"\tTick %f\n", m_timestamp_soundtick);
        NSLog(@"\tType %s\n", getTypeName(m_type).c_str());
        NSLog(@"\tAddress %d\n", m_address);
        NSLog(@"\tTap Count %d\n", m_tapCount);
        NSLog(@"\tTouch Phase %s\n", getTouchPhaseName(m_touchPhase).c_str());
    }
};
        
class PlayerInput : public AbstractSingleton<PlayerInput>
{
    friend class AbstractSingleton;
    
    
    //void updateTouchObject(UITouch *touch, const Touch &touchObject);
    
    btHashMap<btHashPtr, Touch*> m_TouchAddressMap;
    btHashMap<btHashInt, Touch*> m_TouchIndexMap;
    
    int m_CurrentNumTouches;
    
    btVector3 m_AccelerometerValue;
    btQuaternion m_GyroValue;
    btVector3 m_GyroChange;
    btScalar m_YawPrev;
    btScalar m_PitchPrev;
    btScalar m_RollPrev;
    
    UIPinchGestureRecognizer *m_PinchGesture;
    bool m_IsPinching;
    float m_PinchCurrentScale;
    bool m_PinchFailed;
    float m_LastPinchScale;

    PlayerInput();
    virtual ~PlayerInput();
    int addTouch(UITouch *touch, float x, float y, unsigned int index, TouchType type);
    
    void updatePinchGesture(UIPinchGestureRecognizer *pinch);
public:
    int touchBegin(UITouch *touch, float x, float y, unsigned int index);
    int touchMoved(UITouch *touch, float x, float y, unsigned int index);
    int touchEnded(UITouch *touch, float x, float y, unsigned int index);
    int touchCancelled(UITouch *touch, float x, float y, unsigned int index);
    
    int getNumTouches()const;
    
    bool getTouchByAddress(const int address, Touch &touch);
    bool getTouchByIndex(const unsigned int index, Touch &touch);
    
    void updateAccelerometer(double x, double y, double z);
    const btVector3 &getAccelerometerValue()const;
    
    void initGyro(double yaw, double pitch, double roll);
    void updateGyro(double yaw, double pitch, double roll);
    const btQuaternion &getGyroValue()const;
    const btVector3 &getGyroChangeValue()const;
    
    
    void pinchGesturePossible(UIPinchGestureRecognizer *pinch);
    void pinchGestureBegan(UIPinchGestureRecognizer *pinch);
    void pinchGestureChanged(UIPinchGestureRecognizer *pinch);
    void pinchGestureEnded(UIPinchGestureRecognizer *pinch);
    void pinchGestureCancelled(UIPinchGestureRecognizer *pinch);
    void pinchGestureFailed(UIPinchGestureRecognizer *pinch);
    bool isPinchGesturing()const;
    bool isPinchGestureFailed()const;
    float getPinchGestureCurrentScale()const;
    
    const UIPinchGestureRecognizer*	getPinchGestureRecognizer() const;
    UIPinchGestureRecognizer*	getPinchGestureRecognizer();
    void setPinchGestureRecognizer(UIPinchGestureRecognizer *pinch);

};

#endif /* defined(__GameAsteroids__PlayerInput__) */
