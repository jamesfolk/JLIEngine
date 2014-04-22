//
//  WorldPhysics.h
//  GameAsteroids
//
//  Created by James Folk on 3/8/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__WorldPhysics__
#define __GameAsteroids__WorldPhysics__

#include "btBulletDynamicsCommon.h"
#include "BulletSoftBody/btSoftRigidDynamicsWorld.h"
#include "BulletSoftBody/btSoftBodyRigidBodyCollisionConfiguration.h"
//#include <map>
#include "CollisionShapeFactoryIncludes.h"

#include "BulletCollision/CollisionDispatch/btGhostObject.h"

class BaseEntity;
class BaseViewObject;
class RigidEntity;
class GhostEntity;
class SoftEntity;
class BaseCamera;
//class OcclusionBuffer;
//class SceneRenderer;

struct btRigidBodyForceWrapper
{
    btRigidBody *pRigidBody;
    btVector3 m_LinearForce;
    btVector3 m_AngularForce;
    
    btRigidBodyForceWrapper(){}
    virtual ~btRigidBodyForceWrapper(){}
};

struct WorldPhysicsInfo
{
    btVector3 gravity;
    btVector3 worldAabbMin;
	btVector3 worldAabbMax;
    
    WorldPhysicsInfo(const btVector3 &_gravity = btVector3(0,-9.81,0),
                     const btVector3 &_worldAabbMin = btVector3(-1000,-1000,-1000),
                     const btVector3 &_worldAabbMax = btVector3(1000,1000,1000)) :
    gravity(_gravity),
    worldAabbMin(_worldAabbMin),
    worldAabbMax(_worldAabbMax)
    {}
};

class CustomFilterCallback : public btOverlapFilterCallback
{
public:
    CustomFilterCallback();
    virtual ~CustomFilterCallback();
    
	// return true when pairs need collision
	virtual bool needBroadphaseCollision(btBroadphaseProxy* proxy0,btBroadphaseProxy* proxy1) const;
};

class WorldPhysics
{
    
    
    
    
private:
    static WorldPhysics *s_WorldPhysics;
public:    
    static BaseEntity *getEntity(const btCollisionObject *pCollisionObject);
    static BaseEntity *getEntity(btBroadphaseProxy *proxy);

    static void createInstance(const WorldPhysicsInfo& constructionInfo = WorldPhysicsInfo());
    static WorldPhysics *getInstance();
    static void destroyInstance();
    
public:
    void update();
    void render();
    
    void initDebugDrawWorld();
    void debugDrawWorld();
    
    bool isActionObject(BaseEntity *pBaseEntity);
    void addActionObject(btActionInterface *pBaseEntity);
    void removeActionObject(btActionInterface *pBaseEntity);
    
    btRigidBody *addRigidBody(RigidEntity *pPhysicsEntity,
                              const btTransform &initialTransform,
                              btScalar mass,
                              IDType collisionShapeFactoryID);
    
    btRigidBody *addRigidBody(RigidEntity *pPhysicsEntity,
                              const btTransform &initialTransform,
                              btScalar mass,
                              IDType collisionShapeFactoryID, short group, short mask);
    
    void removeRigidBody(btRigidBody *obj);
    
    btPairCachingGhostObject *addGhostObject(GhostEntity *pGhostEntity,
                                             IDType collisionShapeFactoryID);
    void removeGhostObject(btPairCachingGhostObject *obj);
    
    void ghostObjectCollisionTest();
    void applyWorldForces();
    
    btSoftBody *addSoftBody(SoftEntity *pPhysicsEntity,
                              const btTransform &initialTransform,
                              btScalar mass);
    void removeSoftBody(btSoftBody *obj);
    
    void setGravity(const btVector3 &gravity);
    
    static float getFrictionAbs(){return 10.0f;}
    
    virtual void enableContinuousCollisionDetection(bool enable = true);
    virtual bool isContinuousCollisionDetectionEnabled()const;
private:
    WorldPhysics(const WorldPhysicsInfo& constructionInfo);
    ~WorldPhysics();
    
    btDefaultCollisionConfiguration *m_collisionConfiguration;
    btCollisionDispatcher *m_dispatcher;
    
    btBroadphaseInterface *m_overlappingPairCache;
    
    btSequentialImpulseConstraintSolver *m_solver;
    btDiscreteDynamicsWorld *m_dynamicsWorld;
    btOverlapFilterCallback *m_btOverlapFilterCallback;
    btGhostPairCallback *m_btGhostPairCallback;
    
    GLuint m_shaderHandle;
    
    btAlignedObjectArray<btPairCachingGhostObject*> *m_GhostObjects;
    
    btBroadphaseInterface*	m_broadphase;
    btAlignedObjectArray<struct  btBroadphaseProxy*> m_proxies;
    
//    btSoftBodyWorldInfo	m_softBodyWorldInfo;
    
//    OcclusionBuffer *m_ocb;
//    SceneRenderer *m_srenderer;
};

#endif /* defined(__GameAsteroids__WorldPhysics__) */
