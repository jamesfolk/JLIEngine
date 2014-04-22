//
//  CollisionFilterBehaviorFactory.cpp
//  GameAsteroids
//
//  Created by James Folk on 7/19/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "CollisionFilterBehaviorFactory.h"

#include "FinishLevelCollisionFilterBehavior.h"
#include "PlayerCollisionFilterBehavior.h"
#include "MazePickupCollisionFilterBehavior.h"

#include "GGJConeCollisionFilterBehavior.h"
#include "GGJObjectCollisionFilterBehavior.h"
#include "GGJPlaneCollisionFilterBehavior.h"
#include "GGJPlayerCollisionFilterBehavior.h"

BaseCollisionFilterBehavior *CollisionFilterBehaviorFactory::ctor(CollisionFilterBehaviorInfo *constructionInfo)
{
    BaseCollisionFilterBehavior *pBehavior = NULL;
    
    switch(constructionInfo->m_Type)
    {
        case CollisionFilterBehaviorTypes_Base:
        {
            pBehavior = new BaseCollisionFilterBehavior(*constructionInfo);
        }
            break;
        case CollisionFilterBehaviorTypes_FinishLevel:
        {
            FinishLevelFilterBehaviorInfo *info = dynamic_cast<FinishLevelFilterBehaviorInfo*>(constructionInfo);
            FinishLevelCollisionFilterBehavior *pB = new FinishLevelCollisionFilterBehavior(*info);
            pBehavior = pB;
        }
            break;
        case CollisionFilterBehaviorTypes_Player:
        {
            PlayerFilterBehaviorInfo *info = dynamic_cast<PlayerFilterBehaviorInfo*>(constructionInfo);
            PlayerCollisionFilterBehavior *pB = new PlayerCollisionFilterBehavior(*info);
            pBehavior = pB;
        }
            break;
        case CollisionFilterBehaviorTypes_MazePickup:
        {
            MazePickupFilterBehaviorInfo *info = dynamic_cast<MazePickupFilterBehaviorInfo*>(constructionInfo);
            MazePickupCollisionFilterBehavior *pB = new MazePickupCollisionFilterBehavior(*info);
            pBehavior = pB;
        }
            break;
            
        case CollisionFilterBehaviorTypes_GGJObject:
        {
            GGJObjectFilterBehaviorInfo *info = dynamic_cast<GGJObjectFilterBehaviorInfo*>(constructionInfo);
            GGJObjectCollisionFilterBehavior *pB = new GGJObjectCollisionFilterBehavior(*info);
            pBehavior = pB;
        }
            break;
        case CollisionFilterBehaviorTypes_GGJPlayer:
        {
            GGJPlayerFilterBehaviorInfo *info = dynamic_cast<GGJPlayerFilterBehaviorInfo*>(constructionInfo);
            GGJPlayerCollisionFilterBehavior *pB = new GGJPlayerCollisionFilterBehavior(*info);
            pBehavior = pB;
        }
            break;
        case CollisionFilterBehaviorTypes_GGJCone:
        {
            GGJConeFilterBehaviorInfo *info = dynamic_cast<GGJConeFilterBehaviorInfo*>(constructionInfo);
            GGJConeCollisionFilterBehavior *pB = new GGJConeCollisionFilterBehavior(*info);
            pBehavior = pB;
        }
            break;
        case CollisionFilterBehaviorTypes_GGJPlane:
        {
            GGJPlaneFilterBehaviorInfo *info = dynamic_cast<GGJPlaneFilterBehaviorInfo*>(constructionInfo);
            GGJPlaneCollisionFilterBehavior *pB = new GGJPlaneCollisionFilterBehavior(*info);
            pBehavior = pB;
        }
            break;
        default:
            btAssert(true);
            break;
    }
    
    return pBehavior;
}

BaseCollisionFilterBehavior *CollisionFilterBehaviorFactory::ctor(int type)
{
    return NULL;
}

void CollisionFilterBehaviorFactory::dtor(BaseCollisionFilterBehavior *object)
{
    delete object;
    object = NULL;
}
