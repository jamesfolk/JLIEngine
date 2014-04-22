//
//  VertexBufferObject_OLD.h
//  MazeADay
//
//  Created by James Folk on 3/19/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#ifndef __MazeADay__VertexBufferObject__
#define __MazeADay__VertexBufferObject__

#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

#include "btAlignedObjectArray.h"
#include "btVector3.h"
#include "btTransform.h"
#include "btVector2.h"
#include "AbstractFactoryIncludes.h"
#include "AbstractFactory.h"
#include "ShaderFactory.h"
#include "VBOTransformQueue.h"
#include "VertexBufferObjectFactoryIncludes.h"

#include "VBOMaterial.h"


//class VertexBufferObjectInfo;
class BaseEntity;

#if defined(DEBUG) || defined (_DEBUG)
extern void _check_gl_error(const char *file, int line, const char *function);
#define check_gl_error() _check_gl_error(__FILE__,__LINE__,__FUNCTION__);
#else
#define check_gl_error() ;
#endif

//#define TEXTURE_MAX (8)
extern const unsigned int TEXTURE_MAX;



















class VertexBufferObject :
public AbstractFactoryObject
{
    struct AttributeHandles
    {
        AttributeHandles():
        transformmatrix(GL_INVALID_VALUE),
        position(GL_INVALID_VALUE),
        normal(GL_INVALID_VALUE),
        textureCoord(new GLint[TEXTURE_MAX]),
        color(GL_INVALID_VALUE)
        {}
        
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
        modelViewMatrix(GL_INVALID_VALUE),
        projectionMatrix(GL_INVALID_VALUE),
        modelMatrix(GL_INVALID_VALUE)
        {
        }
        
        
        GLuint modelViewMatrix;
        GLuint projectionMatrix;
        GLuint modelMatrix;
    }m_GLSLUniforms;
    
    GLuint m_NumTextures;
    GLuint m_NumVertices;
    GLuint m_NumIndices;
    
    GLuint m_VAO;
    GLuint m_VBO;
    GLuint m_IB;
    
    GLboolean m_ShouldRender;
    
    IDType *m_MaterialFactoryIDs;
    IDType m_ShaderFactoryID;
    
    GLsizei m_Stride;
    
    size_t m_PositionOffset;
    size_t m_WorldTransformOffset;
    size_t m_NormalOffset;
    size_t m_ColorOffset;
    size_t *m_TextureOffset;
    
    VBOTransformQueue *m_VBOTransformQueue;
    unsigned int m_MinNumberOfVertexBufferObjects;
    
    BaseEntity *temp;
private:
    typedef void (*vector2Func)(int i, btVector2 &to, const btVector2 &from);
    typedef void (*vector3Func)(int i, btVector3 &to, const btVector3 &from);
    typedef void (*vector4Func)(int i, btVector4 &to, const btVector4 &from);
    typedef void (*transformFunc)(int i, btTransform &to, const btTransform &from);
    
//    void updateGLBuffer_Internal(transformFunc worldTransform = NULL,
//                        vector3Func position = NULL,
//                        vector3Func normal = NULL,
//                        vector4Func color = NULL,
//                        vector2Func texture0 = NULL,
//                        vector2Func texture1 = NULL,
//                        vector2Func texture2 = NULL,
//                        vector2Func texture3 = NULL,
//                        vector2Func texture4 = NULL,
//                        vector2Func texture5 = NULL,
//                        vector2Func texture6 = NULL,
//                        vector2Func texture7 = NULL);
protected:
    virtual void updateGLBufferPosition(int i, btVector3 &to, const btVector3 &from);
    virtual void updateGLBufferWorldTransform(int i, btTransform &to, const btTransform &from);
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
    
    SIMD_FORCE_INLINE const size_t getWorldTransformOffset(const unsigned int row)const
    {
        /*
         glVertexAttribPointer(pos1, 4, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 4 * 4, (void*)(0));
         glVertexAttribPointer(pos2, 4, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 4 * 4, (void*)(sizeof(float) * 4));
         glVertexAttribPointer(pos3, 4, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 4 * 4, (void*)(sizeof(float) * 8));
         glVertexAttribPointer(pos4, 4, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 4 * 4, (void*)(sizeof(float) * 12));
         */
        return (m_WorldTransformOffset + (sizeof(float) * (row * 4)));
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
//        btAssert(index < m_NumTextures);
        
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

    void loadGLSL(const IDType shaderFactoryID, const IDType materialFactoryID[TEXTURE_MAX]);
    void loadGLSL(const IDType shaderFactoryID,
                  const IDType materialFactoryID0,
                  const IDType materialFactoryID1 = 0,
                  const IDType materialFactoryID2 = 0,
                  const IDType materialFactoryID3 = 0,
                  const IDType materialFactoryID4 = 0,
                  const IDType materialFactoryID5 = 0,
                  const IDType materialFactoryID6 = 0,
                  const IDType materialFactoryID7 = 0);
    
    
    template<class VERTEX_ATTRIBUTE>
    GLboolean loadGLBuffer(const btAlignedObjectArray<VERTEX_ATTRIBUTE> &vertices, GLenum array_usage,
                           const btAlignedObjectArray<GLushort> &indices, GLenum indice_usage);
    virtual GLboolean unLoadGLBuffer();
    virtual GLboolean isGLBufferLoaded()const;
    
//    template<
//    class WorldTransformFunction,
//    class PositionFunction,
//    class NormalFunction,
//    class ColorFunction,
//    class Texture0Function
//    >
//    void updateGLBuffer(WorldTransformFunction wtFunc,
//                        PositionFunction pFunc,
//                        NormalFunction nFunc,
//                        ColorFunction cFunc,
//                        Texture0Function t0Func)
//    {
//        this->updateGLBuffer(wtFunc, pFunc, nFunc, cFunc, t0Func);
//    }
    
//    void updateGLBuffer(bool worldTransform = true,
//                        bool position = false,
//                        bool normal = false,
//                        bool color = false,
//                        bool texture0 = false,
//                        bool texture1 = false,
//                        bool texture2 = false,
//                        bool texture3 = false,
//                        bool texture4 = false,
//                        bool texture5 = false,
//                        bool texture6 = false,
//                        bool texture7 = false)
//    {
//        this->updateGLBuffer_Internal((worldTransform)?&VertexBufferObject::updateGLBufferWorldTransform:NULL,
//                             (position)?&VertexBufferObject::updateGLBufferPosition:NULL,
//                             (normal)?&VertexBufferObject::updateGLBufferNormal:NULL,
//                             (color)?&VertexBufferObject::updateGLBufferColor:NULL,
//                             (texture0)?&VertexBufferObject::updateGLBufferTexture:NULL,
//                             (texture1)?&VertexBufferObject::updateGLBufferTexture:NULL,
//                             (texture2)?&VertexBufferObject::updateGLBufferTexture:NULL,
//                             (texture3)?&VertexBufferObject::updateGLBufferTexture:NULL,
//                             (texture4)?&VertexBufferObject::updateGLBufferTexture:NULL,
//                             (texture5)?&VertexBufferObject::updateGLBufferTexture:NULL,
//                             (texture6)?&VertexBufferObject::updateGLBufferTexture:NULL,
//                             (texture7)?&VertexBufferObject::updateGLBufferTexture:NULL);
//    }
    
    void updateGLBuffer();
    
    void updateGLBuffer(bool position,
                        bool normal,
                        bool color,
                        bool texture[TEXTURE_MAX]);
//                        bool texture0,
//                        bool texture1,
//                        bool texture2,
//                        bool texture3,
//                        bool texture4,
//                        bool texture5,
//                        bool texture6,
//                        bool texture7);
    
    void renderGLBuffer(GLenum drawmode);
    
    bool registerEntity(BaseEntity *entity);
    bool unRegisterEntity(BaseEntity *entity);
    
    void render(BaseEntity *entity);
    
    const VBOMaterial*	getMaterial(unsigned int index) const;
    VBOMaterial*	getMaterial(unsigned int index);
    
    btVector3 getHalfExtends() const;
    btTransform getInitialTransform() const;
    btScalar getBoundingRadius()const;
    bool hasAlphaTexture()const;
public:
    template<class Function, class AttributeType>
    void get_each_attribute(Function &fn, size_t offset)const
    {
        unsigned char *ptr = NULL;
        void *p = NULL;
        AttributeType attribute;
        
        glBindVertexArrayOES(m_VAO);
        glBindBuffer(GL_ARRAY_BUFFER, m_VBO);
        
        glMapBufferOES( GL_ARRAY_BUFFER, GL_WRITE_ONLY_OES );
        glGetBufferPointervOES( GL_ARRAY_BUFFER, GL_BUFFER_MAP_POINTER_OES, &p );
        
        ptr = (unsigned char*)p;
        
        int idx = 0;
        for(int i = 0; i < (m_NumVertices * m_Stride); i+=m_Stride)
        {
            memcpy(&attribute, ptr + i + offset, sizeof(AttributeType));
            fn(idx++, attribute);
        }
        
        glBindVertexArrayOES(m_VAO);
        glBindBuffer( GL_ARRAY_BUFFER, m_VBO );
        
        glUnmapBufferOES( GL_ARRAY_BUFFER );
        
        glBindBuffer(GL_ARRAY_BUFFER,0);
        glBindVertexArrayOES(0);
    }
    
    template<class Function>
    void get_each_triangle(Function fn)const
    {
        unsigned char *ptr = NULL;
        void *p;
        btVector3 vertice[3];
        
        glBindVertexArrayOES(m_VAO);
        glBindBuffer(GL_ARRAY_BUFFER, m_VBO);
        
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
        
        glBindVertexArrayOES(m_VAO);
        glBindBuffer( GL_ARRAY_BUFFER, m_VBO );
        
        glUnmapBufferOES( GL_ARRAY_BUFFER );
        
        glBindBuffer(GL_ARRAY_BUFFER,0);
        glBindVertexArrayOES(0);
    }
    
    template<class Function>
    void set_each_triangle(Function fn)const
    {
        unsigned char *ptr = NULL;
        void *p;
        btVector3 vertice[3];
        btVector3 normal[3];
        
        glBindVertexArrayOES(m_VAO);
        glBindBuffer(GL_ARRAY_BUFFER, m_VBO);
        
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
        
        glBindVertexArrayOES(m_VAO);
        glBindBuffer( GL_ARRAY_BUFFER, m_VBO );
        
        glUnmapBufferOES( GL_ARRAY_BUFFER );
        
        glBindBuffer(GL_ARRAY_BUFFER,0);
        glBindVertexArrayOES(0);
    }
};

template<class VERTEX_ATTRIBUTE>
GLboolean VertexBufferObject::loadGLBuffer(const btAlignedObjectArray<VERTEX_ATTRIBUTE> &vertices, GLenum array_usage,
                                           const btAlignedObjectArray<GLushort> &indices, GLenum indice_usage)
{
    GLboolean ret = GL_FALSE;
    
    unLoadGLBuffer();
    
    if(vertices.size() > 0)
    {
        unsigned long long int size = vertices.size();
        
        if (size < m_MinNumberOfVertexBufferObjects)
        {
#pragma mark THIS IS WHERE m_MinNumberOfVertexBufferObjects needs to fix
//            size = m_MinNumberOfVertexBufferObjects;
        }
        m_NumVertices = vertices.size();
        m_NumIndices = indices.size();
        
        m_Stride = VERTEX_ATTRIBUTE::getStride();
        
        m_PositionOffset = VERTEX_ATTRIBUTE::getPositionOffset();
        m_WorldTransformOffset = VERTEX_ATTRIBUTE::getWorldTransformOffset();
        m_NormalOffset = VERTEX_ATTRIBUTE::getNormalOffset();
        m_ColorOffset = VERTEX_ATTRIBUTE::getColorOffset();
        for(int textureIndex = 0; textureIndex < TEXTURE_MAX; ++textureIndex)
        {
            m_TextureOffset[textureIndex] = VERTEX_ATTRIBUTE::getTextureOffset(textureIndex);
        }
        
        m_VBOTransformQueue->init(m_NumVertices);
        
        glGenVertexArraysOES(1, &m_VAO);check_gl_error()
        glBindVertexArrayOES(m_VAO);check_gl_error()
        
        glGenBuffers(1, &m_VBO);check_gl_error()
        glBindBuffer(GL_ARRAY_BUFFER, m_VBO);check_gl_error()
        
        glBufferData(GL_ARRAY_BUFFER,
                     size * VERTEX_ATTRIBUTE::getStride(),
                     &vertices[0],
                     array_usage);check_gl_error()
        
        glBindBuffer(GL_ARRAY_BUFFER,0);check_gl_error()
        glBindVertexArrayOES(0);check_gl_error()
        
        ret = TRUE;
        
        if(m_NumIndices > 0)
        {
            glGenBuffers(1, &m_IB);check_gl_error()
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_IB);check_gl_error()
            glBufferData(GL_ELEMENT_ARRAY_BUFFER,
                         indices.size() * sizeof(indices[0]),
                         &indices[0],
                         indice_usage);check_gl_error()
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);check_gl_error()
        }
    }
    
    return ret;
}


#endif /* defined(__MazeADay__VertexBufferObject__) */
