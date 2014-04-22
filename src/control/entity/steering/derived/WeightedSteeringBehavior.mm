//
//  WeightedSteeringBehavior.mm
//  GameAsteroids
//
//  Created by James Folk on 3/30/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "WeightedSteeringBehavior.h"

#include "btBulletDynamicsCommon.h"
#include "SteeringEntity.h"


WeightedSteeringBehavior::WeightedSteeringBehavior():
BaseEntitySteeringBehavior()
{
    
}

WeightedSteeringBehavior::WeightedSteeringBehavior(const WeightedSteeringBehaviorInfo &constructionInfo) :
BaseEntitySteeringBehavior(constructionInfo)
{
    
}
WeightedSteeringBehavior::~WeightedSteeringBehavior()
{
    
}

btVector3 WeightedSteeringBehavior::sumLinearSteering()
{
    btVector3 steering;
    steering.setZero();
    
//    accumulateLinearForce(steering,
//                          getDirectLinearImpulse());
//    if(isSeekOn())
//        accumulateLinearForce(steering,
//                              Seek(getSeekPosition()));
//    
//    if(isArriveOn())
//        accumulateLinearForce(steering,
//                              Arrive(getArrivePosition(), Deceleration_Fast));
//    
//    if(isWanderOn())
//        accumulateLinearForce(steering,
//                              Wander());
    
    if(getOwner() &&
       getOwner()->IsOn(BehaviorType_Pursuit) &&
       getOwner()->getPursuitTarget())
    {
        getOwner()->accumulateLinearForce(steering, Pursuit(getOwner()->getPursuitTarget()));
    }
    
//    if(isEvadeOn())
//        accumulateLinearForce(steering,
//                              Evade(getEvadeTarget()));
//    
//    if(isOffsetPursuitOn())
//        accumulateLinearForce(steering,
//                              OffsetPursuit(getOffsetPursuitTarget(),
//                                            getOffsetPursuitOffset()));
//    
//    if(isFollowPathOn())
//        accumulateLinearForce(steering, FollowPath());
    
    return steering;
}

btVector3 WeightedSteeringBehavior::sumAngularSteering()
{
    btVector3 currentAngular;
    currentAngular.setZero();
    
//    accumulateLinearForce(currentAngular, getDirectAngularImpulse());
    
    return currentAngular;
}