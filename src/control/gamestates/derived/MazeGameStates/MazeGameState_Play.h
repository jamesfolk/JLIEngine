//
//  MazeGameState_Play.h
//  MazeADay
//
//  Created by James Folk on 11/15/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __MazeADay__MazeGameState_Play__
#define __MazeADay__MazeGameState_Play__

#include "BaseGameState.h"
class btVector3;

class MazeGameState_Play: public BaseGameState
{
public:
    MazeGameState_Play();
    virtual ~MazeGameState_Play();
    
    virtual void enter(void*);
    virtual void update(void*, btScalar deltaTimeStep);
    virtual void render();
    virtual void exit(void*);
    virtual bool onMessage(void*, const Telegram&);
    
    virtual void touchRespond(const DeviceTouch &touch);
    virtual void pinchGestureRespond(const DevicePinchGesture &touch);
    virtual void gyroRespond(const DeviceGyro &touch);
    virtual void motionRespond(const DeviceMotion &input);
    
    btVector3 getPlayerControlTouchPosition(const DeviceTouch &touch)const;
    btScalar getPlayerControlTouchDistance(const DeviceTouch &touch)const;
    void applyAngularForceOnPlayer(const DeviceTouch &touch);
    void applyTorqueToPlayer(const btVector3 &torque);
    
private:
    double m_TouchStartTime;
    bool m_InitalizeTouch;
    btVector3 *m_TouchStart;
    
    float m_ImpulseContant;
    float m_MaxTouchDistance;
};

#endif /* defined(__MazeADay__MazeGameState_Play__) */
