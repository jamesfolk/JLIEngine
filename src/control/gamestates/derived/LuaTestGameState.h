//
//  LuaTestGameState.h
//  MazeADay
//
//  Created by James Folk on 1/27/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#ifndef __MazeADay__LuaTestGameState__
#define __MazeADay__LuaTestGameState__

#include "BaseGameState.h"

#include "fmod.hpp"
#include "fmod_errors.h"

class LuaTestGameState: public BaseGameState
{
public:
    LuaTestGameState();
    virtual ~LuaTestGameState();
    
    virtual void enter(void*);
    virtual void update(void*, btScalar deltaTimeStep);
    virtual void render();
    virtual void exit(void*);
    virtual bool onMessage(void*, const Telegram&);
    
    virtual void touchRespond(const DeviceTouch &input);
    virtual void tapGestureRespond(const DeviceTapGesture &input);
    virtual void pinchGestureRespond(const DevicePinchGesture &input);
    virtual void panGestureRespond(const DevicePanGesture &input);
    virtual void swipeGestureRespond(const DeviceSwipeGesture &input);
    virtual void rotationGestureRespond(const DeviceRotationGesture &input);
    virtual void longPressGestureRespond(const DeviceLongPressGesture &input);
    virtual void accelerometerRespond(const DeviceAccelerometer &input);
    virtual void motionRespond(const DeviceMotion &input);
    virtual void gyroRespond(const DeviceGyro &input);
    virtual void magnetometerRespond(const DeviceMagnetometer &input);
private:
    
    FMOD::System   *system;
    FMOD::Sound    *sound;
    FMOD::Channel  *channel;
};

#endif /* defined(__MazeADay__LuaTestGameState__) */
