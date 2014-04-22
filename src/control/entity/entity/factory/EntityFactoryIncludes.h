//
//  EntityFactoryIncludes.h
//  GameAsteroids
//
//  Created by James Folk on 4/18/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef GameAsteroids_EntityFactoryIncludes_h
#define GameAsteroids_EntityFactoryIncludes_h

#include "AbstractFactoryIncludes.h"
#include "ViewObjectFactoryIncludes.h"
#include "EntityStateMachineFactoryIncludes.h"
#include "AnimationControllerFactoryIncludes.h"
#include "SteeringBehaviorFactoryIncludes.h"
#include "CollisionShapeFactoryIncludes.h"

#include "btVector3.h"
#include "FrameCounter.h"
#include "btQuaternion.h"
#include "UtilityFunctions.h"

class EntityFactory;

//typedef unsigned long long int EntityID;

enum EntityTypes
{
    EntityTypes_NONE,
    EntityTypes_BaseEntity,
    EntityTypes_RigidEntity,
    EntityTypes_SteeringEntity,
    EntityTypes_GhostEntity,
    EntityTypes_SoftEntity,
    
    EntityTypes_MAX
};

class BaseViewObject;


class BaseEntityInfo
{
public:
    IDType m_ViewObjectID;
    IDType m_StateMachineFactoryID;
    IDType m_AnimationFactoryID;
    EntityTypes m_EntityType;
    bool m_IsOrthographicEntity;
    GLenum m_drawMode;
    
    virtual ~BaseEntityInfo(){}
    
    BaseEntityInfo(IDType viewObjectID = 0,
                   IDType stateMachineFactoryID = 0,
                   IDType animationFactoryID = 0,
                   bool isOrthographicEntity = false,
                   GLenum drawMode = GL_TRIANGLES) :
    m_ViewObjectID(viewObjectID),
    m_StateMachineFactoryID(stateMachineFactoryID),
    m_AnimationFactoryID(animationFactoryID),
    m_EntityType(EntityTypes_BaseEntity),
    m_IsOrthographicEntity(isOrthographicEntity),
    m_drawMode(drawMode)
    {
        
    }
    
    BaseEntityInfo(const BaseEntityInfo &rhs) :
    m_ViewObjectID(rhs.m_ViewObjectID),
    m_StateMachineFactoryID(rhs.m_StateMachineFactoryID),
    m_AnimationFactoryID(rhs.m_AnimationFactoryID),
    m_EntityType(rhs.m_EntityType),
    m_IsOrthographicEntity(rhs.m_IsOrthographicEntity),
    m_drawMode(rhs.m_drawMode)
    {
        
    }
    BaseEntityInfo &operator=(const BaseEntityInfo &rhs)
    {
        if(this != &rhs)
        {
            m_ViewObjectID = rhs.m_ViewObjectID;
            m_StateMachineFactoryID = rhs.m_StateMachineFactoryID;
            m_AnimationFactoryID = rhs.m_AnimationFactoryID;
            m_EntityType = rhs.m_EntityType;
            m_IsOrthographicEntity = rhs.m_IsOrthographicEntity;
            m_drawMode = rhs.m_drawMode;
        }
        return *this;
    }
};


/*
 Set mass to be zero if static is desired.
 */
class RigidEntityInfo : public BaseEntityInfo
{
public:
    IDType m_collisionShapeFactoryID;
    btScalar m_mass;
    
    RigidEntityInfo(IDType viewObjectID = 0,
                      IDType stateMachineFactoryID = 0,
                      IDType animationFactoryID = 0,
                      bool isOrthographicEntity = false,
                      IDType collisionShapeFactoryID = 0,
                      btScalar mass = 0) :
    BaseEntityInfo(viewObjectID, stateMachineFactoryID, animationFactoryID, isOrthographicEntity),
    m_collisionShapeFactoryID(collisionShapeFactoryID),
    m_mass(mass)
    {
        m_EntityType = EntityTypes_RigidEntity;
    }

    RigidEntityInfo(const RigidEntityInfo &rhs) :
    BaseEntityInfo(rhs),
    m_collisionShapeFactoryID(rhs.m_collisionShapeFactoryID),
    m_mass(rhs.m_mass)
    {
    }
    
    RigidEntityInfo &operator=(const RigidEntityInfo &rhs)
    {   
        if(this != &rhs)
        {
            BaseEntityInfo::operator=(rhs);
            
            m_collisionShapeFactoryID = rhs.m_collisionShapeFactoryID;
            m_mass = rhs.m_mass;
        }
        return *this;
    }
};
    
class SoftEntityInfo : public BaseEntityInfo
{
public:
    btScalar m_mass;
    
    SoftEntityInfo(){m_EntityType = EntityTypes_SoftEntity;}
    ~SoftEntityInfo(){}
};

class FollowPathInfo
{
    float m_dWaypointSeekDistSq;
public:
    FollowPathInfo(float waypointSeekDistance = .20f) :
    m_dWaypointSeekDistSq(waypointSeekDistance * waypointSeekDistance)
    {
        
    }
    
    void setWayPointSeekDistance(const float waypointSeekDistance)
    {
        m_dWaypointSeekDistSq = (waypointSeekDistance * waypointSeekDistance);
    }
    
    float getWayPointSeekDistanceSquared()const
    {
        return m_dWaypointSeekDistSq;
    }
};

class WanderInfo
{
    btScalar m_dWanderJitter;
    btScalar m_dWanderRadius;
    btVector3 m_vWanderTarget;
    btScalar m_dWanderDistance;
public:
    explicit WanderInfo(btScalar wanderJitter = 1.0f,
                        btScalar wanderRadius = 10.5f,
                        btVector3 wanderTarget = g_vHeadingVector,
                        btScalar wanderDistance = 10.0f) :
    m_dWanderJitter(wanderJitter),
    m_dWanderRadius(wanderRadius),
    m_vWanderTarget(wanderTarget),
    m_dWanderDistance(wanderDistance)
    {
        btScalar up,side,heading;
        
        m_vWanderTarget = m_vWanderTarget.rotate(g_vHeadingVector, heading = DEGREES_TO_RADIANS(randomScalarInRange(0, 360.0)));
        
        m_vWanderTarget.normalize();
    }
    
    WanderInfo(const WanderInfo &rhs) :
    m_dWanderJitter(rhs.m_dWanderJitter),
    m_dWanderRadius(rhs.m_dWanderRadius),
    m_vWanderTarget(rhs.m_vWanderTarget),
    m_dWanderDistance(rhs.m_dWanderDistance)
    {
    }
    
    WanderInfo &operator=(const WanderInfo &rhs)
    {
        if(this != &rhs)
        {
            m_dWanderJitter = rhs.m_dWanderJitter;
            m_dWanderRadius = rhs.m_dWanderRadius;
            m_vWanderTarget = rhs.m_vWanderTarget;
            m_dWanderDistance = rhs.m_dWanderDistance;
        }
        return *this;
    }
    
    void rotateTarget()
    {
        btScalar JitterThisTimeSlice = m_dWanderJitter * FrameCounter::getInstance()->getCurrentDiffTime();
        
        btQuaternion randomRotation(randomScalarClamped() * JitterThisTimeSlice,
                                    randomScalarClamped() * JitterThisTimeSlice,
                                    randomScalarClamped() * JitterThisTimeSlice);
        
        m_vWanderTarget.normalize();
        m_vWanderTarget *= m_dWanderRadius;
        m_vWanderTarget = quatRotate(randomRotation, m_vWanderTarget);
    }
    const btVector3 &getTarget()const
    {
        return m_vWanderTarget;
    }
    void setJitter(const btScalar jitter)
    {
        m_dWanderJitter = jitter;
    }
    
    void setRadius(const btScalar radius)
    {
        m_dWanderRadius = radius;
    }
    btScalar getRadius()
    {
        return m_dWanderRadius;
    }
    
    void setDistance(const btScalar distance)
    {
        m_dWanderDistance = distance;
    }
    btScalar getDistance()const
    {
        return m_dWanderDistance;
    }
    
};

class SteeringEntityInfo : public RigidEntityInfo
{
public:
    IDType m_steeringBehaviorFactoryID;
    WanderInfo m_WanderInfo;
    FollowPathInfo m_FollowPathInfo;
    
    SteeringEntityInfo(IDType viewObjectID = 0,
                       IDType stateMachineFactoryID = 0,
                       IDType animationFactoryID = 0,
                       bool isOrthographicEntity = false,
                       IDType collisionShapeFactoryID = 0,
                       btScalar mass = 0,
                       IDType steeringBehaviorFactoryID = 0,
                       const WanderInfo &wanderInfo = WanderInfo(),
                       const FollowPathInfo &followPathInfo = FollowPathInfo()) :
    RigidEntityInfo(viewObjectID, stateMachineFactoryID, animationFactoryID, isOrthographicEntity, collisionShapeFactoryID, mass),
    m_steeringBehaviorFactoryID(steeringBehaviorFactoryID),
    m_WanderInfo(wanderInfo),
    m_FollowPathInfo(followPathInfo)
    {
        m_EntityType = EntityTypes_SteeringEntity;
    }
    
    SteeringEntityInfo(const SteeringEntityInfo &rhs) :
    RigidEntityInfo(rhs),
    m_steeringBehaviorFactoryID(rhs.m_steeringBehaviorFactoryID),
    m_WanderInfo(rhs.m_WanderInfo)
    {
        
    }
    
    SteeringEntityInfo &operator=(const SteeringEntityInfo &rhs)
    {
        if(this != &rhs)
        {
            RigidEntityInfo::operator=(rhs);
            
            m_steeringBehaviorFactoryID = rhs.m_steeringBehaviorFactoryID;
            m_WanderInfo = rhs.m_WanderInfo;
        }
        return *this;
    }
};
    
class GhostEntityInfo : public BaseEntityInfo
{
public:
    IDType m_collisionShapeFactoryID;
    
    GhostEntityInfo(IDType viewObjectID = 0,
                    IDType stateMachineFactoryID = 0,
                    IDType animationFactoryID = 0,
                    bool isOrthographicEntity = false,
                    IDType collisionShapeFactoryID = 0) :
    BaseEntityInfo(viewObjectID, stateMachineFactoryID, animationFactoryID, isOrthographicEntity),
    m_collisionShapeFactoryID(collisionShapeFactoryID)
    {
        m_EntityType = EntityTypes_GhostEntity;
    }
    
    GhostEntityInfo(const GhostEntityInfo &rhs) :
    BaseEntityInfo(rhs),
    m_collisionShapeFactoryID(rhs.m_collisionShapeFactoryID)
    {
    }
    
    GhostEntityInfo &operator=(const GhostEntityInfo &rhs)
    {
        if(this != &rhs)
        {
            BaseEntityInfo::operator=(rhs);
            m_collisionShapeFactoryID = rhs.m_collisionShapeFactoryID;
        }
        return *this;
    }
};

#endif
