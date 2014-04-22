//
//  EntityTextureBufferObject.cpp
//  BaseProject
//
//  Created by library on 10/10/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "EntityTextureBufferObject.h"
#include "UtilityFunctions.h"
#include "ShaderFactory.h"
#include "BaseEntity.h"
#include "BaseCamera.h"
#include "CameraFactory.h"

//#define check_gl_error() _check_gl_error(__FILE__,__LINE__,__FUNCTION__);
#include "VertexBufferObject.h"

void EntityTextureBufferObject::addEntity(BaseEntity *entity)
{
    m_Entities.push_back(entity);
}
void EntityTextureBufferObject::setCamera(BaseCamera *cam)
{
    m_pCamera = cam;
}
void EntityTextureBufferObject::renderFBO()
{
    //    glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);check_gl_error()
    //    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);check_gl_error()
    //
    glEnable(GL_DEPTH_TEST);check_gl_error()
    
    glEnable (GL_BLEND);check_gl_error()
    glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);check_gl_error()
    
    
    BaseCamera *cam = CameraFactory::getInstance()->getCurrentCamera();
    CameraFactory::getInstance()->setCurrentCamera(m_pCamera);
    
    glUseProgram(ShaderFactory::getInstance()->getCurrentShaderID());check_gl_error()
    
    for(int i = 0; i < m_Entities.size(); i++)
        m_Entities[i]->render();
    
    glUseProgram(0);check_gl_error()
    
    CameraFactory::getInstance()->setCurrentCamera(cam);
    
    //TextureBufferObjectFactory::getInstance()->render();
}