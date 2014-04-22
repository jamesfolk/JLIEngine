 //
//  BaseViewObject.cpp
//  HelloOpenGL
//
//  Created by James Folk on 2/18/13.
//
//

//static GLuint vbHandle;
//static GLuint ibHandle;
//
//static void example()
//{
//    int vertexCount = 0;
//    int normalCount = 0;
//    int instanceCount = 0;
//    int indexCount = 0;
//    
//    // arrays containing geometry information, to fill as needed
//    float* vertexAndNormalPtr = new float[vertexCount + normalCount];
//    float* centrePtr = new float[instanceCount];
//    int* indexPtr = new int[indexCount];
//
//    // vertex buffer initialization, we put 3d vertices and normals
//    glGenBuffers(1, &vbHandle);
//    glBindBuffer(GL_ARRAY_BUFFER, vbHandle);
//    glBufferData(GL_ARRAY_BUFFER, 3*(vertexCount+normalCount)*sizeof(float), vertexAndNormalPtr, GL_STATIC_DRAW);
//
//    // index buffer
//    glGenBuffers(1, &ibHandle);
//    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibHandle);
//    glBufferData(GL_ELEMENT_ARRAY_BUFFER, indexCount*sizeof(int), indexPtr, GL_STATIC_DRAW);
//
//    
//    GLuint program;
//    // create uniform buffer to store centres, ‘program’ is our compiled shader
//    GLint ulocation = glGetUniformLocation(program, "centres");
//    GLint usize = glGetUniformBufferSize(program, ulocation);
//    GLuint ubuffer;
//    glGenBuffers(1, &ubuffer);
//    glBindBuffer(GL_UNIFORM_BUFFER, ubuffer);
//    glBufferData(GL_UNIFORM_BUFFER, usize, centrePtr, GL_STATIC_READ);
//    glUniformBufferEXT(program, ulocation, ubuffer);
//
//    glUseProgram(program);
//    // Set GL state to draw indexed elements
//    glEnableClientState(GL_VERTEX_ARRAY);
//    glEnableClientState(GL_NORMAL_ARRAY);
//    glBindBufferARB(GL_ARRAY_BUFFER_ARB, vbHandle);
//    glBindBufferARB(GL_ELEMENT_ARRAY_BUFFER, ibHandle);
//    glVertexPointer(3, GL_FLOAT, 0, 0);
//    glNormalPointer(GL_FLOAT, 0, (void*)(3 * vertexCount * sizeof(float)));
//    glDrawElementsInstancedEXT (GL_TRIANGLES, indexCount, GL_UNSIGNED_SHORT, 0, instanceCount );
//    // Reset state
//    glBindBufferARB(GL_ARRAY_BUFFER_ARB, 0);
//    glBindBufferARB(GL_ELEMENT_ARRAY_BUFFER, 0);
//    glDisableClientState(GL_VERTEX_ARRAY);
//    glDisableClientState(GL_NORMAL_ARRAY);
//    // Detach shaders
//    glUseProgram(0);
//}
//
//#version 120 
//#extension GL_EXT_bindable_uniform : enable
//#extension GL_EXT_gpu_shader4 : enable 
//bindable uniform vec4 centres[1000];
//varying vec3 v_Normal;
//void main(void)
//{
//    vec3 centre = centres[ gl_InstanceID ].xyz;
//    vec3 pos = gl_Vertex + centre;
//    v_Normal = gl_NormalMatrix * gl_Normal;
//    gl_Position = gl_ModelViewProjectionMatrix * vec4(pos, 1.0);
//}

#include "BaseViewObject.h"
#include "btVector3.h"
#include "btTransform.h"
//#include "ShaderResourceLoader.h"
//#include "ResourceManager.h"

#include "ShaderFactory.h"
#include "CameraFactory.h"
#include "btVector2.h"



#include "BulletCollision/CollisionShapes/btTriangleMesh.h"
#include "BulletCollision/CollisionShapes/btConvexHullShape.h"

#include "BaseTextureBehavior.h"
#include "TextureFactoryIncludes.h"

#include "ZipFileResourceLoader.h"

//#define check_gl_error() _check_gl_error(__FILE__,__LINE__,__FUNCTION__);
#include "VertexBufferObject.h"

static float s_textureMatrix[16] =
{
    1.0f, 0.0f, 0.0f, 0.0f,
    0.0f, 1.0f, 0.0f, 0.0f,
    0.0f, 0.0f, 1.0f, 0.0f,
    0.0f, 0.0f, 0.0f, 1.0f
};
static float s_pointCoordMatrix[16] =
{
    1.0f, 0.0f, 0.0f, 0.0f,
    0.0f, 1.0f, 0.0f, 0.0f,
    0.0f, 0.0f, 1.0f, 0.0f,
    0.0f, 0.0f, 0.0f, 1.0f
};

static float s_lightPosition[4]         = {0.00, -1.00, 0.00, 0.00};
static float s_materialAmbientColor[4]  = {0.00, 0.00, 0.00, 1.00};
static float s_materialDiffuseColor0[4] = {1.00, 0.00, 0.00, 1.0f};
static float s_materialDiffuseColor1[4] = {0.00, 1.00, 0.00, 1.0f};
static float s_materialDiffuseColor2[4] = {0.00, 0.00, 1.00, 1.0f};
static float s_materialDiffuseColor3[4] = {0.50, 0.00, 0.00, 1.0f};
static float s_materialSpecularColor[4] = {1.00, 1.00, 1.00, 1.0f};
static int s_materialSpecularExponent   = 100;
static float s_touch[2] = {0.0f, 0.0f};
static float s_touch2[2] = {0.0f, 0.0f};
static float s_scr[2] = {0.0f, 0.0f};

const char *const GLSL_ATTRIBUTE_transformmatrix = "transformmatrix";
const char *const GLSL_ATTRIBUTE_position = "position";
const char *const GLSL_ATTRIBUTE_normal = "normal";
const char *const GLSL_ATTRIBUTE_textureCoord[8] =
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
//const char *GLSL_ATTRIBUTE_textureCoord0 = "textureCoord0";
const char *const GLSL_ATTRIBUTE_color = "color";

const char *const GLSL_UNIFORM_modelViewProjectionMatrix = "modelViewProjectionMatrix";
const char *const GLSL_UNIFORM_eyePosition = "eyePosition";
const char *const GLSL_UNIFORM_modelMatrix = "modelMatrix";
const char *const GLSL_UNIFORM_modelViewMatrix = "modelViewMatrix";
const char *const GLSL_UNIFORM_projectionMatrix = "projectionMatrix";
const char *const GLSL_UNIFORM_normalMatrix = "normalMatrix";
const char *const GLSL_UNIFORM_time = "time";
const char *const GLSL_UNIFORM_lightPosition = "lightPosition";
const char *const GLSL_UNIFORM_textureMatrix = "textureMatrix";
const char *const GLSL_UNIFORM_pointCoordMatrix = "pointCoordMatrix";
const char *const GLSL_UNIFORM_materialAmbientColor = "materialAmbientColor";
const char *const GLSL_UNIFORM_materialDiffuseColor0 = "materialDiffuseColor0";
const char *const GLSL_UNIFORM_materialDiffuseColor1 = "materialDiffuseColor1";
const char *const GLSL_UNIFORM_materialDiffuseColor2 = "materialDiffuseColor2";
const char *const GLSL_UNIFORM_materialDiffuseColor3 = "materialDiffuseColor3";
const char *const GLSL_UNIFORM_materialSpecularColor = "materialSpecularColor";
const char *const GLSL_UNIFORM_materialSpecularExponent= "materialSpecularExponent";

const char *const GLSL_UNIFORM_texture[8] =
{
    "texture0",
    "texture1",
    "texture2",
    "texture3",
    "texture4",
    "texture5",
    "texture6",
    "texture7"
};

//const char *GLSL_UNIFORM_texture0 = "texture0";
//const char *GLSL_UNIFORM_texture1 = "texture1";

const char *const GLSL_UNIFORM_touch = "touch";
const char *const GLSL_UNIFORM_scr = "scr";
const char *const GLSL_UNIFORM_touch2 = "touch2";

const char *const GLSL_UNIFORM_enableTexture[8] =
{
    "enableTexture0",
    "enableTexture1",
    "enableTexture2",
    "enableTexture3",
    "enableTexture4",
    "enableTexture5",
    "enableTexture6",
    "enableTexture7"
};

const char *const GLSL_UNIFORM_enableVertexColor = "enableVertexColor";
const char *const GLSL_UNIFORM_enableNormal = "enableNormal";
const char *const GLSL_UNIFORM_pointSize = "pointSize";
const char *const GLSL_UNIFORM_enablePointCoord = "enablePointCoord";
const char *const GLSL_UNIFORM_enableTextureCube[8] =
{
    "enableTextureCube0",
    "enableTextureCube1",
    "enableTextureCube2",
    "enableTextureCube3",
    "enableTextureCube4",
    "enableTextureCube5",
    "enableTextureCube6",
    "enableTextureCube7"
};

/*
 touch;
 scr;
 touch2;
 */

GLboolean BaseViewObject::setGLSLUniforms(const btTransform &modelView, const btTransform &projection, const btTransform &model)
{
    GLfloat m[16];
    
    modelView.getOpenGLMatrix(m);
    GLboolean ret = this->setGLSLModelViewMatrix(m);
    
    projection.getOpenGLMatrix(m);
    ret &= this->setGLSLProjectionMatrix(m);
    
    model.getOpenGLMatrix(m);
    ret &= this->setGLSLModelMatrix(m);
    
    return ret;
}

GLboolean BaseViewObject::setGLSLUniforms(const btTransform &modelViewProjection, const btTransform &transformMatrix)
{
    GLfloat m[16];
    
    modelViewProjection.getOpenGLMatrix(m);
    GLboolean ret = this->setGLSLModelViewProjectionMatrix(m);
    
    transformMatrix.getOpenGLMatrix(m);
    ret &= this->setGLSLModelMatrix(m);
    
    return ret;
}

GLboolean BaseViewObject::setGLSLModelViewProjectionMatrix(const GLfloat *matrix)
{
    GLint cp;
    glGetIntegerv(GL_CURRENT_PROGRAM, &cp);
    
    if(matrix &&
       /*glIsProgram(cp) &&*/
       isGLHandleValid(m_GLSLUniforms.modelViewProjectionMatrix))
    {
        glUniformMatrix4fv(m_GLSLUniforms.modelViewProjectionMatrix, 1, 0, matrix);check_gl_error()
        return GL_TRUE;
    }
    return GL_FALSE;
}

GLboolean BaseViewObject::setGLSLModelMatrix(const float *matrix)
{
    GLint cp;
    glGetIntegerv(GL_CURRENT_PROGRAM, &cp);
    
    if(matrix &&
       /*glIsProgram(cp) &&*/
       isGLHandleValid(m_GLSLUniforms.modelMatrix))
    {
        glUniformMatrix4fv(m_GLSLUniforms.modelMatrix, 1, 0, matrix);check_gl_error()
        return GL_TRUE;
    }
    return GL_FALSE;
}
//
GLboolean BaseViewObject::setGLSLEyePosition(const GLfloat *position)
{
    GLint cp;
    glGetIntegerv(GL_CURRENT_PROGRAM, &cp);
    
    if(position &&
       /*glIsProgram(cp) &&*/
       isGLHandleValid(m_GLSLUniforms.eyePosition))
    {
        glUniform3fv(m_GLSLUniforms.eyePosition, 1, position);check_gl_error()
        return GL_TRUE;
    }
    return GL_FALSE;
}

GLboolean BaseViewObject::setGLSLModelViewMatrix(const GLfloat *matrix)
{
    GLint cp;
    glGetIntegerv(GL_CURRENT_PROGRAM, &cp);
    
    if(matrix &&
       /*glIsProgram(cp) &&*/
       isGLHandleValid(m_GLSLUniforms.modelViewMatrix))
    {
        glUniformMatrix4fv(m_GLSLUniforms.modelViewMatrix, 1, 0, matrix);check_gl_error()
        return GL_TRUE;
    }
    return GL_FALSE;
}

GLboolean BaseViewObject::setGLSLProjectionMatrix(const GLfloat *matrix)
{
    GLint cp;
    glGetIntegerv(GL_CURRENT_PROGRAM, &cp);
    
    if(matrix &&
       /*glIsProgram(cp) &&*/
       isGLHandleValid(m_GLSLUniforms.projectionMatrix))
    {
        glUniformMatrix4fv(m_GLSLUniforms.projectionMatrix, 1, 0, matrix);check_gl_error()
        return GL_TRUE;
    }
    return GL_FALSE;
}

GLboolean BaseViewObject::setGLSLNormalMatrix(const GLfloat *matrix)
{
    GLint cp;
    glGetIntegerv(GL_CURRENT_PROGRAM, &cp);
    
    if(matrix &&
       /*glIsProgram(cp) &&*/
       isGLHandleValid(m_GLSLUniforms.normalMatrix))
    {
        glUniformMatrix3fv(m_GLSLUniforms.normalMatrix, 1, 0, matrix);check_gl_error()
        return GL_TRUE;
    }
    return GL_FALSE;
}

GLboolean BaseViewObject::setGLSLTime(const GLfloat time)
{
    GLint cp;
    glGetIntegerv(GL_CURRENT_PROGRAM, &cp);
    
    if(/*glIsProgram(cp) &&*/
       isGLHandleValid(m_GLSLUniforms.time))
    {
        glUniform1f(m_GLSLUniforms.time, time);check_gl_error()
        return GL_TRUE;
    }
    return GL_FALSE;
}

GLboolean BaseViewObject::setGLSLLightPosition(const GLfloat *position)
{
    GLint cp;
    glGetIntegerv(GL_CURRENT_PROGRAM, &cp);
    
    if(position &&
       /*glIsProgram(cp) &&*/
       isGLHandleValid(m_GLSLUniforms.lightPosition))
    {
        glUniform4fv(m_GLSLUniforms.lightPosition, 1, position);check_gl_error()
        return GL_TRUE;
    }
    return GL_FALSE;
}

GLboolean BaseViewObject::setGLSLTextureMatrix(const GLfloat *matrix)
{
    GLint cp;
    glGetIntegerv(GL_CURRENT_PROGRAM, &cp);
    
    if(matrix &&
       /*glIsProgram(cp) &&*/
       isGLHandleValid(m_GLSLUniforms.textureMatrix))
    {
        glUniformMatrix4fv(m_GLSLUniforms.textureMatrix, 1, 0, matrix);check_gl_error()
        return GL_TRUE;
    }
    return GL_FALSE;
}//

GLboolean BaseViewObject::setGLSLPointCoordMatrix(const GLfloat *matrix)
{
    GLint cp;
    glGetIntegerv(GL_CURRENT_PROGRAM, &cp);
    
    if(matrix &&
       /*glIsProgram(cp) &&*/
       isGLHandleValid(m_GLSLUniforms.pointCoordMatrix))
    {
        glUniformMatrix4fv(m_GLSLUniforms.pointCoordMatrix, 1, 0, matrix);check_gl_error()
        return GL_TRUE;
    }
    return GL_FALSE;
}

GLboolean BaseViewObject::setGLSLAmbientColor(const GLfloat *color)
{
    GLint cp;
    glGetIntegerv(GL_CURRENT_PROGRAM, &cp);
    
    if(color &&
       /*glIsProgram(cp) &&*/
       isGLHandleValid(m_GLSLUniforms.materialAmbientColor))
    {
        glUniform4fv(m_GLSLUniforms.materialAmbientColor, 1, color);check_gl_error()
        return GL_TRUE;
    }
    return GL_FALSE;
}

GLboolean BaseViewObject::setGLSLDiffuseColor(const GLfloat *color, const GLuint index)
{
//    GLint cp;
//    glGetIntegerv(GL_CURRENT_PROGRAM, &cp);
//    
//    if(/*glIsProgram(cp) &&*/
//       isGLHandleValid
    GLboolean ret = GL_FALSE;
    
    switch (index)
    {
        case 0:
            if(color && isGLHandleValid(m_GLSLUniforms.materialDiffuseColor0))
            {
                glUniform4fv(m_GLSLUniforms.materialDiffuseColor0, 1, color);check_gl_error()
                ret = GL_TRUE;
            }
            break;
        case 1:
            if(color && isGLHandleValid(m_GLSLUniforms.materialDiffuseColor1))
            {
                glUniform4fv(m_GLSLUniforms.materialDiffuseColor1, 1, color);check_gl_error()
                ret = GL_TRUE;
            }
            break;
        case 2:
            if(color && isGLHandleValid(m_GLSLUniforms.materialDiffuseColor2))
            {
                glUniform4fv(m_GLSLUniforms.materialDiffuseColor2, 1, color);check_gl_error()
                ret = GL_TRUE;
            }            break;
        case 3:
            if(color && isGLHandleValid(m_GLSLUniforms.materialDiffuseColor3))
            {
                glUniform4fv(m_GLSLUniforms.materialDiffuseColor3, 1, color);check_gl_error()
                ret = GL_TRUE;
            }
            break;
            
        default:
            break;
    }
    
    
    return ret;
}

GLboolean BaseViewObject::setGLSLSpecularColor(const GLfloat *color)
{
    GLint cp;
    glGetIntegerv(GL_CURRENT_PROGRAM, &cp);
    
    if(color &&
       /*glIsProgram(cp) &&*/
       isGLHandleValid(m_GLSLUniforms.materialSpecularColor))
    {
        glUniform4fv(m_GLSLUniforms.materialSpecularColor, 1, color);check_gl_error()
        return GL_TRUE;
    }
    return GL_FALSE;
}

GLboolean BaseViewObject::setGLSLSpecularExponent(const GLfloat exponent)
{
    GLint cp;
    glGetIntegerv(GL_CURRENT_PROGRAM, &cp);
    
    if(/*glIsProgram(cp) &&*/
       isGLHandleValid(m_GLSLUniforms.materialSpecularExponent))
    {
        glUniform1f(m_GLSLUniforms.materialSpecularExponent, exponent);check_gl_error()
        return GL_TRUE;
    }
    return GL_FALSE;
}
/*
touch
scr
touch2
*/
GLboolean BaseViewObject::setGLSLTouch(const GLfloat *touch)
{
    GLint cp;
    glGetIntegerv(GL_CURRENT_PROGRAM, &cp);
    
    if(touch &&
       /*glIsProgram(cp) &&*/
       isGLHandleValid(m_GLSLUniforms.touch))
    {
        glUniform2fv (m_GLSLUniforms.touch, 1, touch);check_gl_error()
        return GL_TRUE;
    }
    return GL_FALSE;
}
GLboolean BaseViewObject::setGLSLTouch2(const GLfloat *touch)
{
    GLint cp;
    glGetIntegerv(GL_CURRENT_PROGRAM, &cp);
    
    if(touch &&
       /*glIsProgram(cp) &&*/
       isGLHandleValid(m_GLSLUniforms.touch2))
    {
        glUniform2fv (m_GLSLUniforms.touch2, 1, touch);check_gl_error()
        return GL_TRUE;
    }
    return GL_FALSE;
}
GLboolean BaseViewObject::setGLSLScr(const GLfloat *touch)
{
    GLint cp;
    glGetIntegerv(GL_CURRENT_PROGRAM, &cp);
    
    if(touch &&
       /*glIsProgram(cp) &&*/
       isGLHandleValid(m_GLSLUniforms.scr))
    {
        glUniform2fv (m_GLSLUniforms.scr, 1, touch);check_gl_error()
        return GL_TRUE;
    }
    return GL_FALSE;
}

GLboolean BaseViewObject::enableGLSLTexture(const unsigned int index, bool enable)
{
    btAssert(index < 8);
    
    GLboolean value = (enable)?GL_TRUE:GL_FALSE;
    m_GLSLUniformValues->enableTexture[index] = value;
    
    GLint cp;
    glGetIntegerv(GL_CURRENT_PROGRAM, &cp);
    
    if(glIsProgram(cp) &&
       isGLHandleValid(m_GLSLUniforms.enableTexture[index]))
    {
        
        
        
        glUniform1i(m_GLSLUniforms.enableTexture[index], value);check_gl_error()
        return GL_TRUE;
    }
    return GL_FALSE;
}

GLboolean BaseViewObject::enableGLSLVertexColor(bool enable)
{
    GLboolean value = (enable)?GL_TRUE:GL_FALSE;
    m_GLSLUniformValues->enableVertexColor = value;
    
    GLint cp;
    glGetIntegerv(GL_CURRENT_PROGRAM, &cp);
    
    if(glIsProgram(cp) &&
       isGLHandleValid(m_GLSLUniforms.enableVertexColor))
    {
        
        
        
        glUniform1i(m_GLSLUniforms.enableVertexColor, value);check_gl_error()
        return GL_TRUE;
    }
    return GL_FALSE;
}

GLboolean BaseViewObject::enableGLSLNormal(bool enable)
{
    GLboolean value = (enable)?GL_TRUE:GL_FALSE;
    m_GLSLUniformValues->enableNormal = value;
    
    GLint cp;
    glGetIntegerv(GL_CURRENT_PROGRAM, &cp);
    
    if(glIsProgram(cp) &&
       isGLHandleValid(m_GLSLUniforms.enableNormal))
    {
        
        
        
        glUniform1i(m_GLSLUniforms.enableNormal, value);check_gl_error()
        return GL_TRUE;
    }
    return GL_FALSE;
}

//enablePointCoord
GLboolean BaseViewObject::enableGLSLPointCoord(bool enable)
{
    GLint cp;
    glGetIntegerv(GL_CURRENT_PROGRAM, &cp);
    
    if(/*glIsProgram(cp) &&*/
       isGLHandleValid(m_GLSLUniforms.enablePointCoord))
    {
        GLboolean value = (enable)?GL_TRUE:GL_FALSE;
        
        m_GLSLUniformValues->enablePointCoord = value;
        glUniform1i(m_GLSLUniforms.enablePointCoord, value);check_gl_error()
        return GL_TRUE;
    }
    return GL_FALSE;
}

GLboolean BaseViewObject::enableGLSLTextureCube(const unsigned int index, bool enable)
{
    btAssert(index < 8);
    
    GLint cp;
    glGetIntegerv(GL_CURRENT_PROGRAM, &cp);
    
    if(/*glIsProgram(cp) &&*/
       isGLHandleValid(m_GLSLUniforms.enableTextureCube[index]))
    {
        GLboolean value = (enable)?GL_TRUE:GL_FALSE;
        
        m_GLSLUniformValues->enableTextureCube[index] = value;
        glUniform1i(m_GLSLUniforms.enableTextureCube[index], value);check_gl_error()
        return GL_TRUE;
    }
    return GL_FALSE;
}

GLboolean BaseViewObject::setGLSLPointSize(const GLfloat pointSize)
{
    GLint cp;
    glGetIntegerv(GL_CURRENT_PROGRAM, &cp);
    
    if(/*glIsProgram(cp) &&*/
       isGLHandleValid(m_GLSLUniforms.pointSize))
    {
        m_GLSLUniformValues->pointSize = pointSize;
        glUniform1f(m_GLSLUniforms.pointSize, pointSize);check_gl_error()
        return GL_TRUE;
    }
    return GL_FALSE;
}
//const GLuint BaseViewObject::getShaderHandle()const
//{
//    return ShaderFactory::getInstance()->get(m_shaderFactoryID)->m_ShaderProgramHandle;
//}
//const std::string &BaseViewObject::getName()const
//{
//    return m_viewObjectName;
//}

btVector3 BaseViewObject::getHalfExtends() const
{
    const BaseMeshObject *mo = ZipFileResourceLoader::getInstance()->getMeshObject(getName());
    
    if(mo)
        mo->getHalfExtends();
    
    return btVector3(0,0,0);
}

btTransform BaseViewObject::getInitialTransform() const
{
    const BaseMeshObject *mo = ZipFileResourceLoader::getInstance()->getMeshObject(getName());
    
    if(mo)
        mo->getWorldTransform();
    
    return btTransform::getIdentity();
}

btScalar BaseViewObject::getBoundingRadius()const
{
    btScalar boundingRadius = btMax(getHalfExtends().getX(), getHalfExtends().getY());
    return btMax(boundingRadius, getHalfExtends().getZ());
    
}

const std::string BaseViewObject::getTextureFileName(const int index)const
{
    btAssert(index < 2);
 
    return ZipFileResourceLoader::getInstance()->getMeshObject(getName())->getUVImage(index);
}

BaseViewObject::BaseViewObject(const BaseViewObjectInfo& constructionInfo) :
m_GLSLUniformValues(new GLSLUniformValues),
//m_viewObjectName(constructionInfo.m_viewObjectName),
m_vertexArrayBuffer(0),
m_vertexBuffer(0),
m_indexBuffer(0),
m_Stride(0),
m_PositionOffset(0),
m_NormalOffset(0),
m_ColorOffset(0),
m_TextureOffset(new size_t[8]),
m_NumVertices(0),
m_NumIndices(0),
m_SetVertexAttributes(false),
m_textureFactoryIDs(new IDType[8]),
m_textureBehaviorFactoryIDs(new IDType[8])
{
    setName(constructionInfo.m_viewObjectName);
    
    memset(m_TextureOffset, 0, sizeof(size_t) * 8);
    memcpy(m_textureFactoryIDs, constructionInfo.m_textureFactoryIDs, sizeof(IDType) * 8);
    memcpy(m_textureBehaviorFactoryIDs, constructionInfo.m_textureBehaviorFactoryIDs, sizeof(IDType) * 8);
    
    setGLSLLightPosition(s_lightPosition);
    
    for(int i = 0; i < 16; i++)
    {
        m_GLSLUniformValues->textureMatrix[i] = s_textureMatrix[i];
    }
    //pointCoordMatrix
    for(int i = 0; i < 16; i++)
    {
        m_GLSLUniformValues->pointCoordMatrix[i] = s_pointCoordMatrix[i];
    }
    
    setGLSLAmbientColor(s_materialAmbientColor);
    setGLSLDiffuseColor(s_materialDiffuseColor0, 0);
    setGLSLDiffuseColor(s_materialDiffuseColor1, 1);
    setGLSLDiffuseColor(s_materialDiffuseColor2, 2);
    setGLSLDiffuseColor(s_materialDiffuseColor3, 3);
    setGLSLSpecularColor(s_materialSpecularColor);
    setGLSLSpecularExponent(s_materialSpecularExponent);
    
    
    setGLSLTouch(s_touch);
    setGLSLTouch2(s_touch2);
    
    for(int i = 0; i < 8; i++)
    {
        if(getTextureBehavior(i))
        {
            getTextureBehavior(i)->setOwner(this);
        }
        
        if(constructionInfo.m_textureFactoryIDs[i])
            loadTextureID(i, constructionInfo.m_textureFactoryIDs[i]);
    }
    
}
BaseViewObject::~BaseViewObject()
{
    unLoad();
    
    for(int i = 0; i < 8; i++)
    {
        unLoadTexture(i);
    }
    
    delete [] m_textureBehaviorFactoryIDs;
    m_textureBehaviorFactoryIDs = NULL;
    
    delete [] m_textureFactoryIDs;
    m_textureFactoryIDs = NULL;
    
    delete [] m_TextureOffset;
    m_TextureOffset = NULL;
    
    delete m_GLSLUniformValues;
    m_GLSLUniformValues = NULL;
}

void BaseViewObject::renderInternal(GLuint vertexBufferArray,
                                    GLuint vertexBuffer,
                                    GLenum drawmode)
{
    return;
    glBindVertexArrayOES(vertexBufferArray);check_gl_error()
    glBindBuffer(GL_ARRAY_BUFFER,vertexBuffer);check_gl_error()
    
    s_scr[0] = CameraFactory::getScreenWidth();
    s_scr[1] = CameraFactory::getScreenHeight();
    
    setGLSLScr(s_scr);

    for(int i = 0; i < 8; i++)
    {
        if(m_GLSLUniformValues->texture[i] &&
           isGLHandleValid(m_GLSLUniforms.texture[i]))
        {
            glActiveTexture(GL_TEXTURE0 + i);check_gl_error()
            glBindTexture(m_GLSLUniformValues->texture[i]->target,
                          m_GLSLUniformValues->texture[i]->name);
        }
        else if(isGLHandleValid(m_GLSLUniformValues->textureName[i]))
        {
            glActiveTexture(GL_TEXTURE0 + i);check_gl_error()
            glBindTexture(GL_TEXTURE_2D,
                          m_GLSLUniformValues->textureName[i]);
        }
        glUniform1i(m_GLSLUniforms.texture[i], 0);
        
        if(isGLHandleValid(m_GLSLUniforms.enableTexture[i]))
            enableGLSLTexture(i, m_GLSLUniformValues->enableTexture[i]);
        if(isGLHandleValid(m_GLSLUniforms.enableTextureCube[i]))
            enableGLSLTextureCube(i, m_GLSLUniformValues->enableTextureCube[i]);
    }
    
    if(isGLHandleValid(m_GLSLUniforms.enableVertexColor))
        enableGLSLVertexColor(m_GLSLUniformValues->enableVertexColor);
    
    if(isGLHandleValid(m_GLSLUniforms.enableNormal))
        enableGLSLNormal(m_GLSLUniformValues->enableNormal);
    
    if(isGLHandleValid(m_GLSLUniforms.enablePointCoord))
        enableGLSLPointCoord(m_GLSLUniformValues->enablePointCoord);
    
    if(isGLHandleValid(m_GLSLUniforms.pointSize))
        setGLSLPointSize(m_GLSLUniformValues->pointSize);
    
    if(isGLHandleValid(m_GLSLUniforms.textureMatrix))
        setGLSLTextureMatrix(m_GLSLUniformValues->textureMatrix);
    
    if(isGLHandleValid(m_GLSLUniforms.pointCoordMatrix))
        setGLSLPointCoordMatrix(m_GLSLUniformValues->pointCoordMatrix);
    
    if(0 != m_indexBuffer)
    {
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_indexBuffer);check_gl_error()
        glDrawElements(drawmode, m_NumIndices, GL_UNSIGNED_SHORT, 0);check_gl_error()
        
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);check_gl_error()
    }
    else
    {
        glDrawArrays(drawmode, 0, m_NumVertices);check_gl_error()
    }
    
    glBindBuffer(GL_ARRAY_BUFFER,0);check_gl_error()
    glBindVertexArrayOES(0);check_gl_error()
    
}

bool BaseViewObject::isGLHandleValid(const GLuint handle)const
{
    return (GL_INVALID_VALUE != handle);
}

void BaseViewObject::updateProgram(const GLuint vertexBufferArray,
                                   const GLuint vertexBuffer)
{
    btAssert(vertexBufferArray != 0);
    btAssert(vertexBuffer != 0);
    
    GLuint programHandle = ShaderFactory::getInstance()->getCurrentShaderID(); //getShaderHandle();
    
    glBindVertexArrayOES(vertexBufferArray);check_gl_error()
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);check_gl_error()
    
    setup(programHandle);
    
    glBindBuffer(GL_ARRAY_BUFFER,0);check_gl_error()
    glBindVertexArrayOES(0);check_gl_error()
    
    m_GLSLUniforms.modelViewProjectionMatrix = glGetUniformLocation(programHandle, GLSL_UNIFORM_modelViewProjectionMatrix);
    m_GLSLUniforms.modelMatrix               = glGetUniformLocation(programHandle, GLSL_UNIFORM_modelMatrix);
    m_GLSLUniforms.eyePosition               = glGetUniformLocation(programHandle, GLSL_UNIFORM_eyePosition);
    m_GLSLUniforms.modelViewMatrix           = glGetUniformLocation(programHandle, GLSL_UNIFORM_modelViewMatrix);
    m_GLSLUniforms.projectionMatrix          = glGetUniformLocation(programHandle, GLSL_UNIFORM_projectionMatrix);
    m_GLSLUniforms.normalMatrix              = glGetUniformLocation(programHandle, GLSL_UNIFORM_normalMatrix);
    m_GLSLUniforms.time                      = glGetUniformLocation(programHandle, GLSL_UNIFORM_time);
    m_GLSLUniforms.lightPosition             = glGetUniformLocation(programHandle, GLSL_UNIFORM_lightPosition);
    m_GLSLUniforms.textureMatrix = glGetUniformLocation(programHandle, GLSL_UNIFORM_textureMatrix);
    m_GLSLUniforms.pointCoordMatrix = glGetUniformLocation(programHandle, GLSL_UNIFORM_pointCoordMatrix);
    m_GLSLUniforms.materialAmbientColor      = glGetUniformLocation(programHandle, GLSL_UNIFORM_materialAmbientColor);
    m_GLSLUniforms.materialDiffuseColor0     = glGetUniformLocation(programHandle, GLSL_UNIFORM_materialDiffuseColor0);
    m_GLSLUniforms.materialDiffuseColor1     = glGetUniformLocation(programHandle, GLSL_UNIFORM_materialDiffuseColor1);
    m_GLSLUniforms.materialDiffuseColor2     = glGetUniformLocation(programHandle, GLSL_UNIFORM_materialDiffuseColor2);
    m_GLSLUniforms.materialDiffuseColor3     = glGetUniformLocation(programHandle, GLSL_UNIFORM_materialDiffuseColor3);
    m_GLSLUniforms.materialSpecularColor     = glGetUniformLocation(programHandle, GLSL_UNIFORM_materialSpecularColor);
    m_GLSLUniforms.materialSpecularExponent  = glGetUniformLocation(programHandle, GLSL_UNIFORM_materialSpecularExponent);
    
    m_GLSLUniforms.touch                  = glGetUniformLocation(programHandle, GLSL_UNIFORM_touch);
    m_GLSLUniforms.scr                  = glGetUniformLocation(programHandle, GLSL_UNIFORM_scr);
    m_GLSLUniforms.touch2                  = glGetUniformLocation(programHandle, GLSL_UNIFORM_touch2);
    
    for(int i = 0; i < 8; i++)
    {
        m_GLSLUniforms.texture[i] = glGetUniformLocation(programHandle, GLSL_UNIFORM_texture[i]);
        m_GLSLUniforms.enableTexture[i] = glGetUniformLocation(programHandle, GLSL_UNIFORM_enableTexture[i]);
        m_GLSLUniforms.enableTextureCube[i] = glGetUniformLocation(programHandle, GLSL_UNIFORM_enableTextureCube[i]);
    }
    
    m_GLSLUniforms.enableVertexColor = glGetUniformLocation(programHandle, GLSL_UNIFORM_enableVertexColor);
    m_GLSLUniforms.enableNormal = glGetUniformLocation(programHandle, GLSL_UNIFORM_enableNormal);
    
    m_GLSLUniforms.enablePointCoord = glGetUniformLocation(programHandle, GLSL_UNIFORM_enablePointCoord);
    m_GLSLUniforms.pointSize = glGetUniformLocation(programHandle, GLSL_UNIFORM_pointSize);
    
}

bool BaseViewObject::loadTextureName(const unsigned int index, GLuint textureName)
{
    btAssert(index < 8);
    
    unLoadTexture(index);
    
    m_textureFactoryIDs[index] = 0;
    
    //m_GLSLUniformValues->texture[index] = nil;
    m_GLSLUniformValues->texture[index] = NULL;
    
    m_GLSLUniformValues->textureName[index] = textureName;
    
    m_GLSLUniformValues->enableTextureCube[index] = false;
    
    m_TextureIndices.push_back(index);
    return true;
}

bool BaseViewObject::loadTextureID(const unsigned int index, IDType textureFactoryID)
{
    btAssert(index < 8);
    
    unLoadTexture(index);
    
    m_textureFactoryIDs[index] = textureFactoryID;
    
    GLKTextureInfoWrapper *textureInfoWrapper = TextureFactory::getInstance()->get(textureFactoryID);
    
    //btAssert(NULL != textureInfoWrapper->m_GLKTextureInfo);
    
    m_GLSLUniformValues->texture[index] = textureInfoWrapper->m_GLKTextureInfo;
    
    m_GLSLUniformValues->textureName[index] = GL_INVALID_VALUE;
    
    m_GLSLUniformValues->enableTextureCube[index] = (m_GLSLUniformValues->texture[index]->target == GL_TEXTURE_CUBE_MAP)?true:false;
//    m_GLSLUniformValues->enableTextureCube[index] = (m_GLSLUniformValues->texture[index].target == GL_TEXTURE_CUBE_MAP)?true:false;
    
    m_TextureIndices.push_back(index);
    return true;

}
bool BaseViewObject::unLoadTexture(const unsigned int index)
{
    btAssert(index < 8);
    
    m_textureFactoryIDs[index] = 0;
    //m_GLSLUniformValues->texture[index] = nil;
    m_GLSLUniformValues->texture[index] = NULL;
    m_GLSLUniformValues->textureName[index] = GL_INVALID_VALUE;
    m_TextureIndices.remove(index);
    
    return true;
}

GLKTextureInfoWrapper *BaseViewObject::getTexture(const unsigned int index)const
{
    btAssert(index < 8);
    
    IDType _id = m_textureFactoryIDs[index];
    return TextureFactory::getInstance()->get(_id);
}

bool BaseViewObject::hasAlphaTexture()
{
    IDType indice = 0;
    for (int i = 0; i < m_TextureIndices.size(); i++)
    {
        indice = m_TextureIndices[i];
        
        GLKTextureInfoWrapper *infowrap = getTexture(indice);
        if(infowrap)
        {
            if(infowrap->isTranslucent())
                return true;
        }
    }
    
    return false;
}

void BaseViewObject::render(GLenum drawmode)
{
    if(isLoaded())
        renderInternal(m_vertexArrayBuffer, m_vertexBuffer, drawmode);
}

void BaseViewObject::setShaderFactoryID(const IDType ID)
{
    //m_shaderFactoryID = ID;
    if(isLoaded())
        updateProgram(m_vertexArrayBuffer, m_vertexBuffer);
}

GLboolean BaseViewObject::load(GLsizeiptr array_size, const GLvoid* array_data,
                               GLenum array_usage)
{
    if(m_SetVertexAttributes && !isLoaded())
    {
        m_SetVertexAttributes = false;
        
        glGenVertexArraysOES(1, &m_vertexArrayBuffer);check_gl_error()
        glBindVertexArrayOES(m_vertexArrayBuffer);check_gl_error()
        
        glGenBuffers(1, &m_vertexBuffer);check_gl_error()
        glBindBuffer(GL_ARRAY_BUFFER, m_vertexBuffer);check_gl_error()
        
        glBufferData(GL_ARRAY_BUFFER,
                     array_size,
                     array_data,
                     array_usage);check_gl_error()
        
        glBindBuffer(GL_ARRAY_BUFFER,0);check_gl_error()
        glBindVertexArrayOES(0);check_gl_error()
        
        updateProgram(m_vertexArrayBuffer, m_vertexBuffer);
        
        for (int i = 0; i < 8; ++i)
        {
            if(getTextureBehavior(i))
                getTextureBehavior(i)->load();
        }
        
        return isLoaded();
    }
    return GL_FALSE;
}


GLboolean BaseViewObject::load(GLsizeiptr indice_size, const GLvoid* indice_data,
                               GLsizeiptr array_size, const GLvoid* array_data,
                               GLenum indice_usage,
                               GLenum array_usage)
{
    if(m_SetVertexAttributes && !isLoaded())
    {
        m_SetVertexAttributes = false;
        
        glGenVertexArraysOES(1, &m_vertexArrayBuffer);check_gl_error()
        glBindVertexArrayOES(m_vertexArrayBuffer);check_gl_error()
        
        glGenBuffers(1, &m_vertexBuffer);check_gl_error()
        glBindBuffer(GL_ARRAY_BUFFER, m_vertexBuffer);check_gl_error()
        
        glBufferData(GL_ARRAY_BUFFER,
                     array_size,
                     array_data,
                     array_usage);check_gl_error()
        
        
        glGenBuffers(1, &m_indexBuffer);check_gl_error()
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_indexBuffer);check_gl_error()
        glBufferData(GL_ELEMENT_ARRAY_BUFFER,
                     indice_size,
                     indice_data,
                     indice_usage);check_gl_error()
        
        
        
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);check_gl_error()
        glBindBuffer(GL_ARRAY_BUFFER,0);check_gl_error()
        glBindVertexArrayOES(0);check_gl_error()
        
        updateProgram(m_vertexArrayBuffer, m_vertexBuffer);
        
        for (int i = 0; i < 8; ++i)
        {
            if(getTextureBehavior(i))
                getTextureBehavior(i)->load();
        }
        
        return isLoaded();
    }
    return GL_FALSE;
}

GLboolean BaseViewObject::reLoad(GLsizeiptr size, const GLvoid* data)
{
    if(m_SetVertexAttributes && isLoaded())
    {
        m_SetVertexAttributes = false;
        
        glBindVertexArrayOES(m_vertexArrayBuffer);check_gl_error()
        glBindBuffer( GL_ARRAY_BUFFER, m_vertexBuffer );check_gl_error()
        
        glMapBufferOES( GL_ARRAY_BUFFER, GL_WRITE_ONLY_OES );check_gl_error()
        
        void *ptr = NULL;
        glGetBufferPointervOES( GL_ARRAY_BUFFER, GL_BUFFER_MAP_POINTER_OES, &ptr );check_gl_error()
        
        memcpy(ptr, data, size);
        
        glBindVertexArrayOES(m_vertexArrayBuffer);check_gl_error()
        glBindBuffer( GL_ARRAY_BUFFER, m_vertexBuffer );check_gl_error()
        
        glUnmapBufferOES( GL_ARRAY_BUFFER );check_gl_error()
        
        glBindBuffer(GL_ARRAY_BUFFER,0);check_gl_error()
        glBindVertexArrayOES(0);check_gl_error()
        
        updateProgram(m_vertexArrayBuffer, m_vertexBuffer);
        
        return isLoaded();
    }
    return GL_FALSE;
}

GLboolean BaseViewObject::unLoad()
{
    if(0 != m_indexBuffer)
    {
        glDeleteBuffers(1, &m_indexBuffer);check_gl_error()
        m_indexBuffer = 0;
    }
    
    if(0 != m_vertexBuffer)
    {
        glDeleteBuffers(1, &m_vertexBuffer);check_gl_error()
        m_vertexBuffer = 0;
    }
    
    if(0 != m_vertexArrayBuffer)
    {
        glDeleteVertexArraysOES(1, &m_vertexArrayBuffer);check_gl_error()
        m_vertexArrayBuffer = 0;
    }
    
    return ((m_vertexArrayBuffer == 0) && (m_vertexBuffer == 0));
}

GLboolean BaseViewObject::isLoaded()const
{
    return ((m_vertexArrayBuffer != 0) && (m_vertexBuffer != 0))?GL_TRUE:GL_FALSE;
}

GLvoid BaseViewObject::setup(const GLuint programHandle)const
{
    if(isLoaded())
    {
        int attrib = GL_INVALID_VALUE;
        
        attrib = glGetAttribLocation(programHandle, "transformmatrix");
        if(attrib != GL_INVALID_VALUE)
        {
            int pos1 = attrib + 0;
            int pos2 = attrib + 1;
            int pos3 = attrib + 2;
            int pos4 = attrib + 3;
            
            glEnableVertexAttribArray(pos1);
            glEnableVertexAttribArray(pos2);
            glEnableVertexAttribArray(pos3);
            glEnableVertexAttribArray(pos4);
            
//            glVertexAttribPointer(pos1, 4, GL_FLOAT, GL_FALSE, getStride(), getWorldTransformOffset(0));
//            glVertexAttribPointer(pos2, 4, GL_FLOAT, GL_FALSE, getStride(), getWorldTransformOffset(1));
//            glVertexAttribPointer(pos3, 4, GL_FLOAT, GL_FALSE, getStride(), getWorldTransformOffset(2));
//            glVertexAttribPointer(pos4, 4, GL_FLOAT, GL_FALSE, getStride(), getWorldTransformOffset(3));
            
            glVertexAttribDivisorEXT(pos1, 1);
            glVertexAttribDivisorEXT(pos2, 1);
            glVertexAttribDivisorEXT(pos3, 1);
            glVertexAttribDivisorEXT(pos4, 1);
        }
        
        attrib = glGetAttribLocation(programHandle, GLSL_ATTRIBUTE_position);check_gl_error()
        if(attrib != GL_INVALID_VALUE)
        {
            glEnableVertexAttribArray(attrib);check_gl_error()
            glVertexAttribPointer(attrib, 4, GL_FLOAT, GL_FALSE,
                                  getStride(),
                                  getPositionOffset());check_gl_error()
        }
        
        if(hasColorAttribute())
        {
            attrib = glGetAttribLocation(programHandle, GLSL_ATTRIBUTE_color);check_gl_error()
            if(attrib != GL_INVALID_VALUE)
            {
                glEnableVertexAttribArray(attrib);check_gl_error()
                glVertexAttribPointer(attrib, 4, GL_FLOAT, GL_FALSE,
                                      getStride(),
                                      getColorOffset());check_gl_error()
            }
        }
        
        if(hasNormalAttribute())
        {
            attrib = glGetAttribLocation(programHandle, GLSL_ATTRIBUTE_normal);check_gl_error()
            if(attrib != GL_INVALID_VALUE)
            {
                glEnableVertexAttribArray(attrib);check_gl_error()
                glVertexAttribPointer(attrib, 4, GL_FLOAT, GL_FALSE,
                                      getStride(),
                                      getNormalOffset());check_gl_error()
            }
        }
        
        for(int i = 0; i < 8; i++)
        {
            if(hasTextureAttribute(i))
            {
                attrib = glGetAttribLocation(programHandle, GLSL_ATTRIBUTE_textureCoord[i]);check_gl_error()
                if(attrib != GL_INVALID_VALUE)
                {
                    glEnableVertexAttribArray(attrib);check_gl_error()
                    glVertexAttribPointer(attrib, 2, GL_FLOAT, GL_FALSE,
                                          getStride(),
                                          getTextureOffset(i));check_gl_error()
                }
            }
        }
    }
}
