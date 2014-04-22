//
//  RigidEntity.h
//  GameAsteroids
//
//  Created by James Folk on 3/11/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__PhysicsEntity__
#define __GameAsteroids__PhysicsEntity__

#include "BaseEntity.h"
#include "BaseEntitySteeringBehavior.h"
#include "CollisionShapeFactoryIncludes.h"
#include "SteeringBehaviorFactoryIncludes.h"

#include "GhostEntity.h"

#include "EntityFactoryIncludes.h"

class btRigidBody;

#define BIT(x) (1<<(x))



enum CollisionMask
{
    CollisionMask_NONE = 0, //<Collide with nothing
    CollisionMask_ONE = BIT(0), //<Collide with type one
    CollisionMask_TWO = BIT(1), //<Collide with type two
    CollisionMask_THREE = BIT(2), //<Collide with type three
    CollisionMask_FOUR = BIT(3), //<Collide with type four
    CollisionMask_FIVE = BIT(4), //<Collide with type five
    CollisionMask_SIX = BIT(5), //<Collide with type six
    CollisionMask_SEVEN = BIT(6), //<Collide with type seven
    CollisionMask_EIGHT = BIT(7), //<Collide with type eight
    CollisionMask_ALL = 0xFF //<Collide with everything
};

class RigidEntity : public BaseEntity
{
    friend class EntityFactory;
protected:
    RigidEntity( const RigidEntityInfo& constructionInfo);
    RigidEntity();
    virtual ~RigidEntity();
public:
    
    void setup(IDType collisionShapeID,
               btScalar mass,
               const btVector3 &origin = btVector3(0,0,0),
               const btQuaternion &rotation = btQuaternion::getIdentity(),
               CollisionMask group = CollisionMask_ALL,
               CollisionMask mask = CollisionMask_ALL);
//    void setup(IDType collisionShapeID,
//               btScalar mass,
//               const btTransform &initialTransform = btTransform::getIdentity(),
//               CollisionMask group = CollisionMask_ALL,
//               CollisionMask mask = CollisionMask_ALL);
    //BT_DECLARE_ALIGNED_ALLOCATOR();
    
    virtual void updateAction( btCollisionWorld* collisionWorld, btScalar deltaTimeStep);
    virtual void debugDraw(btIDebugDraw* debugDrawer);
    
    virtual void setOrigin(const btVector3 &pos);
    virtual void setRotation(const btQuaternion &rot);
    virtual void lookAt(const btVector3 &pos);
    
    virtual bool setScale(const btVector3 &scale);
    
    SIMD_FORCE_INLINE const btRigidBody*	getRigidBody() const
    {
		return m_btRigidBody;
	}
    
	SIMD_FORCE_INLINE btRigidBody*	getRigidBody()
    {
        return m_btRigidBody;
	}
    
    virtual void setDynamicPhysics();
    
    virtual SIMD_FORCE_INLINE bool isDynamicPhysics()const
    {
        return !(getRigidBody()->isStaticObject() || getRigidBody()->isKinematicObject());
        //return ((getRigidBody()->getCollisionFlags() & 0) != 0);
    }
    
    virtual void setKinematicPhysics();
    
    virtual SIMD_FORCE_INLINE bool isKinematicPhysics()const
    {
        return getRigidBody()->isKinematicObject();
    }
    
    virtual void setStaticPhysics();
    
    virtual SIMD_FORCE_INLINE bool isStaticPhysics()const
    {
        return getRigidBody()->isStaticObject();
    }
    
    virtual void enableCollision(const bool enable = true);
    virtual bool isCollisionEnabled()const;
    
    virtual void enableHandleCollision(const bool enable = true);
    virtual bool isCollisionHandleEnabled()const;
    
    virtual void enableDebugDraw(const bool enable = true);
    virtual bool isEnableDebugDraw()const;
    
    btScalar     getLinearSpeed()const;
	btScalar     getLinearSpeedSq()const;
    
    btScalar getAngularSpeed()const;
    btScalar getAngularSpeedSq()const;
    
    void setLinearSpeed(const btScalar speed);
    void setAngularSpeed(const btScalar speed);
    
    btVector3 getLinearVelocityHeading()const;
    
    virtual btTransform getWorldTransform() const;
    virtual void setWorldTransform(const btTransform& worldTrans);
    
    const btCollisionShape*	getCollisionShape() const;
    btCollisionShape*	getCollisionShape();
    void setCollisionShape(const IDType ID);
    
    btScalar getMass()const;
    void setMass(const btScalar mass);
    
    
    
    void setCollisionMask(CollisionMask mask);
    CollisionMask getCollisionMask()const;
    void enableCollisionMask(CollisionMask mask, bool enable = true);
    bool hasCollisionMask(CollisionMask mask)const;
    
    void setCollisionGroup(CollisionMask group);
    CollisionMask getCollisionGroup()const;
    void enableCollisionGroup(CollisionMask mask, bool enable = true);
    bool hasCollisionGroup(CollisionMask group)const;
    
    static bool isMaskInGroup(CollisionMask group, CollisionMask mask);
    
private:
    btRigidBody *m_btRigidBody;
    //CollisionShapeType m_CollisionShapeType;
    IDType m_CollisionShapeFactoryID;
    btScalar m_Mass;
private:
    
    RigidEntity(const RigidEntity &rhs);
    RigidEntity &operator=(const RigidEntity &rhs);
    
};

#endif /* defined(__GameAsteroids__PhysicsEntity__) */
