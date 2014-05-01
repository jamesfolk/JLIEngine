//
//  VBOMaterial.h
//  MazeADay
//
//  Created by James Folk on 3/30/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#ifndef __MazeADay__VBOMaterial__
#define __MazeADay__VBOMaterial__

#include <string>

#include "AbstractFactory.h"

#include "VBOMaterialFactoryIncludes.h"
#include "AbstractBehavior.h"


class VertexBufferObject;
class ImageFileEditor;

class VBOMaterial :
public AbstractFactoryObject,
public AbstractBehavior<VertexBufferObject>
{
    std::string m_TextureFileName;
    ImageFileEditor *m_ImageFileEditor;
    GLuint m_TextureUniform;
public:
    VBOMaterial();
    VBOMaterial(const VBOMaterialInfo &info);
    virtual ~VBOMaterial();
    
    void setTextureFilename(const std::string &filename);
    
    virtual void loadGLSL(VertexBufferObject *owner, const unsigned int textureIndex);
    virtual void render(VertexBufferObject *owner, const unsigned int textureIndex);
};

#endif /* defined(__MazeADay__VBOMaterial__) */
