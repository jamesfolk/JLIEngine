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
m_TextureFileName(""),
m_ImageFileEditor(new ImageFileEditor()),
m_TextureUniform(0)
{
    
}

VBOMaterial::VBOMaterial(const VBOMaterialInfo &info):
AbstractBehavior<VertexBufferObject>(NULL),
m_TextureFileName(""),
m_ImageFileEditor(new ImageFileEditor()),
m_TextureUniform(0)
{
    
}

VBOMaterial::~VBOMaterial()
{
    m_ImageFileEditor->unload();
    
    delete m_ImageFileEditor;
    m_ImageFileEditor = NULL;
}

void VBOMaterial::setTextureFilename(const std::string &filename)
{
    m_TextureFileName = filename;
}

void VBOMaterial::loadGLSL(VertexBufferObject *owner, const unsigned int textureIndex)
{
    setOwner(owner);
    
    m_ImageFileEditor->load(m_TextureFileName);
    char buffer[256];
    sprintf(buffer, "texture%d", textureIndex);
    m_TextureUniform = glGetUniformLocation(owner->getProgramUsed(), buffer);
    
    btAssert(owner->hasTextureAttribute(textureIndex));
}

void VBOMaterial::render(VertexBufferObject *owner, const unsigned int textureIndex)
{
    setOwner(owner);
    
    glActiveTexture(GL_TEXTURE0 + textureIndex);
    m_ImageFileEditor->reload();
    glUniform1i(m_TextureUniform, 0);
}
