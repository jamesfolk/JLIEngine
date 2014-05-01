//
//  LuaVM.h
//  GameAsteroids
//
//  Created by James Folk on 8/12/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__LuaVM__
#define __GameAsteroids__LuaVM__

#include "AbstractSingleton.h"

#include <string>

#include "DeviceInput.h"


extern "C" {
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

}

class BaseEntity;
class btManifoldPoint;



class DeviceTouch;
class DeviceTapGesture;
class DevicePinchGesture;
class DevicePanGesture;
class DeviceSwipeGesture;
class DeviceRotationGesture;
class DeviceLongPressGesture;
class DeviceAccelerometer;
class DeviceMotion;
class DeviceGyro;
class DeviceMagnetometer;
class Telegram;


class LuaVM :
public AbstractSingleton<LuaVM>
{
    friend class AbstractSingleton;
public:
    void init();
    
    bool execute(const std::string &code);
    bool execute(const std::string &code, btScalar _btScalar);
    bool execute(const std::string &code, BaseEntity *pEntity, BaseEntity *pOtherEntity, const btManifoldPoint &pt);
    bool execute(const std::string &code, const DeviceTouch &input);
    bool execute(const std::string &code, const DeviceTapGesture &input);
    bool execute(const std::string &code, const DevicePinchGesture &input);
    bool execute(const std::string &code, const DevicePanGesture &input);
    bool execute(const std::string &code, const DeviceSwipeGesture &input);
    bool execute(const std::string &code, const DeviceRotationGesture &input);
    bool execute(const std::string &code, const DeviceLongPressGesture &input);
    bool execute(const std::string &code, const DeviceAccelerometer &input);
    bool execute(const std::string &code, const DeviceMotion &input);
    bool execute(const std::string &code, const DeviceGyro &input);
    bool execute(const std::string &code, const DeviceMagnetometer &input);
    bool execute(const std::string &code, BaseEntity *pEntity, btCollisionWorld* collisionWorld, btScalar deltaTimeStep);
    bool execute(const std::string &code, BaseEntity *pEntity);
    bool execute(const std::string &code, BaseEntity *pEntity, btScalar _btScalar);
    bool execute(const std::string &code, BaseEntity *entity, const Telegram &telegram, bool &returnValue);
    bool execute(const std::string &code, const Telegram &telegram, bool &returnValue);
    
    void unInit();
    void reset();
    
    bool loadFile(const std::string &file);
    bool loadString(const std::string &file);
    
    virtual void touchRespond(DeviceTouch *input);
    virtual void tapGestureRespond(DeviceTapGesture input);
    virtual void pinchGestureRespond(DevicePinchGesture *input);
    virtual void panGestureRespond(DevicePanGesture *input);
    virtual void swipeGestureRespond(DeviceSwipeGesture *input);
    virtual void rotationGestureRespond(DeviceRotationGesture *input);
    virtual void longPressGestureRespond(DeviceLongPressGesture *input);
    virtual void accelerometerRespond(DeviceAccelerometer *input);
    virtual void motionRespond(DeviceMotion *input);
    virtual void gyroRespond(DeviceGyro *input);
    virtual void magnetometerRespond(DeviceMagnetometer *input);
    
protected:
    LuaVM();
    virtual ~LuaVM();
    
    void getError(int error);
    bool compile();
    
    lua_State			*m_lua_State;
};

#endif /* defined(__GameAsteroids__LuaVM__) */
