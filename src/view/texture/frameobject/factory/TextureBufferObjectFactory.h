//
//  TextureBufferObjectFactory.h
//  BaseProject
//
//  Created by library on 10/9/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __BaseProject__TextureBufferObjectFactory__
#define __BaseProject__TextureBufferObjectFactory__

#include "AbstractFactory.h"
#include "TextureBufferObjectFactoryIncludes.h"
#include "BaseTextureBufferObject.h"

class TextureBufferObjectFactory;

class TextureBufferObjectFactory :
public AbstractFactory<TextureBufferObjectFactory, TextureBufferObjectFactoryInfo, BaseTextureBufferObject>
{
    friend class AbstractSingleton;
    
    TextureBufferObjectFactory(){}
    virtual ~TextureBufferObjectFactory(){}
public:
    virtual void render();
    
protected:
    virtual BaseTextureBufferObject * ctor(TextureBufferObjectFactoryInfo *constructionInfo);
    virtual BaseTextureBufferObject *ctor(int type = 0);
    virtual void dtor(BaseTextureBufferObject *object);
};

#endif /* defined(__BaseProject__TextureBufferObjectFactory__) */
