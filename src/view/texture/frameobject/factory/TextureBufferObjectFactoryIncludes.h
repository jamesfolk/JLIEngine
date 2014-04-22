//
//  TextureBufferObjectFactoryIncludes.h
//  BaseProject
//
//  Created by library on 10/9/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef BaseProject_TextureBufferObjectFactoryIncludes_h
#define BaseProject_TextureBufferObjectFactoryIncludes_h

enum TextureBufferObjectFactoryTypes_e
{
    TextureBufferObjectFactory_NONE,
    TextureBufferObjectFactory_SCENE,
    TextureBufferObjectFactory_ENTITIES,
    TextureBufferObjectFactory_MiniMaze,
    TextureBufferObjectFactory_MAX
};

struct TextureBufferObjectFactoryInfo
{
    TextureBufferObjectFactoryInfo(size_t width, size_t height) :
    m_Type(TextureBufferObjectFactory_NONE),
    m_width(width),
    m_height(height)
    {}
    virtual ~TextureBufferObjectFactoryInfo(){}
    
    TextureBufferObjectFactoryTypes_e m_Type;
    size_t m_width;
    size_t m_height;
};

#endif
