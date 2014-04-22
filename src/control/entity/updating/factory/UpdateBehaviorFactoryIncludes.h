//
//  UpdateBehaviorFactoryIncludes.h
//  GameAsteroids
//
//  Created by James Folk on 7/16/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef GameAsteroids_UpdateBehaviorFactoryIncludes_h
#define GameAsteroids_UpdateBehaviorFactoryIncludes_h

#include <string>

enum UpdateBehaviorTypes
{
    UpdateBehaviorTypes_NONE,
    UpdateBehaviorTypes_Base,
    UpdateBehaviorTypes_Lua,
    
//    UpdateBehaviorTypes_Player,
//    UpdateBehaviorTypes_Object,
    
    UpdateBehaviorTypes_MAX
};

struct UpdateBehaviorInfo
{
    UpdateBehaviorTypes m_Type;
    
    UpdateBehaviorInfo(UpdateBehaviorTypes type = UpdateBehaviorTypes_Base) : m_Type(type){}
    virtual ~UpdateBehaviorInfo(){}
};

struct LuaUpdateBehaviorInfo : public UpdateBehaviorInfo
{
    std::string m_LuaFunctionName;
    
    LuaUpdateBehaviorInfo():
    UpdateBehaviorInfo(),
    m_LuaFunctionName("defaultUpdateBehavior")
    {
        m_Type = UpdateBehaviorTypes_Lua;
    }
    
    virtual ~LuaUpdateBehaviorInfo(){}
};

#endif
