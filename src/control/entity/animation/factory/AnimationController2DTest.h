//
//  AnimationController2DTest.h
//  GameAsteroids
//
//  Created by James Folk on 5/6/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__AnimationController2DTest__
#define __GameAsteroids__AnimationController2DTest__

#include "BaseEntityAnimationController.h"

class AnimationController2DTest : public BaseEntityAnimationController
{
public:
    AnimationController2DTest(const AnimationControllerInfo &constructionInfo);
    virtual ~AnimationController2DTest();
    
    virtual void update(btScalar deltaTimeStep);
    
    
};

#endif /* defined(__GameAsteroids__AnimationController2DTest__) */
