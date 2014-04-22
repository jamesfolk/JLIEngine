//
//  TextureBehaviorFactory.cpp
//  GameAsteroids
//
//  Created by James Folk on 6/19/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "TextureBehaviorFactory.h"
#include "BaseTextureBehavior.h"

BaseTextureBehavior *TextureBehaviorFactory::ctor(TextureBehaviorInfo *constructionInfo)
{
    return new BaseTextureBehavior(*constructionInfo);
}
BaseTextureBehavior *TextureBehaviorFactory::ctor(int type)
{
    return NULL;
}
void TextureBehaviorFactory::dtor(BaseTextureBehavior *object)
{
    delete object;
    object = NULL;
}