//
//  SteeringEntity.cpp
//  GameAsteroids
//
//  Created by James Folk on 4/9/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "SteeringEntity.h"

#include "SteeringBehaviorFactory.h"
#include "EntityStateMachine.h"
#include "BaseEntityAnimationController.h"
#include "AbstractFactoryIncludes.h"



/*
 the steering behavior is attached to the motionstate. thus the motion state must not be
 null if there is going to be a steering behavior.
 */
SteeringEntity::SteeringEntity( const SteeringEntityInfo& constructionInfo) :
RigidEntity(constructionInfo),
m_MaxLinearSpeed(std::numeric_limits<btScalar>::max()),
m_MaxLinearForce(std::numeric_limits<btScalar>::max()),
m_MaxAngularSpeed(std::numeric_limits<btScalar>::max()),
m_MaxAngularForce(std::numeric_limits<btScalar>::max()),
m_WanderInfo(new WanderInfo(constructionInfo.m_WanderInfo)),
m_FollowPathInfo(new FollowPathInfo(constructionInfo.m_FollowPathInfo)),
m_SteeringFlags(0),
m_PursueTargetID(0)
{
    setSteeringBehavior(constructionInfo.m_steeringBehaviorFactoryID);
    
    if(getAnimationController())
        getAnimationController()->setOwner(this);
    
    if(getStateMachine())
        getStateMachine()->setOwner(this);
    
    if(getSteeringBehavior())
        getSteeringBehavior()->setOwner(this);
    
    if(getRigidBody())
        getRigidBody()->setActivationState(DISABLE_DEACTIVATION);
}

SteeringEntity::SteeringEntity() :
RigidEntity(),
m_MaxLinearSpeed(std::numeric_limits<btScalar>::max()),
m_MaxLinearForce(std::numeric_limits<btScalar>::max()),
m_MaxAngularSpeed(std::numeric_limits<btScalar>::max()),
m_MaxAngularForce(std::numeric_limits<btScalar>::max()),
m_WanderInfo(new WanderInfo()),
m_FollowPathInfo(new FollowPathInfo()),
m_SteeringFlags(0),
m_PursueTargetID(0)
{
    
}

SteeringEntity::~SteeringEntity()
{
    delete m_FollowPathInfo;
    m_FollowPathInfo = NULL;
    
    delete m_WanderInfo;
    m_WanderInfo = NULL;
}








void SteeringEntity::setup(IDType collisionShapeID,
           btScalar mass,
           const btVector3 &origin,
           const btQuaternion &rotation,
           CollisionMask group,
           CollisionMask mask)
{
    RigidEntity::setup(collisionShapeID,
                       mass,
                       origin,
                       rotation,
                       group,
                       mask);
    
    getRigidBody()->setActivationState(DISABLE_DEACTIVATION);
}





btTransform SteeringEntity::getWorldTransform() const
{
    return RigidEntity::getWorldTransform();
}
void SteeringEntity::setWorldTransform(const btTransform& worldTrans)
{
    RigidEntity::setWorldTransform(worldTrans);
}

void SteeringEntity::updateAction( btCollisionWorld* collisionWorld, btScalar deltaTimeStep)
{
    RigidEntity::updateAction(collisionWorld, deltaTimeStep);
    
    if(getSteeringBehavior())
    {
//        btVector3 impulse;
        getSteeringBehavior()->calculate(this, deltaTimeStep);
        
//        impulse = getSteeringBehavior()->getLinearImpulse();
//        getRigidBody()->applyCentralImpulse(impulse);
//        
//        impulse = getSteeringBehavior()->getAngularImpulse();
//        getRigidBody()->applyTorqueImpulse(impulse);
    }
}
void SteeringEntity::debugDraw(btIDebugDraw* debugDrawer)
{
    if(getSteeringBehavior())
    {
        getSteeringBehavior()->debugDraw(this, debugDrawer);
    }
}

const BaseEntitySteeringBehavior*	SteeringEntity::getSteeringBehavior() const
{
    return SteeringBehaviorFactory::getInstance()->get(m_steeringBehaviorFactoryID);
}

BaseEntitySteeringBehavior*	SteeringEntity::getSteeringBehavior()
{
    return SteeringBehaviorFactory::getInstance()->get(m_steeringBehaviorFactoryID);
}

void SteeringEntity::setSteeringBehavior(const IDType ID)
{
    m_steeringBehaviorFactoryID = ID;
    
    if(getSteeringBehavior())
        getSteeringBehavior()->setOwner(this);
}


btScalar SteeringEntity::getMaxLinearSpeed()const
{
    return m_MaxLinearSpeed;
}
void SteeringEntity::setMaxLinearSpeed(const btScalar new_speed)
{
    m_MaxLinearSpeed = new_speed;
}
btScalar SteeringEntity::getMaxAngularSpeed()const
{
    return m_MaxAngularSpeed;
}
void SteeringEntity::setMaxAngularSpeed(const btScalar new_speed)
{
    m_MaxAngularSpeed = new_speed;
}
btScalar SteeringEntity::getMaxLinearForce()const
{
    return m_MaxLinearForce;
}
void SteeringEntity::setMaxLinearForce(const btScalar force)
{
    m_MaxLinearForce = force;
}
btScalar SteeringEntity::getMaxAngularForce()const
{
    return m_MaxAngularForce;
}
void SteeringEntity::setMaxAngularForce(const btScalar max_force)
{
    m_MaxAngularForce = max_force;
}

SteeringEntity::WallAvoidanceFunction::WallAvoidanceFunction() :
m_From(),
m_To(),
m_DistToClosestIP(std::numeric_limits<btScalar>::max()),
m_ClosestWall(NULL),
m_ClosestPoint(std::numeric_limits<btScalar>::max(),
			   std::numeric_limits<btScalar>::max(),
			   std::numeric_limits<btScalar>::max())
{
}
SteeringEntity::WallAvoidanceFunction::~WallAvoidanceFunction()
{
}

void SteeringEntity::WallAvoidanceFunction::SetFrom(const btVector3 &from)
{
	m_From = from;
}
void SteeringEntity::WallAvoidanceFunction::SetTo(const btVector3 &to)
{
	m_To = to;
}
void SteeringEntity::WallAvoidanceFunction::Set(const btVector3 &from, const btVector3 &to)
{
	SetFrom(from);
	SetTo(to);
}

void SteeringEntity::WallAvoidanceFunction::operator() (BaseEntity *plane)
{
//	btVector3 point;
//	
//	if(planeLineIntersection(plane->getOrigin(), plane->getNormalVector(), m_From, m_To, &point))
//	{
//		btScalar DistToThisIP = m_From.distance(point);
//		
//		if (DistToThisIP < m_DistToClosestIP)
//		{
//			m_DistToClosestIP = DistToThisIP;
//			
//			m_ClosestWall = plane;
//			
//			m_ClosestPoint = point;
//		}
//	}
}

btVector3 SteeringEntity::WallAvoidanceFunction::GetClosestPoint()
{
	return m_ClosestPoint;
}
const BaseEntity *SteeringEntity::WallAvoidanceFunction::GetClosestWall()
{
	return m_ClosestWall;
}

bool SteeringEntity::accumulateLinearForce(btVector3 &runningTotal, const btVector3 &forceToAdd)
{
    return accumlateForce(runningTotal, forceToAdd, getMaxLinearForce());
}
bool SteeringEntity::accumulateAngularForce(btVector3 &runningTotal, const btVector3 &forceToAdd)
{
    return accumlateForce(runningTotal, forceToAdd, getMaxAngularForce());
}

bool SteeringEntity::accumlateForce(btVector3 &runningTotal, const btVector3 &forceToAdd, const btScalar maxForce)
{
    //calculate how much steering force the vehicle has used so far
    btScalar MagnitudeSoFar = runningTotal.length();
    
    //calculate how much steering force remains to be used by this vehicle
    btScalar MagnitudeRemaining = maxForce - MagnitudeSoFar;
    
    //return false if there is no more force left to use
    if (MagnitudeRemaining <= 0.0) return false;
    
    //calculate the magnitude of the force we want to add
    btScalar MagnitudeToAdd = forceToAdd.length();
    
    if(isnan(MagnitudeToAdd))return false;
    
    if(isinf(MagnitudeToAdd))
        MagnitudeToAdd = MagnitudeRemaining;
    
    //if the magnitude of the sum of forceToAdd and the running total
    //does not exceed the maximum force available to this vehicle, just
    //add together. Otherwise add as much of the forceToAdd vector is
    //possible without going over the max.
    if (MagnitudeToAdd < MagnitudeRemaining ||
        forceToAdd.isZero())
    {
        runningTotal += forceToAdd;
    }
    
    else
    {
        //add it to the steering force
        runningTotal += (forceToAdd.normalized() * MagnitudeRemaining);
    }
    
    return true;
}

//bool SteeringEntity::accumulateLinearForce(btVector3 &RunningTot, const btVector3 &ForceToAdd)
//{
//    
//    //calculate how much steering force the vehicle has used so far
//    btScalar MagnitudeSoFar = RunningTot.length();
//    
//    //calculate how much steering force remains to be used by this vehicle
//    btScalar MagnitudeRemaining = getMaxLinearForce() - MagnitudeSoFar;
//    
//    //return false if there is no more force left to use
//    if (MagnitudeRemaining <= 0.0) return false;
//    
//    //calculate the magnitude of the force we want to add
//    btScalar MagnitudeToAdd = ForceToAdd.length();
//    
//    if(isnan(MagnitudeToAdd))return false;
//    
//    if(isinf(MagnitudeToAdd))
//        MagnitudeToAdd = MagnitudeRemaining;
//    
//    //if the magnitude of the sum of ForceToAdd and the running total
//    //does not exceed the maximum force available to this vehicle, just
//    //add together. Otherwise add as much of the ForceToAdd vector is
//    //possible without going over the max.
//    if (MagnitudeToAdd < MagnitudeRemaining ||
//        ForceToAdd.isZero())
//    {
//        RunningTot += ForceToAdd;
//    }
//    
//    else
//    {
//        //add it to the steering force
//        RunningTot += (ForceToAdd.normalized() * MagnitudeRemaining);
//    }
//    
//    return true;
//}
//
//bool SteeringEntity::accumulateAngularForce(btVector3 &runningTotal, const btVector3 &forceToAdd)
//{
//    
//    //calculate how much steering force the vehicle has used so far
//    btScalar MagnitudeSoFar = runningTotal.length();
//    
//    //calculate how much steering force remains to be used by this vehicle
//    btScalar MagnitudeRemaining = getMaxAngularForce() - MagnitudeSoFar;
//    
//    //return false if there is no more force left to use
//    if (MagnitudeRemaining <= 0.0) return false;
//    
//    //calculate the magnitude of the force we want to add
//    btScalar MagnitudeToAdd = forceToAdd.length();
//    
//    if(isnan(MagnitudeToAdd) || isinf(MagnitudeToAdd))return false;
//    
//    //if the magnitude of the sum of ForceToAdd and the running total
//    //does not exceed the maximum force available to this vehicle, just
//    //add together. Otherwise add as much of the ForceToAdd vector is
//    //possible without going over the max.
//    if (MagnitudeToAdd < MagnitudeRemaining ||
//        forceToAdd.isZero())
//    {
//        runningTotal += forceToAdd;
//    }
//    
//    else
//    {
//        //add it to the steering force
//        runningTotal += (forceToAdd.normalized() * MagnitudeRemaining);
//    }
//    
//    return true;
//}

bool accumulateLinearForce(btVector3 &RunningTot, const btVector3 &ForceToAdd);
bool accumulateAngularForce(btVector3 &runningTotal, const btVector3 &forceToAdd);