//
//  BaseTextureBufferObject.h
//  BaseProject
//
//  Created by library on 10/9/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __BaseProject__BaseTextureBufferObject__
#define __BaseProject__BaseTextureBufferObject__

#include "AbstractFactory.h"
#include "TextureBufferObjectFactoryIncludes.h"
//#include "TextureBufferObjectFactory.h"

class BaseTextureBufferObject :
public AbstractFactoryObject
{
    friend class TextureBufferObjectFactory;
    
protected:
    BaseTextureBufferObject(const TextureBufferObjectFactoryInfo &info);
    virtual ~BaseTextureBufferObject();
public:
    SIMD_FORCE_INLINE IDType getID()const
    {
        return AbstractFactoryObject::getID();
    }
    
    SIMD_FORCE_INLINE const std::string &getName()const
    {
        return AbstractFactoryObject::getName();
    }
    
    SIMD_FORCE_INLINE void setName(const std::string &name)
    {
        AbstractFactoryObject::setName(name);
    }
    
    
    bool isLoaded()const;
    void load();
    void render();
    GLuint name()const;
    void unload();
    
protected:
    virtual void renderFBO() = 0;
    
private:
    //-(void)renderFBO:(GLuint)fbo tex:(GLuint)texture
    void _renderFBO(GLuint fbo);
    bool validateDimensions(size_t width, size_t height)const;
    
    GLuint m_textureA;
    GLuint m_textureB;
    int m_height;
    int m_width;
    int m_counter;
    GLuint m_fboA;
    GLuint m_fboB;
    GLuint m_dbA;
    GLuint m_dbB;
};

#endif /* defined(__BaseProject__BaseTextureBufferObject__) */
