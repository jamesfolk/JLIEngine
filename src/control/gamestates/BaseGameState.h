//
//  BaseGameState.h
//  GameAsteroids
//
//  Created by James Folk on 3/20/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__BaseGameState__
#define __GameAsteroids__BaseGameState__

#include "AbstractState.h"

#include "AbstractFactory.h"
#include "DeviceInput.h"
//#include "GameStateFactory.h"

class BaseGameState : public AbstractState<void>//, public AbstractFactoryObject
{
    friend class GameStateFactory;
protected:
    BaseGameState():m_IsPaused(false), m_didQuit(false), m_canPause(true){}
    virtual ~BaseGameState(){}
public:
//    SIMD_FORCE_INLINE IDType getID()const
//    {
//        return AbstractFactoryObject::getID();
//    }
//    
//    SIMD_FORCE_INLINE const std::string &getName()const
//    {
//        return AbstractFactoryObject::getName();
//    }
//    
//    SIMD_FORCE_INLINE void setName(const std::string &name)
//    {
//        AbstractFactoryObject::setName(name);
//    }
    
    
    virtual void enter(void*) = 0;
    
    //this is the states normal update function
    virtual void update(void*, btScalar deltaTimeStep) = 0;
    
    virtual void render() = 0;
    
    //this will execute when the state is exited.
    virtual void exit(void*) = 0;
    
    //this executes if the agent receives a message from the
    //message dispatcher
    virtual bool onMessage(void*, const Telegram&) = 0;
    
    virtual void touchRespond(const DeviceTouch &touch){}
    virtual void tapGestureRespond(const DeviceTapGesture &touch){}
    virtual void pinchGestureRespond(const DevicePinchGesture &touch){}
    virtual void panGestureRespond(const DevicePanGesture &touch){}
    virtual void swipeGestureRespond(const DeviceSwipeGesture &touch){}
    virtual void rotationGestureRespond(const DeviceRotationGesture &touch){}
    virtual void longPressGestureRespond(const DeviceLongPressGesture &touch){}
    virtual void accelerometerRespond(const DeviceAccelerometer &touch){}
    virtual void motionRespond(const DeviceMotion &touch){}
    virtual void gyroRespond(const DeviceGyro &touch){}
    virtual void magnetometerRespond(const DeviceMagnetometer &touch){}
//    virtual void touchesBegan(){}
//    virtual void touchesMoved(){}
//    virtual void touchesEnded(){}
//    virtual void touchesCancelled(){}
    
    virtual void enablePause(bool pause = true);
    
    virtual void allowPause(bool allow = true);
    virtual bool isPauseAllowed()const;
    virtual bool isPaused()const;
    
    virtual void quit();
    virtual bool didQuit()const;
    
    virtual void saveDefaultData();
    virtual void loadDefaultData();
private:
    bool m_IsPaused;
    bool m_didQuit;
    bool m_canPause;
};

#endif /* defined(__GameAsteroids__BaseGameState__) */
