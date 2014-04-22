//
//  CameraPhysicsEntity.h
//  GameAsteroids
//
//  Created by James Folk on 3/29/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__CameraPhysicsEntity__
#define __GameAsteroids__CameraPhysicsEntity__

#include "CameraFactoryIncludes.h"
#include "BaseCamera.h"
#include "RigidEntity.h"

class CameraPhysicsEntity : public BaseCamera, public RigidEntity
{
    friend class CameraFactory;
public:
    //BT_DECLARE_ALIGNED_ALLOCATOR();
    
    IDType getID()const
    {
        return BaseCamera::getID();
    }
    
    virtual void updateAction( btCollisionWorld* collisionWorld, btScalar deltaTimeStep);
	virtual void debugDraw(btIDebugDraw* debugDrawer);
    
    virtual btVector3 getHeadingVector()const;
	virtual btVector3 getUpVector()const;
    virtual btVector3 getSideVector()const;
    
    virtual btVector3 getOrigin()const;
    virtual void setOrigin(const btVector3 &pos);
    
    virtual btQuaternion getRotation()const;
    virtual void setRotation(const btQuaternion &rot);
    
//    virtual void setHeadingVector(const btVector3 &vec);
    
    virtual void lookAt(const btVector3 &pos, const btVector3 &up = g_vUpVector);
//    virtual void rotateHeader(const btQuaternion &rot);
    
    virtual btTransform getWorldTransform() const;
    virtual void setWorldTransform(const btTransform& worldTrans);
    
//    const CameraPhysicsEntityInfo &getCameraPhysicsEntityInfo()const
//    {
//        return m_CameraPhysicsEntityInfo;
//    }
    
    virtual void enableCollision(const bool enable = true);
    virtual bool isCollisionEnabled()const;
private:
    CameraPhysicsEntity();
    CameraPhysicsEntity( const CameraPhysicsEntityInfo& constructionInfo);
    virtual ~CameraPhysicsEntity();
    
    //CameraPhysicsEntityInfo m_CameraPhysicsEntityInfo;
private:
    
    CameraPhysicsEntity(const CameraPhysicsEntity &rhs);
    CameraPhysicsEntity &operator=(const CameraPhysicsEntity &rhs);
};

#endif /* defined(__GameAsteroids__CameraPhysicsEntity__) */
