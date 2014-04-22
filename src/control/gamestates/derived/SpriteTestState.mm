//
//  SpriteTestState.cpp
//  GameAsteroids
//
//  Created by James Folk on 5/6/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "SpriteTestState.h"
#include "CameraFactory.h"
#include "CameraEntity.h"

//#include "PlayerInput.h"

#include "TextureFactory.h"
#include "ShaderFactory.h"
#include "EntityFactory.h"
#include "CameraFactoryIncludes.h"

#include "ZipFileResourceLoader.h"
#include "RigidEntity.h"

#include "TextureBufferObjectFactory.h"
#include "TextureBufferObjectFactoryIncludes.h"

SpriteTestState::SpriteTestState()
{
    m_Rotate = 0.0f;
}
SpriteTestState::~SpriteTestState()
{
    
}

void SpriteTestState::update_specific(btScalar deltaTimeStep)
{
    m_Rotate += (deltaTimeStep * 5);
    if(m_Rotate > DEGREES_TO_RADIANS(360))
        m_Rotate = 0;
    
    //m_pSprite->setRotation(btQuaternion(m_Rotate, m_Rotate, m_Rotate));
    m_pEntity->setRotation(btQuaternion(m_Rotate, m_Rotate, m_Rotate));
    m_pCamera->lookAt(m_pEntity->getOrigin());
}
void SpriteTestState::enter_specific()
{
    
//    ZipFileResourceLoader::getInstance()->open("scene.zip");
//    do
//    {
//        ZipFileResourceLoader::getInstance()->extract();
//    }
//    while (!ZipFileResourceLoader::getInstance()->finished());
    
    BaseViewObjectInfo *constructionInfo = NULL;
    BaseViewObject *vo = NULL;
    
    //    ShaderFactoryKey key(VERTEX_SHADER, FRAGMENT_SHADER);
    //    shaderFactoryID = ShaderFactory::getInstance()->create(&key);
    //IDType shaderFactoryID = ShaderFactory::getInstance()->getCurrentShaderID();
    
    TextureBehaviorInfo *tbInfo = new TextureBehaviorInfo();
    IDType textureBehaviorFactoryID = TextureBehaviorFactory::getInstance()->create(tbInfo);
    delete tbInfo;
    
    std::string defaultSprite = "tarsier";
    TextureFactoryInfo info;
    
    //info.loadFromFile = false;
    info.m_type = TextureFactoryTypes_Data;
    info.right = defaultSprite;
    IDType defaultSpriteTextureID = TextureFactory::getInstance()->create(&info);
    
    
    
    
    
    constructionInfo = new BaseViewObjectInfo(ShaderFactory::getInstance()->getCurrentShaderID(),
                                              "sprite",
                                              0, 0,
                                              &textureBehaviorFactoryID, 1);
    spriteViewObjectID = ViewObjectFactory::getInstance()->create(constructionInfo);
    delete constructionInfo;
    
    //ZipFileResourceLoader::getInstance()->getMeshObject("sprite")->load(vo);
    
    vo = ViewObjectFactory::getInstance()->get(spriteViewObjectID);
    btAlignedObjectArray<GLushort> indiceData;
    btAlignedObjectArray<VertexAttributes_Vertex_Normal_Color_UVLayer1> vertexData;
    VertexAttributeLoader::getInstance()->createSpriteVertices(indiceData, vertexData);
    VertexAttributeLoader::getInstance()->load(vo, indiceData, vertexData);
    
    
    
    
    
    constructionInfo = new BaseViewObjectInfo(ShaderFactory::getInstance()->getCurrentShaderID(),
                                              "sphere",
                                              &defaultSpriteTextureID, 1);
    cubeViewObjectID = ViewObjectFactory::getInstance()->create(constructionInfo);
    vo = ViewObjectFactory::getInstance()->get(cubeViewObjectID);
    ZipFileResourceLoader::getInstance()->getMeshObject("sphere")->load(vo);
    delete constructionInfo;
    
    
    createSprite();
    createCamera();
    createEntity();
    
    
    GLfloat width = 2048;
    GLfloat height = 2048;
    TextureBufferObjectFactoryInfo *textureBufferObjectInfo = new TextureBufferObjectFactoryInfo(width, height);
    textureBufferObjectInfo->m_Type = TextureBufferObjectFactory_SCENE;
    
    m_textureBufferObject = TextureBufferObjectFactory::getInstance()->create(textureBufferObjectInfo);
    TextureBufferObjectFactory::getInstance()->get(m_textureBufferObject)->load();
    delete textureBufferObjectInfo;
    
    
}
void SpriteTestState::exit_specific()
{
    
}

void SpriteTestState::render_specific()
{
//    BaseViewObject *vo = ViewObjectFactory::getInstance()->get(spriteViewObjectID);
//    
//    TextureBufferObjectFactory::getInstance()->get(m_textureBufferObject)->name();
    
    BaseViewObject *vo = ViewObjectFactory::getInstance()->get(spriteViewObjectID);
    vo->loadTextureName(0, TextureBufferObjectFactory::getInstance()->get(m_textureBufferObject)->name());
    m_pEntity->render();
}

//void SpriteTestState::touchesBegan()
//{
//    
//}
//void SpriteTestState::touchesMoved()
//{
////    Touch touch;
////    for(int i = 0; i < PlayerInput::getInstance()->getNumTouches(); i++)
////    {
////        PlayerInput::getInstance()->getTouchByIndex(i, touch);
////        touch.printDebug();
////    }
//}
//void SpriteTestState::touchesEnded()
//{
//    
//}
//void SpriteTestState::touchesCancelled()
//{
//    
//}

void SpriteTestState::createSprite()
{
    BaseEntityInfo *constructionInfo = new BaseEntityInfo(spriteViewObjectID,
                                                          0,
                                                          0,
                                                          true);
    
    m_pSprite = EntityFactory::createEntity<BaseEntity, BaseEntityInfo>(constructionInfo);
    
    m_pSprite->setOrigin(btVector3(64,64,0));
    //m_pSprite->setScale(btVector3(128, 128,0));
    
    delete constructionInfo;
    
    
    
    
    
    
    
    
    BaseViewObject *vo = ViewObjectFactory::getInstance()->get(spriteViewObjectID);
    
    struct vertexclass_s
    {
        GLuint width;
        GLuint height;
        
        void operator() (int i, btVector3 &to, const btVector3 &from)
        {
            to = btVector3(from.x() * width,
                           from.y() * height,
                           from.z());
        }
    } vertexclass;
    
    vertexclass.width = 128;
    vertexclass.height = 128;
    
    
    vo->getTextureBehavior(0)->setXOffset(0);
    vo->getTextureBehavior(0)->setYOffset(0);
    vo->getTextureBehavior(0)->setWidthOfSubTexture(2048);
    vo->getTextureBehavior(0)->setHeightOfSubTexture(2048);
    vo->getTextureBehavior(0)->setWidthOfTexture(2048);
    vo->getTextureBehavior(0)->setHeightOfTexture(2048);
    
    size_t offset_position = reinterpret_cast<size_t>(vo->getPositionOffset());
    vo->set_each_attribute<vertexclass_s, btVector3>(vertexclass, offset_position);
    
    //vo->getTextureBehavior(0)->updateAction(NULL, FrameCounter::getInstance()->getCurrentDiffTime());
}

void SpriteTestState::createCamera()
{
    
    CameraEntityInfo *constructionInfo = new CameraEntityInfo(false);
    
    constructionInfo->m_nearZ = 0.01f;
    constructionInfo->m_farZ = 1000.0f;
    m_pCamera = CameraFactory::createCameraEntity<CameraEntity, CameraEntityInfo>(constructionInfo);
    delete constructionInfo;
    
    CameraFactory::getInstance()->setCurrentCamera(m_pCamera);
    
    m_pCamera->setOrigin(btVector3(0, 40, -20));
    m_pCamera->hide();
    
}

void SpriteTestState::createEntity()
{
    BaseEntityInfo *constructionInfo = new BaseEntityInfo(cubeViewObjectID);
    m_pEntity = EntityFactory::createEntity<BaseEntity, BaseEntityInfo>(constructionInfo);
    delete constructionInfo;
    
    m_pEntity->setOrigin(btVector3(0,0,0));
    m_pEntity->show();
}

