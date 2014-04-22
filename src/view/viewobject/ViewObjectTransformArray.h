//
//  ViewObjectTransformArray.h
//  MazeADay
//
//  Created by James Folk on 3/18/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#ifndef __MazeADay__ViewObjectTransformArray__
#define __MazeADay__ViewObjectTransformArray__

#include "btAlignedObjectArray.h"
#include "jliTransform.h"
#include <queue>

class BaseEntity;
class BaseViewObject;
//btAlignedObjectArray<jliTransform> transformData;
//jliTransform t1(btTransform::getIdentity()),
//t2(btTransform::getIdentity()),
//t3(btTransform::getIdentity()),
//t4(btTransform::getIdentity());
//btTransform temp(btTransform::getIdentity());
//
//
//temp.setOrigin(btVector3(1.1, 2.2, 3.3));
//t1 = temp;
//transformData.push_back(t1);
//
//temp.setOrigin(btVector3(11.1, 22.2, 33.3));
//t2 = temp;
//transformData.push_back(t2);
//
//temp.setOrigin(btVector3(111.1, 222.2, 333.3));
//t3 = temp;
//transformData.push_back(t3);
//
//temp.setOrigin(btVector3(1111.1, 2222.2, 3333.3));
//t4 = temp;
//transformData.push_back(t4);
//
//const GLvoid* array_data = &transformData[0];

class ViewObjectTransformArray
{
    std::queue<unsigned int> m_IndiceQueue;
    
    btAlignedObjectArray<jliTransform> transformData;
    
    bool m_IsDirty;
    unsigned int m_CurrentIndex;
    
    void init();
public:
    void operator() (int i, btTransform &to, const btTransform &from);
    ViewObjectTransformArray(const unsigned int capacity = 100);
    ViewObjectTransformArray(const ViewObjectTransformArray &rhs);
    
    ViewObjectTransformArray &operator=(const ViewObjectTransformArray &rhs);
    
    void render(BaseViewObject *pViewObject);
    
    bool registerEntity(BaseEntity *entity);
    void setWorldTransform(BaseEntity *entity);
};

#endif /* defined(__MazeADay__ViewObjectTransformArray__) */
