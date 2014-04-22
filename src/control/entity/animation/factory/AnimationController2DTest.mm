//
//  AnimationController2DTest.cpp
//  GameAsteroids
//
//  Created by James Folk on 5/6/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "AnimationController2DTest.h"

#include "BaseEntity.h"

AnimationController2DTest::AnimationController2DTest(const AnimationControllerInfo &constructionInfo) :
BaseEntityAnimationController(constructionInfo)
{
    
}
AnimationController2DTest::~AnimationController2DTest()
{
    
}

void AnimationController2DTest::update(btScalar deltaTimeStep)
{
//    BaseSpriteView *pBaseSpriteView = BaseSpriteView::upcast(getOwner()->getVBO());
//    
//    if(pBaseSpriteView)
//    {
//        BaseSpriteViewInfo info = pBaseSpriteView->getSpriteInfo();
//        float xplus = info.getXOffset();
//        float yplus = info.getYOffset();
//        if(xplus + info.getWidth() >= info.getTextureWidth())
//        {
//            xplus = 0.0f;
//            if(yplus + info.getHeight() >= info.getTextureHeight())
//            {
//                yplus = 0.0f;
//            }
//            else
//            {
//                yplus += info.getHeight();
//            }
//        }
//        else
//        {
//            xplus += info.getWidth();
//        }
//        info.setXOffset(xplus);
//        info.setYOffset(yplus);
//        pBaseSpriteView->setSpriteInfo(info);
//    }
    
#if defined(DEBUG) || defined (_DEBUG)
    //NSLog(@"Animation\n");
#endif
}