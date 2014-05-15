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
    
    btHashMap<btHashString, GLuint> m_Locations;
    btAlignedObjectArray<char*> m_AllocatedNamesArray;
    
public:
    VBOMaterial();
    VBOMaterial(const VBOMaterialInfo &info);
    virtual ~VBOMaterial();
    
    void loadTexture(VertexBufferObject *owner,
                     const std::string &filename,
                     const unsigned int textureIndex);
    
    void loadTexture(VertexBufferObject *owner,
                     const IDType ID,
                     const unsigned int textureIndex);
    
    void loadUniform(VertexBufferObject *, const std::string &);
    void unLoadUniform(const std::string &);
    
    GLboolean setUniformValue(const std::string &, const GLint &);
    GLboolean setUniformValue(const std::string &, const btScalar &);
    GLboolean setUniformValue(const std::string &, const btVector2 &);
    GLboolean setUniformValue(const std::string &, const btVector3 &);
    GLboolean setUniformValue(const std::string &, const btVector4 &);
    GLboolean setUniformValue(const std::string &, const btMatrix3x3 &);
    GLboolean setUniformValue(const std::string &, const btTransform &);
    
    virtual void render(const unsigned int textureIndex);
};

#endif /* defined(__MazeADay__VBOMaterial__) */
