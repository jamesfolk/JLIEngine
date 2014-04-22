//
//  VertexBufferObject_OLD.cpp
//  MazeADay
//
//  Created by James Folk on 3/19/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#include "VertexBufferObject_OLD.h"
#include "BaseEntity.h"

#include "VertexBufferObjectFactoryIncludes.h"

#include <string>

#include "VBOMaterialFactory.h"
#include "VBOMaterialFactoryIncludes.h"

#include "ZipFileResourceLoader.h"

#include "CameraFactory.h"
#include "BaseCamera.h"

const unsigned int TEXTURE_MAX = 8;

#if defined(DEBUG) || defined (_DEBUG)
void _check_gl_error(const char *file, int line, const char *function)
{
    GLenum err (glGetError());
    
    while(err!=GL_NO_ERROR) {
        std::string error;
        
        switch(err) {
            case GL_INVALID_OPERATION:
                error="INVALID_OPERATION";
                break;
            case GL_INVALID_ENUM:           error="INVALID_ENUM";           break;
            case GL_INVALID_VALUE:          error="INVALID_VALUE";          break;
            case GL_OUT_OF_MEMORY:          error="OUT_OF_MEMORY";          break;
            case GL_INVALID_FRAMEBUFFER_OPERATION:  error="INVALID_FRAMEBUFFER_OPERATION";  break;
        }
        
        NSLog(@"\nGL_%s\n\t%s\n\t%d\n\t%s\n\n", error.c_str(), file, line, function);
        err=glGetError();
    }
}

//void VertexBufferObject::updateGLBuffer_Internal(transformFunc worldTransform,
//                                vector3Func position,
//                                vector3Func normal,
//                                vector4Func color,
//                                vector2Func texture0,
//                                vector2Func texture1,
//                                vector2Func texture2,
//                                vector2Func texture3,
//                                vector2Func texture4,
//                                vector2Func texture5,
//                                vector2Func texture6,
//                                vector2Func texture7)
//{
//    btAssert(isGLBufferLoaded());
//    
//    unsigned char *ptr = NULL;
//    void *p = NULL;
//    
//    glBindVertexArrayOES(m_VAO);
//    glBindBuffer(GL_ARRAY_BUFFER, m_VBO);
//    
//    glMapBufferOES( GL_ARRAY_BUFFER, GL_WRITE_ONLY_OES );
//    glGetBufferPointervOES( GL_ARRAY_BUFFER, GL_BUFFER_MAP_POINTER_OES, &p );
//    
//    ptr = (unsigned char*)p;
//    
//    if(p)
//    {
//        int idx = 0;
//        for(int i = 0; i < (m_NumVertices * m_Stride); i+=m_Stride)
//        {
//            if(NULL != worldTransform)
//            {
//                GLsizeiptr offset = getWorldTransformOffset(0);
//                btTransform attribute_from;
//                btTransform attribute_to;
//                memcpy(&attribute_from, ptr + i + offset, sizeof(btTransform));
//                worldTransform(idx, attribute_to, attribute_from);
//                memcpy(ptr + i + offset, &attribute_to, sizeof(btTransform));
//            }
//            
//            if(NULL != position)
//            {
//                GLsizeiptr offset = m_PositionOffset;
//                btVector3 attribute_from;
//                btVector3 attribute_to;
//                memcpy(&attribute_from, ptr + i + offset, sizeof(btVector3));
//                position(idx, attribute_to, attribute_from);
//                memcpy(ptr + i + offset, &attribute_to, sizeof(btVector3));
//            }
//            
//            if(hasNormalAttribute() && NULL != normal)
//            {
//                GLsizeiptr offset = m_NormalOffset;
//                btVector3 attribute_from;
//                btVector3 attribute_to;
//                memcpy(&attribute_from, ptr + i + offset, sizeof(btVector3));
//                normal(idx, attribute_to, attribute_from);
//                memcpy(ptr + i + offset, &attribute_to, sizeof(btVector3));
//            }
//            
//            if(hasColorAttribute() && NULL != color)
//            {
//                GLsizeiptr offset = m_ColorOffset;
//                btVector4 attribute_from;
//                btVector4 attribute_to;
//                memcpy(&attribute_from, ptr + i + offset, sizeof(btVector4));
//                color(idx, attribute_to, attribute_from);
//                memcpy(ptr + i + offset, &attribute_to, sizeof(btVector4));
//            }
//            
//            if(NULL != texture0)
//            {
//                if(hasTextureAttribute(0))
//                {
//                    GLsizeiptr offset = m_TextureOffset[0];
//                    btVector2 attribute_from;
//                    btVector2 attribute_to;
//                    memcpy(&attribute_from, ptr + i + offset, sizeof(btVector2));
//                    texture0(idx, attribute_to, attribute_from);
//                    memcpy(ptr + i + offset, &attribute_to, sizeof(btVector2));
//                }
//                
//                if(hasTextureAttribute(1))
//                {
//                    GLsizeiptr offset = m_TextureOffset[1];
//                    btVector2 attribute_from;
//                    btVector2 attribute_to;
//                    memcpy(&attribute_from, ptr + i + offset, sizeof(btVector2));
//                    texture1(idx, attribute_to, attribute_from);
//                    memcpy(ptr + i + offset, &attribute_to, sizeof(btVector2));
//                }
//                
//                if(hasTextureAttribute(2))
//                {
//                    GLsizeiptr offset = m_TextureOffset[2];
//                    btVector2 attribute_from;
//                    btVector2 attribute_to;
//                    memcpy(&attribute_from, ptr + i + offset, sizeof(btVector2));
//                    texture2(idx, attribute_to, attribute_from);
//                    memcpy(ptr + i + offset, &attribute_to, sizeof(btVector2));
//                }
//                
//                if(hasTextureAttribute(3))
//                {
//                    GLsizeiptr offset = m_TextureOffset[3];
//                    btVector2 attribute_from;
//                    btVector2 attribute_to;
//                    memcpy(&attribute_from, ptr + i + offset, sizeof(btVector2));
//                    texture3(idx, attribute_to, attribute_from);
//                    memcpy(ptr + i + offset, &attribute_to, sizeof(btVector2));
//                }
//                
//                if(hasTextureAttribute(4))
//                {
//                    GLsizeiptr offset = m_TextureOffset[4];
//                    btVector2 attribute_from;
//                    btVector2 attribute_to;
//                    memcpy(&attribute_from, ptr + i + offset, sizeof(btVector2));
//                    texture4(idx, attribute_to, attribute_from);
//                    memcpy(ptr + i + offset, &attribute_to, sizeof(btVector2));
//                }
//                
//                if(hasTextureAttribute(5))
//                {
//                    GLsizeiptr offset = m_TextureOffset[5];
//                    btVector2 attribute_from;
//                    btVector2 attribute_to;
//                    memcpy(&attribute_from, ptr + i + offset, sizeof(btVector2));
//                    texture5(idx, attribute_to, attribute_from);
//                    memcpy(ptr + i + offset, &attribute_to, sizeof(btVector2));
//                }
//                
//                if(hasTextureAttribute(6))
//                {
//                    GLsizeiptr offset = m_TextureOffset[6];
//                    btVector2 attribute_from;
//                    btVector2 attribute_to;
//                    memcpy(&attribute_from, ptr + i + offset, sizeof(btVector2));
//                    texture6(idx, attribute_to, attribute_from);
//                    memcpy(ptr + i + offset, &attribute_to, sizeof(btVector2));
//                }
//                
//                if(hasTextureAttribute(7))
//                {
//                    GLsizeiptr offset = m_TextureOffset[7];
//                    btVector2 attribute_from;
//                    btVector2 attribute_to;
//                    memcpy(&attribute_from, ptr + i + offset, sizeof(btVector2));
//                    texture7(idx, attribute_to, attribute_from);
//                    memcpy(ptr + i + offset, &attribute_to, sizeof(btVector2));
//                }
//            }
//            
//            ++idx;
//        }
//    }
//    
//    glBindVertexArrayOES(m_VAO);
//    glBindBuffer( GL_ARRAY_BUFFER, m_VBO );
//    
//    glUnmapBufferOES( GL_ARRAY_BUFFER );
//    
//    glBindBuffer(GL_ARRAY_BUFFER,0);
//    glBindVertexArrayOES(0);
//}

void VertexBufferObject::updateGLBufferPosition(int i, btVector3 &to, const btVector3 &from)
{
    
}
void VertexBufferObject::updateGLBufferWorldTransform(int i, btTransform &to, const btTransform &from)
{
    to = (*m_VBOTransformQueue)[i];
}

VertexBufferObject::VertexBufferObject():
m_NumTextures(0),
m_NumVertices(0),
m_NumIndices(0),
m_VAO(0),
m_VBO(0),
m_IB(0),
m_ShouldRender(GL_FALSE),
m_MaterialFactoryIDs(new IDType[TEXTURE_MAX]),
m_ShaderFactoryID(0),
m_Stride(0),
m_PositionOffset(0),
m_WorldTransformOffset(0),
m_NormalOffset(0),
m_ColorOffset(0),
m_TextureOffset(new size_t[TEXTURE_MAX]),
m_VBOTransformQueue(new VBOTransformQueue()),
m_MinNumberOfVertexBufferObjects(100)
{
    memset(m_MaterialFactoryIDs, 0, sizeof(IDType) * TEXTURE_MAX);
    memset(m_TextureOffset, 0, sizeof(GLsizei) * TEXTURE_MAX);
    
    char buffer[32];
    sprintf(buffer, "%lld", getID());
    setName("NO NAME " + std::string(buffer));
}

VertexBufferObject::VertexBufferObject(const VertexBufferObject &rhs):
m_NumTextures(rhs.m_NumTextures),
m_NumVertices(rhs.m_NumVertices),
m_NumIndices(rhs.m_NumIndices),
m_VAO(0),
m_VBO(0),
m_IB(0),
m_ShouldRender(GL_FALSE),
m_MaterialFactoryIDs(new IDType[TEXTURE_MAX]),
m_ShaderFactoryID(0),
m_Stride(rhs.m_Stride),
m_PositionOffset(rhs.m_PositionOffset),
m_WorldTransformOffset(rhs.m_WorldTransformOffset),
m_NormalOffset(rhs.m_NormalOffset),
m_ColorOffset(rhs.m_ColorOffset),
m_TextureOffset(new size_t[TEXTURE_MAX]),
m_VBOTransformQueue(new VBOTransformQueue()),
m_MinNumberOfVertexBufferObjects(100)
{
    memcpy(m_MaterialFactoryIDs, rhs.m_MaterialFactoryIDs, sizeof(IDType) * TEXTURE_MAX);
    memcpy(m_TextureOffset, rhs.m_TextureOffset, sizeof(size_t) * TEXTURE_MAX);
    
    char buffer[32];
    sprintf(buffer, "%lld", getID());
    setName(rhs.getName() + " copy - " + std::string(buffer));
}

VertexBufferObject::VertexBufferObject(const VertexBufferObjectInfo &info):
m_NumTextures(0),
m_NumVertices(0),
m_NumIndices(0),
m_VAO(0),
m_VBO(0),
m_IB(0),
m_ShouldRender(GL_FALSE),
m_MaterialFactoryIDs(new IDType[TEXTURE_MAX]),
m_ShaderFactoryID(0),
m_Stride(0),
m_PositionOffset(0),
m_WorldTransformOffset(0),
m_NormalOffset(0),
m_ColorOffset(0),
m_TextureOffset(new size_t[TEXTURE_MAX]),
m_VBOTransformQueue(new VBOTransformQueue()),
m_MinNumberOfVertexBufferObjects(info.m_MinNumberOfVertexBufferObjects)
{
    setName(info.m_viewObjectName);
}

VertexBufferObject::~VertexBufferObject()
{
    unLoadGLBuffer();
    
    delete m_VBOTransformQueue;
    m_VBOTransformQueue = NULL;
    
    delete [] m_TextureOffset;
    m_TextureOffset = NULL;
    
    delete [] m_MaterialFactoryIDs;
    m_MaterialFactoryIDs = NULL;
}

VertexBufferObject &VertexBufferObject::operator=(const VertexBufferObject &rhs)
{
    if(this != &rhs)
    {
        delete m_VBOTransformQueue;
        
        m_VBOTransformQueue = new VBOTransformQueue();
        
        m_NumTextures = rhs.m_NumTextures;
        m_NumVertices = rhs.m_NumVertices;
        m_NumIndices = rhs.m_NumIndices;
        
        m_VAO = 0;
        m_VBO = 0;
        m_IB = 0;
        m_ShouldRender = GL_FALSE;
        memcpy(m_MaterialFactoryIDs, rhs.m_MaterialFactoryIDs, sizeof(IDType) * TEXTURE_MAX);

        m_ShaderFactoryID = 0;
        m_Stride = rhs.m_Stride;
        m_PositionOffset = rhs.m_PositionOffset;
        m_WorldTransformOffset = rhs.m_WorldTransformOffset;
        m_NormalOffset = rhs.m_NormalOffset;
        m_ColorOffset = rhs.m_ColorOffset;
        
        memcpy(m_TextureOffset, rhs.m_TextureOffset, sizeof(size_t) * TEXTURE_MAX);
    }
    return *this;
}

void VertexBufferObject::loadGLSL(const IDType shaderFactoryID, const IDType materialFactoryID[TEXTURE_MAX])
{
    loadGLSL(shaderFactoryID,
             materialFactoryID[0],
             materialFactoryID[1],
             materialFactoryID[2],
             materialFactoryID[3],
             materialFactoryID[4],
             materialFactoryID[5],
             materialFactoryID[6],
             materialFactoryID[7]);
}


void VertexBufferObject::loadGLSL(const IDType shaderFactoryID,
                                  const IDType materialFactoryID0,
                                  const IDType materialFactoryID1,
                                  const IDType materialFactoryID2,
                                  const IDType materialFactoryID3,
                                  const IDType materialFactoryID4,
                                  const IDType materialFactoryID5,
                                  const IDType materialFactoryID6,
                                  const IDType materialFactoryID7)
{
    m_ShaderFactoryID = shaderFactoryID;
    
    m_MaterialFactoryIDs[0] = materialFactoryID0;
    m_MaterialFactoryIDs[1] = materialFactoryID1;
    m_MaterialFactoryIDs[2] = materialFactoryID2;
    m_MaterialFactoryIDs[3] = materialFactoryID3;
    m_MaterialFactoryIDs[4] = materialFactoryID4;
    m_MaterialFactoryIDs[5] = materialFactoryID5;
    m_MaterialFactoryIDs[6] = materialFactoryID6;
    m_MaterialFactoryIDs[7] = materialFactoryID7;
    
//    memcpy(m_MaterialFactoryIDs, materialFactoryID, sizeof(IDType) * TEXTURE_MAX);
    
    GLuint programHandle = ShaderFactory::getInstance()->get(m_ShaderFactoryID)->m_ShaderProgramHandle;//get this from shaderfactorid
//    const char *transformMatrix = "transformmatrix"; //get this from materialFactoryID
//    const char *position = "position"; //get this from materialFactoryID
//    const char *color = "color"; //get this from materialFactoryID
    const char *normal = "normal"; //get this from materialFactoryID
    const char *const textureCoord[]  = //get this from materialFactoryID
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
    
    
    if(programHandle > 0 &&
       isGLBufferLoaded())
    {
        
        m_NumTextures = 0;
        for(int i = 0; i < TEXTURE_MAX; i++)
        {
            if(hasTextureAttribute(i))
            {
                ++m_NumTextures;
            }
        }
        
        glUseProgram(programHandle);
        
        
        m_GLSLUniforms.modelViewMatrix = glGetUniformLocation(programHandle, "modelViewMatrix");check_gl_error()
        m_GLSLUniforms.projectionMatrix = glGetUniformLocation(programHandle, "projectionMatrix");check_gl_error()
        m_GLSLUniforms.modelMatrix = glGetUniformLocation(programHandle, "modelMatrix");check_gl_error();
        
        for(int textureIndex = 0; textureIndex < m_NumTextures; ++textureIndex)
        {
            if(hasTextureAttribute(textureIndex))
            {
                getMaterial(textureIndex)->loadGLSL(this, textureIndex);
            }
        }
        
        
        
        m_GLSLAttributes.position = glGetAttribLocation(programHandle, "position");check_gl_error()
        if(m_GLSLAttributes.position != -1)
        {
            glEnableVertexAttribArray(m_GLSLAttributes.position);check_gl_error()
            glVertexAttribPointer(m_GLSLAttributes.position, 4, GL_FLOAT, GL_FALSE,
                                  getStride(),
                                  (const GLvoid*)getPositionOffset());check_gl_error()
        }
        
        if(hasColorAttribute())
        {
            m_GLSLAttributes.color = glGetAttribLocation(programHandle, "color");check_gl_error()
            if(m_GLSLAttributes.color != -1)
            {
                glEnableVertexAttribArray(m_GLSLAttributes.color);check_gl_error()
                glVertexAttribPointer(m_GLSLAttributes.color, 4, GL_FLOAT, GL_FALSE,
                                      getStride(),
                                      (const GLvoid*)getColorOffset());check_gl_error()
            }
        }
        
        if(hasNormalAttribute())
        {
            m_GLSLAttributes.normal = glGetAttribLocation(programHandle, "normal");check_gl_error()
            if(m_GLSLAttributes.normal != -1)
            {
                glEnableVertexAttribArray(m_GLSLAttributes.normal);check_gl_error()
                glVertexAttribPointer(m_GLSLAttributes.normal, 4, GL_FLOAT, GL_FALSE,
                                      getStride(),
                                      (const GLvoid*)getNormalOffset());check_gl_error()
            }
        }
        
        for(int i = 0; i < m_NumTextures; i++)
        {
            if(hasTextureAttribute(i))
            {
                m_GLSLAttributes.textureCoord[i] = glGetAttribLocation(programHandle, textureCoord[i]);check_gl_error()
                if(m_GLSLAttributes.textureCoord[i] != -1)
                {
                    glEnableVertexAttribArray(m_GLSLAttributes.textureCoord[i]);check_gl_error()
                    glVertexAttribPointer(m_GLSLAttributes.textureCoord[i], 2, GL_FLOAT, GL_FALSE,
                                          getStride(),
                                          (const GLvoid*)getTextureOffset(i));check_gl_error()
                }
            }
        }
        
        m_GLSLAttributes.transformmatrix = glGetAttribLocation(programHandle, "transformMatrix");
        if(m_GLSLAttributes.transformmatrix != -1)
        {
            int pos1 = m_GLSLAttributes.transformmatrix + 0;
            int pos2 = m_GLSLAttributes.transformmatrix + 1;
            int pos3 = m_GLSLAttributes.transformmatrix + 2;
            int pos4 = m_GLSLAttributes.transformmatrix + 3;
            
            glEnableVertexAttribArray(pos1);
            glEnableVertexAttribArray(pos2);
            glEnableVertexAttribArray(pos3);
            glEnableVertexAttribArray(pos4);
            
            glVertexAttribPointer(pos1, 4, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 4 * 4, (const GLvoid*)getWorldTransformOffset(0));
            glVertexAttribPointer(pos2, 4, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 4 * 4, (const GLvoid*)getWorldTransformOffset(1));
            glVertexAttribPointer(pos3, 4, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 4 * 4, (const GLvoid*)getWorldTransformOffset(2));
            glVertexAttribPointer(pos4, 4, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 4 * 4, (const GLvoid*)getWorldTransformOffset(3));
            
//            glVertexAttribPointer(pos1, 4, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 4 * 4, (void*)(0));
//            glVertexAttribPointer(pos2, 4, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 4 * 4, (void*)(sizeof(float) * 4));
//            glVertexAttribPointer(pos3, 4, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 4 * 4, (void*)(sizeof(float) * 8));
//            glVertexAttribPointer(pos4, 4, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 4 * 4, (void*)(sizeof(float) * 12));
        
            
            glVertexAttribDivisorEXT(pos1, 1);
            glVertexAttribDivisorEXT(pos2, 1);
            glVertexAttribDivisorEXT(pos3, 1);
            glVertexAttribDivisorEXT(pos4, 1);
        }
        
        glUseProgram(0);
    }
}


GLboolean VertexBufferObject::unLoadGLBuffer()
{
    m_VBOTransformQueue->unInit();
    
    if(0 != m_IB)
    {
        glDeleteBuffers(1, &m_IB);check_gl_error()
        m_IB = 0;
    }
    
    if(0 != m_VBO)
    {
        glDeleteBuffers(1, &m_VBO);check_gl_error()
        m_VBO = 0;
    }
    
    if(0 != m_VAO)
    {
        glDeleteVertexArraysOES(1, &m_VAO);check_gl_error()
        m_VAO = 0;
    }
    
    return ((m_VAO == 0) && (m_VBO == 0));
}

GLboolean VertexBufferObject::isGLBufferLoaded()const
{
    return !((m_VAO == 0) && (m_VBO == 0));
}

void VertexBufferObject::updateGLBuffer()
{
    btAssert(isGLBufferLoaded());
    
    unsigned char *ptr = NULL;
    void *p = NULL;
    
    glBindVertexArrayOES(m_VAO);
    glBindBuffer(GL_ARRAY_BUFFER, m_VBO);
    
    glMapBufferOES( GL_ARRAY_BUFFER, GL_WRITE_ONLY_OES );
    glGetBufferPointervOES( GL_ARRAY_BUFFER, GL_BUFFER_MAP_POINTER_OES, &p );
    
    ptr = (unsigned char*)p;
    
    if(p)
    {
        int idx = 0;
        for(int i = 0; i < (m_NumVertices * m_Stride); i+=m_Stride)
        {
            GLsizeiptr offset = getWorldTransformOffset(0);
            btTransform attribute_from;
            btTransform attribute_to;
            memcpy(&attribute_from, ptr + i + offset, sizeof(btTransform));
            updateGLBufferWorldTransform(idx, attribute_to, attribute_from);
            memcpy(ptr + i + offset, &attribute_to, sizeof(btTransform));
            
            ++idx;
        }
    }
    
    glBindVertexArrayOES(m_VAO);
    glBindBuffer( GL_ARRAY_BUFFER, m_VBO );
    
    glUnmapBufferOES( GL_ARRAY_BUFFER );
    
    glBindBuffer(GL_ARRAY_BUFFER,0);
    glBindVertexArrayOES(0);
}

void VertexBufferObject::updateGLBuffer(bool position,
                                        bool normal,
                                        bool color,
                                        bool texture[TEXTURE_MAX])
{
    btAssert(isGLBufferLoaded());
    
    unsigned char *ptr = NULL;
    void *p = NULL;
    
    glBindVertexArrayOES(m_VAO);
    glBindBuffer(GL_ARRAY_BUFFER, m_VBO);
    
    glMapBufferOES( GL_ARRAY_BUFFER, GL_WRITE_ONLY_OES );
    glGetBufferPointervOES( GL_ARRAY_BUFFER, GL_BUFFER_MAP_POINTER_OES, &p );
    
    ptr = (unsigned char*)p;
    
    if(p)
    {
        int idx = 0;
        for(int i = 0; i < (m_NumVertices * m_Stride); i+=m_Stride)
        {
            GLsizeiptr offset = getWorldTransformOffset(0);
            btTransform attribute_from;
            btTransform attribute_to;
            memcpy(&attribute_from, ptr + i + offset, sizeof(btTransform));
            updateGLBufferWorldTransform(idx, attribute_to, attribute_from);
            memcpy(ptr + i + offset, &attribute_to, sizeof(btTransform));
            
            if(position)
            {
                GLsizeiptr offset = m_PositionOffset;
                btVector3 attribute_from;
                btVector3 attribute_to;
                memcpy(&attribute_from, ptr + i + offset, sizeof(btVector3));
                updateGLBufferPosition(idx, attribute_to, attribute_from);
                memcpy(ptr + i + offset, &attribute_to, sizeof(btVector3));
            }
            
            
            
            if(hasNormalAttribute() && normal)
            {
                GLsizeiptr offset = m_NormalOffset;
                btVector3 attribute_from;
                btVector3 attribute_to;
                memcpy(&attribute_from, ptr + i + offset, sizeof(btVector3));
                updateGLBufferNormal(idx, attribute_to, attribute_from);
                memcpy(ptr + i + offset, &attribute_to, sizeof(btVector3));
            }
            
            if(hasColorAttribute() && color)
            {
                GLsizeiptr offset = m_ColorOffset;
                btVector4 attribute_from;
                btVector4 attribute_to;
                memcpy(&attribute_from, ptr + i + offset, sizeof(btVector4));
                updateGLBufferColor(idx, attribute_to, attribute_from);
                memcpy(ptr + i + offset, &attribute_to, sizeof(btVector4));
            }
            
            for(int textureIndex = 0; textureIndex < m_NumTextures; ++textureIndex)
            {
                if(hasTextureAttribute(textureIndex) && texture[textureIndex])
                {
                    GLsizeiptr offset = m_TextureOffset[textureIndex];
                    btVector2 attribute_from;
                    btVector2 attribute_to;
                    memcpy(&attribute_from, ptr + i + offset, sizeof(btVector2));
                    updateGLBufferTexture(idx, textureIndex, attribute_to, attribute_from);
                    memcpy(ptr + i + offset, &attribute_to, sizeof(btVector2));
                }
            }
            
            
            ++idx;
        }
    }
    
    glBindVertexArrayOES(m_VAO);
    glBindBuffer( GL_ARRAY_BUFFER, m_VBO );
    
    glUnmapBufferOES( GL_ARRAY_BUFFER );
    
    glBindBuffer(GL_ARRAY_BUFFER,0);
    glBindVertexArrayOES(0);
}

void VertexBufferObject::renderGLBuffer(GLenum drawmode)
{
    btAssert(m_ShaderFactoryID > 0);
    
    GLsizei instanceCount = m_VBOTransformQueue->capacity();
    instanceCount = 1;
    if(isGLBufferLoaded() &&
       GL_TRUE == m_ShouldRender)
    {
        m_ShouldRender = GL_FALSE;
        
        GLuint programHandle = ShaderFactory::getInstance()->get(m_ShaderFactoryID)->m_ShaderProgramHandle;
        
        glUseProgram(programHandle);check_gl_error()
        
        
        BaseCamera *pCamera = CameraFactory::getInstance()->getCurrentCamera();
        GLfloat m[16];
        
        pCamera->getProjection2().getOpenGLMatrix(m);
        glUniformMatrix4fv(m_GLSLUniforms.projectionMatrix, 1, 0, m);check_gl_error()
        
        pCamera->getWorldTransform().inverse().getOpenGLMatrix(m);
        glUniformMatrix4fv(m_GLSLUniforms.modelViewMatrix, 1, 0, m);check_gl_error()
        
        temp->getWorldTransform().getOpenGLMatrix(m);
        glUniformMatrix4fv(m_GLSLUniforms.modelMatrix, 1, 0, m);check_gl_error();
        
        
        for(int textureIndex = 0; textureIndex < m_NumTextures; ++textureIndex)
        {
            if(hasTextureAttribute(textureIndex))
            {
                getMaterial(textureIndex)->render(this, textureIndex);
            }
        }
        
        glBindVertexArrayOES(m_VAO);check_gl_error()
        glBindBuffer(GL_ARRAY_BUFFER,m_VBO);check_gl_error()
        
        if(0 != m_IB)
        {
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_IB);check_gl_error()
            
            glDrawElements(drawmode, m_NumIndices, GL_UNSIGNED_SHORT, 0);check_gl_error()
//            glDrawElementsInstancedEXT(drawmode, m_NumIndices, GL_UNSIGNED_SHORT, 0, instanceCount);check_gl_error()
            
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);check_gl_error()
        }
        else
        {
            glDrawArrays(drawmode, 0, m_NumVertices);check_gl_error()
//            glDrawArraysInstancedEXT(drawmode, 0, m_NumVertices, instanceCount);check_gl_error()
        }
        
        glBindBuffer(GL_ARRAY_BUFFER,0);check_gl_error()
        glBindVertexArrayOES(0);check_gl_error()
        
        glUseProgram(0);check_gl_error()
        
    }
}

bool VertexBufferObject::registerEntity(BaseEntity *entity)
{
    return m_VBOTransformQueue->registerEntity(entity);
}
bool VertexBufferObject::unRegisterEntity(BaseEntity *entity)
{
    return m_VBOTransformQueue->unRegisterEntity(entity);
}
void VertexBufferObject::render(BaseEntity *entity)
{
    if(m_VBOTransformQueue->render(entity))
        m_ShouldRender = GL_TRUE;
    temp = entity;
}
const VBOMaterial*	VertexBufferObject::getMaterial(unsigned int index) const
{
    btAssert(hasTextureAttribute(index));
    
    return VBOMaterialFactory::getInstance()->get(m_MaterialFactoryIDs[index]);
}
VBOMaterial*	VertexBufferObject::getMaterial(unsigned int index)
{
    btAssert(hasTextureAttribute(index));
    
    return VBOMaterialFactory::getInstance()->get(m_MaterialFactoryIDs[index]);
}

btVector3 VertexBufferObject::getHalfExtends() const
{
    const BaseMeshObject *mo = ZipFileResourceLoader::getInstance()->getMeshObject(getName());
    
    if(mo)
        mo->getHalfExtends();
    
    return btVector3(0,0,0);
}

btTransform VertexBufferObject::getInitialTransform() const
{
    const BaseMeshObject *mo = ZipFileResourceLoader::getInstance()->getMeshObject(getName());
    
    if(mo)
        mo->getWorldTransform();
    
    return btTransform::getIdentity();
}
btScalar VertexBufferObject::getBoundingRadius()const
{
    btScalar boundingRadius = btMax(getHalfExtends().getX(), getHalfExtends().getY());
    return btMax(boundingRadius, getHalfExtends().getZ());
    
}

bool VertexBufferObject::hasAlphaTexture()const
{
//    IDType indice = 0;
//    for (int i = 0; i < m_TextureIndices.size(); i++)
//    {
//        indice = m_TextureIndices[i];
//        
//        GLKTextureInfoWrapper *infowrap = getTexture(indice);
//        if(infowrap)
//        {
//            if(infowrap->isTranslucent())
//                return true;
//        }
//    }
    
    return false;
}
#endif