//
//  DynamicImageTestState.mm
//  BaseProject
//
//  Created by library on 10/15/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "DynamicImageTestState.h"

#include "CameraEntity.h"
#include "TextureFactoryIncludes.h"
#include "TextureFactory.h"
#include "TextureBufferObjectFactoryIncludes.h"
#include "TextureBufferObjectFactory.h"
//#include "PlayerInput.h"
#include "CameraFactory.h"
#include "BaseEntity.h"
#include "EntityFactory.h"


#include "ImageFileEditor.h"

DynamicImageTestState::DynamicImageTestState()
{
    m_Rotate = 0.0f;
}
DynamicImageTestState::~DynamicImageTestState()
{
    
}

void DynamicImageTestState::update_specific(btScalar deltaTimeStep)
{
    m_Rotate += (deltaTimeStep * 5);
    if(m_Rotate > DEGREES_TO_RADIANS(360))
        m_Rotate = 0;
    
    //m_pSprite->setRotation(btQuaternion(m_Rotate, m_Rotate, m_Rotate));
    m_pEntity->setRotation(btQuaternion(m_Rotate, m_Rotate, m_Rotate));
    m_pCamera->lookAt(m_pEntity->getOrigin());
}
void DynamicImageTestState::enter_specific()
{
    pImage = new ImageFileEditor();
    
    pImageFileEditor[0] = new ImageFileEditor();
    pImageFileEditor[1] = new ImageFileEditor();
    pImageFileEditor[2] = new ImageFileEditor();
    
    pImageFileEditor[0]->load("Tarsier.png");
    pImageFileEditor[1]->load("spritetest2.png");
    pImageFileEditor[2]->load("radiation_box.tga");
    
    //pImage->load(2048, 2048, 4);
    
    pImage->load("Tarsier.png");
    
    
//    int randnum = randomIntegerRange(5, 100);
//    for(int i = 0; i < randnum; i++)
//    {
//        pImageFileEditor[1]->draw(randomIntegerRange(0, pImage->getWidth()),
//                                  randomIntegerRange(0, pImage->getHeight()),
//                                  *pImage);
//    }

//    int ii = 0;
//    for(int x = 0; x < pImage->getWidth(); x += pImageFileEditor[ii]->getWidth())
//    {
//        for(int y = 0; y < pImage->getHeight(); y += pImageFileEditor[ii]->getHeight())
//        {
//            pImageFileEditor[ii]->draw(x, y, *pImage);
//        }
//    }
    
    
    pImage->reload();
    
//    unsigned char *pixel = new unsigned char[pImage->getNumBits()];
//    int w = pImage->getWidth();
//    int h = pImage->getHeight();
//    int i = 0;
//    for (int x  = 0; x < w; x++)
//    {
//        for(int y = 0; y < h; y++)
//        {
//            //pImageFileEditor[i%1]->getPixel(x, y, pixel);
//            
//            //pImage->setPixel(x, y, pixel);
//            
//            i++;
//        }
//    }
//    pImage->reload();
//    delete [] pixel;
    
    
    BaseViewObjectInfo *constructionInfo = NULL;
    BaseViewObject *vo = NULL;
    
    //    ShaderFactoryKey key(VERTEX_SHADER, FRAGMENT_SHADER);
    //    shaderFactoryID = ShaderFactory::getInstance()->create(&key);
    IDType shaderFactoryID = ShaderFactory::getInstance()->getCurrentShaderID();
    
    TextureBehaviorInfo *tbInfo = new TextureBehaviorInfo();
    IDType textureBehaviorFactoryID = TextureBehaviorFactory::getInstance()->create(tbInfo);
    delete tbInfo;
    
    std::string defaultSprite = "tarsier";
    TextureFactoryInfo info;
    
    //info.loadFromFile = false;
    info.m_type = TextureFactoryTypes_Data;
    info.right = defaultSprite;
    IDType defaultSpriteTextureID = TextureFactory::getInstance()->create(&info);
    
    
    
    
    
    constructionInfo = new BaseViewObjectInfo(shaderFactoryID,
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
    
    
    
    
    
    constructionInfo = new BaseViewObjectInfo(shaderFactoryID,
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
void DynamicImageTestState::exit_specific()
{
    
}

void DynamicImageTestState::render_specific()
{
    //    BaseViewObject *vo = ViewObjectFactory::getInstance()->get(spriteViewObjectID);
    //
    //    TextureBufferObjectFactory::getInstance()->get(m_textureBufferObject)->name();
    
    BaseViewObject *vo = ViewObjectFactory::getInstance()->get(spriteViewObjectID);
//    vo->loadTexture(0, TextureBufferObjectFactory::getInstance()->get(m_textureBufferObject)->name());

    vo->loadTextureName(0, pImage->name());
    m_pEntity->render();
}

//void DynamicImageTestState::touchesBegan()
//{
//    
//}
//void DynamicImageTestState::touchesMoved()
//{
////    Touch touch;
////    for(int i = 0; i < PlayerInput::getInstance()->getNumTouches(); i++)
////    {
////        PlayerInput::getInstance()->getTouchByIndex(i, touch);
////        touch.printDebug();
////    }
//    
//    pImage->blur();
//    pImage->reload();
//}
//void DynamicImageTestState::touchesEnded()
//{
//    
//}
//void DynamicImageTestState::touchesCancelled()
//{
//    
//}

void DynamicImageTestState::createSprite()
{
    BaseEntityInfo *constructionInfo = new BaseEntityInfo(spriteViewObjectID,
                                                          0,
                                                          0,
                                                          true);
    
    m_pSprite = EntityFactory::createEntity<BaseEntity, BaseEntityInfo>(constructionInfo);
    
    m_pSprite->setOrigin(btVector3(256,256,0));
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
    
    vertexclass.width = 512;
    vertexclass.height = 512;
    
    
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

void DynamicImageTestState::createCamera()
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

void DynamicImageTestState::createEntity()
{
    BaseEntityInfo *constructionInfo = new BaseEntityInfo(cubeViewObjectID);
    m_pEntity = EntityFactory::createEntity<BaseEntity, BaseEntityInfo>(constructionInfo);
    delete constructionInfo;
    
    m_pEntity->setOrigin(btVector3(0,0,0));
    m_pEntity->show();
}