//
//  TextureFactory.cpp
//  GameAsteroids
//
//  Created by James Folk on 3/14/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "TextureFactory.h"
#include "ZipFileResourceLoader.h"
#include <GLKit/GLKTextureLoader.h>
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
    NSDictionary *options = @{ GLKTextureLoaderGenerateMipmaps : @YES };
    JLIstream *pStream = ZipFileResourceLoader::getInstance()->getImageData(name.c_str());
    NSData *data = [NSData dataWithBytes:pStream->buf length:pStream->size];
    bool asynch = false;
    
    if(!name.empty())
    {
//        if(asynch)
//        {
//            GLKTextureLoaderCallback completionBlock = ^(GLKTextureInfo *GLTextureName, NSError *error)
//            {
//                if(error)
//                {
//                    NSLog(@"Error loading texture from data(%s): %@", name.c_str(), error.debugDescription);
//                    t->m_GLKTextureInfo = nil;
//                    t->m_IsLoaded = false;
//                }
//                else
//                {
//                    t->m_GLKTextureInfo = GLTextureName;
//                    t->m_IsLoaded = true;
//                }
//            };
//
//            GLKTextureLoader *loader = [[GLKTextureLoader alloc] initWithSharegroup:TextureFactory::getInstance()->getShareGroup()];
//
//            glGetError();
//
//            [loader textureWithContentsOfData:data
//                                      options:options
//                                        queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
//                            completionHandler:completionBlock];
//        }
//        else
        {
            NSError *error = nil;
            
            GLKTextureInfo *info = [GLKTextureLoader textureWithContentsOfData:data
                                                                       options:options
                                                                         error:&error];
            
            t->m_GLKTextureInfo->alphaState = (TextureInfoAlphaState)[info alphaState];
            t->m_GLKTextureInfo->containsMipmaps = [info containsMipmaps];
            t->m_GLKTextureInfo->height = [info height];
            t->m_GLKTextureInfo->name = [info name];
            t->m_GLKTextureInfo->target = [info target];
            t->m_GLKTextureInfo->textureOrigin = (TextureInfoOrigin)[info textureOrigin];
            
            
            
            
            
            
            
            
//            t->m_GLKTextureInfo = [GLKTextureLoader textureWithContentsOfData:data
//                                                          options:options
//                                                            error:&error];
            if(error)
            {
                NSLog(@"Error loading texture from data(%s): %@", name.c_str(), error.debugDescription);
                t->m_GLKTextureInfo = nil;
                t->m_IsLoaded = false;
            }
            else
            {
                t->m_IsLoaded = true;
            }
        }
    }
}

void TextureFactory::buildTextureFromFile(const std::string &file, GLKTextureInfoWrapper *t)
{
    NSDictionary *options = @{ GLKTextureLoaderGenerateMipmaps : @YES };
    
    bool asynch = false;
    
    if(!file.empty())
    {
//        if(asynch)
//        {
//            GLKTextureLoaderCallback completionBlock = ^(GLKTextureInfo *GLTextureName, NSError *error)
//            {
//                if(error)
//                {
//                    NSLog(@"Error loading texture from data(%s): %@", file.c_str(), error.debugDescription);
//                    t->m_GLKTextureInfo = nil;
//                    t->m_IsLoaded = false;
//                }
//                else
//                {
//                    t->m_GLKTextureInfo = GLTextureName;
//                    t->m_IsLoaded = true;
//                }
//            };
//
//            
//            GLKTextureLoader *loader = [[GLKTextureLoader alloc] initWithSharegroup:TextureFactory::getInstance()->getShareGroup()];
//
//            glGetError();
//
//            [loader textureWithContentsOfFile:getBundledFile(file)
//                                      options:options
//                                        queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
//                            completionHandler:completionBlock];
//        }
//        else
        {
            NSError *error = nil;
            
            NSString *path = [NSString stringWithUTF8String:FileLoader::getInstance()->getFilePath(file).c_str()];
            
            GLKTextureInfo *info = [GLKTextureLoader textureWithContentsOfFile:path
                                                                       options:options
                                                                         error:&error];
            
            t->m_GLKTextureInfo->alphaState = (TextureInfoAlphaState)[info alphaState];
            t->m_GLKTextureInfo->containsMipmaps = [info containsMipmaps];
            t->m_GLKTextureInfo->height = [info height];
            t->m_GLKTextureInfo->name = [info name];
            t->m_GLKTextureInfo->target = [info target];
            t->m_GLKTextureInfo->textureOrigin = (TextureInfoOrigin)[info textureOrigin];
            
//            t->m_GLKTextureInfo = [GLKTextureLoader textureWithContentsOfFile:getBundledFile(file)
//                                                                      options:options
//                                                                        error:&error];
            
            if(error)
            {
                NSLog(@"Error loading texture from data(%s): %@", file.c_str(), error.debugDescription);
                t->m_GLKTextureInfo = nil;
                t->m_IsLoaded = false;
            }
            else
            {
                t->m_IsLoaded = true;
            }
        }
    }
}

void TextureFactory::buildTextureFromURL(const std::string &url, GLKTextureInfoWrapper *t)
{
    NSDictionary *options = @{ GLKTextureLoaderGenerateMipmaps : @YES };
    NSURL *_url = [[NSURL alloc] initWithString:[NSString stringWithUTF8String:url.c_str()]];
    bool asynch = false;
    
    if(!url.empty())
    {
//        if(asynch)
//        {
//            GLKTextureLoaderCallback completionBlock = ^(GLKTextureInfo *GLTextureName, NSError *error)
//            {
//                
//                
//                if(error)
//                {
//                    NSLog(@"Error loading texture from data(%s): %@", url.c_str(), error.debugDescription);
//                    t->m_GLKTextureInfo = nil;
//                    t->m_IsLoaded = false;
//                }
//                else
//                {
//                    t->m_GLKTextureInfo = GLTextureName;
//                    t->m_IsLoaded = true;
//                }
//            };
//            
//            GLKTextureLoader *loader = [[GLKTextureLoader alloc] initWithSharegroup:TextureFactory::getInstance()->getShareGroup()];
//            
//            glGetError();
//            
//            [loader textureWithContentsOfURL:_url
//                                     options:options
//                                       queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
//                           completionHandler:completionBlock];
//        }
//        else
        {
            NSError *error = nil;
            
            GLKTextureInfo *info = [GLKTextureLoader textureWithContentsOfURL:_url
                                                                      options:options
                                                                        error:&error];
            
            t->m_GLKTextureInfo->alphaState = (TextureInfoAlphaState)[info alphaState];
            t->m_GLKTextureInfo->containsMipmaps = [info containsMipmaps];
            t->m_GLKTextureInfo->height = [info height];
            t->m_GLKTextureInfo->name = [info name];
            t->m_GLKTextureInfo->target = [info target];
            t->m_GLKTextureInfo->textureOrigin = (TextureInfoOrigin)[info textureOrigin];
            
//            t->m_GLKTextureInfo = [GLKTextureLoader textureWithContentsOfURL:_url
//                                                                     options:options
//                                                                       error:&error];
            
            if(error)
            {
                NSLog(@"Error loading texture from data(%s): %@", url.c_str(), error.debugDescription);
                t->m_GLKTextureInfo = nil;
                t->m_IsLoaded = false;
            }
            else
            {
                t->m_IsLoaded = true;
            }
        }
    }
}

//Right(+x), Left(-x), Top(+y), Bottom(-y), Front(+z), Back(-z)
//GLKTextureInfo *TextureFactory::buildCubeMap(const std::string &right,
//                                             const std::string &left,
//                                             const std::string &top,
//                                             const std::string &bottom,
//                                             const std::string &front,
//                                             const std::string &back)
//{
//    GLKTextureInfo *texture = nil;
//    NSDictionary *options = @{ GLKTextureLoaderGenerateMipmaps : @YES };
//    
//    if(!right.empty() &&
//       !left.empty() &&
//       !top.empty() &&
//       !bottom.empty() &&
//       !front.empty() &&
//       !back.empty())
//    {
//    
//        NSArray *cubeMapFileNames = [NSArray arrayWithObjects:
//                                     getBundledFile(right),
//                                     getBundledFile(left),
//                                     getBundledFile(top),
//                                     getBundledFile(bottom),
//                                     getBundledFile(front),
//                                     getBundledFile(back),
//                                     nil];
//        NSError *error;
//        texture = [GLKTextureLoader cubeMapWithContentsOfFiles:cubeMapFileNames
//                                                            options:options
//                                                              error:&error];
//        
//        if(error)
//        {
//            NSLog(@"Error loading cubemap from image(%s,%s,%s,%s,%s,%s): %@",
//                  right.c_str(),
//                  left.c_str(),
//                  top.c_str(),
//                  bottom.c_str(),
//                  front.c_str(),
//                  back.c_str(),
//                  error.debugDescription);
//        }
//    }
//    
//    return texture;
//}

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
    
    
//    GLKTextureInfoWrapper *t = new GLKTextureInfoWrapper();
//    
//    if(constructionInfo->isCubeMap)
//    {
//        t->m_GLKTextureInfo = TextureFactory::buildCubeMap(constructionInfo->right,
//                                                           constructionInfo->left,
//                                                           constructionInfo->top,
//                                                           constructionInfo->bottom,
//                                                           constructionInfo->front,
//                                                           constructionInfo->back);
//    }
//    else
//    {
//        if(constructionInfo->m_type == TextureFactoryTypes_File)
//            TextureFactory::buildTextureFromFile(constructionInfo->right, t);
//        else
//            TextureFactory::buildTextureFromData(constructionInfo->right, t);
//    }
//    
//    return t;
}

GLKTextureInfoWrapper *TextureFactory::ctor(int type)
{
    return NULL;
}

void TextureFactory::dtor(GLKTextureInfoWrapper *object)
{
    //const GLuint array[1] = {[object->m_GLKTextureInfo name]};
    const GLuint array[1] = {object->m_GLKTextureInfo->name};
    glDeleteTextures(1, array);
    
    object->m_GLKTextureInfo = nil;
    
    delete object;
    object = NULL;
}
