//
//  SoftEntity.h
//  GameAsteroids
//
//  Created by James Folk on 7/6/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__SoftEntity__
#define __GameAsteroids__SoftEntity__

#include "BaseEntity.h"
#include "BaseEntitySteeringBehavior.h"
#include "CollisionShapeFactoryIncludes.h"
#include "SteeringBehaviorFactoryIncludes.h"

#include "GhostEntity.h"

#include "EntityFactoryIncludes.h"

class SoftEntity : public BaseEntity
{
    friend class EntityFactory;
protected:
    SoftEntity( const SoftEntityInfo& constructionInfo);
    SoftEntity();
    virtual ~SoftEntity();
public:
    //BT_DECLARE_ALIGNED_ALLOCATOR();
    
    virtual void updateAction( btCollisionWorld* collisionWorld, btScalar deltaTimeStep);
    virtual void debugDraw(btIDebugDraw* debugDrawer);
    
    virtual void setOrigin(const btVector3 &pos);
    virtual void setRotation(const btQuaternion &rot);
    virtual void lookAt(const btVector3 &pos);
    
    virtual bool setScale(const btVector3 &scale);
    
    SIMD_FORCE_INLINE const btSoftBody*	getSoftBody() const {
		return m_btSoftBody;
	}
    
	SIMD_FORCE_INLINE btSoftBody*	getSoftBody() {
        return m_btSoftBody;
	}
    
    virtual void setDynamicPhysics();
    
    virtual SIMD_FORCE_INLINE bool isDynamicPhysics()const
    {
        return ((getSoftBody()->getCollisionFlags() & 0) != 0);
    }
    
    virtual void setKinematicPhysics();
    
    virtual SIMD_FORCE_INLINE bool isKinematicPhysics()const
    {
        return getSoftBody()->isKinematicObject();
    }
    
    virtual void setStaticPhysics();
    
    virtual SIMD_FORCE_INLINE bool isStaticPhysics()const
    {
        return ((getSoftBody()->getCollisionFlags() & btCollisionObject::CF_STATIC_OBJECT) != 0);
    }
    
    virtual void enableCollision(const bool enable = true);
    virtual bool isCollisionEnabled()const;
    
    virtual void enableHandleCollision(const bool enable = true);
    virtual bool isCollisionHandleEnabled()const;
    
//    virtual void handleRigidBodyCollide(BaseEntity *pOtherEntity, const btManifoldPoint&pt);
//    virtual void handleGhostBodyCollide(GhostEntity *pOtherEntity, const btManifoldPoint &pt);
//	virtual void handleCollisionNear(BaseEntity *pOtherEntity, btScalar timeOfImpact);
    
    btScalar     getLinearSpeed()const;
	btScalar     getLinearSpeedSq()const;
    
    btScalar getAngularSpeed()const;
    btScalar getAngularSpeedSq()const;
    
    void setLinearSpeed(const btScalar speed);
    void setAngularSpeed(const btScalar speed);
    
    btVector3 getLinearVelocityHeading()const;
    virtual btTransform getWorldTransform() const;
    virtual void setWorldTransform(const btTransform& worldTrans);
    
    virtual void render(BaseCamera *pCamera = NULL);
private:
    btSoftBody *m_btSoftBody;
    //CollisionShapeType m_CollisionShapeType;
    //IDType m_CollisionShapeFactoryID;
    btScalar m_Mass;
    
private:
    
    SoftEntity(const SoftEntity &rhs);
    SoftEntity &operator=(const SoftEntity &rhs);
};

#endif /* defined(__GameAsteroids__SoftEntity__) */
