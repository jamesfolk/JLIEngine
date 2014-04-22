//
//  UpdateBehaviorFactory.cpp
//  GameAsteroids
//
//  Created by James Folk on 7/16/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "UpdateBehaviorFactory.h"
#include "LuaUpdateBehavior.h"

//#include "PlayerUpdateBehavior.h"
//#include "ObjectUpdateBehavior.h"

BaseUpdateBehavior *UpdateBehaviorFactory::ctor(UpdateBehaviorInfo *constructionInfo)
{
    BaseUpdateBehavior *pBehavior = NULL;
    
    switch(constructionInfo->m_Type)
    {
        case UpdateBehaviorTypes_Base:
            pBehavior = new BaseUpdateBehavior(*constructionInfo);
            break;
        default:
            btAssert(true);
            break;
        case UpdateBehaviorTypes_Lua:
        {
            LuaUpdateBehaviorInfo *info = dynamic_cast<LuaUpdateBehaviorInfo*>(constructionInfo);
            LuaUpdateBehavior *pB = new LuaUpdateBehavior(*info);
            pBehavior = pB;
        }
            break;
//        case UpdateBehaviorTypes_Player:
//        {
//            PlayerUpdateBehaviorInfo *info = dynamic_cast<PlayerUpdateBehaviorInfo*>(constructionInfo);
//            PlayerUpdateBehavior *pB = new PlayerUpdateBehavior(*info);
//            pBehavior = pB;
//        }
//            break;
//        case UpdateBehaviorTypes_Object:
//        {
//            ObjectUpdateBehaviorInfo *info = dynamic_cast<ObjectUpdateBehaviorInfo*>(constructionInfo);
//            ObjectUpdateBehavior *pB = new ObjectUpdateBehavior(*info);
//            pBehavior = pB;
//        }
//            break;
    }
    return pBehavior;
}

BaseUpdateBehavior *UpdateBehaviorFactory::ctor(int type)
{
    BaseUpdateBehavior *pBehavior = NULL;
    
    switch(type)
    {
        default:case UpdateBehaviorTypes_Base:
            pBehavior = new BaseUpdateBehavior();
            break;
        case UpdateBehaviorTypes_Lua:
        {
            LuaUpdateBehavior *pB = new LuaUpdateBehavior();
            pBehavior = pB;
        }
            break;
    }
    
    return pBehavior;
}
void UpdateBehaviorFactory::dtor(BaseUpdateBehavior *object)
{
    delete object;
    object = NULL;
}

//void	UpdateBehaviorFactory::setCurrentLuaEntity(BaseEntity* entity)
//{
//    m_pCurrentLuaEntity = entity;
//}
//const BaseEntity*	UpdateBehaviorFactory::getCurrentLuaEntity() const
//{
//    return m_pCurrentLuaEntity;
//}