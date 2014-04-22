//
//  CollisionShapeFactory.cpp
//  GameAsteroids
//
//  Created by James Folk on 3/15/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "CollisionShapeFactory.h"
const btScalar CollisionShapeFactory::s_ConvexMargin = 0.25;

//#include "WorldPhysics.h"
#include "btVector3.h"

#include "BulletCollision/CollisionShapes/btBoxShape.h"
#include "BulletCollision/CollisionShapes/btSphereShape.h"
#include "BulletCollision/CollisionShapes/btConeShape.h"
#include "BulletCollision/CollisionShapes/btTriangleMesh.h"
#include "BulletCollision/CollisionShapes/btBvhTriangleMeshShape.h"
#include "BulletCollision/CollisionShapes/btCapsuleShape.h"
#include "BulletCollision/CollisionShapes/btCylinderShape.h"
#include "BulletCollision/CollisionShapes/btConvexHullShape.h"
#include "BulletCollision/CollisionShapes/btBox2dShape.h"

#include "UtilityFunctions.h"
#include "BaseViewObject.h"

#include "ViewObjectFactory.h"
#include "VertexBufferObject.h"
#include "VertexBufferObjectFactory.h"

btCollisionShape *CollisionShapeFactory::createCollisionShape(CollisionShapeInfo *constructionInfo)
{
    btCollisionShape *_btCollisionShape = NULL;
    
    
    switch (constructionInfo->m_CollisionShapeType)
    {
        case CollisionShapeType_Cube:
        {
            _btCollisionShape = new btBoxShape(constructionInfo->m_VBO->getHalfExtends());
        }
            break; 
            
        case CollisionShapeType_Sphere:
        {
            btScalar radius = ((constructionInfo->m_VBO->getHalfExtends().getX() +
                               constructionInfo->m_VBO->getHalfExtends().getY() +
                               constructionInfo->m_VBO->getHalfExtends().getZ()) / 3.0f);
            _btCollisionShape = new btSphereShape(radius);
        }
            break;
        case CollisionShapeType_ConeX:
        {
            btScalar height = constructionInfo->m_VBO->getHalfExtends().getX() * 2.0f;
            btScalar radius = ((constructionInfo->m_VBO->getHalfExtends().getY() +
                                constructionInfo->m_VBO->getHalfExtends().getZ()) / 2.0f);
            
            _btCollisionShape = new btConeShapeX(radius, height);
        }
            break;
        case CollisionShapeType_ConeY:
        {
            btScalar height = constructionInfo->m_VBO->getHalfExtends().getY() * 2.0f;
            btScalar radius = ((constructionInfo->m_VBO->getHalfExtends().getX() +
                                constructionInfo->m_VBO->getHalfExtends().getZ()) / 2.0f);
            
            _btCollisionShape = new btConeShape(radius, height);
        }
            break;
        case CollisionShapeType_ConeZ:
        {
            btScalar height = constructionInfo->m_VBO->getHalfExtends().getZ() * 2.0f;
            btScalar radius = ((constructionInfo->m_VBO->getHalfExtends().getX() +
                                constructionInfo->m_VBO->getHalfExtends().getY()) / 2.0f);
            
            _btCollisionShape = new btConeShapeZ(radius, height);
        }   
            break;
        case CollisionShapeType_TriangleMesh:
        {
            struct myclass {           // function object type:
                
                btTriangleMesh *_btTriangleMesh;
                
                void operator() (const btVector3 &v1,
                                 const btVector3 &v2,
                                 const btVector3 &v3)
                {
                    _btTriangleMesh->addTriangle(v1, v2, v3);
                }
            } myobject;
            
            myobject._btTriangleMesh = new btTriangleMesh();
            
        
            constructionInfo->m_VBO->get_each_triangle<myclass>(myobject);
            
            _btCollisionShape = new btBvhTriangleMeshShape( myobject._btTriangleMesh, 1, 1 );
        }
            break;
        case CollisionShapeType_CapsuleX:
        {
            btScalar height = constructionInfo->m_VBO->getHalfExtends().getX() * 2.0f;
            btScalar radius = ((constructionInfo->m_VBO->getHalfExtends().getY() +
                                constructionInfo->m_VBO->getHalfExtends().getZ()) / 2.0f);
            
            _btCollisionShape = new btCapsuleShapeX(radius, height);
        }
            break;
        case CollisionShapeType_CapsuleY:
        {
            btScalar height = constructionInfo->m_VBO->getHalfExtends().getY() * 2.0f;
            btScalar radius = ((constructionInfo->m_VBO->getHalfExtends().getX() +
                                constructionInfo->m_VBO->getHalfExtends().getZ()) / 2.0f);
            
            _btCollisionShape = new btCapsuleShape(radius, height);
        }
            break;
        case CollisionShapeType_CapsuleZ:
        {
            btScalar height = constructionInfo->m_VBO->getHalfExtends().getZ() * 2.0f;
            btScalar radius = ((constructionInfo->m_VBO->getHalfExtends().getX() +
                                constructionInfo->m_VBO->getHalfExtends().getY()) / 2.0f);
            
            _btCollisionShape = new btCapsuleShapeZ(radius, height);
        }
            break;
        case CollisionShapeType_CylinderX:
        {
            _btCollisionShape = new btCylinderShapeX(constructionInfo->m_VBO->getHalfExtends());
        }
            break;
        case CollisionShapeType_CylinderY:
        {
            _btCollisionShape = new btCylinderShape(constructionInfo->m_VBO->getHalfExtends());
        }
            break;
        case CollisionShapeType_CylinderZ:
        {
            _btCollisionShape = new btCylinderShapeZ(constructionInfo->m_VBO->getHalfExtends());
        }
            break;
        case CollisionShapeType_ConvexHull:
        {
            struct myclass {           // function object type:
                
                btConvexHullShape *_btConvexHullShape;
                
                void operator() (int i, const btVector3 &v)
                {
                    _btConvexHullShape->addPoint(v);
                }
            } myobject;
            
            myobject._btConvexHullShape = new btConvexHullShape();
            
//            const BaseViewObject *pVBO = constructionInfo->m_VBO;
            const VertexBufferObject *pVBO = constructionInfo->m_VBO;
//            size_t offset = reinterpret_cast<size_t>(pVBO->getPositionOffset());
            size_t offset = pVBO->getPositionOffset();
            
            pVBO->get_each_attribute<myclass, btVector3>(myobject, offset);
            
            _btCollisionShape = myobject._btConvexHullShape;
        }
            break;
        case CollisionShapeType_Box2d:
        {
            _btCollisionShape = new btBox2dShape(constructionInfo->m_VBO->getHalfExtends());
        }
            break;
        case CollisionShapeType_StaticPlane:
        {
            btScalar constant = btVector3(0,0,0).distance(constructionInfo->m_VBO->getInitialTransform().getOrigin());
            
            
            
            struct myclass {           // function object type:
                
                btVector3 m_normal;
                
                myclass():
                m_normal(btVector3(0,0,0)){}
                
                void operator() (const btVector3 &v1,
                                 const btVector3 &v2,
                                 const btVector3 &v3)
                {
                    m_normal = TriNormal(v1, v2, v3);
                }
            } myobject;
            
            constructionInfo->m_VBO->get_each_triangle<myclass>(myobject);
            
            btMatrix3x3 _btMatrix3x3(constructionInfo->m_VBO->getInitialTransform().getRotation().inverse());
            myobject.m_normal = myobject.m_normal * _btMatrix3x3;
            
            _btCollisionShape = new btStaticPlaneShape(myobject.m_normal, constant);
        }
            break;
    }
    
    if(_btCollisionShape)
        _btCollisionShape->setMargin(s_ConvexMargin);
    
    return _btCollisionShape;
}

IDType CollisionShapeFactory::createShape(IDType viewObjectFactoryID,
                                   CollisionShapeType shape)
{
    CollisionShapeInfo *constructionInfo = NULL;
    
//    constructionInfo = new CollisionShapeInfo(shape,
//                                              ViewObjectFactory::getInstance()->get(viewObjectFactoryID));
    
    constructionInfo = new CollisionShapeInfo(shape,
                                              VertexBufferObjectFactory::getInstance()->get(viewObjectFactoryID));
    
    IDType ret = CollisionShapeFactory::getInstance()->create(constructionInfo);
    delete constructionInfo;
    return ret;
}

btCollisionShapeWrapper *CollisionShapeFactory::ctor(CollisionShapeInfo *constructionInfo)
{
    btCollisionShapeWrapper *t = new btCollisionShapeWrapper();
    t->m_btCollisionShape = createCollisionShape(constructionInfo);
    return t;
}
btCollisionShapeWrapper *CollisionShapeFactory::ctor(int type)
{
    return NULL;
}


void CollisionShapeFactory::dtor(btCollisionShapeWrapper *object)
{
    delete object->m_btCollisionShape;
    object->m_btCollisionShape = NULL;
    
    delete object;
    object = NULL;
}