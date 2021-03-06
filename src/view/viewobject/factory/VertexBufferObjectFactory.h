//
//  VertexBufferObjectFactory.h
//  MazeADay
//
//  Created by James Folk on 3/30/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#ifndef __MazeADay__VertexBufferObjectFactory__
#define __MazeADay__VertexBufferObjectFactory__

#include "AbstractFactory.h"

class VertexBufferObjectFactory;

#include "VertexBufferObjectFactoryIncludes.h"
#include "VertexBufferObject.h"


class VertexBufferObjectFactory :
public AbstractFactory<VertexBufferObjectFactory, VertexBufferObjectInfo, VertexBufferObject>
{
    friend class AbstractSingleton;
    
    VertexBufferObjectFactory(){}
    virtual ~VertexBufferObjectFactory(){}
    
    btAlignedObjectArray<VertexBufferObject*> m_OrthographicEntities;
    btAlignedObjectArray<VertexBufferObject*> m_PerspectiveEntities;
public:
    void registerViewObject(VertexBufferObject *vo, bool orthographic = false);
    void render();
    
    static IDType createViewObject(unsigned int num_instances,
                                   const std::string &zipfile_object_name,
                                   IDType shader_factory_id);
protected:
    virtual VertexBufferObject *ctor(VertexBufferObjectInfo *constructionInfo);
    virtual VertexBufferObject *ctor(int type = 0);
    virtual void dtor(VertexBufferObject *object);
};

#endif /* defined(__MazeADay__VertexBufferObjectFactory__) */
