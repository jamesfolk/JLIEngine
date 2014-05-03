//
//  TextureFactory.cpp
//  GameAsteroids
//
//  Created by James Folk on 3/14/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "TextureFactory.h"
#include "ZipFileResourceLoader.h"
//#include <GLKit/GLKTextureLoader.h>
#include "FileLoader.h"

TextureFactory::TextureFactory()
{
    
}
TextureFactory::~TextureFactory()
{
}

IDType TextureFactory::createTextureFromData(const char *zipfile_object_name)
{
    return createTextureFromData(std::string(zipfile_object_name));
}
IDType TextureFactory::createTextureFromData(const std::string &zipfile_object_name)
{
    TextureFactoryInfo *info = new TextureFactoryInfo();
    info->right = zipfile_object_name;
    info->m_type = TextureFactoryTypes_Data;
    
    IDType ret = TextureFactory::getInstance()->create(info);
    
    delete info;
    
    return ret;
}


void TextureFactory::buildTextureFromData(const std::string &name, GLKTextureInfoWrapper *t)
{
//    NSDictionary *options = @{ GLKTextureLoaderGenerateMipmaps : @YES };
//    JLIstream *pStream = ZipFileResourceLoader::getInstance()->getImageData(name.c_str());
//    NSData *data = [NSData dataWithBytes:pStream->buf length:pStream->size];
//    bool asynch = false;
//    
//    if(!name.empty())
//    {
//        {
//            NSError *error = nil;
//            
//            GLKTextureInfo *info = [GLKTextureLoader textureWithContentsOfData:data
//                                                                       options:options
//                                                                         error:&error];
//            
//            t->m_GLKTextureInfo->alphaState = (TextureInfoAlphaState)[info alphaState];
//            t->m_GLKTextureInfo->containsMipmaps = [info containsMipmaps];
//            t->m_GLKTextureInfo->height = [info height];
//            t->m_GLKTextureInfo->name = [info name];
//            t->m_GLKTextureInfo->target = [info target];
//            t->m_GLKTextureInfo->textureOrigin = (TextureInfoOrigin)[info textureOrigin];
//            
//            
//            
//            
//            
//            
//            if(error)
//            {
//                NSLog(@"Error loading texture from data(%s): %@", name.c_str(), error.debugDescription);
//                t->m_GLKTextureInfo = nil;
//                t->m_IsLoaded = false;
//            }
//            else
//            {
//                t->m_IsLoaded = true;
//            }
//        }
//    }
}

void TextureFactory::buildTextureFromFile(const std::string &file, GLKTextureInfoWrapper *t)
{
//    NSDictionary *options = @{ GLKTextureLoaderGenerateMipmaps : @YES };
//    
//    bool asynch = false;
//    
//    if(!file.empty())
//    {
//        {
//            NSError *error = nil;
//            
//            NSString *path = [NSString stringWithUTF8String:FileLoader::getInstance()->getFilePath(file).c_str()];
//            
//            GLKTextureInfo *info = [GLKTextureLoader textureWithContentsOfFile:path
//                                                                       options:options
//                                                                         error:&error];
//            
//            t->m_GLKTextureInfo->alphaState = (TextureInfoAlphaState)[info alphaState];
//            t->m_GLKTextureInfo->containsMipmaps = [info containsMipmaps];
//            t->m_GLKTextureInfo->height = [info height];
//            t->m_GLKTextureInfo->name = [info name];
//            t->m_GLKTextureInfo->target = [info target];
//            t->m_GLKTextureInfo->textureOrigin = (TextureInfoOrigin)[info textureOrigin];
//            
////
//            if(error)
//            {
//                NSLog(@"Error loading texture from data(%s): %@", file.c_str(), error.debugDescription);
//                t->m_GLKTextureInfo = nil;
//                t->m_IsLoaded = false;
//            }
//            else
//            {
//                t->m_IsLoaded = true;
//            }
//        }
//    }
}

void TextureFactory::buildTextureFromURL(const std::string &url, GLKTextureInfoWrapper *t)
{
//    NSDictionary *options = @{ GLKTextureLoaderGenerateMipmaps : @YES };
//    NSURL *_url = [[NSURL alloc] initWithString:[NSString stringWithUTF8String:url.c_str()]];
//    bool asynch = false;
//    
//    if(!url.empty())
//    {
//        
//        {
//            NSError *error = nil;
//            
//            GLKTextureInfo *info = [GLKTextureLoader textureWithContentsOfURL:_url
//                                                                      options:options
//                                                                        error:&error];
//            
//            t->m_GLKTextureInfo->alphaState = (TextureInfoAlphaState)[info alphaState];
//            t->m_GLKTextureInfo->containsMipmaps = [info containsMipmaps];
//            t->m_GLKTextureInfo->height = [info height];
//            t->m_GLKTextureInfo->name = [info name];
//            t->m_GLKTextureInfo->target = [info target];
//            t->m_GLKTextureInfo->textureOrigin = (TextureInfoOrigin)[info textureOrigin];
//            
//            if(error)
//            {
//                NSLog(@"Error loading texture from data(%s): %@", url.c_str(), error.debugDescription);
//                t->m_GLKTextureInfo = nil;
//                t->m_IsLoaded = false;
//            }
//            else
//            {
//                t->m_IsLoaded = true;
//            }
//        }
//    }
}



GLKTextureInfoWrapper * TextureFactory::ctor(TextureFactoryInfo *constructionInfo)
{
    btAssert(!constructionInfo->isCubeMap);
    
    GLKTextureInfoWrapper *t = new GLKTextureInfoWrapper();
    
    switch(constructionInfo->m_type)
    {
        default:
            btAssert(true);
            break;
            
        case TextureFactoryTypes_File:
        {
            TextureFactory::buildTextureFromFile(constructionInfo->right, t);
        }
            break;
        case TextureFactoryTypes_URL:
        {
            TextureFactory::buildTextureFromURL(constructionInfo->right, t);
        }
            break;
        case TextureFactoryTypes_Data:
        {
            TextureFactory::buildTextureFromData(constructionInfo->right, t);
        }
            break;
        case TextureFactoryTypes_CGImage:
        {
            
        }
            break;
    }
    
    return t;
    
}

GLKTextureInfoWrapper *TextureFactory::ctor(int type)
{
    return NULL;
}

void TextureFactory::dtor(GLKTextureInfoWrapper *object)
{
    const GLuint array[1] = {object->m_GLKTextureInfo->name};
    glDeleteTextures(1, array);
    
    object->m_GLKTextureInfo = nil;
    
    delete object;
    object = NULL;
}
