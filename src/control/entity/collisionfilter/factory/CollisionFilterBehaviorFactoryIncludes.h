//
//  CollisionFilterBehaviorFactoryIncludes.h
//  GameAsteroids
//
//  Created by James Folk on 7/19/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef GameAsteroids_CollisionFilterBehaviorFactoryIncludes_h
#define GameAsteroids_CollisionFilterBehaviorFactoryIncludes_h

enum CollisionFilterBehaviorTypes
{
    CollisionFilterBehaviorTypes_NONE,
    CollisionFilterBehaviorTypes_Base,
    
    CollisionFilterBehaviorTypes_FinishLevel,
    CollisionFilterBehaviorTypes_Player,
    CollisionFilterBehaviorTypes_MazePickup,
    
    CollisionFilterBehaviorTypes_GGJObject,
    CollisionFilterBehaviorTypes_GGJPlayer,
    CollisionFilterBehaviorTypes_GGJCone,
    CollisionFilterBehaviorTypes_GGJPlane,
    
    CollisionFilterBehaviorTypes_MAX
};

struct CollisionFilterBehaviorInfo
{
    CollisionFilterBehaviorTypes m_Type;
    
    CollisionFilterBehaviorInfo(CollisionFilterBehaviorTypes type = CollisionFilterBehaviorTypes_Base):m_Type(type){}
    virtual ~CollisionFilterBehaviorInfo(){}
};

#endif
