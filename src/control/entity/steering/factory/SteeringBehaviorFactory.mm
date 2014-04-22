//
//  SteeringBehaviorFactory.cpp
//  GameAsteroids
//
//  Created by James Folk on 3/15/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "SteeringBehaviorFactory.h"
//#include "SteeringBehavior.h"
#include "WeightedSteeringBehavior.h"

BaseEntitySteeringBehavior *SteeringBehaviorFactory::createSteeringBehavior(SteeringBehaviorInfo *constructionInfo)
{
    BaseEntitySteeringBehavior *pSteeringBehavior = NULL;
    
    switch (constructionInfo->m_Type)
    {
        case SteeringBehaviorTypes_NONE:
        {
            pSteeringBehavior = NULL;
        }
            break;
//        case SteeringBehaviorTypes_TEMP:
//        {
//            pSteeringBehavior = new SteeringBehavior(*constructionInfo);
//        }
//            break;
        case SteeringBehaviorTypes_Weighted:
        {
            WeightedSteeringBehaviorInfo *info = static_cast<WeightedSteeringBehaviorInfo*>(constructionInfo);
            pSteeringBehavior = new WeightedSteeringBehavior(*info);
        }
        default:
            break;
    }
    return pSteeringBehavior;
}

BaseEntitySteeringBehavior *SteeringBehaviorFactory::ctor(SteeringBehaviorInfo *constructionInfo)
{
    return createSteeringBehavior(constructionInfo);
}
BaseEntitySteeringBehavior *SteeringBehaviorFactory::ctor(int type)
{
    BaseEntitySteeringBehavior *pSteeringBehavior = NULL;
    
    switch (type)
    {
        default:case SteeringBehaviorTypes_Weighted:
        {
            pSteeringBehavior = new WeightedSteeringBehavior();
        }
        break;
    }
    
    return pSteeringBehavior;
}

void SteeringBehaviorFactory::dtor(BaseEntitySteeringBehavior *object)
{
    delete object;
    object = NULL;
}
