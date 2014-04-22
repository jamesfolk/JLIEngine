//
//  EntityTextureBufferObject.h
//  BaseProject
//
//  Created by library on 10/10/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __BaseProject__EntityTextureBufferObject__
#define __BaseProject__EntityTextureBufferObject__

#include "BaseTextureBufferObject.h"
#include "btAlignedObjectArray.h"

class BaseEntity;
class BaseCamera;

class EntityTextureBufferObject :
public BaseTextureBufferObject
{
public:
    EntityTextureBufferObject(const TextureBufferObjectFactoryInfo &info):BaseTextureBufferObject(info){}
    virtual ~EntityTextureBufferObject(){}
    
    void addEntity(BaseEntity *);
    void setCamera(BaseCamera*);
protected:
    virtual void renderFBO();
private:
    btAlignedObjectArray<BaseEntity*> m_Entities;
    BaseCamera *m_pCamera;
};

#endif /* defined(__BaseProject__EntityTextureBufferObject__) */
