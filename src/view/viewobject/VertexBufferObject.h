//
//  VertexBufferObject.h
//  MazeADay
//
//  Created by James Folk on 4/7/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#ifndef __MazeADay__VertexBufferObject__
#define __MazeADay__VertexBufferObject__

#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

#include "AbstractFactory.h"
#include "btVector2.h"
#include "btTransform.h"
#include "VertexBufferObjectFactoryIncludes.h"
#include "ShaderFactory.h"
#include "VBOMaterial.h"

#if defined(DEBUG) || defined (_DEBUG)
extern void _check_gl_error(const char *file, int line, const char *function);
#define check_gl_error() _check_gl_error(__FILE__,__LINE__,__FUNCTION__);
#else
#define check_gl_error() ;
#endif

extern const unsigned int TEXTURE_MAX;

class VBOMaterial;
class BaseEntity;

class VertexBufferObject :
public AbstractFactoryObject
{
    struct AttributeHandles
    {
        AttributeHandles():
        transformmatrix(-1),
        position(-1),
        normal(-1),
        textureCoord(new GLint[TEXTURE_MAX]),
        color(-1)
        {
            memset(textureCoord, -1, sizeof(GLint) * TEXTURE_MAX);
        }
        
        virtual ~AttributeHandles()
        {
            delete [] textureCoord;
            textureCoord = NULL;
        }
        
        GLint transformmatrix;
        GLint position;
        GLint normal;
        GLint *textureCoord;
        GLint color;
    }m_GLSLAttributes;
    
    struct UniformHandles
    {
        UniformHandles():
        modelViewMatrix(-1),
        projectionMatrix(-1)
        {
        }
        
        GLuint modelViewMatrix;
        GLuint projectionMatrix;
        GLuint modelViewProjectionMatrix;
    }m_GLSLUniforms;
    
    unsigned int m_NumTextures;
    unsigned int m_NumVertices;
    unsigned int m_NumIndices;

    GLuint m_vertexArrayBuffer;
    GLuint m_modelviewBuffer;
    GLuint m_vertexBuffer;
    GLuint m_indexBuffer;
    
    GLfloat *m_ModelViewArray;
    btAlignedObjectArray<IDType> m_BaseObjects;
    unsigned int m_NumInstances;
    
    GLboolean m_ShouldRender;
    
    IDType m_MaterialFactoryIDs;
    IDType m_ShaderFactoryID;
    
    GLsizei m_Stride;
    size_t m_PositionOffset;
    size_t m_NormalOffset;
    size_t m_ColorOffset;
    size_t *m_TextureOffset;
private:
    typedef void (*vector2Func)(int i, btVector2 &to, const btVector2 &from);
    typedef void (*vector3Func)(int i, btVector3 &to, const btVector3 &from);
    typedef void (*vector4Func)(int i, btVector4 &to, const btVector4 &from);
    typedef void (*transformFunc)(int i, btTransform &to, const btTransform &from);

    void updateGLBuffer();
protected:
    virtual void updateGLBufferPosition(int i, btVector3 &to, const btVector3 &from);
    virtual void updateGLBufferNormal(int i, btVector3 &to, const btVector3 &from){}
    virtual void updateGLBufferColor(int i, btVector4 &to, const btVector4 &from){}
    virtual void updateGLBufferTexture(int i, int textureIndex, btVector2 &to, const btVector2 &from){}
    
public:
    SIMD_FORCE_INLINE const GLsizei getStride()const
    {
        return m_Stride;
    }
    
    SIMD_FORCE_INLINE const size_t getPositionOffset()const
    {
        return m_PositionOffset;
    }
    
    SIMD_FORCE_INLINE const size_t getNormalOffset()const
    {
        return m_NormalOffset;
    }
    
    SIMD_FORCE_INLINE const size_t getColorOffset()const
    {
        return m_ColorOffset;
    }
    
    SIMD_FORCE_INLINE const size_t getTextureOffset(const unsigned int index)const
    {
        btAssert(index < TEXTURE_MAX);
        
        return m_TextureOffset[index];
    }
public:
    SIMD_FORCE_INLINE bool hasColorAttribute()const
    {
        return (0 != getColorOffset());
    }
    
    SIMD_FORCE_INLINE bool hasNormalAttribute()const
    {
        return (0 != getNormalOffset());
    }
    
    SIMD_FORCE_INLINE bool hasTextureAttribute(const unsigned int index)const
    {
        return (0 != getTextureOffset(index));
    }
    
public:
    SIMD_FORCE_INLINE void setID(const IDType ID)
    {
        AbstractFactoryObject::setID(ID);
    }
    
    SIMD_FORCE_INLINE IDType getID()const
    {
        return AbstractFactoryObject::getID();
    }
    
    SIMD_FORCE_INLINE const std::string &getName()const
    {
        return AbstractFactoryObject::getName();
    }
    
    SIMD_FORCE_INLINE void setName(const std::string &name)
    {
        AbstractFactoryObject::setName(name);
    }
    
    VertexBufferObject();
    VertexBufferObject(const VertexBufferObjectInfo &info);
    VertexBufferObject(const VertexBufferObject &rhs);
    
    virtual ~VertexBufferObject();
    
    VertexBufferObject &operator=(const VertexBufferObject &rhs);
    
    template<class VERTEX_ATTRIBUTE>
    GLboolean loadGLBuffer(const unsigned int num_instances,
                           const btAlignedObjectArray<VERTEX_ATTRIBUTE> &vertices,
                           const btAlignedObjectArray<GLushort> &indices,
                           IDType shader_factory_id);
    virtual GLboolean unLoadGLBuffer();
    virtual GLboolean isGLBufferLoaded()const;
    
    
    
    void updateGLBuffer(bool position,
                        bool normal,
                        bool color,
                        bool texture[TEXTURE_MAX]);
    
    void renderGLBuffer(GLenum drawmode);
    
    bool registerEntity(BaseEntity *entity);
    bool unRegisterEntity(BaseEntity *entity);
    
    void markInView(BaseEntity *entity);
    
    void setMaterial(const IDType ID);
    const VBOMaterial*	getMaterial() const;
    VBOMaterial*	getMaterial();
    
    btVector3 getHalfExtends() const;
    btTransform getInitialTransform() const;
    btScalar getBoundingRadius()const;
    bool hasAlphaTexture()const;
    
    GLuint getProgramUsed()const;
public:
    void loadTexture(const std::string &filename,
                     const unsigned int textureIndex)
    {
        getMaterial()->loadTexture(this, filename, textureIndex);
    }
    void loadUniform(const std::string &glslUniformName)
    {
        getMaterial()->loadUniform(this, glslUniformName);
    }
//    void unLoadUniform(const std::string &glslUniformName)
//    {
//        getMaterial()->unLoadUniform(glslUniformName);
//    }
//    
//    GLboolean setUniformValue(const std::string &glslUniformName, const GLint &v)
//    {
//        return getMaterial()->setUniformValue(this, glslUniformName, v);
//    }
//    GLboolean setUniformValue(const std::string &glslUniformName, const btScalar &v)
//    {
//        return getMaterial()->setUniformValue(this, glslUniformName, v);
//    }
//    GLboolean setUniformValue(const std::string &glslUniformName, const btVector2 &v)
//    {
//        return getMaterial()->setUniformValue(this, glslUniformName, v);
//    }
//    GLboolean setUniformValue(const std::string &glslUniformName, const btVector3 &v)
//    {
//        return getMaterial()->setUniformValue(this, glslUniformName, v);
//    }
//    GLboolean setUniformValue(const std::string &glslUniformName, const btVector4 &v)
//    {
//        return getMaterial()->setUniformValue(this, glslUniformName, v);
//    }
//    GLboolean setUniformValue(const std::string &glslUniformName, const btMatrix3x3 &v)
//    {
//        return getMaterial()->setUniformValue(this, glslUniformName, v);
//    }
//    GLboolean setUniformValue(const std::string &glslUniformName, const btTransform &v)
//    {
//        return getMaterial()->setUniformValue(this, glslUniformName, v);
//    }
public:
    template<class Function>
    void get_each_indice(Function fn)const;
    
    template<class Function, class AttributeType>
    void get_each_attribute(Function &fn, size_t offset)const;
    
    template<class Function>
    void get_each_triangle(Function fn)const;
    
    
    template<class Function, class AttributeType>
    void set_each_attribute(Function &fn, size_t offset);
    
    template<class Function>
    void set_each_triangle(Function fn)const;
    
    
    template<class Function, class AttributeType>
    void get_attribute(unsigned int attribute_index, Function &fn, size_t offset)const;
    
    template<class Function, class AttributeType>
    void set_attribute(unsigned int attribute_index, Function &fn, size_t offset);
    
    
};

template<class VERTEX_ATTRIBUTE>
GLboolean VertexBufferObject::loadGLBuffer(const unsigned int num_instances,
                                           const btAlignedObjectArray<VERTEX_ATTRIBUTE> &vertices,
                                           const btAlignedObjectArray<GLushort> &indices,
                                           IDType shader_factory_id)
{
    GLboolean ret = GL_FALSE;
    
    unLoadGLBuffer();
    
    if(vertices.size() > 0)
    {
        m_NumInstances = num_instances;
        m_NumVertices = vertices.size();
        m_NumIndices = indices.size();
        
        m_Stride = VERTEX_ATTRIBUTE::getStride();
        
        m_PositionOffset = VERTEX_ATTRIBUTE::getPositionOffset();
        m_NormalOffset = VERTEX_ATTRIBUTE::getNormalOffset();
        m_ColorOffset = VERTEX_ATTRIBUTE::getColorOffset();
        
        m_NumTextures = 0;
        for(int textureIndex = 0; textureIndex < TEXTURE_MAX; ++textureIndex)
        {
            m_TextureOffset[textureIndex] = VERTEX_ATTRIBUTE::getTextureOffset(textureIndex);
            if(hasTextureAttribute(textureIndex))
                ++m_NumTextures;
        }
        
        glGenVertexArraysOES(1, &m_vertexArrayBuffer);check_gl_error()
        glBindVertexArrayOES(m_vertexArrayBuffer);check_gl_error()
        
        glGenBuffers(1, &m_vertexBuffer);check_gl_error()
        glBindBuffer(GL_ARRAY_BUFFER, m_vertexBuffer);check_gl_error()
        glBufferData(GL_ARRAY_BUFFER,
                     m_NumVertices * sizeof(vertices[0]),
                     &vertices[0],
                     GL_STATIC_DRAW);check_gl_error()
        
        m_ShaderFactoryID = shader_factory_id;
        
        GLuint program = getProgramUsed();
        
        const char *const textureCoord[]  =
        {
            "texture",
            "textureCoord1",
            "textureCoord2",
            "textureCoord3",
            "textureCoord4",
            "textureCoord5",
            "textureCoord6",
            "textureCoord7"
        };
        const char *const position = "position";
        const char *const sourceColor = "color";
        const char *const transformmatrix = "transformMatrix";
        const char *const normal = "normal";
        
        const char *const modelViewMatrix = "modelViewMatrix";
        const char *const projectionMatrix = "projectionMatrix";
        const char *const modelViewProjectionMatrix = "modelViewProjectionMatrix";
        
        
        
        
        glUseProgram(program);
        
        m_GLSLAttributes.position = glGetAttribLocation(program, position);
        m_GLSLAttributes.color = glGetAttribLocation(program, sourceColor);
        m_GLSLAttributes.transformmatrix = glGetAttribLocation(program, transformmatrix);
        m_GLSLAttributes.normal = glGetAttribLocation(program, normal);
        for(int textureIndex = 0; textureIndex < TEXTURE_MAX; ++textureIndex)
            m_GLSLAttributes.textureCoord[textureIndex] = glGetAttribLocation(program, textureCoord[textureIndex]);
        
        m_GLSLUniforms.modelViewMatrix = glGetUniformLocation(program, modelViewMatrix);check_gl_error()
        m_GLSLUniforms.projectionMatrix = glGetUniformLocation(program, projectionMatrix);check_gl_error()
        m_GLSLUniforms.modelViewProjectionMatrix = glGetUniformLocation(program, modelViewProjectionMatrix);
        
        glEnableVertexAttribArray(m_GLSLAttributes.position);check_gl_error()
        glVertexAttribPointer(m_GLSLAttributes.position,
                              4, GL_FLOAT, GL_FALSE,
                              getStride(),
                              (const GLvoid*)getPositionOffset());check_gl_error()
        if(getColorOffset() &&
           -1 != m_GLSLAttributes.color)
        {
            glEnableVertexAttribArray(m_GLSLAttributes.color);check_gl_error()
            glVertexAttribPointer(m_GLSLAttributes.color,
                                  4, GL_FLOAT, GL_FALSE,
                                  getStride(),
                                  (const GLvoid*)getColorOffset());check_gl_error()
        }
        
        if(getNormalOffset() &&
           -1 != m_GLSLAttributes.normal)
        {
            glEnableVertexAttribArray(m_GLSLAttributes.normal);check_gl_error()
            glVertexAttribPointer(m_GLSLAttributes.normal,
                                  4, GL_FLOAT, GL_FALSE,
                                  getStride(),
                                  (const GLvoid*)getNormalOffset());check_gl_error()
        }
        
        for(int textureIndex = 0; textureIndex < m_NumTextures; ++textureIndex)
        {
            if(getTextureOffset(textureIndex) &&
               -1 != m_GLSLAttributes.textureCoord[textureIndex])
            {
                glEnableVertexAttribArray(m_GLSLAttributes.textureCoord[textureIndex]);check_gl_error()
                glVertexAttribPointer(m_GLSLAttributes.textureCoord[textureIndex], 2, GL_FLOAT, GL_FALSE,
                                      getStride(),
                                      (const GLvoid*)getTextureOffset(textureIndex));check_gl_error()
            }
        }
        
        
        
        
        glGenBuffers(1, &m_indexBuffer);check_gl_error()
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_indexBuffer);check_gl_error()
        glBufferData(GL_ELEMENT_ARRAY_BUFFER,
                     m_NumIndices * sizeof(indices[0]),
                     &indices[0],
                     GL_STATIC_DRAW);check_gl_error()
        
        
        m_ModelViewArray = new GLfloat[m_NumInstances * 16];
        
        memset(m_ModelViewArray, 0, m_NumInstances * 16 * sizeof(GLfloat));
        
        glGenBuffers(1, &m_modelviewBuffer);check_gl_error()
        glBindBuffer(GL_ARRAY_BUFFER, m_modelviewBuffer);check_gl_error()
        glBufferData(GL_ARRAY_BUFFER, m_NumInstances * 16 * sizeof(GLfloat), m_ModelViewArray, GL_STREAM_DRAW);check_gl_error()
        
        glEnableVertexAttribArray(m_GLSLAttributes.transformmatrix + 0);check_gl_error()
        glEnableVertexAttribArray(m_GLSLAttributes.transformmatrix + 1);check_gl_error()
        glEnableVertexAttribArray(m_GLSLAttributes.transformmatrix + 2);check_gl_error()
        glEnableVertexAttribArray(m_GLSLAttributes.transformmatrix + 3);check_gl_error()
        glVertexAttribPointer(m_GLSLAttributes.transformmatrix + 0, 4, GL_FLOAT, 0, 16 * sizeof(GLfloat), (GLvoid*)0);check_gl_error()
        glVertexAttribPointer(m_GLSLAttributes.transformmatrix + 1, 4, GL_FLOAT, 0, 16 * sizeof(GLfloat), (GLvoid*)16);check_gl_error()
        glVertexAttribPointer(m_GLSLAttributes.transformmatrix + 2, 4, GL_FLOAT, 0, 16 * sizeof(GLfloat), (GLvoid*)32);check_gl_error()
        glVertexAttribPointer(m_GLSLAttributes.transformmatrix + 3, 4, GL_FLOAT, 0, 16 * sizeof(GLfloat), (GLvoid*)48);check_gl_error()
        
        glVertexAttribDivisorEXT(m_GLSLAttributes.transformmatrix + 0, 1);
        glVertexAttribDivisorEXT(m_GLSLAttributes.transformmatrix + 1, 1);
        glVertexAttribDivisorEXT(m_GLSLAttributes.transformmatrix + 2, 1);
        glVertexAttribDivisorEXT(m_GLSLAttributes.transformmatrix + 3, 1);
        
        
        glUseProgram(0);
        
        ret = GL_TRUE;
        
#if defined(DEBUG) || defined (_DEBUG)
        glLabelObjectEXT(GL_VERTEX_ARRAY_OBJECT_EXT, m_vertexBuffer, 0, getName().c_str());
#endif
        
    }
    
    return ret;
}













template<class Function>
void VertexBufferObject::get_each_indice(Function fn)const
{
    unsigned char *ptr = NULL;
    void *p;
    GLushort indice = 0;
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_indexBuffer);
    
    glMapBufferOES( GL_ELEMENT_ARRAY_BUFFER, GL_WRITE_ONLY_OES );
    glGetBufferPointervOES( GL_ELEMENT_ARRAY_BUFFER, GL_BUFFER_MAP_POINTER_OES, &p );
    
    ptr = (unsigned char*)p;
    
    const size_t stride = sizeof(GLushort);
    for(int i = 0, idx = 0; i < (m_NumIndices * stride); i += stride, idx++)
    {
        memcpy(&indice, ptr + i, stride);
        fn(idx, indice);
    }

    glUnmapBufferOES( GL_ELEMENT_ARRAY_BUFFER );
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,0);
}

template<class Function, class AttributeType>
void VertexBufferObject::get_each_attribute(Function &fn, size_t offset)const
{
    unsigned char *ptr = NULL;
    void *p = NULL;
    AttributeType attribute;
    
    glBindBuffer(GL_ARRAY_BUFFER, m_vertexBuffer);
    
    glMapBufferOES( GL_ARRAY_BUFFER, GL_WRITE_ONLY_OES );
    glGetBufferPointervOES( GL_ARRAY_BUFFER, GL_BUFFER_MAP_POINTER_OES, &p );
    
    ptr = (unsigned char*)p;
    
    int idx = 0;
    for(int i = 0; i < (m_NumVertices * m_Stride); i+=m_Stride)
    {
        memcpy(&attribute, ptr + i + offset, sizeof(AttributeType));
        fn(idx++, attribute);
    }
    
    glUnmapBufferOES( GL_ARRAY_BUFFER );
    
    glBindBuffer(GL_ARRAY_BUFFER,0);
}

template<class Function>
void VertexBufferObject::get_each_triangle(Function fn)const
{
    unsigned char *ptr = NULL;
    void *p;
    btVector3 vertice[3];
    
    glBindBuffer(GL_ARRAY_BUFFER, m_vertexBuffer);
    
    glMapBufferOES( GL_ARRAY_BUFFER, GL_WRITE_ONLY_OES );
    glGetBufferPointervOES( GL_ARRAY_BUFFER, GL_BUFFER_MAP_POINTER_OES, &p );
    
    ptr = (unsigned char*)p;
    
    for(int i = 0; i < (m_NumVertices * m_Stride); i += (m_Stride * 3))
    {
        memcpy(&vertice[0], ptr + (i + (0 * (m_Stride))) + m_PositionOffset, sizeof(btVector3));
        memcpy(&vertice[1], ptr + (i + (1 * (m_Stride))) + m_PositionOffset, sizeof(btVector3));
        memcpy(&vertice[2], ptr + (i + (2 * (m_Stride))) + m_PositionOffset, sizeof(btVector3));
        fn(vertice[0], vertice[1], vertice[2]);
    }
    
    glUnmapBufferOES( GL_ARRAY_BUFFER );
    
    glBindBuffer(GL_ARRAY_BUFFER,0);
}

template<class Function, class AttributeType>
void VertexBufferObject::set_each_attribute(Function &fn, size_t offset)
{
    unsigned char *ptr = NULL;
    void *p = NULL;
    AttributeType attribute_from;
    AttributeType attribute_to;
    
    glBindBuffer(GL_ARRAY_BUFFER, m_vertexBuffer);
    
    glMapBufferOES( GL_ARRAY_BUFFER, GL_WRITE_ONLY_OES );
    glGetBufferPointervOES( GL_ARRAY_BUFFER, GL_BUFFER_MAP_POINTER_OES, &p );
    
    ptr = (unsigned char*)p;
    
    if(p)
    {
        int idx = 0;
        for(int i = 0; i < (m_NumVertices * m_Stride); i+=m_Stride)
        {
            memcpy(&attribute_from, ptr + i + offset, sizeof(AttributeType));
            fn(idx++, attribute_to, attribute_from);
            memcpy(ptr + i + offset, &attribute_to, sizeof(AttributeType));
        }
    }
    
    glUnmapBufferOES( GL_ARRAY_BUFFER );
    
    glBindBuffer(GL_ARRAY_BUFFER,0);
}

template<class Function>
void VertexBufferObject::set_each_triangle(Function fn)const
{
    unsigned char *ptr = NULL;
    void *p;
    btVector3 vertice[3];
    btVector3 normal[3];
    
    glBindBuffer(GL_ARRAY_BUFFER, m_vertexBuffer);
    
    glMapBufferOES( GL_ARRAY_BUFFER, GL_WRITE_ONLY_OES );
    glGetBufferPointervOES( GL_ARRAY_BUFFER, GL_BUFFER_MAP_POINTER_OES, &p );
    
    ptr = (unsigned char*)p;
    
    int idx = 0;
    for(int i = 0; i < (m_NumVertices * m_Stride); i += (m_Stride * 3))
    {
        memcpy(&vertice[0], ptr + (i + (0 * (m_Stride))) + m_PositionOffset, sizeof(btVector3));
        memcpy(&vertice[1], ptr + (i + (1 * (m_Stride))) + m_PositionOffset, sizeof(btVector3));
        memcpy(&vertice[2], ptr + (i + (2 * (m_Stride))) + m_PositionOffset, sizeof(btVector3));
        if(m_NormalOffset != 0)
        {
            memcpy(&normal[0], ptr + (i + (0 * (m_Stride))) + m_NormalOffset, sizeof(btVector3));
            memcpy(&normal[1], ptr + (i + (1 * (m_Stride))) + m_NormalOffset, sizeof(btVector3));
            memcpy(&normal[2], ptr + (i + (2 * (m_Stride))) + m_NormalOffset, sizeof(btVector3));
            
            fn(idx,
               &vertice[0], &vertice[1], &vertice[2],
               &normal[0], &normal[1], &normal[2]);
            
            memcpy(ptr + (i + (0 * (m_Stride))) + m_NormalOffset, &normal[0], sizeof(btVector3));
            memcpy(ptr + (i + (1 * (m_Stride))) + m_NormalOffset, &normal[1], sizeof(btVector3));
            memcpy(ptr + (i + (2 * (m_Stride))) + m_NormalOffset, &normal[2], sizeof(btVector3));
        }
        else
        {
            fn(idx,
               &vertice[0], &vertice[1], &vertice[2]);
        }
        
        
        memcpy(ptr + (i + (0 * (m_Stride))) + m_PositionOffset, &vertice[0], sizeof(btVector3));
        memcpy(ptr + (i + (1 * (m_Stride))) + m_PositionOffset, &vertice[1], sizeof(btVector3));
        memcpy(ptr + (i + (2 * (m_Stride))) + m_PositionOffset, &vertice[2], sizeof(btVector3));
        
        idx++;
    }
    
    glUnmapBufferOES( GL_ARRAY_BUFFER );
    
    glBindBuffer(GL_ARRAY_BUFFER,0);
}


template<class Function, class AttributeType>
void VertexBufferObject::get_attribute(unsigned int attribute_index, Function &fn, size_t offset)const
{
    unsigned char *ptr = NULL;
    void *p = NULL;
    AttributeType attribute;
    
    glBindBuffer(GL_ARRAY_BUFFER, m_vertexBuffer);
    
    glMapBufferOES( GL_ARRAY_BUFFER, GL_WRITE_ONLY_OES );
    glGetBufferPointervOES( GL_ARRAY_BUFFER, GL_BUFFER_MAP_POINTER_OES, &p );
    
    ptr = (unsigned char*)p;
    
    btAssert(attribute_index < (m_NumVertices * m_Stride));
    
    memcpy(&attribute, ptr + attribute_index + offset, sizeof(AttributeType));
    fn(attribute);
    
    glUnmapBufferOES( GL_ARRAY_BUFFER );
    
    glBindBuffer(GL_ARRAY_BUFFER,0);
}

template<class Function, class AttributeType>
void VertexBufferObject::set_attribute(unsigned int attribute_index, Function &fn, size_t offset)
{
    unsigned char *ptr = NULL;
    void *p = NULL;
    AttributeType attribute;
    
    glBindBuffer(GL_ARRAY_BUFFER, m_vertexBuffer);
    
    glMapBufferOES( GL_ARRAY_BUFFER, GL_WRITE_ONLY_OES );
    glGetBufferPointervOES( GL_ARRAY_BUFFER, GL_BUFFER_MAP_POINTER_OES, &p );
    
    ptr = (unsigned char*)p;
    
    btAssert(attribute_index < (m_NumVertices * m_Stride));
    
    memcpy(&attribute, ptr + attribute_index + offset, sizeof(AttributeType));
    fn(attribute, attribute);
    memcpy(ptr + attribute_index + offset, &attribute, sizeof(AttributeType));
    
    glUnmapBufferOES( GL_ARRAY_BUFFER );
    
    glBindVertexArrayOES(0);
}

#endif /* defined(__MazeADay__VertexBufferObject__) */
