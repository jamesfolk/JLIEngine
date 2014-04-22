//
//  LuaEntityState.cpp
//  MazeADay
//
//  Created by James Folk on 2/27/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#include "LuaEntityState.h"
#include "LuaVM.h"

LuaEntityState::LuaEntityState()
{
    
}
LuaEntityState::~LuaEntityState()
{
    
}
void LuaEntityState::enter(BaseEntity *entity)
{
    LuaVM::getInstance()->execute(entity->getName() + getName() + std::string("EnterState"), entity);
}
void LuaEntityState::update(BaseEntity *entity, btScalar deltaTimeStep)
{
    
    LuaVM::getInstance()->execute(entity->getName() + getName() + std::string("UpdateState"),
                                  entity, deltaTimeStep);
}
void LuaEntityState::exit(BaseEntity *entity)
{
    LuaVM::getInstance()->execute(entity->getName() + getName() + std::string("ExitState"), entity);
}
bool LuaEntityState::onMessage(BaseEntity *entity, const Telegram &telegram)
{   
    bool ret = false;
    
    LuaVM::getInstance()->execute(entity->getName() + getName() + std::string("OnMessage"), entity, telegram, ret);
    
    return ret;
}