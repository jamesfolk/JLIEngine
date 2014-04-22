//
//  RotationGameState.h
//  MazeADay
//
//  Created by James Folk on 1/27/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#ifndef __MazeADay__RotationGameState__
#define __MazeADay__RotationGameState__

#include "BaseTestState.h"

class RotationGameState: public BaseTestState
{
public:
    RotationGameState();
    virtual ~RotationGameState();
    
    virtual void update_specific(btScalar deltaTimeStep);
    virtual void enter_specific();
    virtual void exit_specific();
    virtual void render_specific();
    
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
    std::vector<RigidEntity*> m_Spheres;
    
    std::vector<btQuaternion> m_Rotations;
    std::vector<btVector3> m_Pivots;
    
    CameraEntity *m_pCameraEntity;
    float m_Rotate;
    
    btQuaternion m_transitionQuaternion;
};

#endif /* defined(__MazeADay__RotationGameState__) */
