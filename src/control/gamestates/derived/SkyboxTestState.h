//
//  SkyboxTestState.h
//  MazeADay
//
//  Created by James Folk on 12/22/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __MazeADay__SkyboxTestState__
#define __MazeADay__SkyboxTestState__

#include "BaseTestState.h"

class SkyboxTestState: public BaseTestState
{
public:
    SkyboxTestState();
    virtual ~SkyboxTestState();
    
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
    CameraEntity *getCamera();
    RigidEntity *getSkybox();
    
    CameraEntity *m_pCameraEntity;
    RigidEntity *m_pSkybox;
};

#endif /* defined(__MazeADay__SkyboxTestState__) */
