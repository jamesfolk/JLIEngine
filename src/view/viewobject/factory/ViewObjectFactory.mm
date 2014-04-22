//
//  ViewObjectFactory.cpp
//  GameAsteroids
//
//  Created by James Folk on 3/26/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

//#include "BaseSpriteView.h"

#include "ViewObjectFactory.h"

#include "ViewObjectFactoryIncludes.h"
#include "BaseViewObject.h"
#include "ZipFileResourceLoader.h"

IDType ViewObjectFactory::createViewObject(const char * zipfile_object_name,
                        IDType texture_factory_ids)
{
    return createViewObject(std::string(zipfile_object_name), &texture_factory_ids);
}

IDType ViewObjectFactory::createViewObject(const std::string &zipfile_object_name,
                                           IDType *texture_factory_ids,
                                           int num_texture_factory_ids,
                                           IDType *textureBehaviorFactoryIDs,
                                           const unsigned int num_texture_behaviors)
{
    BaseViewObjectInfo *info = new BaseViewObjectInfo(ShaderFactory::getInstance()->getCurrentShaderID(),
                                                      zipfile_object_name,
                                                      texture_factory_ids,
                                                      num_texture_factory_ids,
                                                      textureBehaviorFactoryIDs,
                                                      num_texture_behaviors);
    
    IDType ret = ViewObjectFactory::getInstance()->create(info);
    
    BaseViewObject *vo = ViewObjectFactory::getInstance()->get(ret);
    
    ZipFileResourceLoader::getInstance()->getMeshObject(zipfile_object_name)->load(vo);
    
    delete info;
    info = NULL;
    return ret;
}

BaseViewObject *ViewObjectFactory::ctor(BaseViewObjectInfo *constructionInfo)
{
    return new BaseViewObject(*constructionInfo);
}

BaseViewObject *ViewObjectFactory::ctor(int type)
{
    return NULL;
}

void ViewObjectFactory::dtor(BaseViewObject *object)
{
    delete object;
    object = NULL;
}
