//
//  TextureFactoryIncludes.h
//  GameAsteroids
//
//  Created by James Folk on 3/15/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef GameAsteroids_TextureFactoryIncludes_h
#define GameAsteroids_TextureFactoryIncludes_h

#include <string>

#include "AbstractFactory.h"
//#include "TextureFactory.h"

enum TextureInfoAlphaState
{
    TextureInfoAlphaStateNone = 0,
    TextureInfoAlphaStateNonPremultiplied,
    TextureInfoAlphaStatePremultiplied
};

enum TextureInfoOrigin
{
    TextureInfoOriginUnknown = 0,
    TextureInfoOriginTopLeft,
    TextureInfoOriginBottomLeft
};

struct TextureInfo
{
    TextureInfo():
    name(0),
    target(0),
    width(0),
    height(0),
    alphaState(TextureInfoAlphaStateNone),
    textureOrigin(TextureInfoOriginUnknown),
    containsMipmaps(false){}
    
    GLuint                      name;
    GLenum                      target;
    GLuint                      width;
    GLuint                      height;
    TextureInfoAlphaState    alphaState;
    TextureInfoOrigin        textureOrigin;
    bool                        containsMipmaps;
};

//typedef std::string TextureFactoryKey;

enum TextureFactoryType
{
    TextureFactoryTypes_NONE,
    
    TextureFactoryTypes_File,
    TextureFactoryTypes_URL,
    TextureFactoryTypes_Data,
    TextureFactoryTypes_CGImage,
    
    TextureFactoryTypes_MAX
};

struct TextureFactoryInfo
{
    TextureFactoryInfo() :
    m_type(TextureFactoryTypes_File),
    right(""), left(""), top(""), bottom(""), front(""), back(""),
    isCubeMap(false)
    {
    }
    
    ~TextureFactoryInfo(){}
    
    TextureFactoryType m_type;
    
    union
    {
        std::string right;
        std::string url;
        std::string data;
        std::string cgimage;
    };
    
    std::string left;
    std::string top;
    std::string bottom;
    std::string front;
    std::string back;
    
    bool isCubeMap;
    
};



class GLKTextureInfoWrapper :
public AbstractFactoryObject
{
    friend class TextureFactory;
protected:
    GLKTextureInfoWrapper() :
    m_GLKTextureInfo(new TextureInfo),
    m_IsLoaded(false)
    {
        //m_GLKTextureInfo = nil;//[GLKTextureInfo alloc];
    }
    virtual ~GLKTextureInfoWrapper()
    {
        delete m_GLKTextureInfo;
        //[m_GLKTextureInfo release];
    }
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
    
    
    
    GLuint getWidth()const
    {
        return m_GLKTextureInfo->width;
        //return [m_GLKTextureInfo width];
    }
    
    GLuint getHeight()const
    {
        return m_GLKTextureInfo->height;
        //return [m_GLKTextureInfo height];
    }
    
    bool isTranslucent()const
    {
        return m_GLKTextureInfo->alphaState != TextureInfoAlphaStateNone;
//        return [m_GLKTextureInfo alphaState] != GLKTextureInfoAlphaStateNone;
    }
    
    bool containsMipMaps()const
    {
        return m_GLKTextureInfo->containsMipmaps;
//        return ([m_GLKTextureInfo containsMipmaps])?true:false;
    }

    TextureInfo *m_GLKTextureInfo;
    bool m_IsLoaded;
};


#endif
