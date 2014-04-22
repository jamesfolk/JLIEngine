//
//  VBOMaterial.cpp
//  MazeADay
//
//  Created by James Folk on 3/30/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#include "VBOMaterial.h"
#include "VertexBufferObject.h"


extern const unsigned int TEXTURE_MAX;

VBOMaterial::VBOMaterial() :
AbstractBehavior<VertexBufferObject>(NULL),
m_TextureFileName("")
{
    
}

VBOMaterial::VBOMaterial(const VBOMaterialInfo &info):
AbstractBehavior<VertexBufferObject>(NULL)
{
    
}

VBOMaterial::~VBOMaterial()
{
}

void VBOMaterial::setTextureFilename(const std::string &filename)
{
    m_TextureFileName = filename;
}

void VBOMaterial::loadGLSL(VertexBufferObject *owner, const unsigned int textureIndex)
{
    setOwner(owner);
    
    btAssert(owner->hasTextureAttribute(textureIndex));
}

void VBOMaterial::render(VertexBufferObject *owner, const unsigned int textureIndex)
{
    setOwner(owner);
}