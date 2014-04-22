//
//  DeviceInput.h
//  MazeADay
//
//  Created by James Folk on 12/18/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __MazeADay__DeviceInput__
#define __MazeADay__DeviceInput__



#include "AbstractSingleton.h"

#include <queue>

#include "CameraFactory.h"

#import <CoreMotion/CoreMotion.h>

enum DeviceSwipeDirection
{
    DeviceSwipeDirectionNONE,
    DeviceSwipeDirectionRight = UISwipeGestureRecognizerDirectionRight,
    DeviceSwipeDirectionLeft = UISwipeGestureRecognizerDirectionLeft,
    DeviceSwipeDirectionUp = UISwipeGestureRecognizerDirectionUp,
    DeviceSwipeDirectionDown = UISwipeGestureRecognizerDirectionDown,
    
    DeviceSwipeDirectionUpRight,
    DeviceSwipeDirectionUpLeft,
    DeviceSwipeDirectionDownRight,
    DeviceSwipeDirectionDownLeft
};

enum DeviceTouchPhase
{
    DeviceTouchPhaseBegan,             // whenever a finger touches the surface.
    DeviceTouchPhaseMoved,             // whenever a finger moves on the surface.
    DeviceTouchPhaseStationary,        // whenever a finger is touching the surface but hasn't moved since the previous event.
    DeviceTouchPhaseEnded,             // whenever a finger leaves the surface.
    DeviceTouchPhaseCancelled,         // whenever a touch doesn't end but we need to stop tracking (e.g. putting device to face)
};

enum DeviceGestureState
{
    DeviceGestureStatePossible,   // the recognizer has not yet recognized its gesture, but may be evaluating touch events. this is the default state
    
    DeviceGestureStateBegan,      // the recognizer has received touches recognized as the gesture. the action method will be called at the next turn of the run loop
    DeviceGestureStateChanged,    // the recognizer has received touches recognized as a change to the gesture. the action method will be called at the next turn of the run loop
    DeviceGestureStateEnded,      // the recognizer has received touches recognized as the end of the gesture. the action method will be called at the next turn of the run loop and the recognizer will be reset to UIGestureRecognizerStatePossible
    DeviceGestureStateCancelled,  // the recognizer has received touches resulting in the cancellation of the gesture. the action method will be called at the next turn of the run loop. the recognizer will be reset to UIGestureRecognizerStatePossible
    
    DeviceGestureStateFailed,     // the recognizer has received a touch sequence that can not be recognized as the gesture. the action method will not be called and the recognizer will be reset to UIGestureRecognizerStatePossible
    
    // Discrete Gestures – gesture recognizers that recognize a discrete event but do not report changes (for example, a tap) do not transition through the Began and Changed states and can not fail or be cancelled
    DeviceGestureStateRecognized = DeviceGestureStateEnded // the recognizer has received touches recognized as the gesture. the action method will be called at the next turn of the run loop and the recognizer will be reset to UIGestureRecognizerStatePossible
};

class DeviceInputTime
{
    double m_timestamp_frame;
    double m_timestamp_soundtick;
protected:
    DeviceInputTime():
    m_timestamp_frame(0),
    m_timestamp_soundtick(0)
    {
    }

    DeviceInputTime(const DeviceInputTime &rhs):
    m_timestamp_frame(rhs.m_timestamp_frame),
    m_timestamp_soundtick(rhs.m_timestamp_soundtick)
    {
        
    }
    DeviceInputTime &operator=(const DeviceInputTime &rhs)
    {
        if(this != &rhs)
        {
            m_timestamp_frame = rhs.m_timestamp_frame;
            m_timestamp_soundtick = rhs.m_timestamp_soundtick;
        }
        return *this;
    }

    DeviceInputTime(double frame);
public:
    double getTimeStampFrame()const{return m_timestamp_frame;}
    double getTimeStampTick()const{return m_timestamp_soundtick;}
};

class DeviceGesture
{
    DeviceGestureState m_state;
    unsigned int m_number_of_touches;
public:
    DeviceGestureState getState()const{return m_state;}
    unsigned int getNumberOfTouches()const{return m_number_of_touches;}
    
    operator std::string() const
    {
        char buffer[32];
        
        sprintf(buffer,"%s", getDeviceGestureName(m_state));
        
        return std::string(buffer);
    }
protected:
    DeviceGesture(){}
    DeviceGesture(DeviceGestureState state,
                  unsigned int number_of_touches):
    m_state(state),
    m_number_of_touches(number_of_touches)
    {}
    
    const char *getDeviceGestureName(DeviceGestureState state)const
    {
        switch (state)
        {
            case DeviceGestureStatePossible:return "DeviceGestureStatePossible";
            case DeviceGestureStateBegan:return "DeviceGestureStateBegan";
            case DeviceGestureStateChanged:return "DeviceGestureStateChanged";
            case DeviceGestureStateEnded:return "DeviceGestureStateEnded";
            case DeviceGestureStateCancelled:return "DeviceGestureStateCancelled";
            case DeviceGestureStateFailed:return "DeviceGestureStateFailed";
        }
        return "undefined";
    }
    
private:
    
};

class DeviceTapGesture : public DeviceGesture
{
public:
    DeviceTapGesture(){}
    DeviceTapGesture(UITapGestureRecognizer *sender) :
    DeviceGesture((DeviceGestureState)sender.state, sender.numberOfTouches)
    {
        //NSLog(@"DeviceTapGesture\n");
    }
    
    DeviceTapGesture(const DeviceTapGesture&rhs) :
    DeviceGesture(rhs)
    {
        
    }
    
    operator std::string() const
    {
        char buffer[32];
        
        sprintf(buffer,"DeviceTapGesture %s", DeviceGesture::operator std::string().c_str());
        
        return std::string(buffer);
    }
};

class DevicePinchGesture : public DeviceGesture
{
    float m_scale;
    float m_velocity;
    
public:
    DevicePinchGesture(){}
    float getScale()const{return m_scale;}
    float getVelocity()const{return m_velocity;}
    
    
    DevicePinchGesture(UIPinchGestureRecognizer *sender) :
    DeviceGesture((DeviceGestureState)sender.state, sender.numberOfTouches),
    m_scale(sender.scale),
    m_velocity(sender.velocity)
    {
    }
    
    operator std::string() const
    {
        char buffer[64];
        
        sprintf(buffer,"\n\
                %s\
                scale %.1f\n\
                velocity %.1f\n",
                DeviceGesture::operator std::string().c_str(),
                m_scale,
                m_velocity);
        
        sprintf(buffer,"DevicePinchGesture %s", DeviceGesture::operator std::string().c_str());
        
        return std::string(buffer);
    }
    
};

//UIPanGestureRecognizer
class DevicePanGesture : public DeviceGesture
{
    btVector2 m_translation;
public:
    DevicePanGesture(){}
    DevicePanGesture(UIPanGestureRecognizer *sender) :
    DeviceGesture((DeviceGestureState)sender.state, sender.numberOfTouches),
    m_translation([sender translationInView:sender.view].x, [sender translationInView:sender.view].y)
    {
    }
    
    operator std::string() const
    {
        char buffer[64];
        
        sprintf(buffer,"\n\
                %s\
                translation [%.1f, %.1f]\n",
                DeviceGesture::operator std::string().c_str(),
                m_translation.x(),
                m_translation.y());
        
        return std::string(buffer);
    }
    
    const btVector2 &getTranslation()
    {
        return m_translation;
    }
};

//
class DeviceSwipeGesture : public DeviceGesture
{
    DeviceSwipeDirection m_direction;
    
public:
    DeviceSwipeGesture(){}
    DeviceSwipeGesture(UISwipeGestureRecognizer *sender) :
    DeviceGesture((DeviceGestureState)sender.state, sender.numberOfTouches),
    m_direction((DeviceSwipeDirection)sender.direction)
    {
    }
    
    operator std::string() const
    {
        char buffer[256];
        
        sprintf(buffer,"DeviceSwipeGesture %s",
                DeviceGesture::operator std::string().c_str());
        
        return std::string(buffer);
    }
};

//
class DeviceRotationGesture : public DeviceGesture
{
    btScalar m_rotation;
    btScalar m_velocity;
public:
    DeviceRotationGesture(){}
    DeviceRotationGesture(UIRotationGestureRecognizer *sender) :
    DeviceGesture((DeviceGestureState)sender.state, sender.numberOfTouches),
    m_rotation((sender.rotation)),
    m_velocity(sender.velocity)
    {
        //NSLog(@"DeviceRotationGesture\n");
    }
    
    operator std::string() const
    {
        char buffer[32];
        
        sprintf(buffer,"\n\
                %s\
                rotation %.1f\n\
                velocity %.1f\n",
                DeviceGesture::operator std::string().c_str(),
                m_rotation,
                m_velocity);
        
        return std::string(buffer);
    }
    
    btScalar getRotation()const
    {
        return m_rotation;
    }
    
    btScalar getVelocity()const
    {
        return m_velocity;
    }
    
};

//UILongPressGestureRecognizer
class DeviceLongPressGesture : public DeviceGesture
{
public:
    DeviceLongPressGesture(){}
    DeviceLongPressGesture(UILongPressGestureRecognizer *sender) :
    DeviceGesture((DeviceGestureState)sender.state, sender.numberOfTouches)
    {
        //NSLog(@"DeviceLongPressGesture\n");
    }
    
    operator std::string() const
    {
        char buffer[32];
        
        sprintf(buffer,"DeviceLongPressGesture %s", DeviceGesture::operator std::string().c_str());
        
        return std::string(buffer);
    }
};

//CMAccelerometerData
class DeviceAccelerometer : public DeviceInputTime
{
    btVector3 m_acceleration;
    
public:
    DeviceAccelerometer(){}
    DeviceAccelerometer(const DeviceAccelerometer &rhs):
    DeviceInputTime(rhs),
    m_acceleration(rhs.m_acceleration)
    {
        
    }
    DeviceAccelerometer &operator=(const DeviceAccelerometer &rhs)
    {
        if(this != &rhs)
        {
            DeviceInputTime::operator=(rhs);
            
            m_acceleration = rhs.m_acceleration;
        }
        return *this;
    }
    
    DeviceAccelerometer(CMAccelerometerData *data) :
    DeviceInputTime(data.timestamp),
    m_acceleration(data.acceleration.x, data.acceleration.y, data.acceleration.z)
    {
        
    }
    
    
    const btVector3 &getAcceleration()const{return m_acceleration;}
    
    operator std::string() const
    {
        char buffer[32];
        
        sprintf(buffer,"[%.2f, %.2f, %.2f]", m_acceleration.x(), m_acceleration.y(), m_acceleration.z());
        
        return std::string(buffer);
    }
    
    
};

class DeviceAttitude
{
    double m_roll;
    double m_pitch;
    double m_yaw;
    btMatrix3x3 m_rotationMatrix;
    btQuaternion m_quaternion;
public:
    DeviceAttitude():
    m_roll(0),
    m_pitch(0),
    m_yaw(0),
    m_rotationMatrix(btMatrix3x3::getIdentity()),
    m_quaternion(btQuaternion::getIdentity())
    {}
    
    DeviceAttitude(const DeviceAttitude &rhs):
    m_roll(rhs.m_roll),
    m_pitch(rhs.m_pitch),
    m_yaw(rhs.m_yaw),
    m_rotationMatrix(rhs.m_rotationMatrix),
    m_quaternion(rhs.m_quaternion)
    {}
    
    DeviceAttitude &operator=(const DeviceAttitude &rhs)
    {
        if(this != &rhs)
        {
            m_roll = rhs.m_roll;
            m_pitch = rhs.m_pitch;
            m_yaw = rhs.m_yaw;
            m_rotationMatrix = rhs.m_rotationMatrix;
            m_quaternion = rhs.m_quaternion;
        }
        return *this;
    }

    double getRoll()const{return m_roll;}
    double getPitch()const{return m_pitch;}
    double getYaw()const{return m_yaw;}
    const btMatrix3x3 &getRotationMatrix()const{return m_rotationMatrix;}
    const btQuaternion &getQuaternion()const
    {
        
        return m_quaternion;
    }
    
    DeviceAttitude(CMAttitude *attitude):
    m_roll(attitude.roll),
    m_pitch(attitude.pitch),
    m_yaw(attitude.yaw),
    m_rotationMatrix(attitude.rotationMatrix.m11,
                     attitude.rotationMatrix.m12,
                     attitude.rotationMatrix.m13,
                     attitude.rotationMatrix.m21,
                     attitude.rotationMatrix.m22,
                     attitude.rotationMatrix.m23,
                     attitude.rotationMatrix.m31,
                     attitude.rotationMatrix.m32,
                     attitude.rotationMatrix.m33),
    m_quaternion(attitude.quaternion.x,
                 attitude.quaternion.y,
                 attitude.quaternion.z,
                 attitude.quaternion.w)
    {
        
    }
    
    operator std::string() const
    {
        char buffer[2048];
        
        sprintf(buffer,"\
                [roll, pitch, yaw];[%.2f, %.2f, %.2f]\n\
                [rotationMatrix]\n\
                \t[%.2f, %.2f, %.2f]\n\
                \t[%.2f, %.2f, %.2f]\n\
                \t[%.2f, %.2f, %.2f]\n\
                quaternion[x, y, z, w];[%.2f, %.2f, %.2f, %.2f]\n\
                ",
                m_roll, m_pitch, m_yaw,
                m_rotationMatrix.getRow(0).x(), m_rotationMatrix.getRow(0).y(), m_rotationMatrix.getRow(0).z(),
                m_rotationMatrix.getRow(1).x(), m_rotationMatrix.getRow(1).y(), m_rotationMatrix.getRow(1).z(),
                m_rotationMatrix.getRow(2).x(), m_rotationMatrix.getRow(2).y(), m_rotationMatrix.getRow(2).z(),
                m_quaternion.x(), m_quaternion.y(), m_quaternion.z(), m_quaternion.w());
        
        return std::string(buffer);
    }
};

//CMDeviceMotion
class DeviceMotion : public DeviceInputTime
{
    DeviceAttitude m_attitide;
    btVector3 m_rotationRate;
    btVector3 m_gravity;
    btVector3 m_userAcceleration;
    btVector3 m_magneticField;
public:
    DeviceMotion(){}

    const DeviceAttitude &getAttitude()const{return m_attitide;}
    const btVector3 &getRotationRate()const{return m_rotationRate;}
    const btVector3 &getGravity()const{return m_gravity;}
    const btVector3 &getUserAcceleration()const{return m_userAcceleration;}
    const btVector3 &getMagneticField()const{return m_magneticField;}
    
    DeviceMotion(const DeviceMotion &rhs):
    DeviceInputTime(rhs),
    m_attitide(rhs.m_attitide),
    m_rotationRate(rhs.m_rotationRate),
    m_gravity(rhs.m_gravity),
    m_userAcceleration(rhs.m_userAcceleration),
    m_magneticField(rhs.m_magneticField)
    {
        
    }
    DeviceMotion &operator=(const DeviceMotion &rhs)
    {
        if(this != &rhs)
        {
            DeviceInputTime::operator=(rhs);
            
            m_attitide = rhs.m_attitide;
            m_rotationRate = rhs.m_rotationRate;
            m_gravity = rhs.m_gravity;
            m_userAcceleration = rhs.m_userAcceleration;
            m_magneticField = rhs.m_magneticField;
        }
        return *this;
    }
    
    DeviceMotion(CMDeviceMotion *data) :
    DeviceInputTime(data.timestamp),
    m_attitide(data.attitude),
    m_rotationRate(data.rotationRate.x,
                   data.rotationRate.y,
                   data.rotationRate.z),
    m_gravity(data.gravity.x,
              data.gravity.y,
              data.gravity.z),
    m_userAcceleration(data.userAcceleration.x,
                       data.userAcceleration.y,
                       data.userAcceleration.z),
    m_magneticField(data.magneticField.field.x,
                    data.magneticField.field.y,
                    data.magneticField.field.z)
    {
        
    }
    
    operator std::string() const
    {
        char buffer[4096];
        std::string att(m_attitide);
        
        sprintf(buffer,"\
                %s\n\
                rotationRate[%.2f, %.2f, %.2f]\n\
                gravity[%.2f, %.2f, %.2f]\n\
                userAcceleration[%.2f, %.2f, %.2f]\n\
                magneticField[%.2f, %.2f, %.2f]\n\
                ",
                att.c_str(),
                m_rotationRate.x(), m_rotationRate.y(), m_rotationRate.z(),
                m_gravity.x(), m_gravity.y(), m_gravity.z(),
                m_userAcceleration.x(), m_userAcceleration.y(), m_userAcceleration.z(),
                m_magneticField.x(), m_magneticField.y(), m_magneticField.z());
        
        return std::string(buffer);
    }
};

//CMGyroData
class DeviceGyro : public DeviceInputTime
{
    btVector3 m_rotationRate;
public:
    DeviceGyro(){}

    const btVector3 &getRotationRate()const{return m_rotationRate;}
    
    DeviceGyro(const DeviceGyro &rhs):
    DeviceInputTime(rhs),
    m_rotationRate(rhs.m_rotationRate)
    {
        
    }
    DeviceGyro &operator=(const DeviceGyro &rhs)
    {
        if(this != &rhs)
        {
            DeviceInputTime::operator=(rhs);
            
            m_rotationRate = rhs.m_rotationRate;
        }
        return *this;
    }
    
    DeviceGyro(CMGyroData *data) :
    DeviceInputTime(data.timestamp),
    m_rotationRate(data.rotationRate.x, data.rotationRate.y, data.rotationRate.z)
    {
        
    }
    
    operator std::string() const
    {
        char buffer[256];
        
        sprintf(buffer,"\
                rotationRate[%.2f, %.2f, %.2f]\n\
                ",
                m_rotationRate.x(), m_rotationRate.y(), m_rotationRate.z());
        
        return std::string(buffer);
    }
};

//CMMagnetometerData
class DeviceMagnetometer : public DeviceInputTime
{
    btVector3 m_magneticField;
public:
    DeviceMagnetometer(){}

    const btVector3 &getMagneticField()const{return m_magneticField;}
    
    DeviceMagnetometer(const DeviceMagnetometer &rhs):
    DeviceInputTime(rhs),
    m_magneticField(rhs.m_magneticField)
    {
        
    }
    DeviceMagnetometer &operator=(const DeviceMagnetometer &rhs)
    {
        if(this != &rhs)
        {
            DeviceInputTime::operator=(rhs);
            
            m_magneticField = rhs.m_magneticField;
        }
        return *this;
    }
    
    DeviceMagnetometer(CMMagnetometerData *data) :
    DeviceInputTime(data.timestamp),
    m_magneticField(data.magneticField.x, data.magneticField.y, data.magneticField.z)
    {
    }
    
    operator std::string() const
    {
        char buffer[256];
        
        sprintf(buffer,"\
                magneticField[%.2f, %.2f, %.2f]\n\
                ",
                m_magneticField.x(), m_magneticField.y(), m_magneticField.z());
        
        return std::string(buffer);
    }
};

class DeviceTouch : public DeviceInputTime
{
    btVector2 m_pos;
    btVector2 m_prev_pos;
    unsigned int m_address;
    unsigned int m_tapCount;
    DeviceTouchPhase m_touchPhase;
    unsigned int m_touchIndex;
    unsigned int m_touchTotal;
public:
    DeviceTouch(){}

    void pack();
    char *unpack()const;
    
    const btVector2 &getPosition()const{return m_pos;}
    const btVector2 &getPreviousPosition()const{return m_prev_pos;}
    unsigned int getAddress()const{return m_address;}
    unsigned int getTapCount()const{return m_tapCount;}
    DeviceTouchPhase getTouchPhase()const{return m_touchPhase;}
    unsigned int getTouchIndex()const{return m_touchIndex;}
    unsigned int getTouchTotal()const{return m_touchTotal;}
    
    DeviceTouch(const DeviceTouch &rhs):
    DeviceInputTime(rhs),
    m_pos(rhs.m_pos),
    m_prev_pos(rhs.m_prev_pos),
    m_address(rhs.m_address),
    m_tapCount(rhs.m_tapCount),
    m_touchPhase(rhs.m_touchPhase),
    m_touchIndex(rhs.m_touchIndex),
    m_touchTotal(rhs.m_touchTotal)
    {
        
    }
    DeviceTouch &operator=(const DeviceTouch &rhs)
    {
        if(this != &rhs)
        {
            DeviceInputTime::operator=(rhs);
            
            m_pos = rhs.m_pos;
            m_prev_pos = rhs.m_prev_pos;
            m_address = rhs.m_address;
            m_tapCount = rhs.m_tapCount;
            m_touchPhase = rhs.m_touchPhase;
            m_touchIndex = rhs.m_touchIndex;
            m_touchTotal = rhs.m_touchTotal;
        }
        return *this;
    }

    
    DeviceTouch(UITouch *touch, int n, int N) :
    DeviceInputTime(touch.timestamp)
    {
        convert(*this, touch);
        
        m_touchIndex = n;
        m_touchTotal = N;
    }
    
    operator std::string() const
    {
        char buffer[1024];
        
        sprintf(buffer,"\n\
                Current Pos [%.0f, %.0f]\n\
                Previous Pos [%.0f, %.0f]\n\
                Frame [%f]\n\
                Tick [%f]\n\
                Address [%d]\n\
                TapCount [%d]\n\
                TouchPhase [%s]\n\
                Touch %d of %d\n",
                m_pos.x(), m_pos.y(),
                m_prev_pos.x(), m_prev_pos.y(),
                getTimeStampFrame(), getTimeStampTick(),
                m_address, m_tapCount,
                getTouchPhaseName(m_touchPhase), m_touchIndex + 1, m_touchTotal);
        return std::string(buffer);
    }
    
private:
    
    const char *getTouchPhaseName(DeviceTouchPhase phase)const
    {
        switch (phase)
        {
            case DeviceTouchPhaseBegan:return "DeviceTouchPhaseBegan";
            case DeviceTouchPhaseMoved:return "DeviceTouchPhaseMoved";
            case DeviceTouchPhaseStationary:return "DeviceTouchPhaseStationary";
            case DeviceTouchPhaseEnded:return "DeviceTouchPhaseEnded";
            case DeviceTouchPhaseCancelled:return "DeviceTouchPhaseCancelled";
        }
        return "undefined";
    }
    
    void convert(DeviceTouch &t, UITouch *touch)const
    {
        
        CGPoint p = [touch locationInView:touch.view];
        t.m_pos.setX(p.x);
        t.m_pos.setY(p.y);
        p = [touch previousLocationInView:touch.view];
        t.m_prev_pos.setX(p.x);
        t.m_prev_pos.setY(p.y);
        t.m_address = [touch hash];
        t.m_tapCount = [touch tapCount];
        t.m_touchPhase = (DeviceTouchPhase)[touch phase];
        
        CGFloat scaleFactor = touch.view.contentScaleFactor;
        
        t.m_pos *= scaleFactor;
        t.m_prev_pos *= scaleFactor;
        
        btScalar height = CameraFactory::getScreenHeight();
        
        t.m_pos.setY((height) - t.m_pos.y());
        t.m_prev_pos.setY((height) - t.m_prev_pos.y());
    }
};

class DeviceInput : public AbstractSingleton<DeviceInput>
{
public:
    DeviceInput();
    ~DeviceInput();
    
    inline void touchRespond(const DeviceTouch &touch){m_CurrentDeviceTouch=touch;}
    inline void tapGestureRespond(const DeviceTapGesture &touch){m_CurrentDeviceTapGesture=touch;}
    inline void pinchGestureRespond(const DevicePinchGesture &touch){m_CurrentDevicePinchGesture=touch;}
    inline void panGestureRespond(const DevicePanGesture &touch){m_DevicePanGesture=touch;}
    inline void swipeGestureRespond(const DeviceSwipeGesture &touch){m_DeviceSwipeGesture=touch;}
    inline void rotationGestureRespond(const DeviceRotationGesture &touch){m_DeviceRotationGesture=touch;}
    inline void longPressGestureRespond(const DeviceLongPressGesture &touch){m_DeviceLongPressGesture=touch;}
    inline void accelerometerRespond(const DeviceAccelerometer &touch){m_DeviceAccelerometer=touch;}
    inline void motionRespond(const DeviceMotion &touch){m_DeviceMotion=touch;}
    inline void gyroRespond(const DeviceGyro &touch){m_DeviceGyro=touch;}
    inline void magnetometerRespond(const DeviceMagnetometer &touch){m_DeviceMagnetometer=touch;}
    
    inline const DeviceTouch &getCurrentDeviceTouch()const{return m_CurrentDeviceTouch;}
    inline const DeviceTapGesture &getCurrentDeviceTapGesture()const{return m_CurrentDeviceTapGesture;}
    inline const DevicePinchGesture &getCurrentDevicePinchGesture()const{return m_CurrentDevicePinchGesture;}
    inline const DevicePanGesture &getDevicePanGesture()const{return m_DevicePanGesture;}
    inline const DeviceSwipeGesture &getDeviceSwipeGesture()const{return m_DeviceSwipeGesture;}
    inline const DeviceRotationGesture &getDeviceRotationGesture()const{return m_DeviceRotationGesture;}
    inline const DeviceLongPressGesture &getDeviceLongPressGesture()const{return m_DeviceLongPressGesture;}
    inline const DeviceAccelerometer &getDeviceAccelerometer()const{return m_DeviceAccelerometer;}
    inline const DeviceMotion &getDeviceMotion()const{return m_DeviceMotion;}
    inline const DeviceGyro &getDeviceGyro()const{return m_DeviceGyro;}
    inline const DeviceMagnetometer &getDeviceMagnetometer()const{return m_DeviceMagnetometer;}
    
private:
    
    DeviceTouch m_CurrentDeviceTouch;
    DeviceTapGesture m_CurrentDeviceTapGesture;
    DevicePinchGesture m_CurrentDevicePinchGesture;
    DevicePanGesture m_DevicePanGesture;
    DeviceSwipeGesture m_DeviceSwipeGesture;
    DeviceRotationGesture m_DeviceRotationGesture;
    DeviceLongPressGesture m_DeviceLongPressGesture;
    DeviceAccelerometer m_DeviceAccelerometer;
    DeviceMotion m_DeviceMotion;
    DeviceGyro m_DeviceGyro;
    DeviceMagnetometer m_DeviceMagnetometer;
};

#endif /* defined(__MazeADay__DeviceInput__) */
