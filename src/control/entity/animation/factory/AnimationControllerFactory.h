//
//  AnimationControllerFactory.h
//  GameAsteroids
//
//  Created by James Folk on 3/15/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__AnimationControllerFactory__
#define __GameAsteroids__AnimationControllerFactory__

#include "AbstractFactory.h"
#include "AnimationControllerFactoryIncludes.h"

class BaseEntityAnimationController;
class AnimationControllerFactory;

class AnimationControllerFactory :
public AbstractFactory<AnimationControllerFactory, AnimationControllerInfo, BaseEntityAnimationController>
{
    friend class AbstractSingleton;
    
    BaseEntityAnimationController *createAnimationController(AnimationControllerInfo *constructionInfo);
    
    AnimationControllerFactory(){}
    virtual ~AnimationControllerFactory(){}
protected:
    virtual BaseEntityAnimationController *ctor(AnimationControllerInfo *constructionInfo);
    virtual BaseEntityAnimationController *ctor(int type = 0);
    virtual void dtor(BaseEntityAnimationController *object);
};

#endif /* defined(__GameAsteroids__AnimationControllerFactory__) */
