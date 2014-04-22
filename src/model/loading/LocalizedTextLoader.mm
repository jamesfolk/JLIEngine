//
//  LocalizedTextLoader.cpp
//  BaseProject
//
//  Created by library on 9/12/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "LocalizedTextLoader.h"
#include <sstream>
#include "UtilityFunctions.h"
#include "TextureFactoryIncludes.h"
#include "TextureFactory.h"

LocalizedTextLoader::LocalizedTextLoader() :
m_LocalizedTextViewObjects(new btAlignedObjectArray<LocalizedTextViewObjectType>),
m_pTextInfoMapHashMap(new TextInfoMapHashMap()),
m_pImageNameArrayHashMap(new ImageNameArrayHashMap()),
m_pTextureMapHashMap(new TextureMapHashMap())
{
    
}

LocalizedTextLoader::~LocalizedTextLoader()
{
    LocalizedTextHashMap *pLocalizedTextHashMap = NULL;
    TextInfo *pTextInfo = NULL;
    for(int i = 0; i < m_pTextInfoMapHashMap->size(); i++)
    {
        pLocalizedTextHashMap = *m_pTextInfoMapHashMap->getAtIndex(i);
        for(int j = 0; j < pLocalizedTextHashMap->size(); j++)
        {
            pTextInfo = *pLocalizedTextHashMap->getAtIndex(j);
            delete pTextInfo;
            pTextInfo = NULL;
        }
        pLocalizedTextHashMap->clear();
        
        delete pLocalizedTextHashMap;
        pLocalizedTextHashMap = NULL;
    }
    m_pTextInfoMapHashMap->clear();
    delete m_pTextInfoMapHashMap;
    m_pTextInfoMapHashMap = NULL;
    
    
    AllocatedNamesArray *pAllocatedNamesArray = NULL;
    char *buffer = NULL;
    for (int i = 0; i < m_pImageNameArrayHashMap->size(); i++)
    {
        pAllocatedNamesArray = *m_pImageNameArrayHashMap->getAtIndex(i);
        for(int j = 0; j < pAllocatedNamesArray->size(); j++)
        {
            buffer = pAllocatedNamesArray->at(j);
            delete buffer;
            buffer = NULL;
        }
        pAllocatedNamesArray->clear();
        delete pAllocatedNamesArray;
        pAllocatedNamesArray = NULL;
    }
    m_pImageNameArrayHashMap->clear();
    delete m_pImageNameArrayHashMap;
    m_pImageNameArrayHashMap = NULL;
    
    TextureIdHashmap *pTextureIdHashmap;
    IDType textureID = 0;
    for (int i = 0; i < m_pTextureMapHashMap->size(); i++)
    {
        pTextureIdHashmap = *m_pTextureMapHashMap->getAtIndex(i);
        for (int j = 0; j < pTextureIdHashmap->size(); j++)
        {
            textureID = *pTextureIdHashmap->getAtIndex(j);
            TextureFactory::getInstance()->destroy(textureID);
            textureID = 0;
        }
        pTextureIdHashmap->clear();
        delete pTextureIdHashmap;
        pTextureIdHashmap = NULL;
    }
    m_pTextureMapHashMap->clear();
    delete m_pTextureMapHashMap;
    m_pTextureMapHashMap = NULL;
    
    m_LocalizedTextViewObjects->clear();
    delete m_LocalizedTextViewObjects;
    m_LocalizedTextViewObjects = NULL;
}

void LocalizedTextLoader::load(LocalizedTextViewObjectType type)
{
    btAssert(type != LocalizedTextViewObjectType_NONE);
    btAssert(type != LocalizedTextViewObjectType_MAX);
    
    if(NULL == m_pTextInfoMapHashMap->find(btHashInt(type)))
    {
        char buffer[2048] = "";
        std::sprintf(buffer,
                     "%s_%d",
                     g_LocalizedTextViewObjectStructData[type].font_name.c_str(),
                     g_LocalizedTextViewObjectStructData[type].font_size);
        NSString *localized_key = [NSString stringWithUTF8String:buffer];
        
        std::sprintf(buffer,
                     "%s_Localized",
                     g_LocalizedTextViewObjectStructData[type].font_name.c_str());
        NSString *localized_tbl = [NSString stringWithUTF8String:buffer];
        
        
        NSString *s = NSLocalizedStringFromTable(localized_key, localized_tbl, nil);
        
        std::string localizedTextDataToParse([s UTF8String]);
        
        std::istringstream iss0(localizedTextDataToParse);
        std::string mainToken;
        
        
        LocalizedTextHashMap *pLocalizedTextHashMap = new LocalizedTextHashMap();
        AllocatedNamesArray *pAllocatedNamesArray = new AllocatedNamesArray();
        TextureIdHashmap *pTextureIdHashmap = new TextureIdHashmap();
        
        while(getline(iss0, mainToken, ';'))
        {
            std::istringstream iss(mainToken);
            std::string token;
            TextOrigin origin;
            TextMetrics metrics;
            
            getline(iss, token, ',');
            std::string key = (token);
            
            if(key.empty())
                continue;
            
            getline(iss, token, ',');
            std::string textureFile = trim(token);
            
            getline(iss, token, ',');
            int textureFileWidth = std::atoi(token.c_str());
            
            getline(iss, token, ',');
            int textureFileHeight = std::atoi(token.c_str());
            
            getline(iss, token, ',');
            origin.x = std::atoi(token.c_str());
            
            getline(iss, token, ',');
            origin.y = std::atoi(token.c_str());
            
            getline(iss, token, ',');
            metrics.xBearing = std::atoi(token.c_str());
            
            getline(iss, token, ',');
            metrics.yBearing = std::atoi(token.c_str());
            
            getline(iss, token, ',');
            metrics.width = std::atoi(token.c_str());
            
            getline(iss, token, ',');
            metrics.height = std::atoi(token.c_str());
            
            getline(iss, token, ',');
            metrics.xAdvance = std::atoi(token.c_str());
            
            getline(iss, token, ',');
            metrics.yAdvance = std::atoi(token.c_str());
            
            TextInfo *pTextInfo = new TextInfo(textureFile,
                                               textureFileWidth, textureFileHeight,
                                               origin.x, origin.y,
                                               metrics.xBearing, metrics.yBearing,
                                               metrics.width, metrics.height,
                                               metrics.xAdvance, metrics.yAdvance);
            
            
            char *buffer = new char[key.length()];
            strcpy(buffer, key.c_str());
            
            btAssert(NULL == pLocalizedTextHashMap->find(btHashString(buffer)));
            
            pAllocatedNamesArray->push_back(buffer);
            pLocalizedTextHashMap->insert(btHashString(buffer), pTextInfo);
            
            buffer = new char[textureFile.length()];
            strcpy(buffer, textureFile.c_str());
            
            if(NULL == pTextureIdHashmap->find(btHashString(buffer)))
            {
                pAllocatedNamesArray->push_back(buffer);
                
                TextureFactoryInfo info;
                info.right = textureFile;
                IDType textureFactoryID = TextureFactory::getInstance()->create(&info);
                
                pTextureIdHashmap->insert(btHashString(buffer), textureFactoryID);
            }
            else
            {
                delete [] buffer;
                buffer = NULL;
            }
            
        }
        m_pTextInfoMapHashMap->insert(btHashInt(type), pLocalizedTextHashMap);
        m_pImageNameArrayHashMap->insert(btHashInt(type), pAllocatedNamesArray);
        m_pTextureMapHashMap->insert(btHashInt(type), pTextureIdHashmap);
        
        m_LocalizedTextViewObjects->push_back(type);
    }
    
}
void LocalizedTextLoader::unLoad(LocalizedTextViewObjectType type)
{
    btAssert(type != LocalizedTextViewObjectType_NONE);
    btAssert(type != LocalizedTextViewObjectType_MAX);
    
    LocalizedTextHashMap *pLocalizedTextHashMap = *m_pTextInfoMapHashMap->find(btHashInt(type));
    
    if(NULL !=  pLocalizedTextHashMap)
    {
        TextInfo *pTextInfo = NULL;
        for(int i = 0; i < pLocalizedTextHashMap->size(); i++)
        {
            pTextInfo = *(pLocalizedTextHashMap->getAtIndex(i));
            delete pTextInfo;
            pTextInfo = NULL;
        }
        pLocalizedTextHashMap->clear();
        delete pLocalizedTextHashMap;
        pLocalizedTextHashMap = NULL;
        
        m_pTextInfoMapHashMap->remove(btHashInt(type));
        
        AllocatedNamesArray *pAllocatedNamesArray = *m_pImageNameArrayHashMap->find(btHashInt(type));
        char *temp = NULL;
        for (int i = 0; i < pAllocatedNamesArray->size(); i++)
        {
            temp = (*pAllocatedNamesArray)[i];
            delete [] temp;
            temp = NULL;
        }
        pAllocatedNamesArray->clear();
        delete pAllocatedNamesArray;
        pAllocatedNamesArray = NULL;
        
        m_pImageNameArrayHashMap->remove(btHashInt(type));
        
        TextureIdHashmap *pTextureIdHashmap = *m_pTextureMapHashMap->find(btHashInt(type));
        pTextureIdHashmap->clear();
        delete pTextureIdHashmap;
        pTextureIdHashmap = NULL;
        
        m_pTextureMapHashMap->remove(btHashInt(type));
    }
}

void LocalizedTextLoader::unLoadAll()
{
    LocalizedTextHashMap *pLocalizedTextHashMap = NULL;
    TextInfo *pTextInfo = NULL;
    for(int i = 0; i < m_pTextInfoMapHashMap->size(); i++)
    {
        pLocalizedTextHashMap = *m_pTextInfoMapHashMap->getAtIndex(i);
        for(int j = 0; j < pLocalizedTextHashMap->size(); j++)
        {
            pTextInfo = *pLocalizedTextHashMap->getAtIndex(j);
            delete pTextInfo;
            pTextInfo = NULL;
        }
        pLocalizedTextHashMap->clear();
        
        delete pLocalizedTextHashMap;
        pLocalizedTextHashMap = NULL;
    }
    m_pTextInfoMapHashMap->clear();
    
    
    AllocatedNamesArray *pAllocatedNamesArray = NULL;
    char *buffer = NULL;
    for (int i = 0; i < m_pImageNameArrayHashMap->size(); i++)
    {
        pAllocatedNamesArray = *m_pImageNameArrayHashMap->getAtIndex(i);
        for(int j = 0; j < pAllocatedNamesArray->size(); j++)
        {
            buffer = pAllocatedNamesArray->at(j);
            delete buffer;
            buffer = NULL;
        }
        pAllocatedNamesArray->clear();
        delete pAllocatedNamesArray;
        pAllocatedNamesArray = NULL;
    }
    m_pImageNameArrayHashMap->clear();
    
    TextureIdHashmap *pTextureIdHashmap;
    IDType textureID = 0;
    for (int i = 0; i < m_pTextureMapHashMap->size(); i++)
    {
        pTextureIdHashmap = *m_pTextureMapHashMap->getAtIndex(i);
        for (int j = 0; j < pTextureIdHashmap->size(); j++)
        {
            textureID = *pTextureIdHashmap->getAtIndex(j);
            TextureFactory::getInstance()->destroy(textureID);
            textureID = 0;
        }
        pTextureIdHashmap->clear();
        delete pTextureIdHashmap;
        pTextureIdHashmap = NULL;
    }
    m_pTextureMapHashMap->clear();
    
    m_LocalizedTextViewObjects->clear();
}

const TextInfo *LocalizedTextLoader::getTextInfo(const std::string &localized_key, LocalizedTextViewObjectType type) const
{
    const TextInfo *pTextInfo = NULL;
    
    btAssert(type != LocalizedTextViewObjectType_NONE);
    btAssert(type != LocalizedTextViewObjectType_MAX);
    
    LocalizedTextHashMap *pLocalizedTextHashMap = *m_pTextInfoMapHashMap->find(btHashInt(type));
    if(pLocalizedTextHashMap)
    {
        pTextInfo = *pLocalizedTextHashMap->find(btHashString(localized_key.c_str()));
    }
    return pTextInfo;
}
TextInfo *LocalizedTextLoader::getTextInfo(const std::string &localized_key, LocalizedTextViewObjectType type)
{
    TextInfo *pTextInfo = NULL;
    
    btAssert(type != LocalizedTextViewObjectType_NONE);
    btAssert(type != LocalizedTextViewObjectType_MAX);
    
    LocalizedTextHashMap *pLocalizedTextHashMap = *m_pTextInfoMapHashMap->find(btHashInt(type));
    if(pLocalizedTextHashMap)
    {
        pTextInfo = *pLocalizedTextHashMap->find(btHashString(localized_key.c_str()));
    }
    return pTextInfo;
}

IDType LocalizedTextLoader::getTextureFactoryID(const std::string &localized_key,LocalizedTextViewObjectType type)const
{
    btAssert(type != LocalizedTextViewObjectType_NONE);
    btAssert(type != LocalizedTextViewObjectType_MAX);
    
    IDType *textureFactoryID = NULL;
    TextureIdHashmap *pTextureIdHashmap = *m_pTextureMapHashMap->find(btHashInt(type));
    if(pTextureIdHashmap)
    {
        std::string texture_file = getTextInfo(localized_key, type)->fileName;
        textureFactoryID = pTextureIdHashmap->find(btHashString(texture_file.c_str()));
    }
    if(textureFactoryID)
        return *textureFactoryID;
    return NULL;
    
}
