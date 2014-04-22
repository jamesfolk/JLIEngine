//
//  LuaUpdateBehavior.cpp
//  MazeADay
//
//  Created by James Folk on 2/19/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#include "LuaUpdateBehavior.h"
#include "LuaVM.h"
#include "UpdateBehaviorFactory.h"
#include "BaseViewObject.h"

LuaUpdateBehavior::LuaUpdateBehavior() :
BaseUpdateBehavior()//,
//m_LuaFunctionName("UpdateBehavior")
{
    setName("UpdateBehavior");
}

LuaUpdateBehavior::LuaUpdateBehavior(const LuaUpdateBehaviorInfo& constructionInfo):
BaseUpdateBehavior(constructionInfo)//,
//m_LuaFunctionName(constructionInfo.m_LuaFunctionName)
{
    
}

LuaUpdateBehavior::~LuaUpdateBehavior()
{
    
}
void LuaUpdateBehavior::update(BaseEntity *owner, btCollisionWorld* collisionWorld, btScalar deltaTimeStep)
{
    BaseUpdateBehavior::update(owner, collisionWorld, deltaTimeStep);

    LuaVM::getInstance()->execute(getName(), getOwner(), collisionWorld, deltaTimeStep);
}

//void LuaUpdateBehavior::setLuaFunctionName(const std::string &functionName)
//{
//    m_LuaFunctionName = functionName;
//}
