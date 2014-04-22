//
//  ObjectUpdateBehavior.h
//  MazeADay
//
//  Created by James Folk on 1/26/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#ifndef __MazeADay__ObjectUpdateBehavior__
#define __MazeADay__ObjectUpdateBehavior__

#include "BaseUpdateBehavior.h"

struct ObjectUpdateBehaviorInfo :
public UpdateBehaviorInfo
{
    ObjectUpdateBehaviorInfo() : UpdateBehaviorInfo(UpdateBehaviorTypes_Object){}
    virtual ~ObjectUpdateBehaviorInfo(){}
};

class ObjectUpdateBehavior  :
public BaseUpdateBehavior
{
public:
    
    ObjectUpdateBehavior(const ObjectUpdateBehaviorInfo& constructionInfo);
    virtual ~ObjectUpdateBehavior();
    
    virtual void update(btCollisionWorld* collisionWorld, btScalar deltaTimeStep);
    
    void startTimer();
    
    IDType m_timerID;
};

#endif /* defined(__MazeADay__ObjectUpdateBehavior__) */
