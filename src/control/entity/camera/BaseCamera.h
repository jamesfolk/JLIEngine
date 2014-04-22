//
//  BaseCamera.h
//  GameAsteroids
//
//  Created by James Folk on 3/29/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__BaseCamera__
#define __GameAsteroids__BaseCamera__

#include "CameraFactoryIncludes.h"



class btQuaternion;
class btTransform;
#include "btScalar.h"

#include "btBulletDynamicsCommon.h"

#include "UtilityFunctions.h"

#include "AbstractFactory.h"

struct BaseCameraInfo;

class BaseEntity;
class btPairCachingGhostObject;

class BaseCamera :
public btActionInterface,
public AbstractFactoryObject
{
    friend class CameraFactory;
public:
//    static BaseCamera *create(int type = 0);
//    static bool destroy(IDType &_id);
//    static bool destroy(BaseCamera *entity);
//    static BaseCamera *get(IDType _id);
    
    //BT_DECLARE_ALIGNED_ALLOCATOR();
    
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
    
    static btConvexHullShape *createCollisionShape(const BaseCamera &camera);
    
    virtual void updateAction( btCollisionWorld* collisionWorld, btScalar deltaTimeStep);
	virtual void debugDraw(btIDebugDraw* debugDrawer);
    
    virtual btVector3 getHeadingVector()const = 0;
	virtual btVector3 getUpVector()const = 0;
    virtual btVector3 getSideVector()const = 0;
    
    virtual btVector3 getOrigin()const = 0;
    virtual void setOrigin(const btVector3 &pos);
    
    virtual btQuaternion getRotation()const = 0;
    virtual void setRotation(const btQuaternion &rot);
    
//    virtual void setHeadingVector(const btVector3 &vec);
    
    virtual void lookAt(const btVector3 &pos, const btVector3 &up = g_vUpVector) = 0;
    
    virtual btTransform getWorldTransform() const = 0;
    virtual void setWorldTransform(const btTransform& worldTrans) = 0;
    
//    virtual void rotateHeader(const btQuaternion &rot) = 0;
    
    virtual void cull(btDbvtBroadphase*	pbp);
    
//    virtual GLKMatrix4 getProjection()const;
    virtual btTransform getProjection2()const;
    
    SIMD_FORCE_INLINE btScalar getLeft()const
    {
        return m_BaseCameraInfo->m_left;
    }
    SIMD_FORCE_INLINE btScalar getRight()const
    {
        return m_BaseCameraInfo->m_right;
    }
    SIMD_FORCE_INLINE btScalar getTop()const
    {
        return m_BaseCameraInfo->m_top;
    }
    SIMD_FORCE_INLINE btScalar getBottom()const
    {
        return m_BaseCameraInfo->m_bottom;
    }
    SIMD_FORCE_INLINE btScalar getFar()const
    {
        return m_BaseCameraInfo->m_farZ;
    }
    SIMD_FORCE_INLINE btScalar getNear()const
    {
        return m_BaseCameraInfo->m_nearZ;
    }
    
    SIMD_FORCE_INLINE btScalar getFieldOfViewDegrees()const
    {
        return m_BaseCameraInfo->m_fieldOfViewDegrees;
    }
    
    btVector3 unProject(const btVector3 &screenPosition)const;
    btVector3 project(const btVector3 &worldPosition)const;
    
    //positive means closer to camera
    void setZOrder(const BaseEntity *entityBottom, BaseEntity *entityTop, const float amt = 0.01f)const;
    

    virtual void setPerspective(btScalar near, btScalar far, btScalar fieldOfView);
    virtual void setOrthographic(btScalar near, btScalar far,
                                 btScalar left, btScalar right,
                                 btScalar top, btScalar bottom);
    
    virtual btVector3 getTopLeftVector()const;
    virtual btVector3 getTopRightVector()const;
    virtual btVector3 getBottomLeftVector()const;
    virtual btVector3 getBottomRightVector()const;
protected:
    virtual void updateProjection();
    virtual void updateALOrientation();
    
    BaseCamera(const BaseCameraInfo& constructionInfo);
    BaseCamera();
    virtual ~BaseCamera();
    
private:
    
    
//    btScalar m_fieldOfViewDegrees;
//    btScalar m_nearZ;
//    btScalar m_farZ;
//    btScalar m_left;
//    btScalar m_right;
//    btScalar m_top;
//    btScalar m_bottom;
    //btScalar m_centralPlane;
    
//    bool m_UpdatePlanes;
//    GLKMatrix4 m_projectionMatrix;
    btTransform m_projectionMatrix2;
    BaseCameraInfo *m_BaseCameraInfo;
    GLfloat *m_Orientation;
    
//    btVector3	m_planeNormals[5];
//	btScalar	m_planeOffsets[5];
//public:
//    static btVector3 *s_c00;
//    static btVector3 *s_c10;
//    static btVector3 *s_c01;
//    static btVector3 *s_c11;
public:
    //bool m_IsOrthographicCamera;
    //CameraProjectionTypes m_CameraProjectionTypes;
    
    
private:
//    void adjustTransform(GLfloat delta, GLfloat pz);
    
    
    BaseCamera(const BaseCamera &rhs);
    BaseCamera &operator=(const BaseCamera &rhs);
};

#endif /* defined(__GameAsteroids__BaseCamera__) */
