//
//  EntityStateFactory.cpp
//  MazeADay
//
//  Created by James Folk on 1/26/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#include "EntityStateFactory.h"

//#include "ObjectFallState.h"
//#include "GGJPursueState.h"
//#include "GGJEvadeState.h"
#include "LuaEntityState.h"

BaseEntityState *EntityStateFactory::ctor(BaseEntityStateInfo *constructionInfo)
{
    BaseEntityState *pBaseEntityState = NULL;
    
    switch(constructionInfo->gametype)
    {
        case EntityStateType_Lua:
        {
            LuaEntityState *p = new LuaEntityState();
            pBaseEntityState = p;
        }
            break;
    }
    
    return pBaseEntityState;
}

BaseEntityState *EntityStateFactory::ctor(int type)
{
    BaseEntityState *pBaseEntityState = NULL;
    
    switch(type)
    {
        default:case EntityStateType_Lua:
        {
            LuaEntityState *p = new LuaEntityState();
            pBaseEntityState = p;
        }
            break;
    }
    
    return pBaseEntityState;
}

void EntityStateFactory::dtor(BaseEntityState *object)
{
    delete object;
}