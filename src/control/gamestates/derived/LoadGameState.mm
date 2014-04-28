//
//  LoadGameState.mm
//  BaseProject
//
//  Created by library on 8/28/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "LoadGameState.h"
#include "ZipFileResourceLoader.h"
#include "GameStateMachine.h"
#include "TextViewObjectFactory.h"
#include "ShaderFactory.h"
#include "CameraFactoryIncludes.h"
#include "CameraFactory.h"
#include "CameraEntity.h"
#include "GameStateFactory.h"

LoadGameState::LoadGameState()
{
}

LoadGameState::~LoadGameState()
{
    
}

void LoadGameState::enter(void*ptr)
{
    ZipFileResourceLoader::getInstance()->open(m_Filename.c_str());
    
    CameraEntityInfo *constructionInfo = new CameraEntityInfo(true);
    if(constructionInfo->m_IsOrthographicCamera)
    {
        constructionInfo->m_nearZ = -1024;
        constructionInfo->m_farZ = 1024;
    }
//    m_pOrthoCamera = dynamic_cast<CameraEntity*>(CameraFactory::getInstance()->get(CameraFactory::getInstance()->create(constructionInfo)));
    
    delete constructionInfo;
    constructionInfo = NULL;
    
//    CameraFactory::getInstance()->setOrthoCamera(m_pOrthoCamera);
    
    int size = 32;
    BaseTextViewInfo *info = new BaseTextViewInfo(ShaderFactory::getInstance()->getCurrentShaderID());
    
//    for(size_t i = 0; i < size; i++)
//    {
//        m_ObjectDrawingText.push_back(TextViewObjectFactory::getInstance()->create(info));
//        m_PercentageDrawingText.push_back(TextViewObjectFactory::getInstance()->create(info));
//    }
    
    delete info;
    info = NULL;
}

void LoadGameState::update(void*ptr, btScalar deltaTimeStep)
{
    if(ZipFileResourceLoader::getInstance()->finished())
    {
        ZipFileResourceLoader::getInstance()->close();
        
        GameStateMachine::getInstance()->pushGlobalState(m_NextState);
        //GameStateMachine::getInstance()->pushCurrentState(m_NextState);
    }
    else
    {
        ZipFileResourceLoader::getInstance()->extract();
        m_File = ZipFileResourceLoader::getInstance()->currentObjectName();
    }
    
    
    float denominator = ZipFileResourceLoader::getInstance()->numObjects();
    
    
    if(denominator > 0)
    {
        char buffer[32] = "";
        
        float numerator = ZipFileResourceLoader::getInstance()->currentObjectIndex();
        
        sprintf(buffer, "%.1f%%", (numerator / denominator) * 100.0f);
        m_Percentage = buffer;
        
        NSLog(@"%s: ", buffer);
        
//        TextViewObjectFactory::getInstance()->updateDrawText(m_Percentage,
//                                                             LocalizedTextViewObjectType_Monaco_32pt,
//                                                             btVector3(32, 0, 0),
//                                                             m_ObjectDrawingText);
//        
//        TextViewObjectFactory::getInstance()->updateDrawText(m_File,
//                                                             LocalizedTextViewObjectType_Monaco_32pt,
//                                                             btVector3(32, 128, 0),
//                                                             m_PercentageDrawingText);
    }
    NSLog(@"%s\n", m_File.c_str());
}

void  LoadGameState::render()
{
    //DebugString::log(DebugString::btVectorStr(m_pOrthoCamera->getOrigin()));
    //printf("%s\n", m_Percentage.c_str());
}

void LoadGameState::exit(void*ptr)
{
//    for(size_t i = 0; i < 32; i++)
//        TextViewObjectFactory::getInstance()->destroy(m_ObjectDrawingText[i]);
//    m_ObjectDrawingText.clear();
//    
//    for(size_t i = 0; i < 32; i++)
//        TextViewObjectFactory::getInstance()->destroy(m_PercentageDrawingText[i]);
//    m_PercentageDrawingText.clear();
//    
//    IDType ID = m_pOrthoCamera->getID();
//    CameraFactory::getInstance()->destroy(ID);
//    
//    CameraFactory::getInstance()->setOrthoCamera(NULL);
//    m_pOrthoCamera = NULL;
}

bool LoadGameState::onMessage(void*ptr, const Telegram&msg)
{
    
}

void LoadGameState::setZipFile(const std::string &filename)
{
    m_Filename = filename;
}

void LoadGameState::setOnFinishedState(const IDType ID)
{
    m_NextState = GameStateFactory::getInstance()->get(ID);
}