//
//  MemoryLeakFinder.cpp
//  BaseProject
//
//  Created by library on 10/6/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "MemoryLeakFinder.h"

#include "ZipFileResourceLoader.h"

MemoryLeakFinder::MemoryLeakFinder(){}

MemoryLeakFinder::~MemoryLeakFinder(){}
void MemoryLeakFinder::enter(void*)
{
    ZipFileResourceLoader::getInstance()->open("maze.zip");
}
void MemoryLeakFinder::update(void*, btScalar deltaTimeStep)
{
    if(ZipFileResourceLoader::getInstance()->finished())
    {
        ZipFileResourceLoader::getInstance()->close();
    }
    else
    {
        ZipFileResourceLoader::getInstance()->extract();
        NSLog(@"%s\n", ZipFileResourceLoader::getInstance()->currentObjectName().c_str());
    }
}
void  MemoryLeakFinder::render(){}
void MemoryLeakFinder::exit(void*)
{
    ZipFileResourceLoader::getInstance()->destroy();
}
bool MemoryLeakFinder::onMessage(void*, const Telegram&){return false;}
/*
void MemoryLeakFinder::touchesBegan(){}
void MemoryLeakFinder::touchesMoved(){}
void MemoryLeakFinder::touchesEnded(){}
void MemoryLeakFinder::touchesCancelled(){}*/