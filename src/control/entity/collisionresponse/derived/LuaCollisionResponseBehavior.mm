//
//  LuaCollisionResponseBehavior.cpp
//  MazeADay
//
//  Created by James Folk on 2/17/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#include "LuaCollisionResponseBehavior.h"
#include "CollisionResponseBehaviorFactory.h"
#include "LuaVM.h"

LuaCollisionResponseBehavior::LuaCollisionResponseBehavior() :
BaseCollisionResponseBehavior()
{
    m_type = CollisionResponseBehaviorTypes_Lua;
}

LuaCollisionResponseBehavior::LuaCollisionResponseBehavior(const LuaCollisionResponseBehaviorInfo& constructionInfo) :
BaseCollisionResponseBehavior(constructionInfo)
{
    m_type = CollisionResponseBehaviorTypes_Lua;
}

LuaCollisionResponseBehavior::~LuaCollisionResponseBehavior()
{
    
}

void LuaCollisionResponseBehavior::respond(BaseEntity *owner, BaseEntity *pOtherEntity, const btManifoldPoint &pt)
{
    BaseCollisionResponseBehavior::respond(owner, pOtherEntity, pt);
    
    LuaVM::getInstance()->execute(getName(), getOwner(), pOtherEntity, pt);
}
