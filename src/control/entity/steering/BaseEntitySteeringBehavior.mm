//
//  BaseEntitySteeringBehavior.cpp
//  GameAsteroids
//
//  Created by James Folk on 3/11/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "BaseEntitySteeringBehavior.h"
#include "SteeringEntity.h"
#include "UtilityFunctions.h"
#include <algorithm>


#include "math.h"

#include "Path.h"
#include "SteeringBehaviorFactory.h"


//HeadingSmoother::HeadingSmoother(const int capacity) :
//m_Average(g_vHeadingVector * (btScalar)capacity),
//m_Capacity(capacity)
//{
//}
//HeadingSmoother::~HeadingSmoother(){}
//
//
//const btVector3 &HeadingSmoother::getHeadingVector()const
//{
//    return m_Average;
//}
//void HeadingSmoother::addHeading(const btVector3 &heading)
//{
//    btVector3 average = m_Average + heading.normalized();
//    average *= 0.5f;
//    
//    if(!isinf(average.getX()) &&
//       !isinf(average.getY()) &&
//       !isinf(average.getZ()) &&
//       !isnan(average.getX()) &&
//       !isnan(average.getY()) &&
//       !isnan(average.getZ()))
//    {
//        m_Average = average;
//    }
//    else
//    {
//        m_Average = (g_vHeadingVector * (btScalar)m_Capacity);
//    }
//    
//    m_Average.normalize();
//}

BaseEntitySteeringBehavior *BaseEntitySteeringBehavior::create(int type)
{
    return SteeringBehaviorFactory::getInstance()->createObject(type);
}
bool BaseEntitySteeringBehavior::destroy(IDType &_id)
{
    return SteeringBehaviorFactory::getInstance()->destroy(_id);
}
bool BaseEntitySteeringBehavior::destroy(BaseEntitySteeringBehavior *entity)
{
    bool ret = false;
    if(entity)
    {
        IDType _id = entity->getID();
        ret = BaseEntitySteeringBehavior::destroy(_id);
    }
    entity = NULL;
    return ret;
}
BaseEntitySteeringBehavior *BaseEntitySteeringBehavior::get(IDType _id)
{
    return SteeringBehaviorFactory::getInstance()->get(_id);
}

BaseEntitySteeringBehavior::BaseEntitySteeringBehavior() :
AbstractBehavior<SteeringEntity>(NULL),
m_iFlags(0),
m_ArriveOrigin(0,0,0),
m_pPursuitTarget(NULL),
m_pEvadeTarget(NULL),
m_pInterposeTarget1(NULL),
m_pInterposeTarget2(NULL),
m_pHideTarget(NULL),
m_pOffsetPursuitTarget(NULL),
m_OffsetPursuitOffset(0, 0, 0),
m_dPanicDistanceSq(100.0f * 100.0f),
m_dDBoxLength(40.0f),
m_pFeelers(new btAlignedObjectArray<btVector3>()),
m_dWallDetectionFeelerLength(10.0f),
m_LinearImpulse(0, 0, 0),
m_AngularImpulse(0, 0, 0),
m_linearFactor(1.0f, 1.0f, 1.0f),
m_DirectLinearImpulse(0, 0, 0),
m_DirectAngularImpulse(0, 0, 0),
m_DirectLinearDamping(btScalar(0.)),
m_DirectAngularDamping(btScalar(0.)),
m_pPath(NULL)
{
    
}

BaseEntitySteeringBehavior::BaseEntitySteeringBehavior(const SteeringBehaviorInfo &constructionInfo) :
AbstractBehavior<SteeringEntity>(NULL),
//m_SteeringBehaviorInfo(constructionInfo),
m_iFlags(0),
m_ArriveOrigin(0,0,0),
m_pPursuitTarget(NULL),
m_pEvadeTarget(NULL),
m_pInterposeTarget1(NULL),
m_pInterposeTarget2(NULL),
m_pHideTarget(NULL),
m_pOffsetPursuitTarget(NULL),
m_OffsetPursuitOffset(0, 0, 0),
m_dPanicDistanceSq(100.0f * 100.0f),
m_dDBoxLength(40.0f),
m_pFeelers(new btAlignedObjectArray<btVector3>()),
m_dWallDetectionFeelerLength(10.0f),
m_LinearImpulse(0, 0, 0),
m_AngularImpulse(0, 0, 0),
m_linearFactor(1.0f, 1.0f, 1.0f),
m_DirectLinearImpulse(0, 0, 0),
m_DirectAngularImpulse(0, 0, 0),
m_DirectLinearDamping(btScalar(0.)),
m_DirectAngularDamping(btScalar(0.)),
m_pPath(NULL)
{
}

BaseEntitySteeringBehavior::~BaseEntitySteeringBehavior()
{
    
    if(getOwner())
        getOwner()->setSteeringBehavior(0);
    
    delete m_pFeelers;
    m_pFeelers = NULL;
}

void BaseEntitySteeringBehavior::calculate(SteeringEntity *owner, btScalar deltaTimeStep)
{
    setOwner(owner);
    
    m_LinearImpulse = sumLinearSteering() * m_linearFactor;
    m_AngularImpulse = sumAngularSteering();
    
    //m_HeadingSmoother.addHeading(getOwner()->getOrigin() + m_LinearImpulse.normalized());
    
//    applyDirectDamping(deltaTimeStep);
    
#if defined(DEBUG) || defined (_DEBUG)
    //NSLog(@"Steering\n");
#endif
    
    getOwner()->getRigidBody()->applyCentralImpulse(m_LinearImpulse);
    getOwner()->getRigidBody()->applyTorqueImpulse(m_AngularImpulse);
}

void BaseEntitySteeringBehavior::debugDraw(SteeringEntity *owner, btIDebugDraw* debugDrawer)
{
    
//    if(isWanderOn())
//    {
//        btVector3 color(1.0f, 1.0f, 0.0f);
//        
//        btVector3 ahead(owner->getLinearVelocityHeading() * owner->getWanderInfo()->getDistance());
//        btVector3 target = owner->getOrigin() + ahead + owner->getWanderInfo()->getTarget();
//        
//        debugDrawer->drawLine(owner->getOrigin(), target, color);
//        debugDrawer->drawSphere(target, owner->getWanderInfo()->getRadius(), color);
//    }
}

//------------------------- ForwardComponent -----------------------------
//
//  returns the forward oomponent of the steering force
//------------------------------------------------------------------------
btScalar BaseEntitySteeringBehavior::getForwardComponent()
{
    return getOwner()->getLinearVelocityHeading().dot(m_LinearImpulse);
}

//--------------------------- SideComponent ------------------------------
//  returns the side component of the steering force
//------------------------------------------------------------------------
btScalar BaseEntitySteeringBehavior::getSideComponent()
{
    return getOwner()->getSideVector().dot(m_LinearImpulse);
}

//const btVector3 &BaseEntitySteeringBehavior::getSmoothedHeadingVector()const
//{
//    return m_HeadingSmoother.getHeadingVector();
//}

bool BaseEntitySteeringBehavior::accumulateLinearForce(btVector3 &RunningTot, const btVector3 &ForceToAdd)
{
    
    //calculate how much steering force the vehicle has used so far
    btScalar MagnitudeSoFar = RunningTot.length();
    
    //calculate how much steering force remains to be used by this vehicle
    btScalar MagnitudeRemaining = getOwner()->getMaxLinearForce() - MagnitudeSoFar;
    
    //return false if there is no more force left to use
    if (MagnitudeRemaining <= 0.0) return false;
    
    //calculate the magnitude of the force we want to add
    btScalar MagnitudeToAdd = ForceToAdd.length();
    
    if(isnan(MagnitudeToAdd))return false;
    
    if(isinf(MagnitudeToAdd))
        MagnitudeToAdd = MagnitudeRemaining;
    
    //if the magnitude of the sum of ForceToAdd and the running total
    //does not exceed the maximum force available to this vehicle, just
    //add together. Otherwise add as much of the ForceToAdd vector is
    //possible without going over the max.
    if (MagnitudeToAdd < MagnitudeRemaining ||
        ForceToAdd.isZero())
    {
        RunningTot += ForceToAdd;
    }
    
    else
    {
        //add it to the steering force
        RunningTot += (ForceToAdd.normalized() * MagnitudeRemaining);
    }
    
    return true;
}

bool BaseEntitySteeringBehavior::accumulateAngularForce(btVector3 &runningTotal, const btVector3 &forceToAdd)
{
    
    //calculate how much steering force the vehicle has used so far
    btScalar MagnitudeSoFar = runningTotal.length();
    
    //calculate how much steering force remains to be used by this vehicle
    btScalar MagnitudeRemaining = getOwner()->getMaxAngularForce() - MagnitudeSoFar;
    
    //return false if there is no more force left to use
    if (MagnitudeRemaining <= 0.0) return false;
    
    //calculate the magnitude of the force we want to add
    btScalar MagnitudeToAdd = forceToAdd.length();
    
    if(isnan(MagnitudeToAdd) || isinf(MagnitudeToAdd))return false;
    
    //if the magnitude of the sum of ForceToAdd and the running total
    //does not exceed the maximum force available to this vehicle, just
    //add together. Otherwise add as much of the ForceToAdd vector is
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

btVector3 BaseEntitySteeringBehavior::Seek(const btVector3 &TargetPos)
{
    btVector3 vDesiredVelocity = TargetPos - getOwner()->getOrigin();
    vDesiredVelocity = vDesiredVelocity.normalize();
    vDesiredVelocity *= getOwner()->getMaxLinearSpeed();
    
    return vDesiredVelocity - getOwner()->getRigidBody()->getLinearVelocity();
    
//    Vector2D DesiredVelocity = Vec2DNormalize(TargetPos - m_pVehicle->Pos())
//    * m_pVehicle->MaxSpeed();
//    
//    return (DesiredVelocity - m_pVehicle->Velocity());
    
    
    
//	btVector3 vDesiredVelocity = (TargetPos - getOwner()->getOrigin());
//    
//	if(!vDesiredVelocity.isZero())
//        vDesiredVelocity.normalize();
//	
//	vDesiredVelocity *= getOwner()->getMaxLinearSpeed();
//    
//	return (vDesiredVelocity - getOwner()->getRigidBody()->getLinearVelocity());
}
//btVector3 BaseEntitySteeringBehavior::Flee(const btVector3 &TargetPos)
//{
//	//only flee if the target is within 'panic distance'. Work in distance
//	//squared space.
//	if (getOwner()->getOrigin().distance2(TargetPos) > m_dPanicDistanceSq)
//	{
//		return btVector3(0.0f, 0.0f, 0.0f);
//	}
//	
//	btVector3 vDesiredVelocity = (getOwner()->getOrigin() - TargetPos);
//    
//	if(!vDesiredVelocity.isZero())
//        vDesiredVelocity.normalize();
//	vDesiredVelocity *= getOwner()->getMaxLinearSpeed();
//    
//	return (vDesiredVelocity - getOwner()->getRigidBody()->getLinearVelocity());
//}

btVector3 BaseEntitySteeringBehavior::Flee(const btVector3 &TargetPos)
{
	//only flee if the target is within 'panic distance'. Work in distance
	//squared space.
	if (getOwner()->getOrigin().distance2(TargetPos) > m_dPanicDistanceSq)
	{
		return btVector3(0.0f, 0.0f, 0.0f);
	}
	
	btVector3 vDesiredVelocity = (getOwner()->getOrigin() - TargetPos);
    
	if(!vDesiredVelocity.isZero())
        vDesiredVelocity.normalize();
	vDesiredVelocity *= getOwner()->getMaxLinearSpeed();
    
	return (vDesiredVelocity - getOwner()->getRigidBody()->getLinearVelocity());
}

//--------------------------- Arrive -------------------------------------
//
//  This behavior is similar to seek but it attempts to arrive at the
//  target with a zero velocity
//------------------------------------------------------------------------
//Vector2D SteeringBehavior::Arrive(Vector2D     TargetPos, Deceleration deceleration)
btVector3 BaseEntitySteeringBehavior::Arrive(const btVector3 &TargetPos, Deceleration_e deceleration)
{
    //Vector2D ToTarget = TargetPos - m_pVehicle->Pos();
    btVector3 ToTarget = TargetPos - getOwner()->getOrigin();
    
    //calculate the distance to the target
    //double dist = ToTarget.Length();
    btScalar dist = ToTarget.length();

    
    if (dist > 0.1f)
    {
        //because Deceleration is enumerated as an int, this value is required
        //to provide fine tweaking of the deceleration..
        //const double DecelerationTweaker = 0.3;
        const btScalar DecelerationTweaker = 0.3;

        
        //calculate the speed required to reach the target given the desired
        //deceleration
        //double speed =  dist / ((double)deceleration * DecelerationTweaker);
        btScalar speed =  dist / ((btScalar)deceleration * DecelerationTweaker);

        
        //make sure the velocity does not exceed the max
        //speed = min(speed, m_pVehicle->MaxSpeed());
        speed = btMin(speed, getOwner()->getMaxLinearSpeed());

        
        //from here proceed just like Seek except we don't need to normalize
        //the ToTarget vector because we have already gone to the trouble
        //of calculating its length: dist.
        //Vector2D DesiredVelocity =  ToTarget * speed / dist;
        btVector3 DesiredVelocity =  ToTarget * speed / dist;

        
        //return (DesiredVelocity - m_pVehicle->Velocity());
        return (DesiredVelocity - getOwner()->getRigidBody()->getLinearVelocity());
    }
    
    //return Vector2D(0,0);
    return btVector3(0,0,0);
}

//btVector3 BaseEntitySteeringBehavior::Arrive(const btVector3 &vTargetPos, Deceleration_e deceleration)
//{
//	btVector3 vToTarget = vTargetPos - getOwner()->getOrigin();
//	
//	//calculate the distance to the target
//	btScalar dDist = vToTarget.length();
//	
//	if (dDist > 0)
//	{
//		//because Deceleration is enumerated as an int, this value is required
//		//to provide fine tweaking of the deceleration..
//		const btScalar dDecelerationTweaker = 0.3;
//		
//		//calculate the speed required to reach the target given the desired
//		//deceleration
//		btScalar dSpeed =  dDist / ((btScalar)deceleration * dDecelerationTweaker);
//        
//		//make sure the velocity does not exceed the max
//        if(dSpeed > getOwner()->getMaxLinearSpeed())
//            dSpeed = getOwner()->getMaxLinearSpeed();
//		
//		//from here proceed just like Seek except we don't need to normalize
//		//the ToTarget vector because we have already gone to the trouble
//		//of calculating its length: dist.
//		btVector3 vDesiredVelocity =  vToTarget * dSpeed / dDist;
//		
//		return (vDesiredVelocity - getOwner()->getRigidBody()->getLinearVelocity());
//	}
//	
//	return btVector3(0.0f, 0.0f, 0.0f);
//}

btVector3 BaseEntitySteeringBehavior::Pursuit(const RigidEntity* evader)
{
    btVector3 ToEvader = evader->getOrigin() - getOwner()->getOrigin();
    double RelativeHeading = getOwner()->getHeadingVector().dot(evader->getHeadingVector());
    
    if((ToEvader.dot(getOwner()->getHeadingVector()) > 0) &&
       (RelativeHeading < -0.95))
    {
        return Seek(evader->getOrigin());
    }
    
    double LookAheadTime = ToEvader.length() / (getOwner()->getMaxLinearSpeed() + evader->getLinearSpeed());
    return Seek(evader->getOrigin() + evader->getRigidBody()->getLinearVelocity() * LookAheadTime);
    
    
    //if the evader is ahead and facing the agent then we can just seek
    //for the evader's current position.
//    Vector2D ToEvader = evader->Pos() - m_pVehicle->Pos();
//    
//    double RelativeHeading = m_pVehicle->Heading().Dot(evader->Heading());
//    
//    if ( (ToEvader.Dot(m_pVehicle->Heading()) > 0) &&
//        (RelativeHeading < -0.95))  //acos(0.95)=18 degs
//    {
//        return Seek(evader->Pos());
//    }
//    
//    //Not considered ahead so we predict where the evader will be.
//    
//    //the lookahead time is propotional to the distance between the evader
//    //and the pursuer; and is inversely proportional to the sum of the
//    //agent's velocities
//    double LookAheadTime = ToEvader.Length() /
//    (m_pVehicle->MaxSpeed() + evader->Speed());
//    
//    //now seek to the predicted future position of the evader
//    return Seek(evader->Pos() + evader->Velocity() * LookAheadTime);
    
    
    
//    //if the evader is ahead and facing the agent then we can just seek
//    //for the evader's current position.
//    btVector3 ToEvader = evader->getOrigin() - getOwner()->getOrigin();
//    
//    btScalar RelativeHeading = getOwner()->getLinearVelocityHeading().dot(evader->getLinearVelocityHeading());
//    
//    if( (ToEvader.dot(getOwner()->getLinearVelocityHeading()) > 0 &&
//         (RelativeHeading < -0.95))) //acos(0.95)=18 degs
//       {
//           return Seek(evader->getOrigin());
//       }
//    //Not considered ahead so we predict where the evader will be.
//    
//    //the lookahead time is propotional to the distance between the evader
//    //and the pursuer; and is inversely proportional to the sum of the
//    //agent's velocities
//    btScalar LookAheadTime = ToEvader.length() / (getOwner()->getMaxLinearSpeed() + evader->getLinearSpeed());
//    
//    //now seek to the predicted future position of the evader
//    return Seek(evader->getOrigin() + evader->getRigidBody()->getLinearVelocity() * LookAheadTime);
}

//------------------------- Offset Pursuit -------------------------------
//
//  Produces a steering force that keeps a vehicle at a specified offset
//  from a leader vehicle
//------------------------------------------------------------------------
//Vector2D SteeringBehavior::OffsetPursuit(const Vehicle*  leader, const Vector2D offset)
btVector3 BaseEntitySteeringBehavior::OffsetPursuit(const RigidEntity* leader, const btVector3 offset)
{
    //calculate the offset's position in world space
//    Vector2D WorldOffsetPos = PointToWorldSpace(offset,
//                                                leader->Heading(),
//                                                leader->Side(),
//                                                leader->Pos());

    btVector3 target = getOwner()->getOrigin() + getOwner()->getLinearVelocityHeading();
    btVector3 WorldOffsetPos(target - getOwner()->getOrigin());
    
    
    //Vector2D ToOffset = WorldOffsetPos - m_pVehicle->Pos();
    btVector3 ToOffset(WorldOffsetPos - getOwner()->getOrigin());
    
    //the lookahead time is propotional to the distance between the leader
    //and the pursuer; and is inversely proportional to the sum of both
    //agent's velocities
    //double LookAheadTime = ToOffset.Length() / (m_pVehicle->MaxSpeed() + leader->Speed());
    btScalar LookAheadTime = ToOffset.length() / getOwner()->getMaxLinearSpeed() + leader->getLinearSpeed();
    
    //now Arrive at the predicted future position of the offset
    //return Arrive(WorldOffsetPos + leader->Velocity() * LookAheadTime, fast);
    return Arrive(WorldOffsetPos + leader->getRigidBody()->getLinearVelocity() * LookAheadTime, Deceleration_Fast);
}

//btVector3 BaseEntitySteeringBehavior::OffsetPursuit(const RigidEntity* leader, const btVector3 offset)
//{
//	//calculate the offset's position in world space
//	btVector3 vWorldOffsetPos = pointToWorldSpace(offset,
//												  leader->getLinearVelocityHeading(),
//												  leader->getSideVector(),
//												  leader->getOrigin());
//	
//	btVector3 vToOffset = vWorldOffsetPos - getOwner()->getOrigin();
//	
//	//the lookahead time is propotional to the distance between the leader
//	//and the pursuer; and is inversely proportional to the sum of both
//	//agent's velocities
//	btScalar dLookAheadTime = vToOffset.length() /
//	(getOwner()->getMaxLinearSpeed() + leader->getLinearSpeed());
//	
//	//now Arrive at the predicted future position of the offset
//	return Arrive(vWorldOffsetPos + leader->getRigidBody()->getLinearVelocity() * dLookAheadTime, Deceleration_Fast);
//}

btVector3 BaseEntitySteeringBehavior::Evade(const RigidEntity* pursuer)
{
	/* Not necessary to include the check for facing direction this time */
	
	btVector3 vToPursuer = pursuer->getOrigin() - getOwner()->getOrigin();
	
	//uncomment the following two lines to have Evade only consider pursuers
	//within a 'threat range'
	if (vToPursuer.length2() > m_dPanicDistanceSq) return btVector3(0.0f, 0.0f, 0.0f);
	
	//the lookahead time is propotional to the distance between the pursuer
	//and the pursuer; and is inversely proportional to the sum of the
	//agents' velocities
	btScalar dLookAheadTime = vToPursuer.length() /
	(getOwner()->getMaxLinearSpeed() + pursuer->getLinearSpeed());
	
	//now flee away from predicted future position of the pursuer
	return Flee(pursuer->getOrigin() + pursuer->getRigidBody()->getLinearVelocity() * dLookAheadTime);
}

btVector3 BaseEntitySteeringBehavior::Wander(bool rotate_target)
{
    
    
    if(rotate_target)
        getOwner()->getWanderInfo()->rotateTarget();
    
    
    
    btVector3 ahead(getOwner()->getLinearVelocityHeading() * getOwner()->getWanderInfo()->getDistance());
    btVector3 target = getOwner()->getOrigin() + ahead + getOwner()->getWanderInfo()->getTarget();
    return (target - getOwner()->getOrigin());
    
}

btVector3 BaseEntitySteeringBehavior::ObstacleAvoidance(const btAlignedObjectArray<BaseEntity*>& obstacles)
{
    return btVector3(0, 0, 0);
    
//	//the detection box length is proportional to the agent's velocity
//	m_dDBoxLength = c_dMINDETECTIONBOXLENGTH +
//	(getOwner()->getLinearSpeed() / getOwner()->getMaxLinearSpeed()) *
//	c_dMINDETECTIONBOXLENGTH;
//	
//	
//	//tag all obstacles within range of the box for processing
//	EntityMgr::GetInstance()->TagObstaclesWithinViewRange(getOwner(), m_dDBoxLength);
//	
//	//this will keep track of the closest intersecting obstacle (CIB)
//	RigidEntity* ClosestIntersectingObstacle = NULL;
//	
//	//this will be used to track the distance to the CIB
//	btScalar dDistToClosestIP = c_dMAXbtScalar;
//	
//	//this will record the transformed local coordinates of the CIB
//	btVector3 vLocalPosOfClosestObstacle;
//	
//	btAlignedObjectArray<RigidEntity*>::const_iterator curOb = obstacles.begin();
//	
//	while(curOb != obstacles.end())
//	{
//		//if the obstacle has been tagged within range proceed
//		if ((*curOb)->isTagged())
//		{
//			//calculate this obstacle's position in local space
//			btVector3 vLocalPos = PointToLocalSpace((*curOb)->getOrigin(),
//													getOwner()->getLinearVelocityHeading(),
//													getOwner()->getSideVector(),
//													getOwner()->getOrigin());
//			
//			//if the local position has a negative x value then it must lay
//			//behind the agent. (in which case it can be ignored)
//			if (vLocalPos.getX() >= 0)
//			{
//				//if the distance from the x axis to the object's position is less
//				//than its radius + half the width of the detection box then there
//				//is a potential intersection.
//                btScalar dExpandedRadius = (*curOb)->getVBO()->getBoundingRadius() + getOwner()->getVBO()->getBoundingRadius();
////				btScalar dExpandedRadius = (*curOb)->GetSIO2Object()->GetBoundingRadius() + getOwner()->GetSIO2Object()->GetBoundingRadius();
//				
//				if (fabs(vLocalPos.getY()) < dExpandedRadius)
//				{
//					//now to do a line/circle intersection test. The center of the
//					//circle is represented by (cX, cY). The intersection points are
//					//given by the formula x = cX +/-sqrt(r^2-cY^2) for y=0.
//					//We only need to look at the smallest positive value of x because
//					//that will be the closest point of intersection.
//					btScalar cX = vLocalPos.getX();
//					btScalar cY = vLocalPos.getY();
//					
//					//we only need to calculate the sqrt part of the above equation once
//					btScalar dSqrtPart = sqrt(dExpandedRadius*dExpandedRadius - cY*cY);
//					
//					btScalar ip = cX - dSqrtPart;
//					
//					if (ip <= 0.0)
//					{
//						ip = cX + dSqrtPart;
//					}
//					
//					//test to see if this is the closest so far. If it is keep a
//					//record of the obstacle and its local coordinates
//					if (ip < dDistToClosestIP)
//					{
//						dDistToClosestIP = ip;
//						
//						ClosestIntersectingObstacle = *curOb;
//						
//						vLocalPosOfClosestObstacle = vLocalPos;
//					}
//				}
//			}
//		}
//		
//		++curOb;
//	}
//	
//	//if we have found an intersecting obstacle, calculate a steering
//	//force away from it
//	btVector3 vSteeringForce(0.0f, 0.0f, 0.0f);
//	
//	if (ClosestIntersectingObstacle)
//	{
//		//the closer the agent is to an object, the stronger the
//		//steering force should be
//		btScalar multiplier = 1.0 + (m_dDBoxLength - vLocalPosOfClosestObstacle.getX()) /
//		m_dDBoxLength;
//		
//		//calculate the lateral force
//		vSteeringForce.setX((ClosestIntersectingObstacle->GetSIO2Object()->GetBoundingRadius() -
//							 vLocalPosOfClosestObstacle.getY())  * multiplier);
//		
//		//apply a braking force proportional to the obstacles distance from
//		//the vehicle.
//		const btScalar dBrakingWeight = 0.2;
//		
//		vSteeringForce.setZ((ClosestIntersectingObstacle->GetSIO2Object()->GetBoundingRadius() -
//							 vLocalPosOfClosestObstacle.getX()) *
//							dBrakingWeight);
//	}
//	
//	//finally, convert the steering vector from local to world space
//	return VectorToWorldSpace(vSteeringForce,
//							  getOwner()->getLinearVelocityHeading(),
//							  getOwner()->getSideVector());
}

btVector3 BaseEntitySteeringBehavior::WallAvoidance()
{
    return btVector3(0,0,0);
//	btVector3 vSteeringForce(0,0,0);
//	btAlignedObjectArray<btVector3>::iterator iter;
//    BaseEntity::WallAvoidanceFunction myobject;
//	
//	CreateFeelers();
//	
//	for(iter = m_pFeelers->begin(); iter != m_pFeelers->end(); ++iter)
//	{
//		myobject.Set(getOwner()->getOrigin(), *iter);
//		myobject = EntityMgr::GetInstance()->PerformTaskOnWalls(myobject);
//		
//		if(myobject.GetClosestWall())
//		{
//			//calculate by what distance the projected position of the agent
//			//will overshoot the wall
//			btVector3 vOverShoot = (*iter) - myobject.GetClosestPoint();
//			
//			//create a force in the direction of the wall normal, with a
//			//magnitude of the overshoot
//			vSteeringForce = myobject.GetClosestWall()->getNormalVector() * vOverShoot.length();
//		}
//	}
//	
//	return vSteeringForce;
}

btVector3 BaseEntitySteeringBehavior::FollowPath()
{
    //move to next target if close enough to current target (working in
	//distance squared space)
	if(m_pPath->getCurrentWaypoint().distance2(getOwner()->getOrigin()) < getOwner()->getFolowPathInfo()->getWayPointSeekDistanceSquared())
	{
        //at the current way point...
        //move to the next.
        m_pPath->setNextWaypoint();
        
        return Arrive(m_pPath->getCurrentWaypoint(), Deceleration_Fast);
	}
    else
    {
        if(m_pPath->getPathIncrement() == PathIncrement_None)
        {
            return Arrive(m_pPath->getCurrentWaypoint(), Deceleration_Fast);
        }
        else
        {
            return Seek(m_pPath->getCurrentWaypoint());
        }
    }
}

btVector3 BaseEntitySteeringBehavior::Interpose(const RigidEntity* vAgentA, const RigidEntity* vAgentB)
{
	//first we need to figure out where the two agents are going to be at
	//time T in the future. This is approximated by determining the time
	//taken to reach the mid way point at the current time at at max speed.
	btVector3 vMidPoint = (vAgentA->getOrigin() + vAgentB->getOrigin()) / 2.0;
	
	btScalar dTimeToReachMidPoint = getOwner()->getOrigin().distance(vMidPoint) / getOwner()->getMaxLinearSpeed();
	
	//now we have T, we assume that agent A and agent B will continue on a
	//straight trajectory and extrapolate to get their future positions
	btVector3 vAPos = vAgentA->getOrigin() + vAgentA->getRigidBody()->getLinearVelocity() * dTimeToReachMidPoint;
	btVector3 vBPos = vAgentB->getOrigin() + vAgentB->getRigidBody()->getLinearVelocity() * dTimeToReachMidPoint;
	
	//calculate the mid point of these predicted positions
	vMidPoint = (vAPos + vBPos) / 2.0f;
	
	//then steer to Arrive at it
	return Arrive(vMidPoint, Deceleration_Fast);
}
btVector3 BaseEntitySteeringBehavior::Hide(const RigidEntity* hunter, const btAlignedObjectArray<RigidEntity*>& obstacles)
{
    return btVector3(0,0,0);
//	btScalar    dDistToClosest = c_dMAXbtScalar;
//	btVector3 vBestHidingSpot;
//	
//	btAlignedObjectArray<RigidEntity*>::const_iterator curOb = obstacles.begin();
//	btAlignedObjectArray<RigidEntity*>::const_iterator closest;
//	
//	while(curOb != obstacles.end())
//	{
//		//calculate the position of the hiding spot for this obstacle
//		btVector3 vHidingSpot = GetHidingPosition((*curOb)->getOrigin(),
//												  (*curOb)->GetSIO2Object()->GetBoundingRadius(),
//												  hunter->getOrigin());
//		
//		//work in distance-squared space to find the closest hiding
//		//spot to the agent
//		btScalar dist = vHidingSpot.distance2(getOwner()->getOrigin());
//		
//		if (dist < dDistToClosest)
//		{
//			dDistToClosest = dist;
//			
//			vBestHidingSpot = vHidingSpot;
//			
//			closest = curOb;
//		}
//		
//		++curOb;
//		
//	}//end while
//	
//	//if no suitable obstacles found then Evade the hunter
//	if (dDistToClosest == c_fMAXFLOAT)
//	{
//		return Evade(hunter);
//	}
//	
//	//else use Arrive on the hiding spot
//	return Arrive(vBestHidingSpot, Deceleration_Fast);
}
btVector3 BaseEntitySteeringBehavior::Cohesion(const btAlignedObjectArray<RigidEntity*> &neighbors)
{
	//first find the center of mass of all the agents
	btVector3 vCenterOfMass, vSteeringForce(0.0f, 0.0f, 0.0f);
	
	int iNeighborCount = 0;
	
	//iterate through the neighbors and sum up all the position vectors
	for (unsigned int a=0; a<neighbors.size(); ++a)
	{
		//make sure *this* agent isn't included in the calculations and that
		//the agent being examined is close enough ***also make sure it doesn't
		//include the evade target ***
		if((neighbors[a] != getOwner()) && neighbors[a]->isTagged() &&
		   (neighbors[a] != m_pEvadeTarget))
		{
			vCenterOfMass += neighbors[a]->getOrigin();
			
			++iNeighborCount;
		}
	}
	
	if (iNeighborCount > 0)
	{
		//the center of mass is the average of the sum of positions
		vCenterOfMass /= (btScalar)iNeighborCount;
		
		//now seek towards that position
		vSteeringForce = Seek(vCenterOfMass);
	}
    
    if(!vSteeringForce.isZero())
        vSteeringForce.normalize();
	
	//the magnitude of cohesion is usually much larger than separation or
	//allignment so it usually helps to normalize it.
	return vSteeringForce;
}
btVector3 BaseEntitySteeringBehavior::Separation(const btAlignedObjectArray<RigidEntity*> &neighbors)
{
	btVector3 vSteeringForce(0.0f, 0.0f, 0.0f);
	
	for (unsigned int a=0; a<neighbors.size(); ++a)
	{
		//make sure this agent isn't included in the calculations and that
		//the agent being examined is close enough. ***also make sure it doesn't
		//include the evade target ***
		if((neighbors[a] != getOwner()) && neighbors[a]->isTagged() &&
		   (neighbors[a] != m_pEvadeTarget))
		{
			btVector3 vToAgent = getOwner()->getOrigin() - neighbors[a]->getOrigin();
            
			//scale the force inversely proportional to the agents distance
			//from its neighbor.
			vSteeringForce += vToAgent.normalize()/vToAgent.length();
		}
	}
	
	return vSteeringForce;
}
btVector3 BaseEntitySteeringBehavior::Alignment(const btAlignedObjectArray<RigidEntity*> &neighbors)
{
	//used to record the average heading of the neighbors
	btVector3 vAverageHeading;
	
	//used to count the number of vehicles in the neighborhood
	int    iNeighborCount = 0;
	
	//iterate through all the tagged vehicles and sum their heading vectors
	for (unsigned int a=0; a<neighbors.size(); ++a)
	{
		//make sure *this* agent isn't included in the calculations and that
		//the agent being examined  is close enough ***also make sure it doesn't
		//include any evade target ***
		if((neighbors[a] != getOwner()) && neighbors[a]->isTagged() &&
		   (neighbors[a] != m_pEvadeTarget))
		{
			vAverageHeading += neighbors[a]->getLinearVelocityHeading();
			
			++iNeighborCount;
		}
	}
	
	//if the neighborhood contained one or more vehicles, average their
	//heading vectors.
	if (iNeighborCount > 0)
	{
		vAverageHeading /= (btScalar)iNeighborCount;
		
		vAverageHeading -= getOwner()->getLinearVelocityHeading();
	}
	
	return vAverageHeading;
}
btVector3 BaseEntitySteeringBehavior::CohesionPlus(const btAlignedObjectArray<RigidEntity*> &agents)
{
	//FIXME: IMPLEMENT
	
	btVector3 vVector3;
	return vVector3;
}
btVector3 BaseEntitySteeringBehavior::SeparationPlus(const btAlignedObjectArray<RigidEntity*> &agents)
{
	//FIXME: IMPLEMENT
	
	btVector3 vVector3;
	return vVector3;
}
btVector3 BaseEntitySteeringBehavior::AlignmentPlus(const btAlignedObjectArray<RigidEntity*> &agents)
{
	//FIXME: IMPLEMENT
	
	btVector3 vVector3;
	return vVector3;
}

void BaseEntitySteeringBehavior::CreateFeelers()
{
	const float s_fFeelerAngle(3.5f);
    
    const btQuaternion s_qFeelerLeft (btQuaternion(g_vYawAxis,   M_PI_2 *  s_fFeelerAngle));
    const btQuaternion s_qFeelerRight(btQuaternion(g_vYawAxis,	 M_PI_2 * -s_fFeelerAngle));
    const btQuaternion s_qFeelerUp   (btQuaternion(g_vPitchAxis, M_PI_2 *  s_fFeelerAngle));
    const btQuaternion s_qFeelerDown (btQuaternion(g_vPitchAxis, M_PI_2 * -s_fFeelerAngle));
    
    const btQuaternion s_qFeelerUpLeft(s_qFeelerUp * s_qFeelerLeft);
    const btQuaternion s_qFeelerUpRight(s_qFeelerUp * s_qFeelerRight);
    const btQuaternion s_qFeelerDownLeft(s_qFeelerDown * s_qFeelerLeft);
    const btQuaternion s_qFeelerDownRight(s_qFeelerDown * s_qFeelerRight);
	
	const btVector3 vHeading(getOwner()->getHeadingVector());
	const btVector3 vPos(getOwner()->getOrigin());
	
	(*m_pFeelers)[0] = vPos + (m_dWallDetectionFeelerLength * quatRotate(s_qFeelerUpLeft, vHeading));
	(*m_pFeelers)[1] = vPos + (m_dWallDetectionFeelerLength * quatRotate(s_qFeelerUpRight, vHeading));
	(*m_pFeelers)[2] = vPos + (m_dWallDetectionFeelerLength * quatRotate(s_qFeelerDownLeft, vHeading));
	(*m_pFeelers)[3] = vPos + (m_dWallDetectionFeelerLength * quatRotate(s_qFeelerDownRight, vHeading));
	
}



