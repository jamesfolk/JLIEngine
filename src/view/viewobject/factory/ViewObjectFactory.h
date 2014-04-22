//
//  ViewObjectFactory.h
//  GameAsteroids
//
//  Created by James Folk on 3/26/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__ViewObjectFactory__
#define __GameAsteroids__ViewObjectFactory__

#include "AbstractFactory.h"

#include "ShaderFactory.h"

class ViewObjectFactory;
struct BaseViewObjectInfo;
//class BaseViewObject;
#include "BaseViewObject.h"


class ViewObjectFactory :
public AbstractFactory<ViewObjectFactory, BaseViewObjectInfo, BaseViewObject>
{
    friend class AbstractSingleton;
    
    ViewObjectFactory(){}
    virtual ~ViewObjectFactory(){}
public:
    static IDType createViewObject(const char * zipfile_object_name,
                                   IDType texture_factory_ids);
    
    static IDType createViewObject(const std::string &zipfile_object_name,
                                   IDType *texture_factory_ids,
                                   int num_texture_factory_ids = 1,
                                   IDType *textureBehaviorFactoryIDs = NULL,
                                   const unsigned int num_texture_behaviors = 0);
protected:
    virtual BaseViewObject *ctor(BaseViewObjectInfo *constructionInfo);
    virtual BaseViewObject *ctor(int type = 0);
    virtual void dtor(BaseViewObject *object);
};

#endif /* defined(__GameAsteroids__ViewObjectFactory__) */
