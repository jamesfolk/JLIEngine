//
//  CollisionResponseBehaviorFactoryIncludes.h
//  GameAsteroids
//
//  Created by James Folk on 7/16/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef GameAsteroids_CollisionResponseBehaviorFactoryIncludes_h
#define GameAsteroids_CollisionResponseBehaviorFactoryIncludes_h

#include <string>

enum CollisionResponseBehaviorTypes
{
    CollisionResponseBehaviorTypes_NONE,
    CollisionResponseBehaviorTypes_Base,
    CollisionResponseBehaviorTypes_Lua,
    
//    CollisionResponseBehaviorTypes_FinishLevel,
//    CollisionResponseBehaviorTypes_MazePickup,
//    CollisionResponseBehaviorTypes_Player,
//    
//    CollisionResponseBehaviorTypes_SwitchToEvade,
//    CollisionResponseBehaviorTypes_GGJPursue,
//    CollisionResponseBehaviorTypes_GGJEvade,
//    CollisionResponseBehaviorTypes_GGJDying,
    
    CollisionResponseBehaviorTypes_MAX
};

struct BaseCollisionResponseBehaviorInfo
{
    CollisionResponseBehaviorTypes m_Type;
    
    BaseCollisionResponseBehaviorInfo():
    m_Type(CollisionResponseBehaviorTypes_Base){}
    
    virtual ~BaseCollisionResponseBehaviorInfo(){}
};

struct LuaCollisionResponseBehaviorInfo : public BaseCollisionResponseBehaviorInfo
{
    std::string m_LuaFunctionName;
    
    LuaCollisionResponseBehaviorInfo():
    BaseCollisionResponseBehaviorInfo(),
    m_LuaFunctionName("defaultCollisionResponse")
    {
        m_Type = CollisionResponseBehaviorTypes_Lua;
    }
    
    virtual ~LuaCollisionResponseBehaviorInfo(){}
};

#endif
