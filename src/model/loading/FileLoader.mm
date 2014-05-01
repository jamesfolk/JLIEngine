//
//  FileLoader.cpp
//  MazeADay
//
//  Created by James Folk on 4/30/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#include "FileLoader.h"
#import <Foundation/Foundation.h>

std::string FileLoader::getFilePath(const std::string &file)const
{
    NSString *fileName = [NSString stringWithUTF8String:getFileName(file).c_str()];
    NSString *extension = [NSString stringWithUTF8String:getFileExtension(file).c_str()];
    
    return std::string([[[NSBundle mainBundle] pathForResource:fileName ofType:extension] UTF8String]);
}

std::string FileLoader::getResourcePath()const
{
    return std::string([[[NSBundle mainBundle] resourcePath] UTF8String]);
}

std::string FileLoader::getFileContents(const std::string &file)const
{
    NSString *path = [NSString stringWithUTF8String:getFilePath(file).c_str()];
    
    NSError* error;
    NSString *shaderString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    return std::string([shaderString UTF8String]);
}

std::string FileLoader::getFileExtension(const std::string &file)const
{
    return file.substr(file.find_last_of(".") + 1);
}
std::string FileLoader::getFileName(const std::string &file)const
{
    return file.substr(0, file.find_last_of("."));
}