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
    }m_GLSLUniforms;
    
    unsigned int m_NumTextures;
    unsigned int m_NumVertices;
    unsigned int m_NumIndices;

    GLuint m_vertexArrayBuffer;
    GLuint m_modelviewBuffer;
    GLuint m_vertexBuffer;
    GLuint m_indexBuffer;
    
    GLfloat *modelview;
    btAlignedObjectArray<IDType> m_BaseObjects;
    unsigned int m_NumInstances;
    
    GLboolean m_ShouldRender;
    
    IDType *m_MaterialFactoryIDs;
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
    
//    void loadGLSL(const IDType shaderFactoryID, const IDType materialFactoryID[TEXTURE_MAX]);
//    void loadGLSL(const IDType shaderFactoryID,
//                  const IDType materialFactoryID0,
//                  const IDType materialFactoryID1 = 0,
//                  const IDType materialFactoryID2 = 0,
//                  const IDType materialFactoryID3 = 0,
//                  const IDType materialFactoryID4 = 0,
//                  const IDType materialFactoryID5 = 0,
//                  const IDType materialFactoryID6 = 0,
//                  const IDType materialFactoryID7 = 0);
    
    
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
        
        glBindBuffer( GL_ARRAY_BUFFER, m_vertexBuffer );
        
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
        
        glBindBuffer( GL_ARRAY_BUFFER, m_vertexBuffer );
        
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
        
        glBindBuffer( GL_ARRAY_BUFFER, m_vertexBuffer );
        
        glUnmapBufferOES( GL_ARRAY_BUFFER );
        
        glBindBuffer(GL_ARRAY_BUFFER,0);
        glBindVertexArrayOES(0);
    }
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
//        std::string svertices("{ ");
//        for(size_t i = 0; i < vertices.size(); ++i)
//        {
//            VERTEX_ATTRIBUTE v = vertices[i];
//            std::string s = (std::string)v;
//            s+=",\n";
//            svertices += s;
//        }
//        svertices += " }";
//        printf("%s", svertices.c_str());
        
        btAlignedObjectArray<VERTEX_ATTRIBUTE> vertices_of_instances;
        btAlignedObjectArray<GLushort> indices_of_instances;
        
        m_NumInstances = num_instances;
        m_NumVertices = vertices.size();
        m_NumIndices = indices.size();
        
        indices_of_instances.resize(m_NumInstances * m_NumIndices);
        GLuint indexDelta = 0;
        for (int i = 0; i < m_NumInstances * m_NumIndices; i += m_NumIndices)
        {
            for(int j = 0; j < m_NumIndices; ++j)
            {
                indices_of_instances[i + j] = indices[j] + indexDelta;
            }
            indexDelta += m_NumVertices;
        }
        
        for(int i = 0; i < num_instances; ++i)
        {
            vertices_of_instances.concatFromArray(vertices);
        }
        
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
                     m_NumVertices * sizeof(vertices[0]) * m_NumInstances,
                     &vertices_of_instances[0],
                     GL_STATIC_DRAW);check_gl_error()
        
        m_ShaderFactoryID = shader_factory_id;
        
        GLuint program = ShaderFactory::getInstance()->get(m_ShaderFactoryID)->m_ShaderProgramHandle;
        
        const char *const textureCoord[]  =
        {
            "textureCoord0",
            "textureCoord1",
            "textureCoord2",
            "textureCoord3",
            "textureCoord4",
            "textureCoord5",
            "textureCoord6",
            "textureCoord7"
        };
        
        glUseProgram(program);
        
        m_GLSLAttributes.position = glGetAttribLocation(program, "position");
        m_GLSLAttributes.color = glGetAttribLocation(program, "sourceColor");
        m_GLSLAttributes.transformmatrix = glGetAttribLocation(program, "transformmatrix");
        m_GLSLAttributes.normal = glGetAttribLocation(program, "normal");
        for(int textureIndex = 0; textureIndex < TEXTURE_MAX; ++textureIndex)
            m_GLSLAttributes.textureCoord[textureIndex] = glGetAttribLocation(program, textureCoord[textureIndex]);
        
        m_GLSLUniforms.modelViewMatrix = glGetUniformLocation(program, "modelViewMatrix");check_gl_error()
        m_GLSLUniforms.projectionMatrix = glGetUniformLocation(program, "projectionMatrix");check_gl_error()
        
        for(int textureIndex = 0; textureIndex < m_NumTextures; ++textureIndex)
            if(getMaterial(textureIndex))
                getMaterial(textureIndex)->loadGLSL(this, textureIndex);
        
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
        
        modelview = new GLfloat[m_NumInstances * m_NumVertices * 16];
        
        const GLuint STRIDE = 64;
        
        btScalar identityTransform[] =
        {
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1,
        };
        for (int i = 0, offset = 0;
             i < m_NumInstances * m_NumVertices;
             i += m_NumVertices, offset += STRIDE)
        {
            for (int j = 0; j < m_NumVertices; j++)
            {
                memcpy(modelview + (offset + (16 * j)), identityTransform, sizeof(GLfloat) * 16);
            }
        }
        
        
        
        
        glGenBuffers(1, &m_modelviewBuffer);check_gl_error()
        glBindBuffer(GL_ARRAY_BUFFER, m_modelviewBuffer);check_gl_error()
        glBufferData(GL_ARRAY_BUFFER, m_NumInstances * m_NumVertices * 16 * sizeof(GLfloat), modelview, GL_STREAM_DRAW);check_gl_error()
        
        glEnableVertexAttribArray(m_GLSLAttributes.transformmatrix + 0);check_gl_error()
        glEnableVertexAttribArray(m_GLSLAttributes.transformmatrix + 1);check_gl_error()
        glEnableVertexAttribArray(m_GLSLAttributes.transformmatrix + 2);check_gl_error()
        glEnableVertexAttribArray(m_GLSLAttributes.transformmatrix + 3);check_gl_error()
        glVertexAttribPointer(m_GLSLAttributes.transformmatrix + 0, 4, GL_FLOAT, 0, STRIDE, (GLvoid*)0);check_gl_error()
        glVertexAttribPointer(m_GLSLAttributes.transformmatrix + 1, 4, GL_FLOAT, 0, STRIDE, (GLvoid*)16);check_gl_error()
        glVertexAttribPointer(m_GLSLAttributes.transformmatrix + 2, 4, GL_FLOAT, 0, STRIDE, (GLvoid*)32);check_gl_error()
        glVertexAttribPointer(m_GLSLAttributes.transformmatrix + 3, 4, GL_FLOAT, 0, STRIDE, (GLvoid*)48);check_gl_error()
        
        glVertexAttribDivisorEXT(m_GLSLAttributes.transformmatrix + 0, 1);
        glVertexAttribDivisorEXT(m_GLSLAttributes.transformmatrix + 1, 1);
        glVertexAttribDivisorEXT(m_GLSLAttributes.transformmatrix + 2, 1);
        glVertexAttribDivisorEXT(m_GLSLAttributes.transformmatrix + 3, 1);
        
        glGenBuffers(1, &m_indexBuffer);check_gl_error()
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_indexBuffer);check_gl_error()
        glBufferData(GL_ELEMENT_ARRAY_BUFFER,
                     m_NumInstances * m_NumIndices * sizeof(indices[0]),
                     &indices_of_instances[0],
                     GL_STATIC_DRAW);check_gl_error()
        
        glUseProgram(0);
        
        ret = GL_TRUE;
        
#if defined(DEBUG) || defined (_DEBUG)
        glLabelObjectEXT(GL_VERTEX_ARRAY_OBJECT_EXT, m_vertexBuffer, 0, getName().c_str());
#endif
        
    }
    
    return ret;
}

#endif /* defined(__MazeADay__VertexBufferObject__) */
