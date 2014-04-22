//
//  AnimationControllerFactory.cpp
//  GameAsteroids
//
//  Created by James Folk on 3/15/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "AnimationControllerFactory.h"
#include "BaseEntityAnimationController.h"
//#include "AnimationController.h"
#include "AnimationController2DTest.h"

BaseEntityAnimationController *AnimationControllerFactory::createAnimationController(AnimationControllerInfo *constructionInfo)
{
    BaseEntityAnimationController *pBaseAnimationController = NULL;
    
    switch (constructionInfo->m_Type)
    {
        case AnimationControllerTypes_NONE:
            pBaseAnimationController = NULL;
            break;
//        case AnimationControllerTypes_TEMP:
//        {
//            AnimationController *pAnimationController = new AnimationController(*constructionInfo);
//            pBaseAnimationController = pAnimationController;
//        }
//            break;
        case AnimationControllerTypes_2DTEST:
        {
            AnimationController2DTest *pAnimationController2DTest = new AnimationController2DTest(*constructionInfo);
            pBaseAnimationController = pAnimationController2DTest;
        }
            break;
        default:
            break;
    }
    return pBaseAnimationController;
}

BaseEntityAnimationController *AnimationControllerFactory::ctor(AnimationControllerInfo *constructionInfo)
{
    return createAnimationController(constructionInfo);
}

BaseEntityAnimationController *AnimationControllerFactory::ctor(int type)
{
    return NULL;
}
void AnimationControllerFactory::dtor(BaseEntityAnimationController *object)
{
    delete object;
}

