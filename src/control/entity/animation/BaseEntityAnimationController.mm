//
//  BaseEntityAnimationController.cpp
//  GameAsteroids
//
//  Created by James Folk on 3/11/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "BaseEntityAnimationController.h"
#include "BaseEntity.h"

BaseEntityAnimationController::BaseEntityAnimationController(const AnimationControllerInfo &constructionInfo):
AbstractBehavior<BaseEntity>(NULL),
m_AnimationControllerInfo(constructionInfo)
{
    
}

BaseEntityAnimationController::~BaseEntityAnimationController()
{
    if(getOwner())
        getOwner()->setAnimationControllerID(0);
}

const AnimationControllerInfo &BaseEntityAnimationController::getAnimationControllerInfo()const
{
    return m_AnimationControllerInfo;
}