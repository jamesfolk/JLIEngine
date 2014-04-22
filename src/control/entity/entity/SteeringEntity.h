//
//  SteeringEntity.h
//  GameAsteroids
//
//  Created by James Folk on 4/9/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__SteeringEntity__
#define __GameAsteroids__SteeringEntity__

#include "RigidEntity.h"
#include "CollisionShapeFactoryIncludes.h"
#include "FrameCounter.h"

#include "EntityFactoryIncludes.h"
#include "EntityFactory.h"

class btRigidBody;



class SteeringEntity : public RigidEntity
{

    friend class EntityFactory;
    friend class BaseEntitySteeringBehavior;
protected:
    SteeringEntity( const SteeringEntityInfo& constructionInfo);
    SteeringEntity();
    virtual ~SteeringEntity();
public:
    //BT_DECLARE_ALIGNED_ALLOCATOR();
    void setup(IDType collisionShapeID,
               btScalar mass,
               const btVector3 &origin = btVector3(0,0,0),
               const btQuaternion &rotation = btQuaternion::getIdentity(),
               CollisionMask group = CollisionMask_ALL,
               CollisionMask mask = CollisionMask_ALL);
    
    virtual btTransform getWorldTransform() const;
    virtual void setWorldTransform(const btTransform& worldTrans);
    
    virtual void updateAction( btCollisionWorld* collisionWorld, btScalar deltaTimeStep);
    virtual void debugDraw(btIDebugDraw* debugDrawer);
    
    
    
    
    const BaseEntitySteeringBehavior*	getSteeringBehavior() const;
    BaseEntitySteeringBehavior*	getSteeringBehavior();
    void setSteeringBehavior(const IDType ID);
    
    virtual void setStaticPhysics()
    {
        btAssert(true && "steering entity cannot be static");
    }
    
    virtual SIMD_FORCE_INLINE bool isStaticPhysics()const
    {
        return false;
    }
    
    btScalar     getMaxLinearSpeed()const;
	void      setMaxLinearSpeed(const btScalar new_speed);
    
    btScalar getMaxAngularSpeed()const;
    void setMaxAngularSpeed(const btScalar new_speed);
    
    btScalar getMaxLinearForce()const;
    void setMaxLinearForce(const btScalar max_force);
    
    btScalar getMaxAngularForce()const;
    void setMaxAngularForce(const btScalar max_force);
    
    SIMD_FORCE_INLINE const WanderInfo*	getWanderInfo() const
    {
        return m_WanderInfo;
    }
    
    SIMD_FORCE_INLINE WanderInfo*	getWanderInfo()
    {
        return m_WanderInfo;
    }
    
    SIMD_FORCE_INLINE const FollowPathInfo * getFolowPathInfo() const
    {
        return m_FollowPathInfo;
    }
    
    SIMD_FORCE_INLINE FollowPathInfo*	getFolowPathInfo()
    {
        return m_FollowPathInfo;
    }
    
    class WallAvoidanceFunction
    {
    public:
        WallAvoidanceFunction();
        ~WallAvoidanceFunction();
        
        void SetFrom(const btVector3 &from);
        void SetTo(const btVector3 &to);
        void Set(const btVector3 &from, const btVector3 &to);
        
        void operator() (BaseEntity *e);
    private:
        btVector3 m_From;
        btVector3 m_To;
    private:
        btScalar m_DistToClosestIP;
        BaseEntity *m_ClosestWall;
        btVector3 m_ClosestPoint;
    public:
        btVector3 GetClosestPoint();
        const BaseEntity *GetClosestWall();
    };
    
    SIMD_FORCE_INLINE void clearSteering()
    {
        m_SteeringFlags = BehaviorType_NONE;
    }
    
    
    SIMD_FORCE_INLINE void	pursue(IDType targetID)
    {
        On(BehaviorType_Pursuit);
        
        m_PursueTargetID = targetID;
    }
    
    
    SIMD_FORCE_INLINE RigidEntity*	getPursuitTarget()
    {
        return dynamic_cast<RigidEntity*>(EntityFactory::getInstance()->get(m_PursueTargetID));
    }
    
    //this function tests if a specific bit of m_iFlags is set
    SIMD_FORCE_INLINE bool      IsOn(BehaviorType bt)const
    {
        BehaviorType _bt = (BehaviorType)m_SteeringFlags;
        int v = _bt & bt;
        bool ret = (v == 0)?false:true;
        return ret;
    }
    
    
    bool accumulateLinearForce(btVector3 &RunningTot, const btVector3 &ForceToAdd);
    bool accumulateAngularForce(btVector3 &runningTotal, const btVector3 &forceToAdd);
    
private:
    
    static bool accumlateForce(btVector3 &runningTotal, const btVector3 &forceToAdd, const btScalar maxForce);
    
    SIMD_FORCE_INLINE void On(const BehaviorType &bt, bool on = true)
    {
        if(on)
        {
            m_SteeringFlags |= bt;
        }
        else
        {
            if(IsOn(bt))
            {
                m_SteeringFlags ^= bt;
            }
        }
    }
    
    
    
    IDType m_steeringBehaviorFactoryID;
    //BaseEntitySteeringBehavior *m_sb;
    btScalar m_MaxLinearSpeed;
    btScalar m_MaxLinearForce;
    btScalar m_MaxAngularSpeed;
    btScalar m_MaxAngularForce;
    WanderInfo *m_WanderInfo;
    FollowPathInfo *m_FollowPathInfo;
    
    unsigned long long m_SteeringFlags;
    IDType m_PursueTargetID;
private:
    
    SteeringEntity(const SteeringEntity &rhs);
    SteeringEntity &operator=(const SteeringEntity &rhs);
    
};

#endif /* defined(__GameAsteroids__SteeringEntity__) */
