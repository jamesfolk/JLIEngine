//
//  VertexBufferObjectFactory.cpp
//  MazeADay
//
//  Created by James Folk on 3/30/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#include "VertexBufferObjectFactory.h"
#include "ZipFileResourceLoader.h"

void VertexBufferObjectFactory::registerViewObject(VertexBufferObject *vo, bool orthographic)
{
    if(orthographic)
    {
        m_OrthographicEntities.remove(vo);
        m_OrthographicEntities.push_back(vo);
    }
    else
    {
        m_PerspectiveEntities.remove(vo);
        m_PerspectiveEntities.push_back(vo);
    }
}

void VertexBufferObjectFactory::render()
{
    for (int i = 0; i < m_PerspectiveEntities.size(); ++i)
    {
        m_PerspectiveEntities[i]->renderGLBuffer(GL_TRIANGLES);
    }
    for(int i = 0; i < m_OrthographicEntities.size(); ++i)
    {
        m_OrthographicEntities[i]->renderGLBuffer(GL_TRIANGLES);
    }
}

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