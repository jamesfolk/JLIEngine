//
//  GameStateMachine.h
//  GameAsteroids
//
//  Created by James Folk on 3/20/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__GameStateMachine__
#define __GameAsteroids__GameStateMachine__

#include "AbstractStateMachine.h"
#include "AbstractSingleton.h"
#include "BaseGameState.h"
#include "DeviceInput.h"

class GameStateMachine : public AbstractStateMachine<void>, public AbstractSingleton<GameStateMachine>
{
    friend class AbstractSingleton;
    
protected:
    GameStateMachine(){}
    virtual ~GameStateMachine(){}
public:
    
    bool  isInState(const BaseGameState& st)const
    {
        if(getCurrentState()->getID() == st.getID())
            return true;
        return false;
    }
    
    //call this to render
    void  render()
    {
        BaseGameState *pCurrentState = dynamic_cast<BaseGameState*>(getCurrentState());
        BaseGameState *pGlobalState = dynamic_cast<BaseGameState*>(getGlobalState());
        
        if(pGlobalState)
            pGlobalState->render();
        
        if (pCurrentState)
            pCurrentState->render();
    }
    
    virtual void touchRespond(const DeviceTouch &touch)
    {
        BaseGameState *pCurrentState = dynamic_cast<BaseGameState*>(getCurrentState());
        BaseGameState *pGlobalState = dynamic_cast<BaseGameState*>(getGlobalState());
        
        if(pGlobalState)
            pGlobalState->touchRespond(touch);
        
        if (pCurrentState)
            pCurrentState->touchRespond(touch);
        
        DeviceInput::getInstance()->touchRespond(touch);
    }
    
    virtual void tapGestureRespond(const DeviceTapGesture &touch)
    {
        BaseGameState *pCurrentState = dynamic_cast<BaseGameState*>(getCurrentState());
        BaseGameState *pGlobalState = dynamic_cast<BaseGameState*>(getGlobalState());
        
        if(pGlobalState)
            pGlobalState->tapGestureRespond(touch);
        
        if (pCurrentState)
            pCurrentState->tapGestureRespond(touch);
        
        DeviceInput::getInstance()->tapGestureRespond(touch);
    }
    virtual void pinchGestureRespond(const DevicePinchGesture &touch)
    {
        BaseGameState *pCurrentState = dynamic_cast<BaseGameState*>(getCurrentState());
        BaseGameState *pGlobalState = dynamic_cast<BaseGameState*>(getGlobalState());
        
        if(pGlobalState)
            pGlobalState->pinchGestureRespond(touch);
        
        if (pCurrentState)
            pCurrentState->pinchGestureRespond(touch);
        
        DeviceInput::getInstance()->pinchGestureRespond(touch);
    }
    virtual void panGestureRespond(const DevicePanGesture &touch)
    {
        BaseGameState *pCurrentState = dynamic_cast<BaseGameState*>(getCurrentState());
        BaseGameState *pGlobalState = dynamic_cast<BaseGameState*>(getGlobalState());
        
        if(pGlobalState)
            pGlobalState->panGestureRespond(touch);
        
        if (pCurrentState)
            pCurrentState->panGestureRespond(touch);
        
        DeviceInput::getInstance()->panGestureRespond(touch);
    }
    virtual void swipeGestureRespond(const DeviceSwipeGesture &touch)
    {
        BaseGameState *pCurrentState = dynamic_cast<BaseGameState*>(getCurrentState());
        BaseGameState *pGlobalState = dynamic_cast<BaseGameState*>(getGlobalState());
        
        if(pGlobalState)
            pGlobalState->swipeGestureRespond(touch);
        
        if (pCurrentState)
            pCurrentState->swipeGestureRespond(touch);
        
        DeviceInput::getInstance()->swipeGestureRespond(touch);
    }
    virtual void rotationGestureRespond(const DeviceRotationGesture &touch)
    {
        BaseGameState *pCurrentState = dynamic_cast<BaseGameState*>(getCurrentState());
        BaseGameState *pGlobalState = dynamic_cast<BaseGameState*>(getGlobalState());
        
        if(pGlobalState)
            pGlobalState->rotationGestureRespond(touch);
        
        if (pCurrentState)
            pCurrentState->rotationGestureRespond(touch);
        
        DeviceInput::getInstance()->rotationGestureRespond(touch);
    }
    virtual void longPressGestureRespond(const DeviceLongPressGesture &touch)
    {
        BaseGameState *pCurrentState = dynamic_cast<BaseGameState*>(getCurrentState());
        BaseGameState *pGlobalState = dynamic_cast<BaseGameState*>(getGlobalState());
        
        if(pGlobalState)
            pGlobalState->longPressGestureRespond(touch);
        
        if (pCurrentState)
            pCurrentState->longPressGestureRespond(touch);
        
        DeviceInput::getInstance()->longPressGestureRespond(touch);
    }
    virtual void accelerometerRespond(const DeviceAccelerometer &touch)
    {
        BaseGameState *pCurrentState = dynamic_cast<BaseGameState*>(getCurrentState());
        BaseGameState *pGlobalState = dynamic_cast<BaseGameState*>(getGlobalState());
        
        if(pGlobalState)
            pGlobalState->accelerometerRespond(touch);
        
        if (pCurrentState)
            pCurrentState->accelerometerRespond(touch);
        
        DeviceInput::getInstance()->accelerometerRespond(touch);
    }
    virtual void motionRespond(const DeviceMotion &touch)
    {
        BaseGameState *pCurrentState = dynamic_cast<BaseGameState*>(getCurrentState());
        BaseGameState *pGlobalState = dynamic_cast<BaseGameState*>(getGlobalState());
        
        if(pGlobalState)
            pGlobalState->motionRespond(touch);
        
        if (pCurrentState)
            pCurrentState->motionRespond(touch);
        
        DeviceInput::getInstance()->motionRespond(touch);
    }
    virtual void gyroRespond(const DeviceGyro &touch)
    {
        BaseGameState *pCurrentState = dynamic_cast<BaseGameState*>(getCurrentState());
        BaseGameState *pGlobalState = dynamic_cast<BaseGameState*>(getGlobalState());
        
        if(pGlobalState)
            pGlobalState->gyroRespond(touch);
        
        if (pCurrentState)
            pCurrentState->gyroRespond(touch);
        
        DeviceInput::getInstance()->gyroRespond(touch);
    }
    virtual void magnetometerRespond(const DeviceMagnetometer &touch)
    {
        BaseGameState *pCurrentState = dynamic_cast<BaseGameState*>(getCurrentState());
        BaseGameState *pGlobalState = dynamic_cast<BaseGameState*>(getGlobalState());
        
        if(pGlobalState)
            pGlobalState->magnetometerRespond(touch);
        
        if (pCurrentState)
            pCurrentState->magnetometerRespond(touch);
        
        DeviceInput::getInstance()->magnetometerRespond(touch);
    }
    
    
    virtual void enablePause(bool pause = true)
    {
        BaseGameState *pCurrentState = dynamic_cast<BaseGameState*>(getCurrentState());
        BaseGameState *pGlobalState = dynamic_cast<BaseGameState*>(getGlobalState());
        
        if(pGlobalState)
            pGlobalState->enablePause(pause);
        if (pCurrentState)
            pCurrentState->enablePause(pause);
    }
    
    virtual void allowPause(bool allow = true)
    {
        BaseGameState *pCurrentState = dynamic_cast<BaseGameState*>(getCurrentState());
        BaseGameState *pGlobalState = dynamic_cast<BaseGameState*>(getGlobalState());
        
        if(pGlobalState)
            pGlobalState->allowPause(allow);
        
        if (pCurrentState)
            pCurrentState->allowPause(allow);
    }
    
    virtual bool isPauseAllowed()const
    {
        const BaseGameState *pCurrentState = dynamic_cast<const BaseGameState*>(getCurrentState());
        
        if (pCurrentState)
            return pCurrentState->isPauseAllowed();
        return false;
    }
    
    virtual bool isPaused()const
    {
        const BaseGameState *pCurrentState = dynamic_cast<const BaseGameState*>(getCurrentState());
        
        if (pCurrentState)
            return pCurrentState->isPaused();
        return false;
    }
    
    virtual void quit()
    {
        BaseGameState *pCurrentState = dynamic_cast<BaseGameState*>(getCurrentState());
        BaseGameState *pGlobalState = dynamic_cast<BaseGameState*>(getGlobalState());
        
        if(pGlobalState)
            pGlobalState->quit();
        
        if (pCurrentState)
            pCurrentState->quit();
    }
    
    virtual bool didQuit()const
    {
        const BaseGameState *pCurrentState = dynamic_cast<const BaseGameState*>(getCurrentState());
        const BaseGameState *pGlobalState = dynamic_cast<const BaseGameState*>(getGlobalState());
        
        
        if (pCurrentState)
            return pCurrentState->didQuit();
        return false;
    }
    

    virtual void saveDefaultData()
    {
        BaseGameState *pCurrentState = dynamic_cast<BaseGameState*>(getCurrentState());
        BaseGameState *pGlobalState = dynamic_cast<BaseGameState*>(getGlobalState());
        
        if(pGlobalState)
            pGlobalState->saveDefaultData();
        
        if (pCurrentState)
            pCurrentState->saveDefaultData();
        
    }

    virtual void loadDefaultData()
    {
        BaseGameState *pCurrentState = dynamic_cast<BaseGameState*>(getCurrentState());
        BaseGameState *pGlobalState = dynamic_cast<BaseGameState*>(getGlobalState());
        
        if(pGlobalState)
            pGlobalState->loadDefaultData();
        
        if (pCurrentState)
            pCurrentState->loadDefaultData();
    }

};

#endif /* defined(__GameAsteroids__GameStateMachine__) */
