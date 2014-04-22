//
//  GhostEntity.h
//  GameAsteroids
//
//  Created by James Folk on 4/17/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__GhostEntity__
#define __GameAsteroids__GhostEntity__

#include "BaseEntity.h"
#include "BaseEntitySteeringBehavior.h"
#include "CollisionShapeFactoryIncludes.h"
#include "SteeringBehaviorFactoryIncludes.h"

#include "BaseViewObject.h"

#include "EntityFactoryIncludes.h"

class btPairCachingGhostObject;
class BaseEntity;

class GhostEntity : public BaseEntity
{
    friend class EntityFactory;
protected:
    GhostEntity( const GhostEntityInfo& constructionInfo);
    GhostEntity();
    virtual ~GhostEntity();
public:
    void setup(IDType collisionShapeID, const btTransform &initialTransform = btTransform::getIdentity());
    //BT_DECLARE_ALIGNED_ALLOCATOR();
    
    virtual void updateAction( btCollisionWorld* collisionWorld, btScalar deltaTimeStep);
    virtual void debugDraw(btIDebugDraw* debugDrawer);
    
    virtual void setOrigin(const btVector3 &pos);
    virtual void setRotation(const btQuaternion &rot);
    virtual void lookAt(const btVector3 &pos);
    
    virtual bool setScale(const btVector3 &scale);
    
    SIMD_FORCE_INLINE const btPairCachingGhostObject*	getGhostObject() const {
		return m_btPairCachingGhostObject;
	}
    
	SIMD_FORCE_INLINE btPairCachingGhostObject*	getGhostObject() {
        return m_btPairCachingGhostObject;
	}
    
//    virtual void show();
//    virtual void hide();
    
    virtual void enableCollision(const bool enable = true);
    virtual bool isCollisionEnabled()const;
    
    virtual void enableDebugDraw(const bool enable = true);
    virtual bool isEnableDebugDraw()const;
    
    virtual btTransform getWorldTransform() const;
    virtual void setWorldTransform(const btTransform& worldTrans);
private:
    btPairCachingGhostObject *m_btPairCachingGhostObject;
    IDType m_CollisionShapeID;
    bool m_CollisionEnabled;
private:
    
    GhostEntity(const GhostEntity &rhs);
    GhostEntity &operator=(const GhostEntity &rhs);
    
};

#endif /* defined(__GameAsteroids__GhostEntity__) */
