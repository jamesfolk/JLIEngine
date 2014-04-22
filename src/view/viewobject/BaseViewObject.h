//
//  BaseViewObject.h
//  HelloOpenGL
//
//  Created by James Folk on 2/18/13.
//
//



#ifndef __HelloOpenGL__BaseViewObject__
#define __HelloOpenGL__BaseViewObject__
#include "UtilityFunctions.h"
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

#include "TextureFactory.h"

#include <string>
#include <vector>

#include "WorldPhysics.h"

//#include "VertexAttributes.h"



//#include "CollisionShapeFactory.h"
#include "ViewObjectFactoryIncludes.h"
#include "BaseTextureBehavior.h"

#include "TextureBehaviorFactory.h"

#include "VertexAttributesInclude.h"

#include "ViewObjectFactory.h"

class btConvexHullShape;
class btTriangleMesh;
class GLKTextureInfoWrapper;


 
    
    
    
    
    
    
    
    
    
    
    
    
extern const char *const GLSL_ATTRIBUTE_transformmatrix;
extern const char *const GLSL_ATTRIBUTE_position;
extern const char *const GLSL_ATTRIBUTE_normal;
extern const char *const GLSL_ATTRIBUTE_textureCoord[8];
//extern const char *GLSL_ATTRIBUTE_textureCoord0;
extern const char *const GLSL_ATTRIBUTE_color;

extern const char *const GLSL_UNIFORM_modelViewProjectionMatrix;
extern const char *const GLSL_UNIFORM_eyePosition;
extern const char *const GLSL_UNIFORM_modelMatrix;
extern const char *const GLSL_UNIFORM_modelViewMatrix;
extern const char *const GLSL_UNIFORM_projectionMatrix;
extern const char *const GLSL_UNIFORM_normalMatrix;
extern const char *const GLSL_UNIFORM_time;
extern const char *const GLSL_UNIFORM_lightPosition;
extern const char *const GLSL_UNIFORM_textureMatrix;
extern const char *const GLSL_UNIFORM_pointCoordMatrix;
extern const char *const GLSL_UNIFORM_materialAmbientColor;
extern const char *const GLSL_UNIFORM_materialDiffuseColor0;
extern const char *const GLSL_UNIFORM_materialDiffuseColor1;
extern const char *const GLSL_UNIFORM_materialDiffuseColor2;
extern const char *const GLSL_UNIFORM_materialDiffuseColor3;
extern const char *const GLSL_UNIFORM_materialSpecularColor;
extern const char *const GLSL_UNIFORM_materialSpecularExponent;
extern const char *const GLSL_UNIFORM_texture[8];
    //extern const char *GLSL_UNIFORM_texture0;
//extern const char *GLSL_UNIFORM_texture1;

extern const char *const GLSL_UNIFORM_touch;
extern const char *const GLSL_UNIFORM_scr;
extern const char *const GLSL_UNIFORM_touch2;

extern const char *const GLSL_UNIFORM_enableTexture[8];
//extern const char *GLSL_UNIFORM_enableTexture0;
//extern const char *GLSL_UNIFORM_enableTexture1;
extern const char *const GLSL_UNIFORM_enableNormal;
extern const char *const GLSL_UNIFORM_enableVertexColor;
extern const char *const GLSL_UNIFORM_enablePointCoord;
extern const char *const GLSL_UNIFORM_enableTextureCube[8];
extern const char *const GLSL_UNIFORM_pointSize;

//#define 0 (-1)










//struct GLSLAttributes
//{
//    GLSLAttributes():
//    position(0),
//    normal(0),
//    textureCoord(new GLuint[8]),
//    color(0),
//    transformmatrix(0)
//    {
//        memset(textureCoord, 0, sizeof(GLuint) * 8);
//    }
//    
//    ~GLSLAttributes()
//    {
//        delete [] textureCoord;
//        textureCoord = NULL;
//    }
//    
//    GLuint position;
//    GLuint normal;
//    GLuint *textureCoord;
//    GLuint color;
//    GLuint transformmatrix;
//};

struct GLSLUniforms
{
    GLSLUniforms():
    modelViewProjectionMatrix(GL_INVALID_VALUE),
    eyePosition(GL_INVALID_VALUE),
    modelMatrix(GL_INVALID_VALUE),
    modelViewMatrix(GL_INVALID_VALUE),
    projectionMatrix(GL_INVALID_VALUE),
    normalMatrix(GL_INVALID_VALUE),
    time(GL_INVALID_VALUE),
    lightPosition(GL_INVALID_VALUE),
    textureMatrix(GL_INVALID_VALUE),
    pointCoordMatrix(GL_INVALID_VALUE),
    materialAmbientColor(GL_INVALID_VALUE),
    materialDiffuseColor0(GL_INVALID_VALUE),
    materialDiffuseColor1(GL_INVALID_VALUE),
    materialDiffuseColor2(GL_INVALID_VALUE),
    materialDiffuseColor3(GL_INVALID_VALUE),
    materialSpecularColor(GL_INVALID_VALUE),
    materialSpecularExponent(GL_INVALID_VALUE),
    touch(GL_INVALID_VALUE),
    scr(GL_INVALID_VALUE),
    touch2(GL_INVALID_VALUE),
    enableNormal(GL_INVALID_VALUE),
    enableVertexColor(GL_INVALID_VALUE),
    enablePointCoord(GL_INVALID_VALUE),
    pointSize(GL_INVALID_VALUE)
    {
        memset(texture, GL_INVALID_VALUE, sizeof(GLuint) * 8);
        memset(enableTexture, GL_INVALID_VALUE, sizeof(GLuint) * 8);
        memset(enableTextureCube, GL_INVALID_VALUE, sizeof(GLuint) * 8);
    }
    
    
    GLuint modelViewProjectionMatrix;
    GLuint eyePosition;
    GLuint modelMatrix;
    GLuint modelViewMatrix;
    GLuint projectionMatrix;
    GLuint normalMatrix;
    GLuint time;
    GLuint lightPosition;
    GLuint textureMatrix;
    GLuint pointCoordMatrix;
    GLuint materialAmbientColor;
    GLuint materialDiffuseColor0;
    GLuint materialDiffuseColor1;
    GLuint materialDiffuseColor2;
    GLuint materialDiffuseColor3;
    GLuint materialSpecularColor;
    GLuint materialSpecularExponent;
    
    //GLuint texture0;
    //GLuint texture1;
    GLuint texture[8];
    
    GLuint touch;
    GLuint scr;
    GLuint touch2;
    
    //GLuint enableTexture0;
    //GLuint enableTexture1;
    GLuint enableTexture[8];
    
    GLuint enableNormal;
    GLuint enableVertexColor;
    GLuint enablePointCoord;
    GLuint enableTextureCube[8];
    GLuint pointSize;
};

struct GLSLUniformValues
{
    GLSLUniformValues():
    modelViewProjectionMatrix(NULL),
    modelMatrix(NULL),
    eyePosition(NULL),
    modelViewMatrix(NULL),
    projectionMatrix(NULL),
    normalMatrix(NULL),
    time(0.0f),
    lightPosition(NULL),
    materialAmbientColor(NULL),
    materialDiffuseColor0(NULL),
    materialDiffuseColor1(NULL),
    materialDiffuseColor2(NULL),
    materialDiffuseColor3(NULL),
    materialSpecularColor(NULL),
    materialSpecularExponent(0.0f),
    enableNormal(false),
    enableVertexColor(false),
    enablePointCoord(false),
    pointSize(1.0f)
    {
        for(int i = 0; i < 8; i++)
        {
            //texture[i] = nil;
            texture[i] = NULL;
            enableTexture[i] = false;
            enableTextureCube[i] = false;
        }
        
        for(int i = 0; i < 16; i++)
        {
            pointCoordMatrix[i] = 0;
        }
        pointCoordMatrix[0] = pointCoordMatrix[5] = pointCoordMatrix[10] = pointCoordMatrix[15] = 1.0f;
    }
    const GLfloat *modelViewProjectionMatrix;//[16];
    const GLfloat *eyePosition;
    const GLfloat *modelMatrix;//[16];
    const GLfloat *modelViewMatrix;//[16];
    const GLfloat *projectionMatrix;//[16];
    const GLfloat *normalMatrix;//[9];
    GLfloat        time;
    const GLfloat *lightPosition;//[4];
    GLfloat textureMatrix[16];
    GLfloat pointCoordMatrix[16];
    const GLfloat *materialAmbientColor;//[4];
    const GLfloat *materialDiffuseColor0;//[4];
    const GLfloat *materialDiffuseColor1;//[4];
    const GLfloat *materialDiffuseColor2;//[4];
    const GLfloat *materialDiffuseColor3;//[4];
    const GLfloat *materialSpecularColor;//[4];
    GLfloat        materialSpecularExponent;
    
    //GLKTextureInfo *texture[8];
    TextureInfo *texture[8];
    
    GLboolean enableTexture[8];
    GLuint textureName[8];
    
    //GLKTextureInfo *texture0;
    
    //GLKTextureInfo *texture1;
    
    //GLboolean enableTexture0;
    //GLboolean enableTexture1;
    GLboolean enableNormal;
    GLboolean enableVertexColor;
    GLboolean enablePointCoord;
    GLboolean enableTextureCube[8];
    GLfloat pointSize;
};
    
class BaseViewObject :
public AbstractFactoryObject
{
    friend class ViewObjectFactory;
protected:
    BaseViewObject(const BaseViewObjectInfo& constructionInfo);
    virtual ~BaseViewObject();
public:
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
    
    
    SIMD_FORCE_INLINE const BaseTextureBehavior*	getTextureBehavior(unsigned int index) const
    {
        return TextureBehaviorFactory::getInstance()->get(m_textureBehaviorFactoryIDs[index]);
	}
    
	SIMD_FORCE_INLINE BaseTextureBehavior*	getTextureBehavior(unsigned int index)
    {
        return TextureBehaviorFactory::getInstance()->get(m_textureBehaviorFactoryIDs[index]);
	}
    
    SIMD_FORCE_INLINE void setTextureBehavior(unsigned int index, const IDType _id)
    {
        btAssert(index < 8);
        
        m_textureBehaviorFactoryIDs[index] = _id;
        
        if(isLoaded())
        {
            getTextureBehavior(index)->load();
        }
    }
    
    template<class Function>
    void get_each_indice(Function fn)const
    {
        unsigned char *ptr = NULL;
        void *p;
        GLushort indice = 0;
        
        glBindVertexArrayOES(m_vertexArrayBuffer);
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
        
        glBindVertexArrayOES(m_vertexArrayBuffer);
        glBindBuffer( GL_ELEMENT_ARRAY_BUFFER, m_indexBuffer );
        
        glUnmapBufferOES( GL_ELEMENT_ARRAY_BUFFER );
        
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,0);
        glBindVertexArrayOES(0);
    }
    
    
    
    
    
    template<class Function>
    void get_each_triangle(Function fn)const
    {
        unsigned char *ptr = NULL;
        void *p;
        btVector3 vertice[3];
        
        glBindVertexArrayOES(m_vertexArrayBuffer);
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
        
        glBindVertexArrayOES(m_vertexArrayBuffer);
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
        
        glBindVertexArrayOES(m_vertexArrayBuffer);
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
        
        glBindVertexArrayOES(m_vertexArrayBuffer);
        glBindBuffer( GL_ARRAY_BUFFER, m_vertexBuffer );
        
        glUnmapBufferOES( GL_ARRAY_BUFFER );
        
        glBindBuffer(GL_ARRAY_BUFFER,0);
        glBindVertexArrayOES(0);
    }
    
    
    
    
    
    template<class Function, class AttributeType>
    void set_each_attribute(Function &fn, size_t offset)
    {
        unsigned char *ptr = NULL;
        void *p = NULL;
        AttributeType attribute_from;
        AttributeType attribute_to;
        
        glBindVertexArrayOES(m_vertexArrayBuffer);
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
        
        glBindVertexArrayOES(m_vertexArrayBuffer);
        glBindBuffer( GL_ARRAY_BUFFER, m_vertexBuffer );
        
        glUnmapBufferOES( GL_ARRAY_BUFFER );
        
        glBindBuffer(GL_ARRAY_BUFFER,0);
        glBindVertexArrayOES(0);
    }
    
    template<class Function, class AttributeType>
    void set_attribute(unsigned int attribute_index, Function &fn, size_t offset)
    {
        unsigned char *ptr = NULL;
        void *p = NULL;
        AttributeType attribute;
        
        glBindVertexArrayOES(m_vertexArrayBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, m_vertexBuffer);
        
        glMapBufferOES( GL_ARRAY_BUFFER, GL_WRITE_ONLY_OES );
        glGetBufferPointervOES( GL_ARRAY_BUFFER, GL_BUFFER_MAP_POINTER_OES, &p );
        
        ptr = (unsigned char*)p;
        
        btAssert(attribute_index < (m_NumVertices * m_Stride));
        
        memcpy(&attribute, ptr + attribute_index + offset, sizeof(AttributeType));
        fn(attribute, attribute);
        memcpy(ptr + attribute_index + offset, &attribute, sizeof(AttributeType));
        
        glBindVertexArrayOES(m_vertexArrayBuffer);
        glBindBuffer( GL_ARRAY_BUFFER, m_vertexBuffer );
        
        glUnmapBufferOES( GL_ARRAY_BUFFER );
        
        glBindBuffer(GL_ARRAY_BUFFER,0);
        glBindVertexArrayOES(0);
    }
    
    
    template<class Function, class AttributeType>
    void get_each_attribute(Function &fn, size_t offset)const
    {
        unsigned char *ptr = NULL;
        void *p = NULL;
        AttributeType attribute;
        
        glBindVertexArrayOES(m_vertexArrayBuffer);
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
        
        glBindVertexArrayOES(m_vertexArrayBuffer);
        glBindBuffer( GL_ARRAY_BUFFER, m_vertexBuffer );
        
        glUnmapBufferOES( GL_ARRAY_BUFFER );
        
        glBindBuffer(GL_ARRAY_BUFFER,0);
        glBindVertexArrayOES(0);
    }
    
    template<class Function, class AttributeType>
    void get_attribute(unsigned int attribute_index, Function &fn, size_t offset)const
    {
        unsigned char *ptr = NULL;
        void *p = NULL;
        AttributeType attribute;
        
        glBindVertexArrayOES(m_vertexArrayBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, m_vertexBuffer);
        
        glMapBufferOES( GL_ARRAY_BUFFER, GL_WRITE_ONLY_OES );
        glGetBufferPointervOES( GL_ARRAY_BUFFER, GL_BUFFER_MAP_POINTER_OES, &p );
        
        ptr = (unsigned char*)p;
        
        btAssert(attribute_index < (m_NumVertices * m_Stride));
        
        memcpy(&attribute, ptr + attribute_index + offset, sizeof(AttributeType));
        fn(attribute);
        
        glBindVertexArrayOES(m_vertexArrayBuffer);
        glBindBuffer( GL_ARRAY_BUFFER, m_vertexBuffer );
        
        glUnmapBufferOES( GL_ARRAY_BUFFER );
        
        glBindBuffer(GL_ARRAY_BUFFER,0);
        glBindVertexArrayOES(0);
    }

    virtual void render(GLenum drawmode);
    
    virtual void setShaderFactoryID(const IDType ID);
    
    virtual GLboolean load(GLsizeiptr array_size, const GLvoid* array_data,
                           GLenum array_usage = GL_STATIC_DRAW);
    
    virtual GLboolean load(GLsizeiptr indice_size, const GLvoid* indice_data,
                           GLsizeiptr array_size, const GLvoid* array_data,
                           GLenum indice_usage = GL_STATIC_DRAW,
                           GLenum array_usage = GL_STATIC_DRAW);
    virtual GLboolean reLoad(GLsizeiptr size, const GLvoid* data);
    
    virtual GLboolean unLoad();
    virtual GLboolean isLoaded()const;
    
    void setVertexAttributeProperties(const GLsizei stride,
                                      const size_t positionOffset,
//                                      const size_t worldTransformOffset,
                                      const size_t normalOffset,
                                      const size_t colorOffset,
                                      const size_t texture0Offset,
                                      const size_t numVertices,
                                      const size_t numIndices = 0)
    {
        m_Stride = stride;
        m_PositionOffset = positionOffset;
//        m_WorldTransformOffset = worldTransformOffset;
        m_NormalOffset = normalOffset;
        m_ColorOffset = colorOffset;
        //m_Texture0Offset = texture0Offset;
        m_TextureOffset[0] = texture0Offset;
        
        m_NumVertices = numVertices;
        m_NumIndices = numIndices;
        
        m_SetVertexAttributes = true;
    }
    
    GLboolean setGLSLUniforms(const btTransform &modelView, const btTransform &projection, const btTransform &model);
    GLboolean setGLSLUniforms(const btTransform &modelViewProjection, const btTransform &transformMatrix);
    
    GLboolean setGLSLModelViewProjectionMatrix(const GLfloat *matrix);
    GLboolean setGLSLEyePosition(const GLfloat *matrix);
    GLboolean setGLSLModelMatrix(const float *matrix);
    GLboolean setGLSLModelViewMatrix(const GLfloat *matrix);
    GLboolean setGLSLProjectionMatrix(const GLfloat *matrix);
    GLboolean setGLSLNormalMatrix(const GLfloat *matrix);
    GLboolean setGLSLTime(const GLfloat time);
    GLboolean setGLSLLightPosition(const GLfloat *position);
    GLboolean setGLSLTextureMatrix(const GLfloat *matrix);
    GLboolean setGLSLPointCoordMatrix(const GLfloat *matrix);
    GLboolean setGLSLAmbientColor(const GLfloat *color);
    GLboolean setGLSLDiffuseColor(const GLfloat *color, const GLuint index);
    GLboolean setGLSLSpecularColor(const GLfloat *color);
    GLboolean setGLSLSpecularExponent(const GLfloat exponent);
    GLboolean setGLSLTouch(const GLfloat *touch);
    GLboolean setGLSLTouch2(const GLfloat *touch);
    GLboolean setGLSLScr(const GLfloat *touch);
    GLboolean enableGLSLTexture(const unsigned int index, bool enable = true);
    GLboolean enableGLSLNormal(bool enable = true);
    GLboolean enableGLSLVertexColor(bool enable = true);
    GLboolean enableGLSLPointCoord(bool enable = false);
    GLboolean enableGLSLTextureCube(const unsigned int index, bool enable);
    GLboolean setGLSLPointSize(const GLfloat exponent);
    
    //const GLuint getShaderHandle()const;
    //const std::string &getName()const;
    btVector3 getHalfExtends() const;
    btTransform getInitialTransform() const;
    btScalar getBoundingRadius()const;
    const std::string getTextureFileName(const int index)const;

    bool loadTextureName(const unsigned int index, GLuint textureName);
    bool loadTextureID(const unsigned int index, IDType textureFactoryID);
    bool unLoadTexture(const unsigned int index);
    
    GLKTextureInfoWrapper *getTexture(const unsigned int index)const;
    
    bool hasAlphaTexture();
    
    
    
    GLsizei getStride()const
    {
        return m_Stride;
    }
    
    const GLvoid* getPositionOffset()const
    {
        return (const GLvoid*)m_PositionOffset;
    }
//    const GLvoid* getWorldTransformOffset(int row)const
//    {
//        return (const GLvoid*)(m_WorldTransformOffset + (sizeof(float) * (row * 4)));
//    }
    const GLvoid* getNormalOffset()const
    {
        return (const GLvoid*)m_NormalOffset;
    }
    const GLvoid* getColorOffset()const
    {
        return (const GLvoid*)m_ColorOffset;
    }
    const GLvoid* getTextureOffset(const unsigned int index)const
    {
        btAssert(index < 8);
        return (const GLvoid*)m_TextureOffset[index];
    }
    
    bool hasColorAttribute()const
    {
        return (NULL != getColorOffset());
    }
    bool hasNormalAttribute()const
    {
        return (NULL != getNormalOffset());
    }
    bool hasTextureAttribute(const unsigned int index)const
    {
        return (NULL != getTextureOffset(index));
    }
//    bool hasTexture0Attribute()const
//    {
//        return (NULL != getTexture0Offset());
//    }
    
    unsigned int getNumVertices()
    {
        return m_NumVertices;
    }
    
    unsigned int getNumIndices()
    {
        return m_NumIndices;
    }
protected:
    virtual GLvoid setup(const GLuint programHandle)const;
    
    void renderInternal(GLuint vertexBufferArray,
                        GLuint vertexBuffer,
                        GLenum drawmode);
    
    bool isGLHandleValid(const GLuint handle)const;
    
    void updateProgram(const GLuint vertexBufferArray,
                       const GLuint vertexBuffer);
    
#if defined(DEBUG) || defined (_DEBUG)
    void assertFile(const std::string file)
    {
        size_t marker = file.find_last_of(".");
        NSString *fileName = [NSString stringWithUTF8String:file.substr(0, marker).c_str()];
        NSString *extension = [NSString stringWithUTF8String:file.substr(marker + 1).c_str()];
        
        NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:extension];
        
        btAssert(filePath && file.c_str());
    }
#endif
    GLSLUniformValues *m_GLSLUniformValues;
    GLSLUniforms m_GLSLUniforms;
    
private:
    //std::string m_viewObjectName;
    //IDType m_shaderFactoryID;
    GLuint m_vertexArrayBuffer;
    GLuint m_vertexBuffer;
    GLuint m_indexBuffer;
    
    GLsizei m_Stride;
    
    size_t m_PositionOffset;
//    size_t m_WorldTransformOffset;
    size_t m_NormalOffset;
    size_t m_ColorOffset;
    size_t *m_TextureOffset;//[8];
    
    int m_NumVertices;
    int m_NumIndices;
    bool m_SetVertexAttributes;
    
    IDType *m_textureFactoryIDs;//[8];
    IDType *m_textureBehaviorFactoryIDs;//[8];
    
    btAlignedObjectArray<IDType> m_TextureIndices;
};

#endif /* defined(__HelloOpenGL__BaseViewObject__) */
