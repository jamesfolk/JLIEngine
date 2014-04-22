//
//  TextureBehaviorFactory.h
//  GameAsteroids
//
//  Created by James Folk on 6/19/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__TextureBehaviorFactory__
#define __GameAsteroids__TextureBehaviorFactory__

#include "AbstractFactory.h"
#include "TextureBehaviorFactoryIncludes.h"

class BaseTextureBehavior;
class TextureBehaviorFactory;

class TextureBehaviorFactory :
public AbstractFactory<TextureBehaviorFactory, TextureBehaviorInfo, BaseTextureBehavior>
{
    friend class AbstractSingleton;
    
    TextureBehaviorFactory(){}
    virtual ~TextureBehaviorFactory(){}
protected:
    virtual BaseTextureBehavior *ctor(TextureBehaviorInfo *constructionInfo);
    virtual BaseTextureBehavior *ctor(int type = 0);
    virtual void dtor(BaseTextureBehavior *object);
};

#endif /* defined(__GameAsteroids__TextureBehaviorFactory__) */
