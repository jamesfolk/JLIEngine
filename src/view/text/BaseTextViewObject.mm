//
//  BaseTextViewObject.cpp
//  GameAsteroids
//
//  Created by James Folk on 6/24/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "ZipFileResourceLoader.h"


#include "BaseTextViewObject.h"
#include "TextureBehaviorFactory.h"
#include "TextureFactory.h"
#include "ViewObjectFactory.h"
#include "TextureFactoryIncludes.h"
#include "LocalizedTextViewObjectTypes.h"

#include <sstream>

#include "CameraFactory.h"
#include "BaseCamera.h"
#include "LocalizedTextLoader.h"
#include "VertexAttributeLoader.h"
#include "GLDebugDrawer.h"

BaseTextViewObject::BaseTextViewObject(const BaseTextViewInfo &info) :
m_LocalizedKey(""),
m_WorldTransform(btTransform::getIdentity()),
m_VertexTransform(new VertexTransform()),
m_viewObjectFactoryID(0),
m_textureBehaviorFactoryID(0),
m_spriteFactoryID(0),
m_hidden(false),
m_currentTextureFactoryID(0)
{
    TextureBehaviorInfo *tbInfo = new TextureBehaviorInfo();
    m_textureBehaviorFactoryID = TextureBehaviorFactory::getInstance()->create(tbInfo);
    delete tbInfo;
    tbInfo = NULL;

    BaseViewObjectInfo *constructionInfo = new BaseViewObjectInfo(info.m_shaderFactoryID,
                                              "sprite",
                                              0, 0,
                                              &m_textureBehaviorFactoryID, 1);
    m_viewObjectFactoryID = ViewObjectFactory::getInstance()->create(constructionInfo);
    delete constructionInfo;
    constructionInfo = NULL;
    
    BaseViewObject *vo = ViewObjectFactory::getInstance()->get(m_viewObjectFactoryID);
    
    btAlignedObjectArray<GLushort> indiceData;
    btAlignedObjectArray<VertexAttributes_Vertex_Normal_Color_UVLayer1> vertexData;
    VertexAttributeLoader::getInstance()->createSpriteVertices(indiceData, vertexData);
    
    VertexAttributeLoader::getInstance()->load(vo, indiceData, vertexData);
    
    btAssert(m_VertexTransform);
    
    m_VertexTransform->m_Vertices.resize(vertexData.size());
    size_t offset_position = reinterpret_cast<size_t>(getVBO()->getPositionOffset());
    getVBO()->get_each_attribute<VertexTransform, btVector3>(*m_VertexTransform, offset_position);
    
    WorldPhysics::getInstance()->addActionObject(this);
}

BaseTextViewObject::~BaseTextViewObject()
{
    WorldPhysics::getInstance()->removeActionObject(this);
    
    BaseViewObject *vo = ViewObjectFactory::getInstance()->get(m_viewObjectFactoryID);
    vo->unLoad();
    ViewObjectFactory::getInstance()->destroy(m_viewObjectFactoryID);
    m_viewObjectFactoryID = 0;
    
    TextureBehaviorFactory::getInstance()->destroy(m_textureBehaviorFactoryID);
    m_textureBehaviorFactoryID = 0;
    
    delete m_VertexTransform;
    m_VertexTransform = NULL;
}


void BaseTextViewObject::updateAction( btCollisionWorld* collisionWorld, btScalar deltaTimeStep)
{
    
}

void BaseTextViewObject::debugDraw(btIDebugDraw* debugDrawer)
{
    if(m_VertexTransform->pTextInfo == NULL)
        return;
    
    btVector3 from, to;
    btVector3 color(1, 0, 0);
    int size = m_VertexTransform->m_Vertices.size();
    
    BaseCamera *pCamera = GLDebugDrawer::getInstance()->getCurrentCamera();
    
    GLDebugDrawer::getInstance()->setOrthoCamera();
    
    for (int i = 0; i < size; i++)
    {
        from = m_VertexTransform->m_Vertices[i % size];
        from.setX((from.x() * m_VertexTransform->getTextInfo()->metrics.width)  + m_VertexTransform->getTextInfo()->metrics.xBearing);
        from.setY((from.y() * m_VertexTransform->getTextInfo()->metrics.height) - (m_VertexTransform->getTextInfo()->metrics.height + m_VertexTransform->getTextInfo()->metrics.yBearing));
        
        to = m_VertexTransform->m_Vertices[(i + 1) % size];
        to.setX((to.x() * m_VertexTransform->getTextInfo()->metrics.width) + m_VertexTransform->getTextInfo()->metrics.xBearing);
        to.setY((to.y() * m_VertexTransform->getTextInfo()->metrics.height) - (m_VertexTransform->getTextInfo()->metrics.height + m_VertexTransform->getTextInfo()->metrics.yBearing));
        
        debugDrawer->drawLine(getWorldTransform() * from, getWorldTransform() * to, color);
    }
    
    GLDebugDrawer::getInstance()->setCurrentCamera(pCamera);
}

void BaseTextViewObject::setTextKey(const std::string &localized_key, LocalizedTextViewObjectType type)
{
    btAssert(localized_key != "\"");
    btAssert(localized_key != "\\");
    
    if(m_LocalizedKey != localized_key)
    {
        m_LocalizedKey = localized_key;
        
        m_VertexTransform->pTextInfo = LocalizedTextLoader::getInstance()->getTextInfo(m_LocalizedKey, type);
        
        IDType ID = LocalizedTextLoader::getInstance()->getTextureFactoryID(localized_key, type);
        if(m_currentTextureFactoryID != ID)
        {
            getVBO()->unLoadTexture(0);
            
            m_currentTextureFactoryID = ID;
            
            getVBO()->loadTextureID(0, m_currentTextureFactoryID);
        }
        
        getVBO()->getTextureBehavior(0)->setXOffset(m_VertexTransform->getTextInfo()->origin.x);
        getVBO()->getTextureBehavior(0)->setYOffset(m_VertexTransform->getTextInfo()->origin.y);
        getVBO()->getTextureBehavior(0)->setWidthOfSubTexture(m_VertexTransform->getTextInfo()->metrics.width);
        getVBO()->getTextureBehavior(0)->setHeightOfSubTexture(m_VertexTransform->getTextInfo()->metrics.height);
        getVBO()->getTextureBehavior(0)->setWidthOfTexture(m_VertexTransform->getTextInfo()->textureFileWidth);
        getVBO()->getTextureBehavior(0)->setHeightOfTexture(m_VertexTransform->getTextInfo()->textureFileHeight);
        
        size_t offset_position = reinterpret_cast<size_t>(getVBO()->getPositionOffset());
        getVBO()->set_each_attribute<VertexTransform, btVector3>(*m_VertexTransform, offset_position);
        
        getVBO()->getTextureBehavior(0)->updateAction(NULL, FrameCounter::getInstance()->getCurrentDiffTime());
        
        
    }
}

const std::string &BaseTextViewObject::getTextKey()const
{
    return m_LocalizedKey;
}

void BaseTextViewObject::render()
{
    BaseViewObject *pBaseViewObject = getVBO();
    
    if((NULL != pBaseViewObject) &&
       (NULL != m_VertexTransform->pTextInfo) &&
       false == m_hidden)
    {
        btTransform _btTransform(getWorldTransform());
        btVector3 _origin(_btTransform.getOrigin());
        _origin.setX(_origin.x() + m_VertexTransform->getTextInfo()->metrics.xBearing);
        _origin.setY(_origin.y() - (m_VertexTransform->getTextInfo()->metrics.height + m_VertexTransform->getTextInfo()->metrics.yBearing));
        _btTransform.setOrigin(_origin);
        
        btTransform _offset( btQuaternion(btDegrees(0), btDegrees(180), btDegrees(0)));
        
        BaseCamera *pCamera = CameraFactory::getInstance()->getOrthoCamera();
        
//        GLKMatrix4 cameraLocationMatrix = getGLKMatrix4(pCamera->getWorldTransform().inverse());
        btTransform cameraLocationMatrix(pCamera->getWorldTransform().inverse());
        
//        GLKMatrix4 _modelViewMatrix = GLKMatrix4Multiply(cameraLocationMatrix, getGLKMatrix4(_btTransform * _offset));
        btTransform modelViewMatrix(cameraLocationMatrix * (_btTransform * _offset));
        
//        GLKMatrix4 _projectionMatrix = pCamera->getProjection();
        btTransform projectionMatrix(pCamera->getProjection2());
        
//        GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(_modelViewMatrix), NULL);
        btMatrix3x3 normalMatrix(modelViewMatrix.getBasis().inverse().transpose());

        float m[16];
        
        modelViewMatrix.getOpenGLMatrix(m);
        pBaseViewObject->setGLSLModelViewMatrix(m);
        
        projectionMatrix.getOpenGLMatrix(m);
        pBaseViewObject->setGLSLProjectionMatrix(m);
        
        normalMatrix.getOpenGLSubMatrix(m);
        pBaseViewObject->setGLSLNormalMatrix(m);
        
        pBaseViewObject->render(GL_TRIANGLES);
    }
}
