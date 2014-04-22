//
//  CameraEntity.h
//  GameAsteroids
//
//  Created by James Folk on 3/12/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__CameraEntity__
#define __GameAsteroids__CameraEntity__

#include "CameraFactoryIncludes.h"
#include "BaseCamera.h"
#include "BaseEntity.h"
//#include "AbstractLuaFactoryObject.h"
#include "CameraFactory.h"

class CameraEntity : public BaseCamera, public BaseEntity//, public AbstractLuaFactoryObject<CameraEntity, CameraFactory>
{
    friend class CameraFactory;
public:
    
    static BaseCamera *create(int type = 0);
    static bool destroy(IDType &_id);
    static bool destroy(BaseCamera *entity);
    static BaseCamera *get(IDType _id);
    
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
    
    virtual void enableCollision(const bool enable = true){}
    virtual bool isCollisionEnabled()const{return false;}
private:
    CameraEntity();
    CameraEntity( const CameraEntityInfo& constructionInfo);
    virtual ~CameraEntity();
private:
    
    CameraEntity(const CameraEntity &rhs);
    CameraEntity &operator=(const CameraEntity &rhs);
};

#endif /* defined(__GameAsteroids__Camera__) */
