//
//  CollisionResponseBehaviorFactory.mm
//  GameAsteroids
//
//  Created by James Folk on 7/16/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "CollisionResponseBehaviorFactory.h"

#include "LuaCollisionResponseBehavior.h"

//#include "FinishLevelCollisionResponseBehavior.h"
//#include "MazePickupCollisionResponseBehavior.h"
//#include "PlayerCollisionResponseBehavior.h"
//#include "SwitchToEvadeCollisionResponseBehavior.h"
//
//#include "GGJPursueCollisionResponse.h"
//#include "GGJEvadeCollisionResponse.h"
//#include "GGJDyingCollisionResponse.h"

//void	CollisionResponseBehaviorFactory::setCurrentLuaEntity(BaseEntity* entity)
//{
//    m_CurrentCollisionEntity = entity;
//}
//const BaseEntity*	CollisionResponseBehaviorFactory::getCurrentLuaEntity() const
//{
//    return m_CurrentCollisionEntity;
//}

BaseCollisionResponseBehavior *CollisionResponseBehaviorFactory::ctor(BaseCollisionResponseBehaviorInfo *constructionInfo)
{
    BaseCollisionResponseBehavior *pBehavior = NULL;
    
    switch(constructionInfo->m_Type)
    {
        case CollisionResponseBehaviorTypes_Base:
        {
            pBehavior = new BaseCollisionResponseBehavior(*constructionInfo);
        }
            break;
        case CollisionResponseBehaviorTypes_Lua:
        {
            LuaCollisionResponseBehaviorInfo *info = dynamic_cast<LuaCollisionResponseBehaviorInfo*>(constructionInfo);
            LuaCollisionResponseBehavior *pB = new LuaCollisionResponseBehavior(*info);
            pBehavior = pB;
        }
            break;
            
        default:
            btAssert(true);
            break;
    }
    
    return pBehavior;
}

BaseCollisionResponseBehavior *CollisionResponseBehaviorFactory::ctor(int type)
{
    BaseCollisionResponseBehavior *pBehavior = NULL;
    
    switch(type)
    {
        default:case CollisionResponseBehaviorTypes_Base:
        {
            pBehavior = new BaseCollisionResponseBehavior();
        }
        break;
        case CollisionResponseBehaviorTypes_Lua:
        {
            LuaCollisionResponseBehavior *pB = new LuaCollisionResponseBehavior();
            pBehavior = pB;
        }
        break;
    }
    
    return pBehavior;
}

void CollisionResponseBehaviorFactory::dtor(BaseCollisionResponseBehavior *object)
{
    delete object;
    object = NULL;
}