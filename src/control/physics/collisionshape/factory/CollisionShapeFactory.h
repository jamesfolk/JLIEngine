//
//  CollisionShapeFactory.h
//  GameAsteroids
//
//  Created by James Folk on 3/15/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__CollisionShapeFactory__
#define __GameAsteroids__CollisionShapeFactory__

#include "AbstractFactory.h"
#include "CollisionShapeFactoryIncludes.h"
#include "CollisionShapeFactory.h"

class btCollisionShape;
class CollisionShapeFactory;

class CollisionShapeFactory :
public AbstractFactory<CollisionShapeFactory, CollisionShapeInfo, btCollisionShapeWrapper>
{
    friend class AbstractSingleton;
    
    btCollisionShape *createCollisionShape(CollisionShapeInfo *constructionInfo);
    
    CollisionShapeFactory(){}
    virtual ~CollisionShapeFactory(){}
public:
    static IDType createShape(IDType viewObjectFactoryID,
                              CollisionShapeType shape);
protected:
    virtual btCollisionShapeWrapper *ctor(CollisionShapeInfo *constructionInfo);
    virtual btCollisionShapeWrapper *ctor(int type = 0);
    virtual void dtor(btCollisionShapeWrapper *object);
public:
    static const btScalar s_ConvexMargin;
};

#endif /* defined(__GameAsteroids__CollisionShapeFactory__) */
