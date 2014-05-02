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
#include "VertexBufferObjectFactory.h"

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
#endif

void VertexBufferObject::updateGLBuffer()
{
    static const GLuint STRIDE = 64;
    
    static GLfloat transform[16]={0};
    
	glBindBuffer(GL_ARRAY_BUFFER, m_modelviewBuffer);check_gl_error()

    for (unsigned int offset = 0, instance = 0;
         instance < m_NumInstances;
         offset += 16, ++instance)
    {
        if(instance < m_BaseObjects.size())
        {
            BaseEntity *pEntity = EntityFactory::getInstance()->get(m_BaseObjects[instance]);
            pEntity->getWorldTransform().getOpenGLMatrix(transform);
        }
        else
        {
            memset(transform, 0, STRIDE);
        }
        
        memcpy(m_ModelViewArray + offset, transform, sizeof(GLfloat) * 16);
    }
    
	glBufferSubData(GL_ARRAY_BUFFER, 0, m_NumInstances * 16 * sizeof(GLfloat), m_ModelViewArray);check_gl_error()
}

void VertexBufferObject::updateGLBufferPosition(int i, btVector3 &to, const btVector3 &from)
{
    
}

VertexBufferObject::VertexBufferObject():
m_NumTextures(0),
m_NumVertices(0),
m_NumIndices(0),
m_vertexArrayBuffer(0),
m_modelviewBuffer(0),
m_vertexBuffer(0),
m_indexBuffer(0),
m_ModelViewArray(NULL),
m_NumInstances(0),
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
m_vertexArrayBuffer(0),
m_modelviewBuffer(rhs.m_modelviewBuffer),
m_vertexBuffer(rhs.m_vertexBuffer),
m_indexBuffer(rhs.m_indexBuffer),
m_ModelViewArray(NULL),
m_NumInstances(rhs.m_NumInstances),
m_ShouldRender(rhs.m_ShouldRender),
m_MaterialFactoryIDs(new IDType[TEXTURE_MAX]),
m_ShaderFactoryID(rhs.m_ShaderFactoryID),
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
m_vertexArrayBuffer(0),
m_modelviewBuffer(0),
m_vertexBuffer(0),
m_indexBuffer(0),
m_ModelViewArray(NULL),
m_NumInstances(0),
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
        m_vertexArrayBuffer = 0;
        m_modelviewBuffer = 0;
        m_vertexBuffer = 0;
        m_indexBuffer = 0;
        m_ModelViewArray = NULL;
        m_NumInstances = rhs.m_NumInstances;
        m_ShouldRender = rhs.m_ShouldRender;
        m_ShaderFactoryID = rhs.m_ShaderFactoryID;
        m_Stride = rhs.m_Stride;
        m_PositionOffset = rhs.m_PositionOffset;
        m_NormalOffset = rhs.m_NormalOffset;
        m_ColorOffset = rhs.m_ColorOffset;
        
        memcpy(m_MaterialFactoryIDs, rhs.m_MaterialFactoryIDs, sizeof(IDType) * TEXTURE_MAX);
        memcpy(m_TextureOffset, rhs.m_TextureOffset, sizeof(size_t) * TEXTURE_MAX);
        
        delete [] m_ModelViewArray;
        m_ModelViewArray = NULL;
        
        //TODO: load a copy of the buffer.
    }
    return *this;
}

GLboolean VertexBufferObject::unLoadGLBuffer()
{   
    delete [] m_ModelViewArray;
    m_ModelViewArray = NULL;
    
    if (0 != m_vertexArrayBuffer)
    {
        glDeleteVertexArraysOES(1, &m_vertexArrayBuffer);
        m_vertexArrayBuffer = 0;
    }
    
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
        glDeleteBuffers(1, &m_vertexBuffer);check_gl_error()
        m_vertexBuffer = 0;
    }
    
    return ((m_vertexArrayBuffer == 0) && (m_vertexBuffer == 0) && (m_modelviewBuffer == 0) && (m_indexBuffer == 0));
}

GLboolean VertexBufferObject::isGLBufferLoaded()const
{
    return !((m_vertexArrayBuffer == 0) && (m_vertexBuffer == 0) && (m_modelviewBuffer == 0) && (m_indexBuffer == 0));
}

void VertexBufferObject::updateGLBuffer(bool position,
                                        bool normal,
                                        bool color,
                                        bool texture[TEXTURE_MAX])
{
    btAssert(isGLBufferLoaded());
    
    unsigned char *ptr = NULL;
    void *p = NULL;
    
    glBindBuffer(GL_ARRAY_BUFFER, m_vertexBuffer);
    
    glMapBufferOES( GL_ARRAY_BUFFER, GL_WRITE_ONLY_OES );
    glGetBufferPointervOES( GL_ARRAY_BUFFER, GL_BUFFER_MAP_POINTER_OES, &p );
    
    ptr = (unsigned char*)p;
    
    if(p)
    {
        for(unsigned int i = 0, idx = 0; i < (m_NumVertices * m_Stride); i+=m_Stride, ++idx)
        {
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
        }
    }
    
    glUnmapBufferOES( GL_ARRAY_BUFFER );
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
}

void VertexBufferObject::renderGLBuffer(GLenum drawmode)
{
    
#if defined(DEBUG) || defined (_DEBUG)
    glPushGroupMarkerEXT(0, getName().c_str());
#endif
    
    GLuint program = getProgramUsed();
    
    glUseProgram(program);check_gl_error()
    
    BaseCamera *pCamera = CameraFactory::getInstance()->getCurrentCamera();
    
    static GLfloat m[16];
    
    pCamera->getProjection2().getOpenGLMatrix(m);
    glUniformMatrix4fv(m_GLSLUniforms.projectionMatrix, 1, 0, m);check_gl_error()
    
    pCamera->getWorldTransform().inverse().getOpenGLMatrix(m);
    glUniformMatrix4fv(m_GLSLUniforms.modelViewMatrix, 1, 0, m);check_gl_error()
    
    for(int textureIndex = 0; textureIndex < m_NumTextures; ++textureIndex)
        if(getMaterial(textureIndex))
            getMaterial(textureIndex)->render(this, textureIndex);

    
    
    updateGLBuffer();
    
    glBindVertexArrayOES(m_vertexArrayBuffer);check_gl_error()
    
	glBindBuffer(GL_ARRAY_BUFFER, m_vertexBuffer);check_gl_error()
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_indexBuffer);check_gl_error()
    
    glDrawElementsInstancedEXT(drawmode, m_NumIndices, GL_UNSIGNED_SHORT, 0, m_NumInstances);check_gl_error();
	
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);check_gl_error()
    glBindBuffer(GL_ARRAY_BUFFER, 0);check_gl_error()
    glBindVertexArrayOES(0);
    glUseProgram(0);
    
#if defined(DEBUG) || defined (_DEBUG)
    glPopGroupMarkerEXT();
#endif
}

bool VertexBufferObject::registerEntity(BaseEntity *entity)
{
    btAssert (m_BaseObjects.size() + 1 <= m_NumInstances);
    
    unRegisterEntity(entity);
    
    m_BaseObjects.push_back(entity->getID());
    
    VertexBufferObjectFactory::getInstance()->registerViewObject(this, entity->isOrthographic());
    
    return true;
}
bool VertexBufferObject::unRegisterEntity(BaseEntity *entity)
{
    btAssert(entity);
    
    m_BaseObjects.remove(entity->getID());
    
    return true;
}
void VertexBufferObject::markInView(BaseEntity *entity)
{
    m_ShouldRender = GL_TRUE;
}

void VertexBufferObject::setMaterial(unsigned int index, const IDType ID)
{
    btAssert(hasTextureAttribute(index));
    
    m_MaterialFactoryIDs[index] = ID;
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
        return mo->getHalfExtends();
    
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

GLuint VertexBufferObject::getProgramUsed()const
{
    return ShaderFactory::getInstance()->get(m_ShaderFactoryID)->m_ShaderProgramHandle;
}
