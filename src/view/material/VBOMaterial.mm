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
    
    char *buffer = NULL;
    for(int i = 0; i < m_AllocatedNamesArray.size(); ++i)
    {
        buffer = m_AllocatedNamesArray[i];
        delete [] buffer;
    }
}

void VBOMaterial::loadTexture(VertexBufferObject *owner,
                              const std::string &filename,
                              const unsigned int textureIndex)
{
    setOwner(owner);
    
    btAssert(getOwner()->hasTextureAttribute(textureIndex));
    
    m_ImageFileEditor->unload();
    
    m_ImageFileEditor->load(filename);
    
    char buffer[256];
    sprintf(buffer, "texture%d", textureIndex);
    
    m_TextureUniform = glGetUniformLocation(getOwner()->getProgramUsed(), buffer);
}

void VBOMaterial::loadTexture(VertexBufferObject *owner,
                              const IDType ID,
                              const unsigned int textureIndex)
{
    setOwner(owner);
}

void VBOMaterial::loadUniform(VertexBufferObject *owner,  const std::string &glslName)
{
    setOwner(owner);
    
    char *buffer = new char[glslName.length()];
    strcpy(buffer, glslName.c_str());
    
    m_Locations.insert(btHashString(buffer),
                       glGetUniformLocation(getOwner()->getProgramUsed(), glslName.c_str()));
    m_AllocatedNamesArray.push_back(buffer);
    
}

void VBOMaterial::unLoadUniform( const std::string &glslName)
{
    m_Locations.remove(btHashString(glslName.c_str()));
}

GLboolean VBOMaterial::setUniformValue( const std::string &glslName, const GLint &v)
{
    GLuint *i = m_Locations.find(btHashString(glslName.c_str()));
    if(i)
    {
        glUniform1i(*i, v);
        return true;
    }
    return false;
}

GLboolean VBOMaterial::setUniformValue( const std::string &glslName, const btScalar &v)
{
    
    
    GLuint *i = m_Locations.find(btHashString(glslName.c_str()));
    if(i)
    {
        glUniform1f(*i, v);
        
        return true;
    }
    return false;
}

GLboolean VBOMaterial::setUniformValue( const std::string &glslName, const btVector2 &v)
{
    
    
    GLuint *i = m_Locations.find(btHashString(glslName.c_str()));
    if(i)
    {
        glUniform2f(*i, v.x(), v.y());
        
        return true;
    }
    return false;
}

GLboolean VBOMaterial::setUniformValue( const std::string &glslName, const btVector3 &v)
{
    
    
    GLuint *i = m_Locations.find(btHashString(glslName.c_str()));
    if(i)
    {
        glUniform3f(*i, v.x(), v.y(), v.z());
        
        return true;
    }
    return false;
}

GLboolean VBOMaterial::setUniformValue( const std::string &glslName, const btVector4 &v)
{
    btHashString key(glslName.c_str());
    const GLuint* i = m_Locations.find(key);
    
    if(i)
    {
        glUniform4f(*i, v.x(), v.y(), v.z(), v.w());
        
        return true;
    }
    return false;
}

GLboolean VBOMaterial::setUniformValue( const std::string &glslName, const btMatrix3x3 &v)
{
    
    
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

GLboolean VBOMaterial::setUniformValue( const std::string &glslName, const btTransform &v)
{
    
    
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


void VBOMaterial::render(const unsigned int textureIndex)
{
    if(-1 != m_TextureUniform)
    {
        glActiveTexture(GL_TEXTURE0 + textureIndex);
//        m_ImageFileEditor->reload();
        glUniform1i(m_TextureUniform, 0);
    }

}
