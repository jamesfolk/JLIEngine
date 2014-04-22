//
//  TextViewObjectFactory.cpp
//  GameAsteroids
//
//  Created by James Folk on 6/25/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "BaseViewObject.h"
#include "TextViewObjectFactory.h"

#include "TextViewObjectFactoryIncludes.h"
#include "BaseTextViewObject.h"
#include "GLDebugDrawer.h"
#include <sstream>
#include "TextureFactory.h"

TextViewObjectFactory::TextViewObjectFactory() :
m_TextViewObjects(new btAlignedObjectArray<BaseTextViewObject*>())
{
}

TextViewObjectFactory::~TextViewObjectFactory()
{
    delete m_TextViewObjects;
    m_TextViewObjects = NULL;
}


void TextViewObjectFactory::updateDrawText(const std::string text,
                                           const LocalizedTextViewObjectType &type,
                                           const btVector3 &position,
                                           const btAlignedObjectArray<IDType> &textRenderer,
                                           const btVector3 &writeDirection)const
{
    btAssert(text.length() <= textRenderer.size());
    
    btVector3 normalized_write_direction(writeDirection.normalized());

    char buffer[2];
    const TextInfo *pTextInfo = NULL;
    btVector3 current_position(position);
    BaseTextViewObject *pBaseTextViewObject = NULL;
    
    for(int i = 0; i < textRenderer.size(); i++)
    {
        pBaseTextViewObject = TextViewObjectFactory::getInstance()->get(textRenderer[i]);
        
        if(pBaseTextViewObject)
        {
            if(i < text.length())
            {
                sprintf(buffer, "%c", text.at(i));
                
                pBaseTextViewObject->setTextKey(std::string(buffer), type);
                pBaseTextViewObject->setPosition(current_position);
                
                pTextInfo = pBaseTextViewObject->getTextInfo();
                current_position.setX(current_position.x() + (pTextInfo->metrics.xAdvance * normalized_write_direction.x()));
                current_position.setY(current_position.y() + (pTextInfo->metrics.height * normalized_write_direction.y()));
                
                pBaseTextViewObject->show();
            }
            else
            {
                pBaseTextViewObject->hide();
            }
        }
    }
    
}

void TextViewObjectFactory::render()
{
//    if(GLDebugDrawer::getInstance())
//        return;
    
    for(int i = 0; i < m_TextViewObjects->size(); i++)
        (*m_TextViewObjects)[i]->render();
}

BaseTextViewObject *TextViewObjectFactory::ctor(BaseTextViewInfo *constructionInfo)
{
    BaseTextViewObject *pVO = new BaseTextViewObject(*constructionInfo);
    m_TextViewObjects->push_back(pVO);
    return pVO;
}
BaseTextViewObject *TextViewObjectFactory::ctor(int type)
{
    return NULL;
}

void TextViewObjectFactory::dtor(BaseTextViewObject *object)
{
    m_TextViewObjects->remove(object);
    delete object;
    object = NULL;
}