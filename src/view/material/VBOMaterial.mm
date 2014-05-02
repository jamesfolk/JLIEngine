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

void VBOMaterial::loadVec3(VertexBufferObject *owner,
                           const std::string &glslName)
{
    setOwner(owner);
    
    m_3vLocations.insert(btHashString(glslName.c_str()),
                         glGetUniformLocation(owner->getProgramUsed(), glslName.c_str()));
    
    
}

void VBOMaterial::unLoadVec3(VertexBufferObject *owner, const std::string &glslName)
{
    m_3vLocations.remove(btHashString(glslName.c_str()));
}

bool VBOMaterial::setVec3(VertexBufferObject *owner,
                          const std::string &glslName,
                          const btVector3 &vec)
{
    setOwner(owner);
    
    GLuint *i = m_3vLocations.find(btHashString(glslName.c_str()));
    if(i)
    {
        glUniform3f(*i, vec.x(), vec.y(), vec.z());
        
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
