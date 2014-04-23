//
//  VertexBufferObject.cpp
//  MazeADay
//
//  Created by James Folk on 4/7/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#include "VertexBufferObject.h"
#include "BaseEntity.h"
#include "VBOMaterial.h"

#include "CameraFactory.h"
#include "VBOMaterialFactory.h"
#include "ZipFileResourceLoader.h"
#include "EntityFactory.h"

const unsigned int TEXTURE_MAX = 8;
const unsigned int MAX_INSTANCES = 1000;

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
#endif

void VertexBufferObject::updateGLBuffer()
{
    const GLuint STRIDE = 64;
    
    btScalar identityTransform[] =
    {
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1,
    };
    
	glBindBuffer(GL_ARRAY_BUFFER, m_modelviewBuffer);check_gl_error()
    
    for (int i = 0, offset = 0, current_index = 0;
         i < m_NumInstances * m_NumVertices;
         i += m_NumVertices, offset += STRIDE, ++current_index)
    {
        if(current_index < m_BaseObjects.size())
        {
            btScalar *transform = new GLfloat[16];
            
            BaseEntity *pEntity = EntityFactory::getInstance()->get(m_BaseObjects[current_index]);
            pEntity->getWorldTransform().getOpenGLMatrix(transform);
            
            for (int j = 0; j < m_NumVertices; j++)
            {
                memcpy(modelview + (offset + (16 * j)), transform, sizeof(GLfloat) * 16);
            }
            
            delete [] transform;
            transform = NULL;
        }
        else
        {
            for (int j = 0; j < m_NumVertices; j++)
            {
                memcpy(modelview + (offset + (16 * j)), identityTransform, sizeof(GLfloat) * 16);
            }
        }
	}
    
	glBufferSubData(GL_ARRAY_BUFFER, 0, m_NumInstances * m_NumVertices * 16 * sizeof(GLfloat), modelview);check_gl_error()
	
	glEnableVertexAttribArray(m_GLSLAttributes.transformmatrix + 0);check_gl_error()
	glEnableVertexAttribArray(m_GLSLAttributes.transformmatrix + 1);check_gl_error()
	glEnableVertexAttribArray(m_GLSLAttributes.transformmatrix + 2);check_gl_error()
	glEnableVertexAttribArray(m_GLSLAttributes.transformmatrix + 3);check_gl_error()
	glVertexAttribPointer(m_GLSLAttributes.transformmatrix + 0, 4, GL_FLOAT, 0, STRIDE, (GLvoid*)0);check_gl_error()
	glVertexAttribPointer(m_GLSLAttributes.transformmatrix + 1, 4, GL_FLOAT, 0, STRIDE, (GLvoid*)16);check_gl_error()
	glVertexAttribPointer(m_GLSLAttributes.transformmatrix + 2, 4, GL_FLOAT, 0, STRIDE, (GLvoid*)32);check_gl_error()
	glVertexAttribPointer(m_GLSLAttributes.transformmatrix + 3, 4, GL_FLOAT, 0, STRIDE, (GLvoid*)48);check_gl_error()
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
}

void VertexBufferObject::updateGLBufferPosition(int i, btVector3 &to, const btVector3 &from)
{
    
}

VertexBufferObject::VertexBufferObject():
m_NumTextures(0),
m_NumVertices(0),
m_NumIndices(0),
modelview(0),
m_vertexBuffer(0),
m_indexBuffer(0),
m_ShouldRender(GL_FALSE),
m_MaterialFactoryIDs(new IDType[TEXTURE_MAX]),
m_ShaderFactoryID(0),
m_Stride(0),
m_PositionOffset(0),
m_NormalOffset(0),
m_ColorOffset(0),
m_TextureOffset(new size_t[TEXTURE_MAX])
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
modelview(0),
m_vertexBuffer(0),
m_indexBuffer(0),
m_ShouldRender(GL_FALSE),
m_MaterialFactoryIDs(new IDType[TEXTURE_MAX]),
m_ShaderFactoryID(0),
m_Stride(rhs.m_Stride),
m_PositionOffset(rhs.m_PositionOffset),
m_NormalOffset(rhs.m_NormalOffset),
m_ColorOffset(rhs.m_ColorOffset),
m_TextureOffset(new size_t[TEXTURE_MAX])
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
modelview(0),
m_vertexBuffer(0),
m_indexBuffer(0),
m_ShouldRender(GL_FALSE),
m_MaterialFactoryIDs(new IDType[TEXTURE_MAX]),
m_ShaderFactoryID(0),
m_Stride(0),
m_PositionOffset(0),
m_NormalOffset(0),
m_ColorOffset(0),
m_TextureOffset(new size_t[TEXTURE_MAX])
{
    setName(info.m_viewObjectName);
}

VertexBufferObject::~VertexBufferObject()
{
    unLoadGLBuffer();
    
    delete [] m_TextureOffset;
    m_TextureOffset = NULL;
    
    delete [] m_MaterialFactoryIDs;
    m_MaterialFactoryIDs = NULL;
}

VertexBufferObject &VertexBufferObject::operator=(const VertexBufferObject &rhs)
{
    if(this != &rhs)
    {
        m_NumTextures = rhs.m_NumTextures;
        m_NumVertices = rhs.m_NumVertices;
        m_NumIndices = rhs.m_NumIndices;
        
        modelview = 0;
        m_vertexBuffer = 0;
        m_indexBuffer = 0;
        m_ShouldRender = GL_FALSE;
        memcpy(m_MaterialFactoryIDs, rhs.m_MaterialFactoryIDs, sizeof(IDType) * TEXTURE_MAX);
        
        m_ShaderFactoryID = 0;
        m_Stride = rhs.m_Stride;
        m_PositionOffset = rhs.m_PositionOffset;
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
    
    
    m_MaterialFactoryIDs[0] = materialFactoryID0;
    m_MaterialFactoryIDs[1] = materialFactoryID1;
    m_MaterialFactoryIDs[2] = materialFactoryID2;
    m_MaterialFactoryIDs[3] = materialFactoryID3;
    m_MaterialFactoryIDs[4] = materialFactoryID4;
    m_MaterialFactoryIDs[5] = materialFactoryID5;
    m_MaterialFactoryIDs[6] = materialFactoryID6;
    m_MaterialFactoryIDs[7] = materialFactoryID7;
    
    
    
    GLuint program = ShaderFactory::getInstance()->get(m_ShaderFactoryID)->m_ShaderProgramHandle;
    
    glUseProgram(program);
    
    
    
    
    
    for(int textureIndex = 0; textureIndex < m_NumTextures; ++textureIndex)
        getMaterial(textureIndex)->loadGLSL(this, textureIndex);
    
    glUseProgram(0);
    
//    if(program > 0 &&
//       isGLBufferLoaded())
//    {
//        GLuint program = ShaderFactory::getInstance()->get(m_ShaderFactoryID)->m_ShaderProgramHandle;
//        
//        glUseProgram(program);
//        
//        glBindAttribLocation(program, ATTRIB_POSITION, "position");
//        glBindAttribLocation(program, ATTRIB_COLOR, "sourceColor");
//        glBindAttribLocation(program, ATTRIB_TRANSFORMMATRIX, "modelview");
//        
//        m_GLSLUniforms.modelViewMatrix = glGetUniformLocation(program, "modelViewMatrix");check_gl_error()
//        m_GLSLUniforms.projectionMatrix = glGetUniformLocation(program, "projectionMatrix");check_gl_error()
//        m_GLSLUniforms.modelMatrix = glGetUniformLocation(program, "modelMatrix");check_gl_error();
//        
//        for(int textureIndex = 0; textureIndex < m_NumTextures; ++textureIndex)
//            getMaterial(textureIndex)->loadGLSL(this, textureIndex);
    
        
//        
//        
////        m_GLSLAttributes.transformmatrix = glGetAttribLocation(programHandle, "transformmatrix");check_gl_error()
//        m_GLSLAttributes.transformmatrix = 0;
//        
////        m_GLSLAttributes.position = glGetAttribLocation(programHandle, "position");check_gl_error()
//        m_GLSLAttributes.position = 1;
//        
//        if(hasColorAttribute())
//            m_GLSLAttributes.color = glGetAttribLocation(programHandle, "color");check_gl_error()
//        
//        if(hasNormalAttribute())
//            m_GLSLAttributes.normal = glGetAttribLocation(programHandle, "normal");check_gl_error()
//        
//        for(int textureIndex = 0; textureIndex < m_NumTextures; ++textureIndex)
//            m_GLSLAttributes.textureCoord[textureIndex] = glGetAttribLocation(programHandle,
//                                                                              textureCoord[textureIndex]);check_gl_error()
//        
//        
//        
//        m_GLSLUniforms.modelViewMatrix = glGetUniformLocation(programHandle, "modelViewMatrix");check_gl_error()
//        m_GLSLUniforms.projectionMatrix = glGetUniformLocation(programHandle, "projectionMatrix");check_gl_error()
//        m_GLSLUniforms.modelMatrix = glGetUniformLocation(programHandle, "modelMatrix");check_gl_error();
//        
//        for(int textureIndex = 0; textureIndex < m_NumTextures; ++textureIndex)
//            getMaterial(textureIndex)->loadGLSL(this, textureIndex);
//        
//        glBindBuffer(GL_ARRAY_BUFFER, m_vertexBuffer);
//        
////        if(m_GLSLAttributes.transformmatrix != 1)
////        {
////            for (unsigned int i = 0; i < 4 ; i++)
////            {
////                glEnableVertexAttribArray(m_GLSLAttributes.transformmatrix + i);
////                glVertexAttribPointer(m_GLSLAttributes.transformmatrix + i, 4, GL_FLOAT, GL_FALSE, getStride(), (const GLvoid*)getWorldTransformOffset(i));
//////                glVertexAttribDivisorEXT(m_GLSLAttributes.transformmatrix + i, 1);
////            }
////        }
//        if(m_GLSLAttributes.position != -1)
//        {
//            glEnableVertexAttribArray(m_GLSLAttributes.position);check_gl_error()
//            glVertexAttribPointer(m_GLSLAttributes.position,
//                                  4, GL_FLOAT, GL_FALSE,
//                                  getStride(),
//                                  (const GLvoid*)getPositionOffset());check_gl_error()
//        }
//        if(m_GLSLAttributes.color != -1)
//        {
//            glEnableVertexAttribArray(m_GLSLAttributes.color);check_gl_error()
//            glVertexAttribPointer(m_GLSLAttributes.color,
//                                  4, GL_FLOAT, GL_FALSE,
//                                  getStride(),
//                                  (const GLvoid*)getColorOffset());check_gl_error()
//        }
//        if(m_GLSLAttributes.normal != -1)
//        {
//            glEnableVertexAttribArray(m_GLSLAttributes.normal);check_gl_error()
//            glVertexAttribPointer(m_GLSLAttributes.normal,
//                                  4, GL_FLOAT, GL_FALSE,
//                                  getStride(),
//                                  (const GLvoid*)getNormalOffset());check_gl_error()
//        }
//        for(int textureIndex = 0; textureIndex < m_NumTextures; ++textureIndex)
//        {
//            if(m_GLSLAttributes.textureCoord[textureIndex] != -1)
//            {
//                glEnableVertexAttribArray(m_GLSLAttributes.textureCoord[textureIndex]);check_gl_error()
//                if(m_GLSLAttributes.textureCoord[textureIndex] != -1)
//                {
//                    glVertexAttribPointer(m_GLSLAttributes.textureCoord[textureIndex], 2, GL_FLOAT, GL_FALSE,
//                                          getStride(),
//                                          (const GLvoid*)getTextureOffset(textureIndex));check_gl_error()
//                }
//            }
//        }
        
//        glUseProgram(0);
//    }
}


GLboolean VertexBufferObject::unLoadGLBuffer()
{   
    delete [] modelview;
    modelview = NULL;
    
    if(0 != m_indexBuffer)
    {
        glDeleteBuffers(1, &m_indexBuffer);check_gl_error()
        m_indexBuffer = 0;
    }
    
    if(0 != m_modelviewBuffer)
    {
        glDeleteBuffers(1, &m_modelviewBuffer);check_gl_error()
        m_modelviewBuffer = 0;
    }
    
    if(0 != m_vertexBuffer)
    {
        glDeleteVertexArraysOES(1, &m_vertexBuffer);check_gl_error()
        m_vertexBuffer = 0;
    }
    
    return ((m_vertexBuffer == 0) && (m_modelviewBuffer == 0) && (m_indexBuffer == 0));
}

GLboolean VertexBufferObject::isGLBufferLoaded()const
{
    return !((m_vertexBuffer == 0) && (m_modelviewBuffer == 0) && (m_indexBuffer == 0));
}

void VertexBufferObject::updateGLBuffer(bool position,
                                        bool normal,
                                        bool color,
                                        bool texture[TEXTURE_MAX])
{
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
//            GLsizeiptr offset = getWorldTransformOffset(0);
//            btTransform attribute_from;
//            btTransform attribute_to;
//            memcpy(&attribute_from, ptr + i + offset, sizeof(btTransform));
//            updateGLBufferWorldTransform(idx, attribute_to, attribute_from);
//            memcpy(ptr + i + offset, &attribute_to, sizeof(btTransform));
//            
//            if(position)
//            {
//                GLsizeiptr offset = m_PositionOffset;
//                btVector3 attribute_from;
//                btVector3 attribute_to;
//                memcpy(&attribute_from, ptr + i + offset, sizeof(btVector3));
//                updateGLBufferPosition(idx, attribute_to, attribute_from);
//                memcpy(ptr + i + offset, &attribute_to, sizeof(btVector3));
//            }
//            
//            
//            
//            if(hasNormalAttribute() && normal)
//            {
//                GLsizeiptr offset = m_NormalOffset;
//                btVector3 attribute_from;
//                btVector3 attribute_to;
//                memcpy(&attribute_from, ptr + i + offset, sizeof(btVector3));
//                updateGLBufferNormal(idx, attribute_to, attribute_from);
//                memcpy(ptr + i + offset, &attribute_to, sizeof(btVector3));
//            }
//            
//            if(hasColorAttribute() && color)
//            {
//                GLsizeiptr offset = m_ColorOffset;
//                btVector4 attribute_from;
//                btVector4 attribute_to;
//                memcpy(&attribute_from, ptr + i + offset, sizeof(btVector4));
//                updateGLBufferColor(idx, attribute_to, attribute_from);
//                memcpy(ptr + i + offset, &attribute_to, sizeof(btVector4));
//            }
//            
//            for(int textureIndex = 0; textureIndex < m_NumTextures; ++textureIndex)
//            {
//                if(hasTextureAttribute(textureIndex) && texture[textureIndex])
//                {
//                    GLsizeiptr offset = m_TextureOffset[textureIndex];
//                    btVector2 attribute_from;
//                    btVector2 attribute_to;
//                    memcpy(&attribute_from, ptr + i + offset, sizeof(btVector2));
//                    updateGLBufferTexture(idx, textureIndex, attribute_to, attribute_from);
//                    memcpy(ptr + i + offset, &attribute_to, sizeof(btVector2));
//                }
//            }
//            
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
}

void VertexBufferObject::renderGLBuffer(GLenum drawmode)
{
    GLuint program = ShaderFactory::getInstance()->get(m_ShaderFactoryID)->m_ShaderProgramHandle;
    
    glUseProgram(program);check_gl_error()
    
    BaseCamera *pCamera = CameraFactory::getInstance()->getCurrentCamera();
    
    GLfloat *m = new GLfloat[16];
    pCamera->getProjection2().getOpenGLMatrix(m);
    glUniformMatrix4fv(m_GLSLUniforms.projectionMatrix, 1, 0, m);check_gl_error()
//
    pCamera->getWorldTransform().inverse().getOpenGLMatrix(m);
    glUniformMatrix4fv(m_GLSLUniforms.modelViewMatrix, 1, 0, m);check_gl_error()
    delete [] m;

    updateGLBuffer();
	
	glBindBuffer(GL_ARRAY_BUFFER, m_vertexBuffer);check_gl_error()
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_indexBuffer);check_gl_error()
    
	glDrawElements(GL_TRIANGLES, m_NumInstances * m_NumVertices, GL_UNSIGNED_SHORT, 0);check_gl_error();
	
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);check_gl_error()
    glBindBuffer(GL_ARRAY_BUFFER, 0);check_gl_error()
    
    
    glUseProgram(0);
    
//#if defined(DEBUG) || defined (_DEBUG)
//    glPushGroupMarkerEXT(0, getName().c_str());
//#endif
//    
//    btAssert(m_ShaderFactoryID > 0);
//    
//    GLuint programHandle = ShaderFactory::getInstance()->get(m_ShaderFactoryID)->m_ShaderProgramHandle;
//    
//    glUseProgram(programHandle);check_gl_error()
//    
//    BaseCamera *pCamera = CameraFactory::getInstance()->getCurrentCamera();
//    
//    GLfloat m[16];
//    pCamera->getProjection2().getOpenGLMatrix(m);
//    glUniformMatrix4fv(m_GLSLUniforms.projectionMatrix, 1, 0, m);check_gl_error()
//    
//    pCamera->getWorldTransform().inverse().getOpenGLMatrix(m);
//    glUniformMatrix4fv(m_GLSLUniforms.modelViewMatrix, 1, 0, m);check_gl_error()
//    
//    temp->getWorldTransform().getOpenGLMatrix(m);
//    glUniformMatrix4fv(m_GLSLUniforms.modelMatrix, 1, 0, m);check_gl_error();
//
//    for(int textureIndex = 0; textureIndex < m_NumTextures; ++textureIndex)
//    {
//        getMaterial(textureIndex)->render(this, textureIndex);
//    }
//    
//    updateGLBuffer();
//    
//    
//    glBindBuffer(GL_ARRAY_BUFFER, m_vertexBuffer);
//    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_indexBuffer);
//    
//    glDrawElements(GL_TRIANGLES, m_NumInstances * m_NumVertices, GL_UNSIGNED_SHORT, 0);check_gl_error();
//	
//    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
//    glBindBuffer(GL_ARRAY_BUFFER, 0);
//    
//    glUseProgram(0);check_gl_error()
//    
//#if defined(DEBUG) || defined (_DEBUG)
//    glPopGroupMarkerEXT();
//#endif
}

bool VertexBufferObject::registerEntity(BaseEntity *entity)
{
    btAssert (m_BaseObjects.size() + 1 <= m_NumInstances);
    
    unRegisterEntity(entity);
    
    m_BaseObjects.push_back(entity->getID());
    
    return true;
    
//    return m_VBOTransformQueue->registerEntity(entity);
}
bool VertexBufferObject::unRegisterEntity(BaseEntity *entity)
{
    btAssert(entity);
    
    m_BaseObjects.remove(entity->getID());
    
    return true;
    
//    return m_VBOTransformQueue->unRegisterEntity(entity);
}
void VertexBufferObject::render(BaseEntity *entity)
{
    m_ShouldRender = GL_TRUE;
//    temp = entity;
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