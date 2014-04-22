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
#include "VBOTransformQueue.h"
#include "jliTransform.h"
#include "ShaderFactory.h"

#if defined(DEBUG) || defined (_DEBUG)
extern void _check_gl_error(const char *file, int line, const char *function);
#define check_gl_error() _check_gl_error(__FILE__,__LINE__,__FUNCTION__);
#else
#define check_gl_error() ;
#endif

extern const unsigned int TEXTURE_MAX;
extern const unsigned int MAX_INSTANCES;

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
        projectionMatrix(-1),
        modelMatrix(-1)
        {
        }
        
        
        GLuint modelViewMatrix;
        GLuint projectionMatrix;
        GLuint modelMatrix;
    }m_GLSLUniforms;
    
    unsigned int m_NumTextures;
    unsigned int m_NumVertices;
    unsigned int m_NumIndices;

    GLuint m_modelviewBuffer;
    GLuint m_vertexBuffer;
    GLuint m_indexBuffer;
    
    GLfloat *modelview;
    btAlignedObjectArray<IDType> m_BaseObjects;
    unsigned int m_NumInstances;
    
//    GLuint m_VAO;
//    GLuint m_VBO;
//    GLuint m_IB;
    
    GLboolean m_ShouldRender;
    
    IDType *m_MaterialFactoryIDs;
    IDType m_ShaderFactoryID;
    
    GLsizei m_Stride;
    
    size_t m_PositionOffset;
//    size_t m_WorldTransformOffset;
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

    void updateGLBuffer();
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
    
//    SIMD_FORCE_INLINE const size_t getWorldTransformOffset(const unsigned int row)const
//    {
//        return (m_WorldTransformOffset + (sizeof(float) * (row * 4)));
//    }
    
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
    GLboolean loadGLBuffer(const btAlignedObjectArray<VERTEX_ATTRIBUTE> &vertices,
                           const btAlignedObjectArray<GLushort> &indices,
                           IDType shader_factory_id,
                           const unsigned int num_instances = 1);
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

//enum eAttributes
//{
//	ATTRIB_POSITION,
//    ATTRIB_COLOR,
////    ATTRIB_NORMAL,
//	ATTRIB_TRANSFORMMATRIX,
////    ATTRIB_TEXTURE0,
////    ATTRIB_TEXTURE1,
////    ATTRIB_TEXTURE2,
////    ATTRIB_TEXTURE3,
////    ATTRIB_TEXTURE4,
////    ATTRIB_TEXTURE5,
////    ATTRIB_TEXTURE6,
////    ATTRIB_TEXTURE7,
//    NUM_ATTRIBUTES
//};

template<class VERTEX_ATTRIBUTE>
GLboolean VertexBufferObject::loadGLBuffer(const btAlignedObjectArray<VERTEX_ATTRIBUTE> &vertices,
                                           const btAlignedObjectArray<GLushort> &indices,
                                           IDType shader_factory_id,
                                           const unsigned int num_instances)
{
    GLboolean ret = GL_FALSE;
    
    m_ShaderFactoryID = shader_factory_id;
    
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
    
    m_GLSLAttributes.position = glGetAttribLocation(program, "position");
    m_GLSLAttributes.color = glGetAttribLocation(program, "sourceColor");
    m_GLSLAttributes.transformmatrix = glGetAttribLocation(program, "transformmatrix");
    
    m_GLSLUniforms.modelViewMatrix = glGetUniformLocation(program, "modelViewMatrix");check_gl_error()
    m_GLSLUniforms.projectionMatrix = glGetUniformLocation(program, "projectionMatrix");check_gl_error()
//    m_GLSLUniforms.modelMatrix = glGetUniformLocation(program, "modelMatrix");check_gl_error();
    
    
    glGenBuffers(1, &m_vertexBuffer);check_gl_error()
	glBindBuffer(GL_ARRAY_BUFFER, m_vertexBuffer);check_gl_error()
    glBufferData(GL_ARRAY_BUFFER,
                 m_NumVertices * sizeof(vertices[0]),
                 &vertices[0],
                 GL_STATIC_DRAW);check_gl_error()
    
    glEnableVertexAttribArray(m_GLSLAttributes.position);check_gl_error()
    glVertexAttribPointer(m_GLSLAttributes.position,
                          4, GL_FLOAT, GL_FALSE,
                          getStride(),
                          (const GLvoid*)getPositionOffset());check_gl_error()
	
    
    if(getColorOffset())
    {
        glEnableVertexAttribArray(m_GLSLAttributes.color);check_gl_error()
        glVertexAttribPointer(m_GLSLAttributes.color,
                              4, GL_FLOAT, GL_FALSE,
                              getStride(),
                              (const GLvoid*)getColorOffset());check_gl_error()
    }
    
//    if(getNormalOffset())
//    {
//        glEnableVertexAttribArray(ATTRIB_NORMAL);check_gl_error()
//        glVertexAttribPointer(ATTRIB_NORMAL,
//                              4, GL_FLOAT, GL_FALSE,
//                              getStride(),
//                              (const GLvoid*)getNormalOffset());check_gl_error()
//    }
    
//    if(getTextureOffset(0))
//    {
//        glEnableVertexAttribArray(ATTRIB_TEXTURE0);check_gl_error()
//        glVertexAttribPointer(ATTRIB_TEXTURE0, 2, GL_FLOAT, GL_FALSE,
//                              getStride(),
//                              (const GLvoid*)getTextureOffset(0));check_gl_error()
//    }
	
    modelview = new GLfloat[m_NumInstances * m_NumVertices * 16];
    
    GLfloat m = std::numeric_limits<GLfloat>::max();
    static const GLfloat identityMatrix[] =
    {
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        m, m, m, 1,
    };
    
    for (int i = 0; i < m_NumInstances * m_NumVertices * 16; i += 16)
	{
		memcpy(&modelview[i], identityMatrix, sizeof(identityMatrix));
	}
	
	glGenBuffers(1, &m_modelviewBuffer);check_gl_error()
	glBindBuffer(GL_ARRAY_BUFFER, m_modelviewBuffer);check_gl_error()
	glBufferData(GL_ARRAY_BUFFER, m_NumInstances * m_NumVertices * sizeof(modelview[0]), modelview, GL_STREAM_DRAW);check_gl_error()
    
	glGenBuffers(1, &m_indexBuffer);check_gl_error()
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_indexBuffer);check_gl_error()
	glBufferData(GL_ELEMENT_ARRAY_BUFFER,
                 m_NumIndices * sizeof(indices[0]),
                 &indices[0],
                 GL_DYNAMIC_DRAW);check_gl_error()
    
    
    
    
    
//    GLboolean ret = GL_FALSE;
//    
//    unLoadGLBuffer();
//    
//    if(vertices.size() > 0)
//    {
//        m_NumInstances = num_instances;
//        m_NumVertices = vertices.size();
//        m_NumIndices = indices.size();
//        
//        m_Stride = VERTEX_ATTRIBUTE::getStride();
//        
//        m_PositionOffset = VERTEX_ATTRIBUTE::getPositionOffset();
//        m_NormalOffset = VERTEX_ATTRIBUTE::getNormalOffset();
//        m_ColorOffset = VERTEX_ATTRIBUTE::getColorOffset();
//
//        m_NumTextures = 0;
//        for(int textureIndex = 0; textureIndex < TEXTURE_MAX; ++textureIndex)
//        {
//            m_TextureOffset[textureIndex] = VERTEX_ATTRIBUTE::getTextureOffset(textureIndex);
//            if(hasTextureAttribute(textureIndex))
//                ++m_NumTextures;
//        }
//
//        glGenBuffers(1, &m_vertexBuffer);check_gl_error()
//        glBindBuffer(GL_ARRAY_BUFFER, m_vertexBuffer);check_gl_error()
//        glBufferData(GL_ARRAY_BUFFER,
//                     m_NumVertices * sizeof(vertices[0]),
//                     &vertices[0],
//                     GL_STATIC_DRAW);check_gl_error()
//        
//
//        
//        GLfloat max = std::numeric_limits<GLfloat>::max();
//        static const GLfloat identityMatrix[] =
//        {
//            1, 0, 0, 0,
//            0, 1, 0, 0,
//            0, 0, 1, 0,
//            max, max, max, 1,
//        };
//        
//        modelview = new GLfloat[m_NumInstances * m_NumVertices * 16];
//        
//        for (int i = 0; i < m_NumInstances * m_NumVertices * 16; i += 16)
//        {
//            memcpy(&modelview[i], identityMatrix, sizeof(identityMatrix));
//        }
//        
//        glGenBuffers(1, &m_modelViewBuffer);check_gl_error()
//        glBindBuffer(GL_ARRAY_BUFFER, m_modelViewBuffer);check_gl_error()
//        glBufferData(GL_ARRAY_BUFFER, sizeof(modelview), modelview, GL_STREAM_DRAW);check_gl_error()
//        
//        if(m_NumIndices > 0)
//        {
//            glGenBuffers(1, &m_indexBuffer);check_gl_error()
//            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_indexBuffer);check_gl_error()
//            glBufferData(GL_ELEMENT_ARRAY_BUFFER,
//                         m_NumIndices * sizeof(indices[0]),
//                         &indices[0],
//                         GL_DYNAMIC_DRAW);check_gl_error()
//        }
//        
//#if defined(DEBUG) || defined (_DEBUG)
//        glLabelObjectEXT(GL_VERTEX_ARRAY_OBJECT_EXT, m_vertexBuffer, 0, getName().c_str());
//#endif
//        ret = GL_TRUE;
//    }
    
    return ret;
}

#endif /* defined(__MazeADay__VertexBufferObject__) */
