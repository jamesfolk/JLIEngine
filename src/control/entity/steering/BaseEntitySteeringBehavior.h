//
//  BaseEntitySteeringBehavior.h
//  GameAsteroids
//
//  Created by James Folk on 3/11/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__BaseEntitySteeringBehavior__
#define __GameAsteroids__BaseEntitySteeringBehavior__

#include "AbstractFactory.h"
//#include "SteeringBehaviorFactory.h"
#include "SteeringBehaviorFactoryIncludes.h"

#include "btBulletDynamicsCommon.h"

#include "AbstractBehavior.h"

class BaseEntity;
class SteeringEntity;
class Path;

#include <queue>

//class HeadingSmoother
//{
//public:
//    HeadingSmoother(const int capacity = 1000000);
//    virtual ~HeadingSmoother();
//    
//    
//    const btVector3 &getHeadingVector()const;
//    void addHeading(const btVector3 &heading);
//    
//private:
//    btVector3 m_Average;
//    btScalar m_Capacity;
//};

#include <vector>

#define BIT(x) (1<<(x))

enum BehaviorType
{
	BehaviorType_NONE               = 0,
	BehaviorType_Seek               = BIT(1),
	BehaviorType_Flee               = BIT(2),
	BehaviorType_Arrive             = BIT(3),
	BehaviorType_Wander             = BIT(4),
	BehaviorType_Evade              = BIT(5),
	BehaviorType_Interpose          = BIT(6),
	BehaviorType_Hide               = BIT(7),
	BehaviorType_ObstacleAvoidance  = BIT(8),
	BehaviorType_WallAvoidance      = BIT(9),
	BehaviorType_FollowPath         = BIT(10),
	BehaviorType_Pursuit            = BIT(11),
	BehaviorType_OffsetPursuit      = BIT(12),
	BehaviorType_Cohesion           = BIT(13),
	BehaviorType_Separation         = BIT(14),
	BehaviorType_Alignment          = BIT(15),
	BehaviorType_Flock              = BIT(16),
	BehaviorType_MAX                = 0xFFFFFFFFFFFFFFFF,
};

enum Deceleration_e
{
	Deceleration_Slow = 3,
	Deceleration_Normal = 2,
	Deceleration_Fast = 1
};

const double c_dMINDETECTIONBOXLENGTH = 40.0f;

class RigidEntity;

class BaseEntitySteeringBehavior :
public AbstractFactoryObject,
public AbstractBehavior<SteeringEntity>
{
    friend class SteeringBehaviorFactory;
    
protected:
    virtual btVector3 sumLinearSteering() = 0;
    virtual btVector3 sumAngularSteering() = 0;
    
//public:
    BaseEntitySteeringBehavior();
    BaseEntitySteeringBehavior(const SteeringBehaviorInfo &constructionInfo);
    virtual ~BaseEntitySteeringBehavior();
public:
    
    static BaseEntitySteeringBehavior *create(int type = 0);
    static bool destroy(IDType &_id);
    static bool destroy(BaseEntitySteeringBehavior *entity);
    static BaseEntitySteeringBehavior *get(IDType _id);
    
    SIMD_FORCE_INLINE IDType getID()const
    {
        return AbstractFactoryObject::getID();
    }
    
    SIMD_FORCE_INLINE const std::string &getName()const
    {
        return AbstractFactoryObject::getName();
    }
    
    SIMD_FORCE_INLINE void setName(const std::string &name)
    {
        AbstractFactoryObject::setName(name);
    }
    
    
    virtual void calculate(SteeringEntity *owner, btScalar deltaTimeStep);
    virtual void debugDraw(SteeringEntity *owner, btIDebugDraw* debugDrawer);
    
    //calculates the component of the steering force that is parallel
    //with the vehicle heading
    btScalar    getForwardComponent();
    
    //calculates the component of the steering force that is perpendicuar
    //with the vehicle heading
    btScalar    getSideComponent();
    
    //const btVector3 &getSmoothedHeadingVector()const;
    
    const btVector3& getLinearFactor() const
	{
		return m_linearFactor;
	}
	void setLinearFactor(const btVector3& linearFactor)
	{
		m_linearFactor = linearFactor;
	}
    
//    SIMD_FORCE_INLINE const btVector3 &getLinearImpulse()const
//    {
//        return m_LinearImpulse;
//    }
//    SIMD_FORCE_INLINE const btVector3 &getAngularImpulse()const
//    {
//        return m_AngularImpulse;
//    }
//    
//    SIMD_FORCE_INLINE void setDirectLinearImpulse(const btVector3 &impulse)
//    {
//        m_DirectLinearImpulse = impulse;
//    }
//    SIMD_FORCE_INLINE void setDirectAngularImpulse(const btVector3 &impulse)
//    {
//        m_DirectAngularImpulse = impulse;
//    }
//    
//    const btVector3 &getDirectLinearImpulse() const
//	{
//		return m_DirectLinearImpulse;
//	}
//    
//	const btVector3 &getDirectAngularImpulse() const
//	{
//		return m_DirectAngularImpulse;
//	}
//
//    
//    
//    btScalar getDirectLinearDamping() const
//	{
//		return m_DirectLinearDamping;
//	}
//    
//	btScalar getDirectAngularDamping() const
//	{
//		return m_DirectAngularDamping;
//	}
//    
//    void setDirectImpulseDamping(btScalar lin_damping, btScalar ang_damping)
//    {
//        m_DirectLinearDamping = btClamped(lin_damping, (btScalar)btScalar(0.0), (btScalar)btScalar(1.0));
//        m_DirectAngularDamping = btClamped(ang_damping, (btScalar)btScalar(0.0), (btScalar)btScalar(1.0));
//    }
//    
//    void applyDirectDamping(btScalar timeStep)
//    {
//        m_DirectLinearImpulse *= btPow(btScalar(1)-m_DirectLinearDamping, timeStep);
//        m_DirectAngularImpulse *= btPow(btScalar(1)-m_DirectAngularDamping, timeStep);
//    }
    
//    SIMD_FORCE_INLINE const SteeringBehaviorInfo &getSteeringBehaviorInfo()const
//    {
//        return m_SteeringBehaviorInfo;
//    }
    
    
//    void FleeOn(){m_iFlags |= BehaviorType_Flee;}
//    
//    void setSeekOn(const btVector3 &pos){m_iFlags |= BehaviorType_Seek;m_SeekPosition = pos;}
//    SIMD_FORCE_INLINE const btVector3&	getSeekPosition(){return m_SeekPosition;}
//    
//    SIMD_FORCE_INLINE void setArriveOn(const btVector3 &arrivePos){m_iFlags |= BehaviorType_Arrive;m_ArriveOrigin = arrivePos;}
//    SIMD_FORCE_INLINE const btVector3 &getArrivePosition(){return m_ArriveOrigin;}
//    
//    SIMD_FORCE_INLINE void setWanderOn(){m_iFlags |= BehaviorType_Wander;}
//    
////    SIMD_FORCE_INLINE void	setPursuitOn(RigidEntity* pursuitTargetEntity){m_iFlags |= BehaviorType_Pursuit;m_pPursuitTarget = pursuitTargetEntity;}
////    SIMD_FORCE_INLINE RigidEntity*	getPursuitTarget(){return m_pPursuitTarget;}
//    
//    SIMD_FORCE_INLINE void	setEvadeOn(RigidEntity* evadeTargetEntity){m_iFlags |= BehaviorType_Evade;m_pEvadeTarget = evadeTargetEntity;}
//    SIMD_FORCE_INLINE RigidEntity*	getEvadeTarget(){return m_pEvadeTarget;}
//    
//    
//    SIMD_FORCE_INLINE void setFollowPathOn(Path *path){m_iFlags |= BehaviorType_FollowPath;setPath(path);}
    SIMD_FORCE_INLINE void setPath(Path *path)
    {
        btAssert(path);
        m_pPath = path;
    }
    SIMD_FORCE_INLINE const Path*	getPath()const
    {
        return m_pPath;
    }
    SIMD_FORCE_INLINE Path*	getPath()
    {
        return m_pPath;
    }
        
    //void PursuitOn(RigidEntity* v){m_iFlags |= BehaviorType_Pursuit; m_pPursuitTarget = v;}
    //void EvadeOn(RigidEntity* v){m_iFlags |= BehaviorType_Evade; m_pEvadeTarget = v;}
//    void CohesionOn(){m_iFlags |= BehaviorType_Cohesion;}
//    void SeparationOn(){m_iFlags |= BehaviorType_Separation;}
//    void AlignmentOn(){m_iFlags |= BehaviorType_Alignment;}
//    void ObstacleAvoidanceOn(){m_iFlags |= BehaviorType_ObstacleAvoidance;}
//    void WallAvoidanceOn(){m_iFlags |= BehaviorType_WallAvoidance;}
//    //void FollowPathOn(){m_iFlags |= BehaviorType_FollowPath;}
//    void InterposeOn(RigidEntity* v1, RigidEntity* v2){m_iFlags |= BehaviorType_Interpose; m_pInterposeTarget1 = v1; m_pInterposeTarget2 = v2;}
//    void HideOn(RigidEntity* v){m_iFlags |= BehaviorType_Hide; m_pHideTarget = v;}
//    
//    void setOffsetPursuitOn(RigidEntity* targetEntity, const btVector3 &offset){m_iFlags |= BehaviorType_OffsetPursuit; m_OffsetPursuitOffset = offset; m_pOffsetPursuitTarget = targetEntity;}
//    SIMD_FORCE_INLINE RigidEntity*	getOffsetPursuitTarget(){return m_pOffsetPursuitTarget;}
//    SIMD_FORCE_INLINE const btVector3&	getOffsetPursuitOffset(){return m_OffsetPursuitOffset;}
//    
//    void FlockingOn(){m_iFlags |= BehaviorType_Flock; CohesionOn(); AlignmentOn(); SeparationOn(); setWanderOn();}
//    
//    void FleeOff()  {if(IsOn(BehaviorType_Flee))   m_iFlags ^=BehaviorType_Flee;}
//    void SeekOff()  {if(IsOn(BehaviorType_Seek))   m_iFlags ^=BehaviorType_Seek;}
//    void ArriveOff(){if(IsOn(BehaviorType_Arrive)) m_iFlags ^=BehaviorType_Arrive;}
//    void WanderOff(){if(IsOn(BehaviorType_Wander)) m_iFlags ^=BehaviorType_Wander;}
//    void PursuitOff(){if(IsOn(BehaviorType_Pursuit)) m_iFlags ^=BehaviorType_Pursuit;}
//    void EvadeOff(){if(IsOn(BehaviorType_Evade)) m_iFlags ^=BehaviorType_Evade;}
//    void CohesionOff(){if(IsOn(BehaviorType_Cohesion)) m_iFlags ^=BehaviorType_Cohesion;}
//    void SeparationOff(){if(IsOn(BehaviorType_Separation)) m_iFlags ^=BehaviorType_Separation;}
//    void AlignmentOff(){if(IsOn(BehaviorType_Alignment)) m_iFlags ^=BehaviorType_Alignment;}
//    void ObstacleAvoidanceOff(){if(IsOn(BehaviorType_ObstacleAvoidance)) m_iFlags ^=BehaviorType_ObstacleAvoidance;}
//    void WallAvoidanceOff(){if(IsOn(BehaviorType_WallAvoidance)) m_iFlags ^=BehaviorType_WallAvoidance;}
//    void FollowPathOff(){if(IsOn(BehaviorType_FollowPath)) m_iFlags ^=BehaviorType_FollowPath;}
//    void InterposeOff(){if(IsOn(BehaviorType_Interpose)) m_iFlags ^=BehaviorType_Interpose;}
//    void HideOff(){if(IsOn(BehaviorType_Hide)) m_iFlags ^=BehaviorType_Hide;}
//    void OffsetPursuitOff(){if(IsOn(BehaviorType_OffsetPursuit)) m_iFlags ^=BehaviorType_OffsetPursuit;}
//    void FlockingOff(){if(IsOn(BehaviorType_Flock)){m_iFlags ^=BehaviorType_Flock; CohesionOff(); AlignmentOff(); SeparationOff(); WanderOff();}}
//    
//    bool isFleeOn(){return IsOn(BehaviorType_Flee);}
//    bool isSeekOn(){return IsOn(BehaviorType_Seek);}
//    bool isArriveOn(){return IsOn(BehaviorType_Arrive);}
//    bool isWanderOn(){return IsOn(BehaviorType_Wander);}
//    bool isPursuitOn(){return IsOn(BehaviorType_Pursuit);}
//    bool isEvadeOn(){return IsOn(BehaviorType_Evade);}
//    bool isCohesionOn(){return IsOn(BehaviorType_Cohesion);}
//    bool isSeparationOn(){return IsOn(BehaviorType_Separation);}
//    bool isAlignmentOn(){return IsOn(BehaviorType_Alignment);}
//    bool isObstacleAvoidanceOn(){return IsOn(BehaviorType_ObstacleAvoidance);}
//    bool isWallAvoidanceOn(){return IsOn(BehaviorType_WallAvoidance);}
//    bool isFollowPathOn(){return IsOn(BehaviorType_FollowPath);}
//    bool isInterposeOn(){return IsOn(BehaviorType_Interpose);}
//    bool isHideOn(){return IsOn(BehaviorType_Hide);}
//    bool isOffsetPursuitOn(){return IsOn(BehaviorType_OffsetPursuit);}
//    bool isFlockOn(){return IsOn(BehaviorType_Flock);}
protected:
    
    bool accumulateLinearForce(btVector3 &RunningTot, const btVector3 &ForceToAdd);
    bool accumulateAngularForce(btVector3 &runningTotal, const btVector3 &forceToAdd);
    
    //this behavior moves the agent towards a target position
	virtual btVector3 Seek(const btVector3 &TargetPos);
	
	//this behavior returns a vector that moves the agent away
	//from a target position
	virtual btVector3 Flee(const btVector3 &TargetPos);
	
	//this behavior is similar to BehaviorType_Seek but it attempts to BehaviorType_Arrive
	//at the target position with a zero velocity
	virtual btVector3 Arrive(const btVector3 &TargetPos, Deceleration_e deceleration);
	
	//this behavior predicts where an agent will be in time T and seeks
	//towards that point to intercept it.
	virtual btVector3 Pursuit(const RigidEntity* agent);
	
	//this behavior maintains a position, in the direction of offset
	//from the target vehicle
	virtual btVector3 OffsetPursuit(const RigidEntity* agent, const btVector3 offset);
	
	//this behavior attempts to BehaviorType_Evade a pursuer
	virtual btVector3 Evade(const RigidEntity* agent);
	
	//this behavior makes the agent BehaviorType_Wander about randomly
	virtual btVector3 Wander(bool rotate_target = true);
	
	//this returns a steering force which will attempt to keep the agent
	//away from any obstacles it may encounter
	virtual btVector3 ObstacleAvoidance(const btAlignedObjectArray<BaseEntity*>& obstacles);
	
	//this returns a steering force which will keep the agent away from any
	//walls it may encounter
	virtual btVector3 WallAvoidance();
	
	//given a series of btVector3, this method produces a force that will
	//move the agent along the waypoints in order
	virtual btVector3 FollowPath();
	
	//this results in a steering force that attempts to steer the vehicle
	//to the center of the vector connecting two moving agents.
	virtual btVector3 Interpose(const RigidEntity* VehicleA, const RigidEntity* VehicleB);
	
	//given another agent position to BehaviorType_Hide from and a list of BaseGameEntitys this
	//method attempts to put an obstacle between itself and its opponent
	virtual btVector3 Hide(const RigidEntity* hunter, const btAlignedObjectArray<RigidEntity*>& obstacles);
	
	
	// -- Group Behaviors -- //
	
	virtual btVector3 Cohesion(const btAlignedObjectArray<RigidEntity*> &agents);
	
	virtual btVector3 Separation(const btAlignedObjectArray<RigidEntity*> &agents);
	
	virtual btVector3 Alignment(const btAlignedObjectArray<RigidEntity*> &agents);
	
	//the following three are the same as above but they use cell-space
	//partitioning to find the neighbors
	virtual btVector3 CohesionPlus(const btAlignedObjectArray<RigidEntity*> &agents);
	virtual btVector3 SeparationPlus(const btAlignedObjectArray<RigidEntity*> &agents);
	virtual btVector3 AlignmentPlus(const btAlignedObjectArray<RigidEntity*> &agents);
    
    void CreateFeelers();
public:
    SIMD_FORCE_INLINE void On(const BehaviorType &bt, bool on = true)
    {
        if(on)
        {
            m_iFlags |= BehaviorType_OffsetPursuit;
        }
        else
        {
            if(IsOn(BehaviorType_Flee))
            m_iFlags ^=BehaviorType_Flee;
        }
    }
    
//private:
    //this function tests if a specific bit of m_iFlags is set
    SIMD_FORCE_INLINE bool      IsOn(BehaviorType bt)const
    {
        BehaviorType _bt = (BehaviorType)m_iFlags;
        int v = _bt & bt;
        bool ret = (v == 0)?false:true;
        return ret;
    }
    
    
protected:
    btVector3 m_LinearImpulse;
    btVector3 m_AngularImpulse;
    
    btVector3 m_DirectLinearImpulse;
    btVector3 m_DirectAngularImpulse;
private:
    //SteeringEntity *m_pOwner;
    //SteeringBehaviorInfo m_SteeringBehaviorInfo;
    
    //binary flags to indicate whether or not a behavior should be active
    int           m_iFlags;
    
    btVector3 m_SeekPosition;
    btVector3 m_ArriveOrigin;
    RigidEntity *m_pPursuitTarget;
    RigidEntity *m_pEvadeTarget;
    RigidEntity *m_pInterposeTarget1;
    RigidEntity *m_pInterposeTarget2;
    RigidEntity *m_pHideTarget;
    RigidEntity *m_pOffsetPursuitTarget;
    btVector3 m_OffsetPursuitOffset;
    
    btScalar m_dPanicDistanceSq;//=100.0f * 100.0f
    
    //length of the 'detection box' utilized in obstacle avoidance
	btScalar                 m_dDBoxLength;
    
    //new std::vector<btVector3>(4)
    btAlignedObjectArray<btVector3> *m_pFeelers;
    
    //the length of the 'feeler/s' used in wall detection
	btScalar                 m_dWallDetectionFeelerLength;//=10.0f
    
    //HeadingSmoother m_HeadingSmoother;
    
    btVector3 m_linearFactor;
    
    float					m_DirectLinearDamping;
	float					m_DirectAngularDamping;
    
    Path *m_pPath;
    
};

#endif /* defined(__GameAsteroids__BaseEntitySteeringBehavior__) */
