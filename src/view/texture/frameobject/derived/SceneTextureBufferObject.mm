//
//  SceneTextureBufferObject.cpp
//  BaseProject
//
//  Created by library on 10/9/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "SceneTextureBufferObject.h"

#include "WorldPhysics.h"
#include "EntityFactory.h"
#include "TextViewObjectFactory.h"
#include "ParticleEmitterBehaviorFactory.h"
#include "GameStateMachine.h"
#include "TextureBufferObjectFactory.h"

//#define check_gl_error() _check_gl_error(__FILE__,__LINE__,__FUNCTION__);
#include "VertexBufferObject.h"

void SceneTextureBufferObject::renderFBO()
{
//    glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);check_gl_error()
//    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);check_gl_error()
//    
    glEnable(GL_DEPTH_TEST);check_gl_error()
    
    glEnable (GL_BLEND);check_gl_error()
    glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);check_gl_error()
    
    
    glUseProgram(ShaderFactory::getInstance()->getCurrentShaderID());check_gl_error()
    
    WorldPhysics::getInstance()->render();
    
    EntityFactory::getInstance()->render();
    
    TextViewObjectFactory::getInstance()->render();
    
    ParticleEmitterBehaviorFactory::getInstance()->render();
    
    GameStateMachine::getInstance()->render();
    
    glUseProgram(0);check_gl_error()
    
    //TextureBufferObjectFactory::getInstance()->render();
}