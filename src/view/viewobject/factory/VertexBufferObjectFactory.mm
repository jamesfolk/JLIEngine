//
//  VertexBufferObjectFactory.cpp
//  MazeADay
//
//  Created by James Folk on 3/30/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#include "VertexBufferObjectFactory.h"
#include "ZipFileResourceLoader.h"

IDType VertexBufferObjectFactory::createViewObject(unsigned int num_instances,
                                                   const std::string &zipfile_object_name,
                                                   IDType texture_factory_id,
                                                   IDType shader_factory_id)
{
    VertexBufferObjectInfo *info = new VertexBufferObjectInfo(zipfile_object_name);
    IDType ret = VertexBufferObjectFactory::getInstance()->create(info);
    VertexBufferObject *vbo = VertexBufferObjectFactory::getInstance()->get(ret);
    
    const BaseMeshObject *bmo = ZipFileResourceLoader::getInstance()->getMeshObject(zipfile_object_name);
    btAssert(bmo);
    
    bmo->loadGLBuffer(num_instances, vbo, shader_factory_id);
    
    delete info;
    info = NULL;
    
    return ret;
//    BaseViewObjectInfo *info = new BaseViewObjectInfo(ShaderFactory::getInstance()->getCurrentShaderID(),
//                                                      zipfile_object_name,
//                                                      texture_factory_ids,
//                                                      num_texture_factory_ids,
//                                                      textureBehaviorFactoryIDs,
//                                                      num_texture_behaviors);
//    
//    IDType ret = ViewObjectFactory::getInstance()->create(info);
//    
//    BaseViewObject *vo = ViewObjectFactory::getInstance()->get(ret);
//    
//    ZipFileResourceLoader::getInstance()->getMeshObject(zipfile_object_name)->load(vo);
//    
//    delete info;
//    info = NULL;
//    return ret;
}
VertexBufferObject *VertexBufferObjectFactory::ctor(VertexBufferObjectInfo *constructionInfo)
{
    return new VertexBufferObject(*constructionInfo);
}
VertexBufferObject *VertexBufferObjectFactory::ctor(int type)
{
    return new VertexBufferObject();
}
void VertexBufferObjectFactory::dtor(VertexBufferObject *object)
{
    delete object;
    object = NULL;
}