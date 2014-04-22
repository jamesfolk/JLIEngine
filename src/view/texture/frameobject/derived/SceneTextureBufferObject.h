//
//  SceneTextureBufferObject.h
//  BaseProject
//
//  Created by library on 10/9/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __BaseProject__SceneTextureBufferObject__
#define __BaseProject__SceneTextureBufferObject__

#include "BaseTextureBufferObject.h"

class SceneTextureBufferObject :
public BaseTextureBufferObject
{
public:
    SceneTextureBufferObject(const TextureBufferObjectFactoryInfo &info):BaseTextureBufferObject(info){}
    virtual ~SceneTextureBufferObject(){}
    
protected:
    virtual void renderFBO();
};

#endif /* defined(__BaseProject__SceneTextureBufferObject__) */
