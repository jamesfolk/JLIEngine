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
#include "btHashMap.h"


class VertexBufferObject;
class ImageFileEditor;

class VBOMaterial :
public AbstractFactoryObject,
public AbstractBehavior<VertexBufferObject>
{
    ImageFileEditor *m_ImageFileEditor;
    GLuint m_TextureUniform;
    
    btHashMap<btHashString, GLuint> m_3vLocations;
public:
    VBOMaterial();
    VBOMaterial(const VBOMaterialInfo &info);
    virtual ~VBOMaterial();
    
    void loadTexture(VertexBufferObject *owner,
                     const std::string &filename,
                     const unsigned int textureIndex);
    
    void loadVec3(VertexBufferObject *owner, const std::string &glslName);
    void unLoadVec3(VertexBufferObject *owner, const std::string &glslName);
    bool setVec3(VertexBufferObject *owner, const std::string &glslName, const btVector3 &vec);
    
    virtual void render(VertexBufferObject *owner, const unsigned int textureIndex);
};

#endif /* defined(__MazeADay__VBOMaterial__) */
