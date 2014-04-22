//
//  WeightedSteeringBehavior.h
//  GameAsteroids
//
//  Created by James Folk on 3/30/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__WeightedWeightedSteeringBehavior__
#define __GameAsteroids__WeightedWeightedSteeringBehavior__

#include "BaseEntitySteeringBehavior.h"

class WeightedSteeringBehavior : public BaseEntitySteeringBehavior
{
public:
    WeightedSteeringBehavior();
    WeightedSteeringBehavior(const WeightedSteeringBehaviorInfo &constructionInfo);
    virtual ~WeightedSteeringBehavior();
    
    virtual btVector3 sumLinearSteering();
    virtual btVector3 sumAngularSteering();
};

#endif /* defined(__GameAsteroids__WeightedWeightedSteeringBehavior__) */
