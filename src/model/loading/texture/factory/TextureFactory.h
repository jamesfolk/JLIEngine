//
//  TextureFactory.h
//  GameAsteroids
//
//  Created by James Folk on 3/14/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__TextureFactory__
#define __GameAsteroids__TextureFactory__

#include "AbstractFactory.h"
#include "TextureFactoryIncludes.h"


class TextureFactory;

//#define CREATE_TEXTURE(filename) TextureFactory::getInstance()->createSharedObject(filename)
//#define DESTROY_TEXTURE(filename) TextureFactory::getInstance()->destroySharedObject(filename)

class TextureFactory :
public AbstractFactory<TextureFactory, TextureFactoryInfo, GLKTextureInfoWrapper>
{
    friend class AbstractSingleton;
    
    TextureFactory();
    virtual ~TextureFactory();
public:
    static IDType createTextureFromData(const char *zipfile_object_name);
    static IDType createTextureFromData(const std::string &zipfile_object_name);
    
    static void buildTextureFromData(const std::string &name, GLKTextureInfoWrapper *t);
    static void buildTextureFromFile(const std::string &file, GLKTextureInfoWrapper *t);
    static void buildTextureFromURL(const std::string &url, GLKTextureInfoWrapper *t);
    //Right(+x), Left(-x), Top(+y), Bottom(-y), Front(+z), Back(-z)
//    static GLKTextureInfo *buildCubeMap(const std::string &right,
//                                        const std::string &left,
//                                        const std::string &top,
//                                        const std::string &bottom,
//                                        const std::string &front,
//                                        const std::string &back);
//    void setShareGroup(EAGLSharegroup *sharegroup)
//    {
//        m_sharegroup = sharegroup;
//    }
//    EAGLSharegroup * getShareGroup()const
//    {
//        return m_sharegroup;
//    }
protected:
    virtual GLKTextureInfoWrapper * ctor(TextureFactoryInfo *constructionInfo);
    virtual GLKTextureInfoWrapper *ctor(int type = 0);
    virtual void dtor(GLKTextureInfoWrapper *object);
    
private:
    //EAGLSharegroup *m_sharegroup;
};

#endif /* defined(__GameAsteroids__TextureFactory__) */
