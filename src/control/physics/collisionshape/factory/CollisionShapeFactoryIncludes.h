//
//  CollisionShapeFactoryIncludes.h
//  GameAsteroids
//
//  Created by James Folk on 3/15/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef GameAsteroids_CollisionShapeFactoryIncludes_h
#define GameAsteroids_CollisionShapeFactoryIncludes_h

//#include <map>
//#include <vector>

//#include "btBulletDynamicsCommon.h"
#include "AbstractFactory.h"
//#include "BaseViewObject.h"
//#include "CollisionShapeFactory.h"

class BaseViewObject;
class VertexBufferObject;
class btCollisionShape;

enum CollisionShapeType
{
    CollisionShapeType_NONE,
    CollisionShapeType_Cube,
    CollisionShapeType_Sphere,
    CollisionShapeType_ConeX,
    CollisionShapeType_ConeY,
    CollisionShapeType_ConeZ,
    CollisionShapeType_TriangleMesh,
    CollisionShapeType_CapsuleX,
    CollisionShapeType_CapsuleY,
    CollisionShapeType_CapsuleZ,
    CollisionShapeType_CylinderX,
    CollisionShapeType_CylinderY,
    CollisionShapeType_CylinderZ,
    CollisionShapeType_ConvexHull,
    CollisionShapeType_Box2d,
    CollisionShapeType_StaticPlane,
    CollisionShapeType_MAX
};




struct CollisionShapeInfo
{
//    CollisionShapeInfo(CollisionShapeType collisionShapeType = CollisionShapeType_NONE,
//                       const BaseViewObject *pVBO = NULL):
//    m_CollisionShapeType(collisionShapeType),
//    m_VBO(pVBO){}
    
    CollisionShapeInfo(CollisionShapeType collisionShapeType = CollisionShapeType_NONE,
                       const VertexBufferObject *pVBO = NULL):
    m_CollisionShapeType(collisionShapeType),
    m_VBO(pVBO){btAssert(m_VBO);}
    
    CollisionShapeType m_CollisionShapeType;
//    const BaseViewObject *m_VBO;
    const VertexBufferObject *m_VBO;
};

class btCollisionShapeWrapper :
public AbstractFactoryObject
{
    friend class CollisionShapeFactory;
protected:
    btCollisionShapeWrapper():m_btCollisionShape(NULL){}
    virtual ~btCollisionShapeWrapper(){}
public:
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
    
    
    btCollisionShape *m_btCollisionShape;
};

//typedef CollisionShapeInfo CollisionShapeFactoryKey;

#endif
