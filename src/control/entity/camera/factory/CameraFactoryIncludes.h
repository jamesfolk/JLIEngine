//
//  CameraFactoryIncludes.h
//  GameAsteroids
//
//  Created by James Folk on 3/29/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef GameAsteroids_CameraFactoryIncludes_h
#define GameAsteroids_CameraFactoryIncludes_h

#include "EntityFactoryIncludes.h"

enum CameraTypes
{
    CameraTypes_NONE,
    CameraTypes_Entity,
    CameraTypes_PhysicsEntity,
    CameraTypes_SteeringEntity,
    CameraTypes_MAX
};

class BaseCameraInfo
{
public:
    btScalar m_fieldOfViewDegrees;
    btScalar m_nearZ;
    btScalar m_farZ;
    btScalar m_left;
    btScalar m_right;
    btScalar m_top;
    btScalar m_bottom;
    CameraTypes m_CameraType;
    bool m_IsOrthographicCamera;
    
    BaseCameraInfo(btScalar fieldOfViewDegrees = 65.0f,
                   btScalar nearZ = 1.0f,
                   btScalar farZ = 1000.0f,
                   btScalar left = 0.0f,
                   btScalar right = 480.0f,
                   btScalar top = 320.0f,
                   btScalar bottom = 0.0f,
                   CameraTypes cameraType = CameraTypes_NONE,
                   bool isOrthographicCamera = false):
    m_fieldOfViewDegrees(fieldOfViewDegrees),
    m_nearZ(nearZ),
    m_farZ(farZ),
    m_left(left),
    m_right(right),
    m_top(top),
    m_bottom(bottom),
    m_CameraType(cameraType),
    m_IsOrthographicCamera(isOrthographicCamera)
    {}
    
    BaseCameraInfo(const BaseCameraInfo &rhs) :
    m_fieldOfViewDegrees(rhs.m_fieldOfViewDegrees),
    m_nearZ(rhs.m_nearZ),
    m_farZ(rhs.m_farZ),
    m_left(rhs.m_left),
    m_right(rhs.m_right),
    m_top(rhs.m_top),
    m_bottom(rhs.m_bottom),
    m_CameraType(rhs.m_CameraType),
    m_IsOrthographicCamera(rhs.m_IsOrthographicCamera)
    {
        
    }
    
    BaseCameraInfo &operator=(const BaseCameraInfo &rhs)
    {   
        if(this != &rhs)
        {
            m_fieldOfViewDegrees = rhs.m_fieldOfViewDegrees;
            m_nearZ = rhs.m_nearZ;
            m_farZ = rhs.m_farZ;
            m_left = rhs.m_left;
            m_right = rhs.m_right;
            m_top = rhs.m_top;
            m_bottom = rhs.m_bottom;
            m_CameraType = rhs.m_CameraType;
            m_IsOrthographicCamera = rhs.m_IsOrthographicCamera;
        }
        return *this;
    }
};

class CameraEntityInfo :
public BaseEntityInfo,
public BaseCameraInfo
{
public:
    CameraEntityInfo(bool isOrthographicCamera = false,
                     IDType viewObjectID = 0,
                     IDType stateMachineFactoryID = 0,
                     IDType animationFactoryID = 0,
                     bool isOrthographicEntity = false,
                     btScalar fieldOfViewDegrees = 65.0f,
                     btScalar nearZ = 1.0f,
                     btScalar farZ = 100.0f,
                     btScalar left = 0.0f,
                     btScalar right = 480.0f,
                     btScalar top = 320.0f,
                     btScalar bottom = 0.0f) :
    BaseEntityInfo(viewObjectID, stateMachineFactoryID, animationFactoryID, isOrthographicEntity),
    BaseCameraInfo(fieldOfViewDegrees,
                   nearZ, farZ,
                   left, right,
                   top, bottom,
                   CameraTypes_Entity,
                   isOrthographicCamera)
    {
        
    }
    
    CameraEntityInfo(const CameraEntityInfo &rhs) :
    BaseEntityInfo(rhs),
    BaseCameraInfo(rhs)
    {
        
    }
    
    CameraEntityInfo &operator=(const CameraEntityInfo &rhs)
    {
        BaseEntityInfo::operator=(rhs);
        BaseCameraInfo::operator=(rhs);
        
        return *this;
    }
};

class CameraPhysicsEntityInfo :
    public RigidEntityInfo,
    public BaseCameraInfo
{
public:
    CameraPhysicsEntityInfo(bool isOrthographicCamera = false,
                            IDType viewObjectID = 0,
                            IDType stateMachineFactoryID = 0,
                            IDType animationFactoryID = 0,
                            bool isOrthographicEntity = false,
                            IDType collisionShapeFactoryID = 0,
                            btScalar mass = 0,
                            btScalar fieldOfViewDegrees = 65.0f,
                            btScalar nearZ = 1.0f,
                            btScalar farZ = 100.0f,
                            btScalar left = 0.0f,
                            btScalar right = 480.0f,
                            btScalar top = 320.0f,
                            btScalar bottom = 0.0f) :
    RigidEntityInfo(viewObjectID, stateMachineFactoryID, animationFactoryID, isOrthographicEntity, collisionShapeFactoryID, mass),
    BaseCameraInfo(fieldOfViewDegrees,
                   nearZ, farZ,
                   left, right,
                   top, bottom,
                   CameraTypes_PhysicsEntity,
                   isOrthographicCamera)
    {
        
    }
    
    CameraPhysicsEntityInfo(const CameraPhysicsEntityInfo &rhs) :
    RigidEntityInfo(rhs),
    BaseCameraInfo(rhs)
    {
        
    }
    
    CameraPhysicsEntityInfo &operator=(const CameraPhysicsEntityInfo &rhs)
    {
        RigidEntityInfo::operator=(rhs);
        BaseCameraInfo::operator=(rhs);
        
        return *this;
    }
};
    
    
    
class CameraSteeringEntityInfo :
    public SteeringEntityInfo,
    public BaseCameraInfo
    
{
public:
    CameraSteeringEntityInfo(bool isOrthographicCamera = false,
                             IDType viewObjectID = 0,
                             IDType stateMachineFactoryID = 0,
                             IDType animationFactoryID = 0,
                             bool isOrthographicEntity = false,
                             IDType collisionShapeFactoryID = 0,
                             btScalar mass = 0,
                             IDType steeringBehaviorFactoryID = 0,
                             const WanderInfo &wanderInfo = WanderInfo(),
                             btScalar fieldOfViewDegrees = 65.0f,
                             btScalar nearZ = 1.0f,
                             btScalar farZ = 100.0f,
                             btScalar left = 0.0f,
                             btScalar right = 480.0f,
                             btScalar top = 320.0f,
                             btScalar bottom = 0.0f) :
    SteeringEntityInfo(viewObjectID, stateMachineFactoryID, animationFactoryID, isOrthographicEntity, collisionShapeFactoryID, mass, steeringBehaviorFactoryID, wanderInfo),
    BaseCameraInfo(fieldOfViewDegrees,
                   nearZ, farZ,
                   left, right,
                   top, bottom,
                   CameraTypes_SteeringEntity,
                   isOrthographicCamera)
    
    {
        
    }
    
    CameraSteeringEntityInfo(const CameraSteeringEntityInfo &rhs) :
    SteeringEntityInfo(rhs),
    BaseCameraInfo(rhs)
    {
        
    }
    CameraSteeringEntityInfo &operator=(const CameraSteeringEntityInfo &rhs)
    {
        SteeringEntityInfo::operator=(rhs);
        BaseCameraInfo::operator=(rhs);
        
        return *this;
    }
};

#endif
