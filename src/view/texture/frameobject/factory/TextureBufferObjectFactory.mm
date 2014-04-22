//
//  TextureBufferObjectFactory.cpp
//  BaseProject
//
//  Created by library on 10/9/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "TextureBufferObjectFactory.h"

#include "SceneTextureBufferObject.h"
#include "EntityTextureBufferObject.h"
#include "MazeMiniMapFBO.h"

void TextureBufferObjectFactory::render()
{
    btAlignedObjectArray<BaseTextureBufferObject*> objects;
    
    this->get(objects);
    for (int i = 0; i < objects.size(); i++)
    {
        objects.at(i)->render();
    }
}

BaseTextureBufferObject * TextureBufferObjectFactory::ctor(TextureBufferObjectFactoryInfo *constructionInfo)
{
    BaseTextureBufferObject *pBaseTextureBufferObject = NULL;
    
    switch (constructionInfo->m_Type)
    {
        case TextureBufferObjectFactory_SCENE:
        {
            pBaseTextureBufferObject = new SceneTextureBufferObject(*constructionInfo);
        }
            break;
        case TextureBufferObjectFactory_ENTITIES:
        {
            pBaseTextureBufferObject = new EntityTextureBufferObject(*constructionInfo);
        }
            break;
        case TextureBufferObjectFactory_MiniMaze:
        {
            MazeMiniMapFBOInfo *info = dynamic_cast<MazeMiniMapFBOInfo*>(constructionInfo);
            MazeMiniMapFBO *pfbo = new MazeMiniMapFBO(*info);
            pBaseTextureBufferObject = pfbo;
        }
            break;
        default:
            break;
    }
    
    return pBaseTextureBufferObject;
}
BaseTextureBufferObject *TextureBufferObjectFactory::ctor(int type)
{
    return NULL;
}
void TextureBufferObjectFactory::dtor(BaseTextureBufferObject *object)
{
    delete object;
    object = NULL;
}