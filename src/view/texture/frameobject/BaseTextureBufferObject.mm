//
//  BaseTextureBufferObject.cpp
//  BaseProject
//
//  Created by library on 10/9/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "BaseTextureBufferObject.h"

#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
//#include <OpenGLES/ES3/gl.h>
//#include <OpenGLES/ES3/glext.h>

#include "UtilityFunctions.h"
#include "CameraFactory.h"

//:!!!:SOURCE: http://blog.angusforbes.com/openglglsl-render-to-texture/

//#define check_gl_error() _check_gl_error(__FILE__,__LINE__,__FUNCTION__);
#include "VertexBufferObject.h"

BaseTextureBufferObject::BaseTextureBufferObject(const TextureBufferObjectFactoryInfo &info) :
m_textureA(0),
m_textureB(0),
m_height(info.m_height),
m_width(info.m_width),
m_counter(0),
m_fboA(0),
m_fboB(0)
{
    btAssert(validateDimensions(m_width, m_height));
}

BaseTextureBufferObject::~BaseTextureBufferObject()
{
    unload();
}

bool BaseTextureBufferObject::isLoaded()const
{
    return (m_fboA && m_fboB && m_textureA && m_textureB);
}

void BaseTextureBufferObject::load()
{
    //create texture A
    //glEnable(GL_TEXTURE_2D);check_gl_error()
    glGenTextures(1, &m_textureA);check_gl_error()
    glBindTexture(GL_TEXTURE_2D, m_textureA);check_gl_error()
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);check_gl_error()
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);check_gl_error()
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);check_gl_error()
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);check_gl_error()
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, m_width, m_height, 0, GL_RGBA,
                 GL_UNSIGNED_BYTE, NULL);check_gl_error()
    
    //create m_textureB
    //...similar code as for m_textureA...
    //glEnable(GL_TEXTURE_2D);check_gl_error()
    glGenTextures(1, &m_textureB);check_gl_error()
    glBindTexture(GL_TEXTURE_2D, m_textureB);check_gl_error()
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);check_gl_error()
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);check_gl_error()
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);check_gl_error()
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);check_gl_error()
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, m_width, m_height, 0, GL_RGBA,
                 GL_UNSIGNED_BYTE, NULL);check_gl_error()
    
    //except this time we will initialize the texture
    //so that some cells start out alive.
    //GLubyte* data = (GLubyte *) malloc(m_width*m_height*4*sizeof(GLubyte));
//    GLubyte *data = new GLubyte[m_width*m_height*4];
//    memset(data, 0, m_width * m_height * 4);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, m_width, m_height, 0, GL_RGBA,
                 GL_UNSIGNED_BYTE, NULL);check_gl_error()
//    delete [] data;
//    data = NULL;
    
    //create m_fboA and attach texture A to it
    
    glGenFramebuffers(1, &m_fboA);check_gl_error()
    glBindFramebuffer(GL_FRAMEBUFFER, m_fboA);check_gl_error()
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                           GL_TEXTURE_2D, m_textureA, 0);check_gl_error()
    
    glGenRenderbuffers(1, &m_dbA);check_gl_error()
    glBindRenderbuffer(GL_RENDERBUFFER, m_dbA);check_gl_error()
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, m_width, m_height);check_gl_error()
    //Attach depth buffer to FBO
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, m_dbA);check_gl_error()
    
    //create m_fboB and attach texture B to it
    
    //...similar code as for m_fboB...
    glGenFramebuffers(1, &m_fboB);check_gl_error()
    glBindFramebuffer(GL_FRAMEBUFFER, m_fboB);check_gl_error()
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                           GL_TEXTURE_2D, m_textureB, 0);check_gl_error()
    glGenRenderbuffers(1, &m_dbB);check_gl_error()
    glBindRenderbuffer(GL_RENDERBUFFER, m_dbB);check_gl_error()
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, m_width, m_height);check_gl_error()
    //Attach depth buffer to FBO
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, m_dbB);check_gl_error()
    
    btAssert(m_dbA && m_dbB && m_fboA && m_fboB && m_textureA && m_textureB && m_dbA && m_dbB);
    
    //initialize a counter so we know if we are "pinging" or "ponging"
    //(i.e. if counter is even then FBO A is current, if odd, FBO B is current.)
    m_counter = 0;
}

void BaseTextureBufferObject::render()
{
    if (m_counter % 2 == 0)
        _renderFBO(m_fboA);
    else
        _renderFBO(m_fboB);
    m_counter++;
}

GLuint BaseTextureBufferObject::name()const
{
    if (m_counter % 2 == 0)
        return m_textureB;
    
    return m_textureA;
}

void BaseTextureBufferObject::unload()
{
    if(m_dbA && m_dbB && m_fboA && m_fboB && m_textureA && m_textureB)
    {
        const GLuint renderbuffers[2] = {m_dbA, m_dbB};
        glDeleteRenderbuffers(2, renderbuffers);check_gl_error()
        
        const GLuint framebuffers[2] = {m_fboA, m_fboB};
        glDeleteFramebuffers(2, framebuffers);check_gl_error()
        
        const GLuint textures[2] = {m_textureA, m_textureB};
        glDeleteTextures(2, textures);check_gl_error()
    }
    
    m_dbA = m_dbB = m_fboA = m_fboB = m_textureA = m_textureB = 0;
}

void BaseTextureBufferObject::_renderFBO(GLuint fbo)
{
    //bind FBO to set textureA as the output texture.
    glBindFramebuffer(GL_FRAMEBUFFER, fbo);check_gl_error()
    
    //set the viewport to be the size of the texture
    glViewport(0, 0, m_width, m_height);check_gl_error()
    
    glClearColor(0, 0, 0, 0.0);check_gl_error()
    //clear the ouput texture
    glClear ( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );check_gl_error()
    
    btScalar prev_width = CameraFactory::getScreenWidth();
    btScalar prev_height = CameraFactory::getScreenHeight();
    
    CameraFactory::updateScreenDimensions(m_width, m_height);
    
    renderFBO();
    
    CameraFactory::updateScreenDimensions(prev_width, prev_height);
    
    glBindFramebuffer(GL_FRAMEBUFFER, 0);check_gl_error() //unbind the FBO
}

bool BaseTextureBufferObject::validateDimensions(size_t width, size_t height)const
{
    return true;
}