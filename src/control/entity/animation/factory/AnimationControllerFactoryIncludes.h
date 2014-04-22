//
//  AnimationControllerFactoryIncludes.h
//  GameAsteroids
//
//  Created by James Folk on 3/15/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef GameAsteroids_AnimationControllerFactoryIncludes_h
#define GameAsteroids_AnimationControllerFactoryIncludes_h

enum AnimationControllerTypes
{
    AnimationControllerTypes_NONE,
    //AnimationControllerTypes_TEMP,
    AnimationControllerTypes_2DTEST,
    AnimationControllerTypes_MAX
};

struct AnimationControllerInfo
{
    AnimationControllerTypes m_Type;
    
    AnimationControllerInfo(){}
    
    int value()const
    {
        return m_Type;
    }
    
    bool operator() (const AnimationControllerInfo& lhs, const AnimationControllerInfo& rhs) const{return lhs.value()<rhs.value();}
};

#endif
