//
//  TextViewObjectFactory.h
//  GameAsteroids
//
//  Created by James Folk on 6/25/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__TextViewObjectFactory__
#define __GameAsteroids__TextViewObjectFactory__

#include "AbstractFactory.h"
#include "BaseTextViewObject.h"

class TextViewObjectFactory;
struct BaseTextViewInfo;

class TextViewObjectFactory :
public AbstractFactory<TextViewObjectFactory, BaseTextViewInfo, BaseTextViewObject>
{
    friend class AbstractSingleton;
    
    TextViewObjectFactory();
    virtual ~TextViewObjectFactory();
    
public:
    void render();
    
    void updateDrawText(const std::string text,
                        const LocalizedTextViewObjectType &type,
                        const btVector3 &position,
                        const btAlignedObjectArray<IDType> &textRenderer,
                        const btVector3 &writeDirection = btVector3(1.0f, 0.0f, 0.0f))const;
    
protected:
    virtual BaseTextViewObject *ctor(BaseTextViewInfo *constructionInfo);
    virtual BaseTextViewObject *ctor(int type = 0);
    virtual void dtor(BaseTextViewObject *object);
    
    btAlignedObjectArray<BaseTextViewObject*> *m_TextViewObjects;
};

#endif /* defined(__GameAsteroids__TextViewObjectFactory__) */
