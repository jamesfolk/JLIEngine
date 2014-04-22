//
//  GLDebugDrawer.cpp
//  GameAsteroids
//
//  Created by James Folk on 3/13/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "GLDebugDrawer.h"
#include "ViewObjectFactory.h"
#include "ViewObjectFactoryIncludes.h"
#include "ShaderFactoryIncludes.h"
#include "VertexAttributeLoader.h"
#include "CameraFactory.h"

#include "ShaderFactory.h"
#include "BaseCamera.h"

#include "TextViewObjectFactoryIncludes.h"
#include "TextViewObjectFactory.h"

#include "VertexAttributeLoader.h"

BaseViewObject *GLDebugDrawer::getLineVBO()
{
    return ViewObjectFactory::getInstance()->get(m_LineViewObjectFactoryID);
}

BaseViewObject *GLDebugDrawer::getIcoSphereVBO()
{
    return ViewObjectFactory::getInstance()->get(m_IcoSphereViewObjectFactoryID);
}

void GLDebugDrawer::setShaderFactoryID(const IDType ID)
{
//    if(0 != m_shaderFactoryID)
//    {
//        btAssert(m_pBaseViewObject);
//        
//        m_pBaseViewObject->unLoad();
//        ViewObjectFactory::getInstance()->destroy(m_pBaseViewObject->getID());
//        m_pBaseViewObject = NULL;
//    }
    //m_shaderFactoryID = ID;
    
    ShaderFactoryKey key(VERTEX_SHADER, FRAGMENT_SHADER);
    BaseViewObjectInfo constructionInfo;
    //constructionInfo.m_shaderFactoryID = ShaderFactory::getInstance()->getCurrentShaderID();
    constructionInfo.m_viewObjectName = std::string("NONE");
    
    
    m_LineViewObjectFactoryID = ViewObjectFactory::getInstance()->create(&constructionInfo);
    m_lineVertexData.resize(2);
    VertexAttributeLoader::getInstance()->load(getLineVBO(), m_lineVertexData);
    
    m_IcoSphereViewObjectFactoryID = ViewObjectFactory::getInstance()->create(&constructionInfo);
//    VertexAttributeLoader::getInstance()->createIcoSphereVertices(m_sphereIndices, m_sphereVertexData);
//    VertexAttributeLoader::getInstance()->load(getIcoSphereVBO(), m_sphereIndices, m_sphereVertexData);

    VertexAttributeLoader::getInstance()->createIcoSphereVertices(m_sphereIndices, m_sphereVertexData);
    VertexAttributeLoader::getInstance()->load(getIcoSphereVBO(), m_sphereVertexData);
}

void GLDebugDrawer::setOrthoCamera()
{
    pCurrentCamera = CameraFactory::getInstance()->getOrthoCamera();
}
void GLDebugDrawer::setProjectionCamera()
{
    pCurrentCamera = CameraFactory::getInstance()->getCurrentCamera();
}

BaseCamera *GLDebugDrawer::getCurrentCamera()
{
    return pCurrentCamera;
}

void GLDebugDrawer::setCurrentCamera(BaseCamera *camera)
{
    pCurrentCamera = camera;
}

GLDebugDrawer::GLDebugDrawer():
//m_shaderFactoryID(0),
m_debugMode(0),
m_LineViewObjectFactoryID(0),
m_IcoSphereViewObjectFactoryID(0),
pCurrentCamera(NULL)
{   
}

GLDebugDrawer::~GLDebugDrawer()
{
    ViewObjectFactory::getInstance()->destroy(m_LineViewObjectFactoryID);
    ViewObjectFactory::getInstance()->destroy(m_IcoSphereViewObjectFactoryID);
}

void    GLDebugDrawer::drawLine(const btVector3& from,const btVector3& to,const btVector3& fromColor, const btVector3& toColor)
{
    if(getLineVBO())
    {
        m_lineVertexData[0].setVertex(from);
        m_lineVertexData[0].setColor(btVector4(fromColor.x(),
                                               fromColor.y(),
                                               fromColor.z(),
                                               1.0f));
        m_lineVertexData[1].setVertex(to);
        m_lineVertexData[1].setColor(btVector4(toColor.x(),
                                               toColor.y(),
                                               toColor.z(),
                                               1.0f));
        
        VertexAttributeLoader::getInstance()->reLoad(getLineVBO(), m_lineVertexData);
        
        pCurrentCamera = CameraFactory::getInstance()->getCurrentCamera();

        if(pCurrentCamera == NULL)
        {
            printf("Unable to debug draw\n");
            return;
        }
        
        btTransform worldTransform(btTransform::getIdentity());
        
//        GLKMatrix4 cameraLocationMatrix = getGLKMatrix4(pCurrentCamera->getWorldTransform().inverse());
        btTransform cameraLocationMatrix(pCurrentCamera->getWorldTransform().inverse());
        
//        GLKMatrix4 _modelViewMatrix = GLKMatrix4Multiply(cameraLocationMatrix, getGLKMatrix4(worldTransform));
        btTransform modelViewMatrix(cameraLocationMatrix * worldTransform);
        
//        GLKMatrix4 _projectionMatrix = pCurrentCamera->getProjection();
        btTransform projectionMatrix(pCurrentCamera->getProjection2());
        
//        GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(_modelViewMatrix), NULL);
        btMatrix3x3 normalMatrix(modelViewMatrix.getBasis().inverse().transpose());
        
        float m[16];
        
        modelViewMatrix.getOpenGLMatrix(m);
        getLineVBO()->setGLSLModelViewMatrix(m);
        
        projectionMatrix.getOpenGLMatrix(m);
        getLineVBO()->setGLSLProjectionMatrix(m);
        
        normalMatrix.getOpenGLSubMatrix(m);
        getLineVBO()->setGLSLNormalMatrix(m);
        
        getLineVBO()->render(GL_LINES);
    }
}

void    GLDebugDrawer::drawLine(const btVector3& from,const btVector3& to,const btVector3& color)
{
    drawLine(from,to,color,color);
}

void GLDebugDrawer::drawSphere (const btVector3& p, btScalar radius, const btVector3& color)
{
    if(getIcoSphereVBO())
    {
        btVector3 vertex;
        btTransform transform(btTransform::getIdentity());
        transform.setOrigin(p);
        
        btAlignedObjectArray<VertexAttributes_Vertex_Color> vertexData;
        vertexData.copyFromArray(m_sphereVertexData);
        
        for (int i = 0; i < m_sphereVertexData.size(); i++)
        {
            m_sphereVertexData.at(i).getVertex(vertex);
            vertex *= radius;
            
            vertexData[i].setVertex(transform * vertex);
            vertexData[i].setColor(btVector4(color.x(),
                                             color.y(),
                                             color.z(),
                                             1.0f));
            
        }
        
        VertexAttributeLoader::getInstance()->reLoad(getIcoSphereVBO(), vertexData);
        
        pCurrentCamera = CameraFactory::getInstance()->getCurrentCamera();
        
        if(pCurrentCamera == NULL)
        {
            printf("Unable to debug draw\n");
            return;
        }
        
        btTransform worldTransform(btTransform::getIdentity());
        
//        GLKMatrix4 cameraLocationMatrix = getGLKMatrix4(pCurrentCamera->getWorldTransform().inverse());
        btTransform cameraLocation(pCurrentCamera->getWorldTransform().inverse());
        
//        GLKMatrix4 _modelViewMatrix = GLKMatrix4Multiply(cameraLocationMatrix, getGLKMatrix4(worldTransform));
        btTransform modelViewMatrix(cameraLocation * worldTransform);
        
//        GLKMatrix4 _projectionMatrix = pCurrentCamera->getProjection();
        btTransform projectionMatrix(pCurrentCamera->getProjection2());
        
//        GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(_modelViewMatrix), NULL);
        btMatrix3x3 normalMatrix(modelViewMatrix.getBasis().inverse().transpose());
        
        float m[16];
        
        modelViewMatrix.getOpenGLMatrix(m);
        getIcoSphereVBO()->setGLSLModelViewMatrix(m);
        
        projectionMatrix.getOpenGLMatrix(m);
        getIcoSphereVBO()->setGLSLProjectionMatrix(m);
        
        normalMatrix.getOpenGLSubMatrix(m);
        getIcoSphereVBO()->setGLSLNormalMatrix(m);
        
        getIcoSphereVBO()->render(GL_LINES);
    }
}

void GLDebugDrawer::drawBox (const btVector3& boxMin, const btVector3& boxMax, const btVector3& color, btScalar alpha)
{
//    btVector3 halfExtent = (boxMax - boxMin) * btScalar(0.5f);
//    btVector3 center = (boxMax + boxMin) * btScalar(0.5f);
//    //glEnable(GL_BLEND);     // Turn blending On
//    //glBlendFunc(GL_SRC_ALPHA, GL_ONE);
//    glColor4f (color.getX(), color.getY(), color.getZ(), alpha);
//    glPushMatrix ();
//    glTranslatef (center.getX(), center.getY(), center.getZ());
//    glScaled(2*halfExtent[0], 2*halfExtent[1], 2*halfExtent[2]);
//    //      glutSolidCube(1.0);
//    glPopMatrix ();
//    //glDisable(GL_BLEND);
}

void    GLDebugDrawer::drawTriangle(const btVector3& a,const btVector3& b,const btVector3& c,const btVector3& color,btScalar alpha)
{
//    //      if (m_debugMode > 0)
//    {
//        const btVector3 n=btCross(b-a,c-a).normalized();
//        glBegin(GL_TRIANGLES);
//        glColor4f(color.getX(), color.getY(), color.getZ(),alpha);
//        glNormal3d(n.getX(),n.getY(),n.getZ());
//        glVertex3d(a.getX(),a.getY(),a.getZ());
//        glVertex3d(b.getX(),b.getY(),b.getZ());
//        glVertex3d(c.getX(),c.getY(),c.getZ());
//        glEnd();
//    }
}

void    GLDebugDrawer::setDebugMode(int debugMode)
{
    m_debugMode = debugMode;
    
}

void    GLDebugDrawer::draw3dText(const btVector3& location,const char* textString)
{
    m_CurrentIndexOfMultipleLocalizedTextArrays++;
    m_CurrentIndexOfMultipleLocalizedTextArrays %= m_MultipleLocalizedTextArrays.size();
    
    LocalizedTextArray *current_array = m_MultipleLocalizedTextArrays[m_CurrentIndexOfMultipleLocalizedTextArrays];
    
    TextViewObjectFactory::getInstance()->updateDrawText(std::string(textString),
                                                         LocalizedTextViewObjectType_Monaco_32pt,
                                                         location,
                                                         *current_array,
                                                         btVector3(1.0f, 0.0f, 0.0f));
}

void    GLDebugDrawer::reportErrorWarning(const char* warningString)
{
    //printf(warningString);
}

void    GLDebugDrawer::drawContactPoint(const btVector3& pointOnB,const btVector3& normalOnB,btScalar distance,int lifeTime,const btVector3& color)
{
    
//    {
//        btVector3 to=pointOnB+normalOnB*distance;
//        const btVector3&from = pointOnB;
//        glColor4f(color.getX(), color.getY(), color.getZ(),1.f);
//        //glColor4f(0,0,0,1.f);
//        
//        glBegin(GL_LINES);
//        glVertex3d(from.getX(), from.getY(), from.getZ());
//        glVertex3d(to.getX(), to.getY(), to.getZ());
//        glEnd();
//        
//        
//        glRasterPos3f(from.x(),  from.y(),  from.z());
//        char buf[12];
//        sprintf(buf," %d",lifeTime);
//        //BMF_DrawString(BMF_GetFont(BMF_kHelvetica10),buf);
//        
//        
//    }
}

void GLDebugDrawer::unInit3DText()
{
    LocalizedTextArray *current_array = NULL;
    for(int i = 0; i < m_MultipleLocalizedTextArrays.size(); i++)
    {
        current_array = m_MultipleLocalizedTextArrays[i];
        for(size_t j = 0; j < (*current_array).size(); j++)
        {
            TextViewObjectFactory::getInstance()->destroy((*current_array)[j]);
        }
        (*current_array).clear();
        
        delete current_array;
        current_array = NULL;
    }
    m_MultipleLocalizedTextArrays.clear();
}

void GLDebugDrawer::init3dText(const unsigned int max_lines)
{
    m_MultipleLocalizedTextArrays.resizeNoInitialize(max_lines);
    
    LocalizedTextArray *current_array = NULL;
    for(int i = 0; i < max_lines; i++)
    {
        current_array = new LocalizedTextArray();
        init3dTextArray(*current_array);
        m_MultipleLocalizedTextArrays[i] = current_array;
    }
    
}

void GLDebugDrawer::init3dTextArray(LocalizedTextArray &array, const unsigned int max_length)
{
    array.clear();
    
    BaseTextViewInfo *info = new BaseTextViewInfo(ShaderFactory::getInstance()->getCurrentShaderID());
    for(size_t i = 0; i < max_length; i++)
    {
        array.push_back(TextViewObjectFactory::getInstance()->create(info));
    }
    delete info;
}

void GLDebugDrawer::draw3dText(const btVector3 &location,
                               const char *textString,
                               unsigned int array_index)
{
    
}

