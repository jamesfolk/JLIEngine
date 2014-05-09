//
//  VBOMaterial.cpp
//  MazeADay
//
//  Created by James Folk on 3/30/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#include "VBOMaterial.h"
#include "VertexBufferObject.h"
#include "ImageFileEditor.h"

extern const unsigned int TEXTURE_MAX;

VBOMaterial::VBOMaterial() :
AbstractBehavior<VertexBufferObject>(NULL),
m_ImageFileEditor(new ImageFileEditor()),
m_TextureUniform(-1)
{
    
}

VBOMaterial::VBOMaterial(const VBOMaterialInfo &info):
AbstractBehavior<VertexBufferObject>(NULL),
m_ImageFileEditor(new ImageFileEditor()),
m_TextureUniform(-1)
{
    
}

VBOMaterial::~VBOMaterial()
{
    m_ImageFileEditor->unload();
    
    delete m_ImageFileEditor;
    m_ImageFileEditor = NULL;
}

void VBOMaterial::loadTexture(VertexBufferObject *owner,
                              const std::string &filename,
                              const unsigned int textureIndex)
{
    btAssert(owner->hasTextureAttribute(textureIndex));
    
    setOwner(owner);
    
    m_ImageFileEditor->unload();
    
    m_ImageFileEditor->load(filename);
    
    char buffer[256];
    sprintf(buffer, "texture%d", textureIndex);
    
    m_TextureUniform = glGetUniformLocation(owner->getProgramUsed(), buffer);
}

void VBOMaterial::loadTexture(VertexBufferObject *owner,
                              const IDType ID,
                              const unsigned int textureIndex)
{
    
}

void VBOMaterial::loadUniform(VertexBufferObject *owner, const std::string &glslName)
{
    setOwner(owner);
    
    m_Locations.insert(btHashString(glslName.c_str()),
                       glGetUniformLocation(owner->getProgramUsed(), glslName.c_str()));
}

void VBOMaterial::unLoadUniform(VertexBufferObject *owner, const std::string &glslName)
{
    m_Locations.remove(btHashString(glslName.c_str()));
}


//GLboolean VBOMaterial::setUniformValue(VertexBufferObject *owner, const std::string &glslName, const GLboolean &v)
//{
//    setOwner(owner);
//    
//    GLuint *i = m_Locations.find(btHashString(glslName.c_str()));
//    if(i)
//    {
//        glUniform1i(*i, (v)?GL_TRUE:GL_FALSE);
//        
//        return true;
//    }
//    return false;
//}
GLboolean VBOMaterial::setUniformValue(VertexBufferObject *owner, const std::string &glslName, const GLint &v)
{
    setOwner(owner);
    
    GLuint *i = m_Locations.find(btHashString(glslName.c_str()));
    if(i)
    {
        glUniform1i(*i, v);
        
        return true;
    }
    return false;
}
GLboolean VBOMaterial::setUniformValue(VertexBufferObject *owner, const std::string &glslName, const btScalar &v)
{
    setOwner(owner);
    
    GLuint *i = m_Locations.find(btHashString(glslName.c_str()));
    if(i)
    {
        glUniform1f(*i, v);
        
        return true;
    }
    return false;
}
GLboolean VBOMaterial::setUniformValue(VertexBufferObject *owner, const std::string &glslName, const btVector2 &v)
{
    setOwner(owner);
    
    GLuint *i = m_Locations.find(btHashString(glslName.c_str()));
    if(i)
    {
        glUniform2f(*i, v.x(), v.y());
        
        return true;
    }
    return false;
}
GLboolean VBOMaterial::setUniformValue(VertexBufferObject *owner, const std::string &glslName, const btVector3 &v)
{
    setOwner(owner);
    
    GLuint *i = m_Locations.find(btHashString(glslName.c_str()));
    if(i)
    {
        glUniform3f(*i, v.x(), v.y(), v.z());
        
        return true;
    }
    return false;
}
GLboolean VBOMaterial::setUniformValue(VertexBufferObject *owner, const std::string &glslName, const btVector4 &v)
{
    setOwner(owner);
    
    GLuint *i = m_Locations.find(btHashString(glslName.c_str()));
    if(i)
    {
        glUniform4f(*i, v.x(), v.y(), v.z(), v.w());
        
        return true;
    }
    return false;
}
GLboolean VBOMaterial::setUniformValue(VertexBufferObject *owner, const std::string &glslName, const btMatrix3x3 &v)
{
    setOwner(owner);
    
    GLuint *i = m_Locations.find(btHashString(glslName.c_str()));
    if(i)
    {
        static btScalar m[9];
        
        v.getOpenGLSubMatrix(m);
        
        glUniformMatrix3fv(*i, 1, 0, m);check_gl_error()
        
        return true;
    }
    return false;
}
GLboolean VBOMaterial::setUniformValue(VertexBufferObject *owner, const std::string &glslName, const btTransform &v)
{
    setOwner(owner);
    
    GLuint *i = m_Locations.find(btHashString(glslName.c_str()));
    if(i)
    {
        static btScalar m[16];
        
        v.getOpenGLMatrix(m);
        
        glUniformMatrix4fv(*i, 1, 0, m);
        
        return true;
    }
    return false;
}


void VBOMaterial::render(VertexBufferObject *owner, const unsigned int textureIndex)
{
    setOwner(owner);
    
    if(-1 != m_TextureUniform)
    {
        glActiveTexture(GL_TEXTURE0 + textureIndex);
//        m_ImageFileEditor->reload();
        glUniform1i(m_TextureUniform, 0);
    }

}
