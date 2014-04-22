//
//  FontTestState.h
//  GameAsteroids
//
//  Created by James Folk on 4/29/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__FontTestState__
#define __GameAsteroids__FontTestState__

#include "BaseTestState.h"

class BaseTextViewObject;

class FontTestState : public BaseTestState
{
public:
    FontTestState();
    virtual ~FontTestState();
    
    virtual void update_specific(btScalar deltaTimeStep);
    virtual void enter_specific();
    virtual void exit_specific();
    virtual void render_specific();
//    
//    virtual void touchesBegan();
//    virtual void touchesMoved();
//    virtual void touchesEnded();
//    virtual void touchesCancelled();
    
    
private:
    IDType shaderFactoryID;
    float m_Rotate;
    BaseTextViewObject *m_pBaseTextViewObject;
    
    //long long int m_CurrentTime;
    //bool m_IsPaused;
    //std::string m_TimeString;
    
    Timer *m_timer;
    Clock *m_clock;
    StopWatch *m_stop_watch;
    
    btAlignedObjectArray<IDType> m_TimerDrawingText;
    btAlignedObjectArray<IDType> m_ClockDrawingText;
    btAlignedObjectArray<IDType> m_StopWatchDrawingText;
    
    
};

#endif /* defined(__GameAsteroids__FontTestState__) */
