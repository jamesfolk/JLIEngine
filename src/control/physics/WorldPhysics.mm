//
//  WorldPhysics.cpp
//  GameAsteroids
//
//  Created by James Folk on 3/8/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#if defined(DEBUG) || defined (_DEBUG)
#include "GLDebugDrawer.h"
#include "ShaderFactory.h"
#endif

#include "WorldPhysics.h"
#include "BaseEntity.h"
#include "RigidEntity.h"
#include "CollisionShapeFactory.h"
#include "BaseViewObject.h"

#include "FrameCounter.h"

#include "BaseCamera.h"

#include "EntityFactory.h"

#include "CameraFactory.h"

//#include "SceneRenderer.h"
//#include "OcclusionBuffer.h"
//#include "UtilityFunctions.h"
//#include "Plane.h"
#include "btSoftBodyHelpers.h"

#include "SoftEntity.h"
#include "BaseViewObject.h"
#include "GLDebugDrawer.h"

static void CustomPreTickCallback (btDynamicsWorld *world, btScalar timeStep)
{
    WorldPhysics::getInstance()->ghostObjectCollisionTest();
}

static void CustomPostTickCallback (btDynamicsWorld *world, btScalar timeStep)
{
}

CustomFilterCallback::CustomFilterCallback()
{

}
CustomFilterCallback::~CustomFilterCallback()
{
    
}

//static BaseEntity *getEntity()
//{
//    
//}
//static void getEntitiesFromCollisionObjects(const btCollisionObject *colObj0, const btCollisionObject *colObj1, BaseEntity *pBaseEntity0, BaseEntity *pBaseEntity1)
//{
//    btAssert(colObj0);
//    btAssert(colObj1);
//    
//    pBaseEntity0 = static_cast<BaseEntity*>(colObj0->getUserPointer());
//    pBaseEntity1 = static_cast<BaseEntity*>(colObj1->getUserPointer());
//}


// return true when pairs need collision
bool CustomFilterCallback::needBroadphaseCollision(btBroadphaseProxy* proxy0,btBroadphaseProxy* proxy1) const
{
    //BaseEntity *pBaseEntity0 = getEntity(proxy0);
    //BaseEntity *pBaseEntity1 = getEntity(proxy1);
    
//    bool shouldObjectCollide = true;
//    
//    if(pBaseEntity0 && pBaseEntity1)
//    {
//        shouldObjectCollide = (pBaseEntity1->shouldCollide(pBaseEntity0)
//                                    || pBaseEntity0->shouldCollide(pBaseEntity1));
//    }
    
    bool collides = (proxy0->m_collisionFilterGroup & proxy1->m_collisionFilterMask) != 0;
    collides = collides && (proxy1->m_collisionFilterGroup & proxy0->m_collisionFilterMask);
    //collides = collides && shouldObjectCollide;
    
    return collides;
}

static inline btScalar	calculateCombinedFriction(float friction0,float friction1)
{
	btScalar friction = friction0 * friction1;
    
	const btScalar MAX_FRICTION  = WorldPhysics::getFrictionAbs();//10.f;
	if (friction < -MAX_FRICTION)
		friction = -MAX_FRICTION;
	if (friction > MAX_FRICTION)
		friction = MAX_FRICTION;
	return friction;
    
}

static inline btScalar	calculateCombinedRestitution(float restitution0,float restitution1)
{
	return restitution0 * restitution1;
}

static void CustomNearCallback(btBroadphasePair& collisionPair, btCollisionDispatcher& dispatcher, const btDispatcherInfo& dispatchInfo)
{
    BT_PROFILE("CustomNearCallback");
    btCollisionObject *pCollisionObject0 = (btCollisionObject *)collisionPair.m_pProxy0->m_clientObject;
    btCollisionObject *pCollisionObject1 = (btCollisionObject *)collisionPair.m_pProxy1->m_clientObject;
    
//	BaseEntity *p0 = (BaseEntity*)pCollisionObject0->getUserPointer();
//    BaseEntity *p1 = (BaseEntity*)pCollisionObject1->getUserPointer();
//    
//    p0->handleCollisionNear(p1, dispatchInfo);
//    p1->handleCollisionNear(p0, dispatchInfo);
//    
//    dispatcher.defaultNearCallback(collisionPair, dispatcher, dispatchInfo);
    
    
    
    
    
//    btCollisionObject* colObj0 = static_cast<btCollisionObject*>(collisionPair.m_pProxy0->m_clientObject);
//    btCollisionObject* colObj1 = static_cast<btCollisionObject*>(collisionPair.m_pProxy1->m_clientObject);
    
    if (dispatcher.needsCollision(pCollisionObject0,pCollisionObject1))
    {
        btCollisionObjectWrapper obj0Wrap(0,pCollisionObject0->getCollisionShape(),pCollisionObject0,pCollisionObject0->getWorldTransform());
        btCollisionObjectWrapper obj1Wrap(0,pCollisionObject1->getCollisionShape(),pCollisionObject1,pCollisionObject1->getWorldTransform());
        
        
        //dispatcher will keep algorithms persistent in the collision pair
        if (!collisionPair.m_algorithm)
        {
            collisionPair.m_algorithm = dispatcher.findAlgorithm(&obj0Wrap,&obj1Wrap);
        }
        
        if (collisionPair.m_algorithm)
        {
            btManifoldResult contactPointResult(&obj0Wrap,&obj1Wrap);
            
            if (dispatchInfo.m_dispatchFunc == 		btDispatcherInfo::DISPATCH_DISCRETE)
            {
                //discrete collision detection query
                
                collisionPair.m_algorithm->processCollision(&obj0Wrap,&obj1Wrap,dispatchInfo,&contactPointResult);
            } else
            {
                //continuous collision detection query, time of impact (toi)
                btScalar toi = collisionPair.m_algorithm->calculateTimeOfImpact(pCollisionObject0,pCollisionObject1,dispatchInfo,&contactPointResult);
                if (dispatchInfo.m_timeOfImpact > toi)
                    dispatchInfo.m_timeOfImpact = toi;
                
            }
            
            BaseEntity *p0 = (BaseEntity*)pCollisionObject0->getUserPointer();
            BaseEntity *p1 = (BaseEntity*)pCollisionObject1->getUserPointer();
            
            p0->handleCollisionNear(p1, dispatchInfo);
//            p1->handleCollisionNear(p0, dispatchInfo);
        }
    }
    
}

static bool CustomCollideCallback(btManifoldPoint& cp,
                                            const btCollisionObjectWrapper* colObj0Wrap,
                                           int partId0,
                                           int index0,
                                           const btCollisionObjectWrapper* colObj1Wrap,
                                           int partId1,
                                           int index1)
{
    btCollisionObject *pCollisionObject0 = const_cast<btCollisionObject *>(colObj0Wrap->getCollisionObject());
    btCollisionObject *pCollisionObject1 = const_cast<btCollisionObject *>(colObj1Wrap->getCollisionObject());
    
	cp.m_combinedFriction = calculateCombinedFriction(pCollisionObject0->getFriction(),pCollisionObject1->getFriction());
	cp.m_combinedRestitution = calculateCombinedRestitution(pCollisionObject0->getRestitution(),pCollisionObject1->getRestitution());
    cp.m_combinedRollingFriction = calculateCombinedFriction(pCollisionObject0->getRollingFriction(), pCollisionObject1->getRollingFriction());
    
    BaseEntity *p0 = (BaseEntity*)pCollisionObject0->getUserPointer();
    BaseEntity *p1 = (BaseEntity*)pCollisionObject1->getUserPointer();
    
    p0->handleCollide(p1, cp);
//    p1->handleCollide(p0, cp);
    
//    const btRigidBody *rb0 = btRigidBody::upcast(pCollisionObject0);
//    const btPairCachingGhostObject *go0 = NULL;
//    if (pCollisionObject0->getInternalType()&btCollisionObject::CO_GHOST_OBJECT)
//        go0 = (const btPairCachingGhostObject*)pCollisionObject0;
//    
//    const btRigidBody *rb1 = btRigidBody::upcast(pCollisionObject1);
//    const btPairCachingGhostObject *go1 = NULL;
//    if (pCollisionObject1->getInternalType()&btCollisionObject::CO_GHOST_OBJECT)
//        go1 = (const btPairCachingGhostObject*)pCollisionObject1;
//    
//    if((rb0 != NULL) && (rb1 != NULL) && (go0 == NULL) && (go1 == NULL))
//    {
//        RigidEntity *pEntity0 = (RigidEntity*)rb0->getUserPointer();
//        RigidEntity *pEntity1 = (RigidEntity*)rb1->getUserPointer();
//        
//        pEntity0->handleCollide(pEntity1, cp);
//        //pEntity1->handleCollide(pEntity0, cp);
//    }
//    else if((rb0 != NULL) && (rb1 == NULL) && (go0 != NULL) && (go1 == NULL))
//    {
//        RigidEntity *pEntity0 = (RigidEntity*)rb0->getUserPointer();
//        GhostEntity *pEntity1 = (GhostEntity*)go0->getUserPointer();
//        
//        pEntity0->handleCollide(pEntity1, cp);
//        //pEntity1->handleCollide(pEntity0, cp);
//    }
//    else if((rb0 == NULL) && (rb1 != NULL) && (go0 == NULL) && (go1 != NULL))
//    {
//        RigidEntity *pEntity0 = (RigidEntity*)rb1->getUserPointer();
//        GhostEntity *pEntity1 = (GhostEntity*)go1->getUserPointer();
//        
//        pEntity0->handleCollide(pEntity1, cp);
//        //pEntity1->handleCollide(pEntity0, cp);
//    }
//    else if((rb0 == NULL) && (rb1 != NULL) && (go0 != NULL) && (go1 == NULL))
//    {
//        RigidEntity *pEntity0 = (RigidEntity*)rb1->getUserPointer();
//        GhostEntity *pEntity1 = (GhostEntity*)go0->getUserPointer();
//        
//        pEntity0->handleCollide(pEntity1, cp);
//        //pEntity1->handleCollide(pEntity0, cp);
//    }
//    else if((rb0 == NULL) && (rb1 != NULL) && (go0 != NULL) && (go1 == NULL))
//    {
//        RigidEntity *pEntity0 = (RigidEntity*)rb1->getUserPointer();
//        GhostEntity *pEntity1 = (GhostEntity*)go0->getUserPointer();
//        
//        pEntity0->handleCollide(pEntity1, cp);
//        //pEntity1->handleCollide(pEntity0, cp);
//    }
//    else if((rb0 == NULL) && (rb1 == NULL) && (go0 != NULL) && (go1 != NULL))
//    {
//        
//        //Handle in the ghost callback
//    }
//    else
//    {
//        btAssert(true);
//    }
    
    
    
    
    
    
    
    
//    BaseEntity *pBaseEntity0 = WorldPhysics::getEntity(pCollisionObject0);
//    BaseEntity *pBaseEntity1 = WorldPhysics::getEntity(pCollisionObject1);
    
    //if(pBaseEntity0->shouldCollide(pBaseEntity1))
//        pBaseEntity0->handleCollide(pBaseEntity1, cp);
//    //if(pBaseEntity1->shouldCollide(pBaseEntity0))
//        pBaseEntity1->handleCollide(pBaseEntity0, cp);
    
	//this return value is currently ignored, but to be on the safe side: return false if you don't calculate friction
	return true;
}

WorldPhysics *WorldPhysics::s_WorldPhysics = NULL;


BaseEntity *WorldPhysics::getEntity(const btCollisionObject *pCollisionObject)
{
    btAssert(pCollisionObject);
    
    BaseEntity *pBaseEntity = static_cast<BaseEntity*>(pCollisionObject->getUserPointer());
    
    return dynamic_cast<BaseEntity*>(pBaseEntity);
}

BaseEntity *WorldPhysics::getEntity(btBroadphaseProxy *proxy)
{
    btAssert(proxy);
    
    btCollisionObject *pCollisionObject = static_cast<btCollisionObject*>(proxy->m_clientObject);
    
    return WorldPhysics::getEntity(pCollisionObject);
}

void WorldPhysics::createInstance(const WorldPhysicsInfo& constructionInfo)
{
    destroyInstance();
    
    s_WorldPhysics = new WorldPhysics(constructionInfo);
    
    gContactAddedCallback = CustomCollideCallback;
}

WorldPhysics *WorldPhysics::getInstance()
{
    return s_WorldPhysics;
}

void WorldPhysics::destroyInstance()
{
    if(s_WorldPhysics)
    {
        delete s_WorldPhysics;
        s_WorldPhysics = NULL;
    }
}


WorldPhysics::WorldPhysics(const WorldPhysicsInfo& constructionInfo) :
m_collisionConfiguration(new btDefaultCollisionConfiguration()),
m_dispatcher(new btCollisionDispatcher(m_collisionConfiguration)),
m_overlappingPairCache(new btDbvtBroadphase()),
m_solver(new btSequentialImpulseConstraintSolver),
m_dynamicsWorld(new btDiscreteDynamicsWorld(m_dispatcher,
                                            m_overlappingPairCache,
                                            m_solver,
                                            m_collisionConfiguration)),
m_btOverlapFilterCallback(new CustomFilterCallback()),
m_btGhostPairCallback(new btGhostPairCallback()),
m_GhostObjects(new btAlignedObjectArray<btPairCachingGhostObject*>())//,
//m_ocb(new OcclusionBuffer()),
//m_srenderer(new SceneRenderer())
{
//    m_softBodyWorldInfo.m_dispatcher = m_dispatcher;
//    m_softBodyWorldInfo.m_broadphase = m_overlappingPairCache;
//    m_softBodyWorldInfo.m_gravity =  constructionInfo.gravity;
//    m_softBodyWorldInfo.m_sparsesdf.Initialize();
//    
//    m_softBodyWorldInfo.m_sparsesdf.Reset();
//    m_softBodyWorldInfo.air_density		=	(btScalar)1.2;
//	m_softBodyWorldInfo.water_density	=	0;
//	m_softBodyWorldInfo.water_offset		=	0;
//	m_softBodyWorldInfo.water_normal		=	btVector3(0,0,1.0f);
//	m_softBodyWorldInfo.m_gravity = constructionInfo.gravity;
    
    m_dynamicsWorld->setGravity(constructionInfo.gravity);
    
    m_dispatcher->setNearCallback(CustomNearCallback);
    m_dynamicsWorld->getPairCache()->setOverlapFilterCallback(m_btOverlapFilterCallback);
    m_dynamicsWorld->setInternalTickCallback(CustomPreTickCallback,NULL,true);
    m_dynamicsWorld->setInternalTickCallback(CustomPostTickCallback,NULL,false);
    m_dynamicsWorld->getBroadphase()->getOverlappingPairCache()->setInternalGhostPairCallback(m_btGhostPairCallback);

}


//WorldPhysics::WorldPhysics(const WorldPhysicsInfo& constructionInfo) :
////m_collisionConfiguration(new btDefaultCollisionConfiguration()),
//m_collisionConfiguration(new btSoftBodyRigidBodyCollisionConfiguration()),
//m_dispatcher(new btCollisionDispatcher(m_collisionConfiguration)),
//m_overlappingPairCache(new btDbvtBroadphase()),
////m_overlappingPairCache(new btAxisSweep3(constructionInfo.worldAabbMin,
////                                        constructionInfo.worldAabbMax,
////                                        3500,
////                                        new btHashedOverlappingPairCache())),
//m_solver(new btSequentialImpulseConstraintSolver),
////m_dynamicsWorld(new btDiscreteDynamicsWorld(m_dispatcher,
////                                          m_overlappingPairCache,
////                                          m_solver,
////                                          m_collisionConfiguration)),
//m_dynamicsWorld(new btSoftRigidDynamicsWorld(m_dispatcher,
//                                             m_overlappingPairCache,
//                                             m_solver,
//                                             m_collisionConfiguration)),
//m_btOverlapFilterCallback(new CustomFilterCallback()),
//m_btGhostPairCallback(new btGhostPairCallback()),
//m_GhostObjects(new btAlignedObjectArray<btPairCachingGhostObject*>()),//,
////m_broadphase(NULL)
//m_ocb(new OcclusionBuffer()),
//m_srenderer(new SceneRenderer())
//{
//    m_softBodyWorldInfo.m_dispatcher = m_dispatcher;
//    m_softBodyWorldInfo.m_broadphase = m_overlappingPairCache;
//    m_softBodyWorldInfo.m_gravity =  constructionInfo.gravity;
//    m_softBodyWorldInfo.m_sparsesdf.Initialize();
//    
//    m_softBodyWorldInfo.m_sparsesdf.Reset();
//    m_softBodyWorldInfo.air_density		=	(btScalar)1.2;
//	m_softBodyWorldInfo.water_density	=	0;
//	m_softBodyWorldInfo.water_offset		=	0;
//	m_softBodyWorldInfo.water_normal		=	btVector3(0,0,1.0f);
//	m_softBodyWorldInfo.m_gravity = constructionInfo.gravity;
//    
//    m_dynamicsWorld->setGravity(constructionInfo.gravity);
//    
//    m_dispatcher->setNearCallback(CustomNearCallback);
//    m_dynamicsWorld->getPairCache()->setOverlapFilterCallback(m_btOverlapFilterCallback);
//    m_dynamicsWorld->setInternalTickCallback(CustomPreTickCallback,NULL,true);
//    m_dynamicsWorld->setInternalTickCallback(CustomPostTickCallback,NULL,false);
//    m_dynamicsWorld->getBroadphase()->getOverlappingPairCache()->setInternalGhostPairCallback(m_btGhostPairCallback);
//    
//    //    btDbvtBroadphase*	pbp=new btDbvtBroadphase();
//    //    m_broadphase			=	pbp;
//    //    pbp->m_deferedcollide	=	true;	/* Faster initialization, set to false after.	*/
//    m_isFirstTime = false;
//    
//}



WorldPhysics::~WorldPhysics()
{
//    delete m_srenderer;
//    m_srenderer = NULL;
//    
//    delete m_ocb;
//    m_ocb = NULL;
    
    //cleanup in the reverse order of creation/initialization
    int i;
    

    delete m_btOverlapFilterCallback;
    m_btOverlapFilterCallback = NULL;
    
	//remove the rigid bodies from the dynamics world and delete
    // them
	for (i=m_dynamicsWorld->getNumCollisionObjects()-1; i>=0 ;i--)
	{
		btCollisionObject* obj =
        m_dynamicsWorld->getCollisionObjectArray()[i];
		btRigidBody* body = btRigidBody::upcast(obj);
		if (body && body->getMotionState())
		{
			delete body->getMotionState();
		}
		m_dynamicsWorld->removeCollisionObject( obj );
		delete obj;
	}
    
	//delete dynamics world
	delete m_dynamicsWorld;
    m_dynamicsWorld = NULL;
    
	//delete solver
	delete m_solver;
    m_solver = NULL;
    
	//delete broadphase
	delete m_overlappingPairCache;
    m_overlappingPairCache = NULL;
    
    delete m_btGhostPairCallback;
    m_btGhostPairCallback = NULL;
    
	//delete dispatcher
	delete m_dispatcher;
    m_dispatcher = NULL;
    
	delete m_collisionConfiguration;
    m_collisionConfiguration = NULL;
    
    delete m_GhostObjects;
    m_GhostObjects = NULL;
    
}

void WorldPhysics::update()
{
    if(m_dynamicsWorld)
        m_dynamicsWorld->stepSimulation(FrameCounter::getInstance()->getCurrentDiffTime(),
                                    32,
                                    1.0f/120.0f);
//    CProfileManager::dumpAll();
}













//static void __gluMultMatrixVecd(const GLfloat matrix[16], const GLfloat in[4],
//                                GLfloat out[4])
//{
//    int i;
//    
//    for (i=0; i<4; i++) {
//        out[i] =
//	    in[0] * matrix[0*4+i] +
//	    in[1] * matrix[1*4+i] +
//	    in[2] * matrix[2*4+i] +
//	    in[3] * matrix[3*4+i];
//    }
//}
//
///*
// ** Invert 4x4 matrix.
// ** Contributed by David Moore (See Mesa bug #6748)
// */
//static int __gluInvertMatrixd(const GLfloat m[16], GLfloat invOut[16])
//{
//    float inv[16], det;
//    int i;
//    
//    inv[0] =   m[5]*m[10]*m[15] - m[5]*m[11]*m[14] - m[9]*m[6]*m[15]
//    + m[9]*m[7]*m[14] + m[13]*m[6]*m[11] - m[13]*m[7]*m[10];
//    inv[4] =  -m[4]*m[10]*m[15] + m[4]*m[11]*m[14] + m[8]*m[6]*m[15]
//    - m[8]*m[7]*m[14] - m[12]*m[6]*m[11] + m[12]*m[7]*m[10];
//    inv[8] =   m[4]*m[9]*m[15] - m[4]*m[11]*m[13] - m[8]*m[5]*m[15]
//    + m[8]*m[7]*m[13] + m[12]*m[5]*m[11] - m[12]*m[7]*m[9];
//    inv[12] = -m[4]*m[9]*m[14] + m[4]*m[10]*m[13] + m[8]*m[5]*m[14]
//    - m[8]*m[6]*m[13] - m[12]*m[5]*m[10] + m[12]*m[6]*m[9];
//    inv[1] =  -m[1]*m[10]*m[15] + m[1]*m[11]*m[14] + m[9]*m[2]*m[15]
//    - m[9]*m[3]*m[14] - m[13]*m[2]*m[11] + m[13]*m[3]*m[10];
//    inv[5] =   m[0]*m[10]*m[15] - m[0]*m[11]*m[14] - m[8]*m[2]*m[15]
//    + m[8]*m[3]*m[14] + m[12]*m[2]*m[11] - m[12]*m[3]*m[10];
//    inv[9] =  -m[0]*m[9]*m[15] + m[0]*m[11]*m[13] + m[8]*m[1]*m[15]
//    - m[8]*m[3]*m[13] - m[12]*m[1]*m[11] + m[12]*m[3]*m[9];
//    inv[13] =  m[0]*m[9]*m[14] - m[0]*m[10]*m[13] - m[8]*m[1]*m[14]
//    + m[8]*m[2]*m[13] + m[12]*m[1]*m[10] - m[12]*m[2]*m[9];
//    inv[2] =   m[1]*m[6]*m[15] - m[1]*m[7]*m[14] - m[5]*m[2]*m[15]
//    + m[5]*m[3]*m[14] + m[13]*m[2]*m[7] - m[13]*m[3]*m[6];
//    inv[6] =  -m[0]*m[6]*m[15] + m[0]*m[7]*m[14] + m[4]*m[2]*m[15]
//    - m[4]*m[3]*m[14] - m[12]*m[2]*m[7] + m[12]*m[3]*m[6];
//    inv[10] =  m[0]*m[5]*m[15] - m[0]*m[7]*m[13] - m[4]*m[1]*m[15]
//    + m[4]*m[3]*m[13] + m[12]*m[1]*m[7] - m[12]*m[3]*m[5];
//    inv[14] = -m[0]*m[5]*m[14] + m[0]*m[6]*m[13] + m[4]*m[1]*m[14]
//    - m[4]*m[2]*m[13] - m[12]*m[1]*m[6] + m[12]*m[2]*m[5];
//    inv[3] =  -m[1]*m[6]*m[11] + m[1]*m[7]*m[10] + m[5]*m[2]*m[11]
//    - m[5]*m[3]*m[10] - m[9]*m[2]*m[7] + m[9]*m[3]*m[6];
//    inv[7] =   m[0]*m[6]*m[11] - m[0]*m[7]*m[10] - m[4]*m[2]*m[11]
//    + m[4]*m[3]*m[10] + m[8]*m[2]*m[7] - m[8]*m[3]*m[6];
//    inv[11] = -m[0]*m[5]*m[11] + m[0]*m[7]*m[9] + m[4]*m[1]*m[11]
//    - m[4]*m[3]*m[9] - m[8]*m[1]*m[7] + m[8]*m[3]*m[5];
//    inv[15] =  m[0]*m[5]*m[10] - m[0]*m[6]*m[9] - m[4]*m[1]*m[10]
//    + m[4]*m[2]*m[9] + m[8]*m[1]*m[6] - m[8]*m[2]*m[5];
//    
//    det = m[0]*inv[0] + m[1]*inv[4] + m[2]*inv[8] + m[3]*inv[12];
//    if (det == 0)
//        return GL_FALSE;
//    
//    det = 1.0 / det;
//    
//    for (i = 0; i < 16; i++)
//        invOut[i] = inv[i] * det;
//    
//    return GL_TRUE;
//}
//
//static void __gluMultMatricesd(const GLfloat a[16], const GLfloat b[16],
//                               GLfloat r[16])
//{
//    int i, j;
//    
//    for (i = 0; i < 4; i++) {
//        for (j = 0; j < 4; j++) {
//            r[i*4+j] =
//            a[i*4+0]*b[0*4+j] +
//            a[i*4+1]*b[1*4+j] +
//            a[i*4+2]*b[2*4+j] +
//            a[i*4+3]*b[3*4+j];
//        }
//    }
//}
//
//GLint gluProject(GLfloat objx, GLfloat objy, GLfloat objz,
//           const GLfloat modelMatrix[16],
//           const GLfloat projMatrix[16],
//           const GLint viewport[4],
//           GLfloat *winx, GLfloat *winy, GLfloat *winz)
//{
//    float in[4];
//    float out[4];
//    
//    in[0]=objx;
//    in[1]=objy;
//    in[2]=objz;
//    in[3]=1.0;
//    __gluMultMatrixVecd(modelMatrix, in, out);
//    __gluMultMatrixVecd(projMatrix, out, in);
//    if (in[3] == 0.0) return(GL_FALSE);
//    in[0] /= in[3];
//    in[1] /= in[3];
//    in[2] /= in[3];
//    /* Map x, y and z to range 0-1 */
//    in[0] = in[0] * 0.5 + 0.5;
//    in[1] = in[1] * 0.5 + 0.5;
//    in[2] = in[2] * 0.5 + 0.5;
//    
//    /* Map x,y to viewport */
//    in[0] = in[0] * viewport[2] + viewport[0];
//    in[1] = in[1] * viewport[3] + viewport[1];
//    
//    *winx=in[0];
//    *winy=in[1];
//    *winz=in[2];
//    return(GL_TRUE);
//}
//
//static GLint
//gluUnProject(GLfloat winx, GLfloat winy, GLfloat winz,
//             const GLfloat modelMatrix[16],
//             const GLfloat projMatrix[16],
//             const GLint viewport[4],
//             GLfloat *objx, GLfloat *objy, GLfloat *objz)
//{
//    float finalMatrix[16];
//    float in[4];
//    float out[4];
//    
//    __gluMultMatricesd(modelMatrix, projMatrix, finalMatrix);
//    if (!__gluInvertMatrixd(finalMatrix, finalMatrix)) return(GL_FALSE);
//    
//    in[0]=winx;
//    in[1]=winy;
//    in[2]=winz;
//    in[3]=1.0;
//    
//    /* Map x and y from window coordinates */
//    in[0] = (in[0] - viewport[0]) / viewport[2];
//    in[1] = (in[1] - viewport[1]) / viewport[3];
//    
//    /* Map to range -1 to 1 */
//    in[0] = in[0] * 2 - 1;
//    in[1] = in[1] * 2 - 1;
//    in[2] = in[2] * 2 - 1;
//    
//    __gluMultMatrixVecd(finalMatrix, in, out);
//    if (out[3] == 0.0) return(GL_FALSE);
//    out[0] /= out[3];
//    out[1] /= out[3];
//    out[2] /= out[3];
//    *objx = out[0];
//    *objy = out[1];
//    *objz = out[2];
//    return(GL_TRUE);
//}
//static btVector3 ComputeWorldRay(int xs, int ys)
//{
//	GLint viewPort[4];
//	GLKMatrix4 modelMatrix = GLKMatrix4Identity;
//	GLKMatrix4 projMatrix = CameraFactory::getInstance()->getCurrentCamera()->getProjection();
//	glGetIntegerv(GL_VIEWPORT, viewPort);
//	//glGetDoublev(GL_MODELVIEW_MATRIX, modelMatrix);
//	//glGetDoublev(GL_PROJECTION_MATRIX, projMatrix);
//	ys = viewPort[3] - ys - 1;
//	GLfloat wx0, wy0, wz0;
//    
//    gluUnProject((GLfloat)xs,
//                 (GLfloat)ys,
//                 0.0,
//                 modelMatrix.m,
//                 projMatrix.m,
//                 viewPort,
//                 &wx0,
//                 &wy0,
//                 &wz0);
//	
//    /*gluUnProject(GLfloat winx, GLfloat winy, GLfloat winz,
//                 const GLfloat modelMatrix[16],
//                 const GLfloat projMatrix[16],
//                 const GLint viewport[4],
//                 GLfloat *objx, GLfloat *objy, GLfloat *objz)*/
//	GLfloat wx1, wy1, wz1;
//	gluUnProject((GLfloat)xs,
//                 (GLfloat)ys,
//                 1.0,
//                 modelMatrix.m,
//                 projMatrix.m,
//                 viewPort,
//                 &wx1,
//                 &wy1,
//                 &wz1);
//	btVector3 tmp(float(wx1-wx0), float(wy1-wy0), float(wz1-wz0));
//	tmp.normalize();
//	return tmp;
//}

void WorldPhysics::render()
{
    if(CameraFactory::getInstance()->getCurrentCamera())
    {
        CameraFactory::getInstance()->getCurrentCamera()->cull((btDbvtBroadphase*)m_overlappingPairCache);
    }
}


void WorldPhysics::initDebugDrawWorld()
{
    m_dynamicsWorld->setDebugDrawer(GLDebugDrawer::getInstance());
}
void WorldPhysics::debugDrawWorld()
{
    m_dynamicsWorld->debugDrawWorld();
}

bool WorldPhysics::isActionObject(BaseEntity *pBaseEntity)
{
    return m_dynamicsWorld->hasAction(pBaseEntity);
}
void WorldPhysics::addActionObject(btActionInterface *pBaseEntity)
{
    m_dynamicsWorld->addAction(pBaseEntity);
}
void WorldPhysics::removeActionObject(btActionInterface *pBaseEntity)
{
    m_dynamicsWorld->removeAction(pBaseEntity);
}
//pVBO->getInitialTransform()

btRigidBody *WorldPhysics::addRigidBody(RigidEntity *pPhysicsEntity,
                                        const btTransform &initialTransform,
                                        btScalar mass,
                                        IDType collisionShapeFactoryID)
{
    btAssert(CollisionShapeFactory::getInstance()->get(collisionShapeFactoryID));
    
    btCollisionShape *_btCollisionShape = CollisionShapeFactory::getInstance()->get(collisionShapeFactoryID)->m_btCollisionShape;
    
    //rigidbody is dynamic if and only if mass is non zero,
    // otherwise static
    btVector3 localInertia(0,0,0);
    if(mass > 0.0f)
    {
        _btCollisionShape->calculateLocalInertia(mass, localInertia);
    }
    
    //using motionstate is recommended, it provides interpolation
    // capabilities, and only synchronizes 'active' objects
    btDefaultMotionState *_btDefaultMotionState = new btDefaultMotionState(initialTransform);
    _btDefaultMotionState->m_userPointer = pPhysicsEntity;
    
    btRigidBody::btRigidBodyConstructionInfo rbInfo(mass,
                                                    _btDefaultMotionState,
                                                    _btCollisionShape,
                                                    localInertia);
    //rbInfo.m_restitution = 0.9f;
    //rbInfo.m_friction = 1000.99f;
    
    btRigidBody* _btRigidBody = new btRigidBody(rbInfo);
    
    _btRigidBody->setLinearFactor(btVector3(1.0f, 1.0f, 1.0f));
    _btRigidBody->setAngularFactor(btVector3(1.0f, 1.0f, 1.0f));
    
    //_btRigidBody->setUserPointer(static_cast<void*>(pPhysicsEntity));
    _btRigidBody->setUserPointer(pPhysicsEntity);
    
    m_dynamicsWorld->addRigidBody(_btRigidBody);
    
    return _btRigidBody;
}

btRigidBody *WorldPhysics::addRigidBody(RigidEntity *pPhysicsEntity,
                                        const btTransform &initialTransform,
                                        btScalar mass,
                                        IDType collisionShapeFactoryID,
                                        short group,
                                        short mask)
{
    btAssert(CollisionShapeFactory::getInstance()->get(collisionShapeFactoryID));
    
    btCollisionShape *_btCollisionShape = CollisionShapeFactory::getInstance()->get(collisionShapeFactoryID)->m_btCollisionShape;
    
    //rigidbody is dynamic if and only if mass is non zero,
    // otherwise static
    btVector3 localInertia(0,0,0);
    if(mass > 0.0f)
    {
        _btCollisionShape->calculateLocalInertia(mass, localInertia);
    }
    
    //using motionstate is recommended, it provides interpolation
    // capabilities, and only synchronizes 'active' objects
    btDefaultMotionState *_btDefaultMotionState = new btDefaultMotionState(initialTransform);
    _btDefaultMotionState->m_userPointer = pPhysicsEntity;
    
    btRigidBody::btRigidBodyConstructionInfo rbInfo(mass,
                                                    _btDefaultMotionState,
                                                    _btCollisionShape,
                                                    localInertia);
    //rbInfo.m_restitution = 0.9f;
    //rbInfo.m_friction = 1000.99f;
    
    btRigidBody* _btRigidBody = new btRigidBody(rbInfo);
    
    _btRigidBody->setLinearFactor(btVector3(1.0f, 1.0f, 1.0f));
    _btRigidBody->setAngularFactor(btVector3(1.0f, 1.0f, 1.0f));
    
    //_btRigidBody->setUserPointer(static_cast<void*>(pPhysicsEntity));
    _btRigidBody->setUserPointer(pPhysicsEntity);
    
    
    m_dynamicsWorld->addRigidBody(_btRigidBody, group, mask);
    
    return _btRigidBody;
}

void WorldPhysics::removeRigidBody(btRigidBody *_btRigidBody)
{
    //RigidEntity *pPhysicsEntity = static_cast<RigidEntity*>(_btRigidBody->getUserPointer());
    //CollisionShapeInfo shapeInfo = pPhysicsEntity->getCollisionShapeInfo();
    
    btAssert(_btRigidBody);
    btAssert(_btRigidBody->getMotionState());
    
    delete _btRigidBody->getMotionState();
    
    m_dynamicsWorld->removeCollisionObject( _btRigidBody );
    
    delete _btRigidBody;
}


btPairCachingGhostObject *WorldPhysics::addGhostObject(GhostEntity *pGhostEntity,
                                                       IDType collisionShapeFactoryID)
{
    btCollisionShape *_btCollisionShape = CollisionShapeFactory::getInstance()->get(collisionShapeFactoryID)->m_btCollisionShape;
    
    btVector3 localInertia(0,0,0);
    _btCollisionShape->calculateLocalInertia(0.0f, localInertia);
    
    
    btPairCachingGhostObject *_btPairCachingGhostObject = new btPairCachingGhostObject();
    
    _btPairCachingGhostObject->setCollisionShape(_btCollisionShape);
    
    //_btPairCachingGhostObject->setUserPointer(static_cast<void*>(pGhostEntity));
    _btPairCachingGhostObject->setUserPointer(pGhostEntity);
    
    
    short collisionFilterGroup = short(btBroadphaseProxy::SensorTrigger);
    
    short collisionFilterMask = short(btBroadphaseProxy::AllFilter ^
                                      (btBroadphaseProxy::StaticFilter));
    
    m_dynamicsWorld->addCollisionObject(_btPairCachingGhostObject,
                                        collisionFilterGroup,
                                        collisionFilterMask);
    
    _btPairCachingGhostObject->setCollisionFlags(btCollisionObject::CF_KINEMATIC_OBJECT |
                                                 btCollisionObject::CF_NO_CONTACT_RESPONSE);
    
    (*m_GhostObjects).push_back(_btPairCachingGhostObject);
    
    return _btPairCachingGhostObject;
}
void WorldPhysics::removeGhostObject(btPairCachingGhostObject *obj)
{
    m_dynamicsWorld->removeCollisionObject( obj );
    
    (*m_GhostObjects).remove(obj);
    
    delete obj;
}

void WorldPhysics::ghostObjectCollisionTest()
{
    //EntityFactory::getInstance()->resetRenderObjects();
    
    if(NULL == m_GhostObjects)
        return;
    
    int size = m_GhostObjects->size();
    
    for(int ghostIndex = 0; ghostIndex < size; ghostIndex++)
    {
        btPairCachingGhostObject *pCurrentGhostObject = (*m_GhostObjects)[ghostIndex];
        
        // Prepare for getting all the contact manifolds for one Overlapping Pair
        btManifoldArray   manifoldArray;
        // Get all the Overlapping Pair
        btBroadphasePairArray& pairArray = pCurrentGhostObject->getOverlappingPairCache()->getOverlappingPairArray();
        int numPairs = pairArray.size();
        
        
        
        for (int pairIndex=0;pairIndex<numPairs;pairIndex++)
        {
            manifoldArray.clear();
            
            const btBroadphasePair& pair = pairArray[pairIndex];
            
            //unless we manually perform collision detection on this pair, the contacts are in the dynamics world paircache:
            //The next line fetches the collision information for this Pair
            btBroadphasePair* collisionPair = m_dynamicsWorld->getPairCache()->findPair(pair.m_pProxy0,pair.m_pProxy1);
            if (!collisionPair)
                continue;
            
            // Read out the all contact manifolds for this Overlapping Pair
            if (collisionPair->m_algorithm)
                collisionPair->m_algorithm->getAllContactManifolds(manifoldArray);
            
            for (int j=0;j<manifoldArray.size();j++)
            {
                btPersistentManifold* manifold = manifoldArray[j];
                
                const btCollisionObject *pCollisionObject0 = (const btCollisionObject *)manifold->getBody0();
                const btCollisionObject *pCollisionObject1 = (const btCollisionObject *)manifold->getBody1();
                
                BaseEntity *p0 = (BaseEntity*)pCollisionObject0->getUserPointer();
                BaseEntity *p1 = (BaseEntity*)pCollisionObject1->getUserPointer();
                
                
                
                
                
                
                
                
//                const btCollisionObject *colObj0 = manifold->getBody0();
//                const btCollisionObject *colObj1 = manifold->getBody1();
//                
//                GhostEntity *pGhostEntity = NULL;
//                BaseEntity *pBaseEntity = NULL;
//                
//                // Check if the first object in the Pair is GhostObject or not.
//                if(colObj0 == pCurrentGhostObject)
//                {
//                    pGhostEntity = dynamic_cast<GhostEntity*>(WorldPhysics::getEntity(colObj0));
//                    pBaseEntity = dynamic_cast<BaseEntity*>(WorldPhysics::getEntity(colObj1));
//                }
//                else
//                {
//                    pGhostEntity = dynamic_cast<GhostEntity*>(WorldPhysics::getEntity(colObj1));
//                    pBaseEntity = dynamic_cast<BaseEntity*>(WorldPhysics::getEntity(colObj0));
//                }
                
//                if(NULL != dynamic_cast<GhostEntity*>(pBaseEntity))
//                    return;

                for (int p=0;p<manifold->getNumContacts();p++)
                {
                    const btManifoldPoint&pt = manifold->getContactPoint(p);
                    if (pt.getDistance()<0.f)
                    {
                        if(pCollisionObject0 == pCurrentGhostObject)
                            p0->handleCollide(p1, pt);
                        else
                            p1->handleCollide(p0, pt);
                        
                        //if(pBaseEntity->shouldCollide(pGhostEntity))
                            //pBaseEntity->handleCollide(pGhostEntity, pt);
                        //if(pGhostEntity->shouldCollide(pBaseEntity))
                            //pGhostEntity->handleCollide(pBaseEntity, pt);
                    }
                }
            }
        }
    }
}


void WorldPhysics::applyWorldForces()
{
}











btSoftBody *WorldPhysics::addSoftBody(SoftEntity *pPhysicsEntity,
                        const btTransform &initialTransform,
                        btScalar mass)
{
//    struct IndiceTransform
//    {
//        IndiceTransform(){}
//        ~IndiceTransform(){}
//        
//        btAlignedObjectArray<GLushort> m_Indices;
//        
//        void operator()(int i, const GLushort &indice)
//        {
//            m_Indices[i] = indice;
//        }
//    }indiceTransform;
//    
//    struct VertexTransform
//    {
//        VertexTransform(){}
//        ~VertexTransform(){}
//        
//        btAlignedObjectArray<btVector3> m_Vertices;
//        //btAlignedObjectArray<int> m_Indices;
//        
//        void operator() (int i, const btVector3 &vertice)
//        {
//            m_Vertices[i] = vertice;
//            //m_Indices[i] = i;
//        }
//    }vertexTransform;
//        
//    
//    vertexTransform.m_Vertices.resize(pPhysicsEntity->getVertexBufferObject()->getNumVertices());
//    
//    size_t offset_position = reinterpret_cast<size_t>(pPhysicsEntity->getVertexBufferObject()->getPositionOffset());
//    pPhysicsEntity->getVertexBufferObject()->get_each_attribute<VertexTransform, btVector3>(vertexTransform, offset_position);
//    
//    
//    indiceTransform.m_Indices.resize(pPhysicsEntity->getVertexBufferObject()->getNumIndices());
//    pPhysicsEntity->getVertexBufferObject()->get_each_indice<IndiceTransform>(indiceTransform);
//    
//    btSoftBody* pSoftBody = NULL;/*new btSoftBody(&m_softBodyWorldInfo,
//                                           vertexTransform.m_Vertices.size(),
//                                           &vertexTransform.m_Vertices[0],0);*/
//    
//    for (int i=0; i< indiceTransform.m_Indices.size(); i+=3)
//    {
//        //pSoftBody->appendLink(vertexTransform.m_Indices[3*i+2],vertexTransform.m_Indices[3*i+0], &mat, true);
//        //pSoftBody->appendLink(vertexTransform.m_Indices[3*i+0],vertexTransform.m_Indices[3*i+1], &mat, true);
//        //pSoftBody->appendLink(vertexTransform.m_Indices[3*i+1],vertexTransform.m_Indices[3*i+2], &mat, true);
//        
//        pSoftBody->appendFace(indiceTransform.m_Indices[i],
//                              indiceTransform.m_Indices[i+1],
//                              indiceTransform.m_Indices[i+2]);
//    }
//    
//    pSoftBody->getCollisionShape()->setMargin(CollisionShapeFactory::s_ConvexMargin);
//    pSoftBody->transform(pPhysicsEntity->getVertexBufferObject()->getInitialTransform());
//    btSoftBody::Material *pMaterial = pSoftBody->m_materials[0];
//    pMaterial->m_kLST = 1.0f;
//    pSoftBody->m_cfg.piterations = 1.0f;
//    pSoftBody->m_cfg.citerations = 1.0f;
//    pSoftBody->m_cfg.kMT  = 1.0f;
//    pSoftBody->m_cfg.kDP  = 0.0f;
//    pSoftBody->m_cfg.kCHR = 1.0f;
//    pSoftBody->m_cfg.kKHR = 0.8f;
//    pSoftBody->m_cfg.kSHR = 1.0f;
//    pSoftBody->setPose( false, true );
//    
//    pSoftBody->m_cfg.kDF = 1.0f;
//    
//    pSoftBody->prepareClusters(16);
//    
//    pSoftBody->setTotalMass(mass, true);
//    
//    pSoftBody->randomizeConstraints();
//    
//    //pSoftBody->setUserPointer(static_cast<void*>(pPhysicsEntity));
//    pSoftBody->setUserPointer(pPhysicsEntity);
//    
//    
////    m_dynamicsWorld->addSoftBody(pSoftBody);
//    
//    return(pSoftBody);
    return NULL;
}
void WorldPhysics::removeSoftBody(btSoftBody *obj)
{
//    m_dynamicsWorld->removeSoftBody(obj);
}

void WorldPhysics::setGravity(const btVector3 &gravity)
{
    m_dynamicsWorld->setGravity(gravity);
}

void WorldPhysics::enableContinuousCollisionDetection(bool enable)
{
    m_dynamicsWorld->getDispatchInfo().m_useContinuous = enable;
}
bool WorldPhysics::isContinuousCollisionDetectionEnabled()const
{
    return m_dynamicsWorld->getDispatchInfo().m_useContinuous;
}
