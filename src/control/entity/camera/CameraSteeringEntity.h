//
//  CameraSteeringEntity.h
//  GameAsteroids
//
//  Created by James Folk on 4/11/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__CameraSteeringEntity__
#define __GameAsteroids__CameraSteeringEntity__

#include "CameraFactoryIncludes.h"
#include "BaseCamera.h"
#include "SteeringEntity.h"

class CameraSteeringEntity : public BaseCamera, public SteeringEntity
{
    friend class CameraFactory;
public:
    //BT_DECLARE_ALIGNED_ALLOCATOR();
    
    IDType getID()const
    {
        return BaseCamera::getID();
    }
    
    SIMD_FORCE_INLINE const std::string &getName()const
    {
        return BaseCamera::getName();
    }
    
    SIMD_FORCE_INLINE void setName(const std::string &name)
    {
        BaseCamera::setName(name);
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
    
private:
    CameraSteeringEntity();
    CameraSteeringEntity( const CameraSteeringEntityInfo& constructionInfo);
    virtual ~CameraSteeringEntity();
private:
    
    CameraSteeringEntity(const CameraSteeringEntity &rhs);
    CameraSteeringEntity &operator=(const CameraSteeringEntity &rhs);
};

#endif /* defined(__GameAsteroids__CameraSteeringEntity__) */
