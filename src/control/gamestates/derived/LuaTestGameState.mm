//
//  LuaTestGameState.cpp
//  MazeADay
//
//  Created by James Folk on 1/27/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#include "LuaTestGameState.h"
#include "LuaVM.h"
#include "DeviceInput.h"
#include "FileLoader.h"


LuaTestGameState::LuaTestGameState()
{
}
LuaTestGameState::~LuaTestGameState()
{
}


void ERRCHECK(FMOD_RESULT result)
{
    if (result != FMOD_OK)
    {
        fprintf(stderr, "FMOD error! (%d) %s\n", result, FMOD_ErrorString(result));
        exit(-1);
    }
}

void LuaTestGameState::enter(void*)
{
    FMOD_RESULT   result        = FMOD_OK;
//    char          buffer[200]   = {0};
    unsigned int  version       = 0;
    
    /*
     Create a System object and initialize
     */
    result = FMOD::System_Create(&system);
    ERRCHECK(result);
    
    result = system->getVersion(&version);
    ERRCHECK(result);
    
    if (version < FMOD_VERSION)
    {
        fprintf(stderr, "You are using an old version of FMOD %08x.  This program requires %08x\n", version, FMOD_VERSION);
//        exit(-1);
    }
    
    result = system->init(32, FMOD_INIT_NORMAL | FMOD_INIT_ENABLE_PROFILE, NULL);
    ERRCHECK(result);
    
    result = system->createStream(FileLoader::getInstance()->getFilePath("Displacement.mp3").c_str(), FMOD_SOFTWARE | FMOD_LOOP_NORMAL, NULL, &sound);
    
    ERRCHECK(result);
    
    /*
     Play the sound
     */
    result = system->playSound(FMOD_CHANNEL_FREE, sound, false, &channel);
    ERRCHECK(result);
    
    
    
    LuaVM::getInstance()->execute(AbstractFactoryObject::getName() + "Enter");
}
void LuaTestGameState::update(void*, btScalar deltaTimeStep)
{
    LuaVM::getInstance()->execute(AbstractFactoryObject::getName() + "Update", deltaTimeStep);
}
void LuaTestGameState::render()
{
    LuaVM::getInstance()->execute(AbstractFactoryObject::getName() + "Render");
}
void LuaTestGameState::exit(void*)
{
    LuaVM::getInstance()->execute("exit");
}
bool LuaTestGameState::onMessage(void*, const Telegram &telegram)
{
    bool ret = false;
    
    LuaVM::getInstance()->execute(AbstractFactoryObject::getName() + "OnMessage", telegram, ret);
    
    return ret;
}

void LuaTestGameState::touchRespond(const DeviceTouch &input)
{
    LuaVM::getInstance()->execute("TouchRespond", input);
}

void LuaTestGameState::tapGestureRespond(const DeviceTapGesture &input)
{
    LuaVM::getInstance()->execute("TapGestureRespond", input);
}

void LuaTestGameState::pinchGestureRespond(const DevicePinchGesture &input)
{
    LuaVM::getInstance()->execute("PinchGestureRespond", input);
}

void LuaTestGameState::panGestureRespond(const DevicePanGesture &input)
{
    LuaVM::getInstance()->execute("PanGestureRespond", input);
}

void LuaTestGameState::swipeGestureRespond(const DeviceSwipeGesture &input)
{
    LuaVM::getInstance()->execute("SwipeGestureRespond", input);
}

void LuaTestGameState::rotationGestureRespond(const DeviceRotationGesture &input)
{
    LuaVM::getInstance()->execute("RotationGestureRespond", input);
}

void LuaTestGameState::longPressGestureRespond(const DeviceLongPressGesture &input)
{
    LuaVM::getInstance()->execute("LongPressGestureRespond", input);
}

void LuaTestGameState::accelerometerRespond(const DeviceAccelerometer &input)
{
    LuaVM::getInstance()->execute("AccelerometerRespond", input);
}

void LuaTestGameState::motionRespond(const DeviceMotion &input)
{
    LuaVM::getInstance()->execute("MotionRespond", input);
}

void LuaTestGameState::gyroRespond(const DeviceGyro &input)
{
    LuaVM::getInstance()->execute("GyroRespond", input);
}

void LuaTestGameState::magnetometerRespond(const DeviceMagnetometer &input)
{
    LuaVM::getInstance()->execute("MagnetometerRespond", input);
}