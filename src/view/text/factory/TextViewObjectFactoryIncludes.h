//
//  TextViewObjectFactoryIncludes.h
//  GameAsteroids
//
//  Created by James Folk on 6/24/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef GameAsteroids_LocalizedTextFactoryIncludes_h
#define GameAsteroids_LocalizedTextFactoryIncludes_h

#include "AbstractFactoryIncludes.h"
#include "LocalizedTextViewObjectTypes.h"
#include <string>

struct TextOrigin
{
    TextOrigin(int _x = 0, int _y = 0) :
    x(_x),
    y(_y)
    {}
    
    TextOrigin(const TextOrigin &copy) :
    x(copy.x),
    y(copy.y)
    {}
    
    TextOrigin& operator=(const TextOrigin &rhs)
    {
        if(this != &rhs)
        {
            x = rhs.x;
            y = rhs.y;
        }
        return *this;
    }
    
    int x;
    int y;
};
struct TextMetrics
{
    int xBearing;
    int yBearing;
    int width;
    int height;
    int xAdvance;
    int yAdvance;
    
    TextMetrics(int _xBearing = 0,
                int _yBearing = 0,
                int _width = 0,
                int _height = 0,
                int _xAdvance = 0,
                int _yAdvance = 0) :
    xBearing(_xBearing),
    yBearing(_yBearing),
    width(_width),
    height(_height),
    xAdvance(_xAdvance),
    yAdvance(_yAdvance)
    {}
    
    TextMetrics(const TextMetrics &copy) :
    xBearing(copy.xBearing),
    yBearing(copy.yBearing),
    width(copy.width),
    height(copy.height),
    xAdvance(copy.xAdvance),
    yAdvance(copy.yAdvance)
    {}
    
    TextMetrics& operator=(const TextMetrics &rhs)
    {
        if(this != &rhs)
        {
            xBearing = rhs.xBearing;
            yBearing = rhs.yBearing;
            width = rhs.width;
            height = rhs.height;
            xAdvance = rhs.xAdvance;
            yAdvance = rhs.yAdvance;
        }
        return *this;
    }
};
    
struct TextInfo
{
    std::string fileName;
    unsigned int textureFileWidth;
    unsigned int textureFileHeight;
    TextOrigin origin;
    TextMetrics metrics;
    
    TextInfo(std::string _fileName = "",
             unsigned int _textureFileWidth = 0,
             unsigned int _textureFileHeight = 0,
             int _x = 0,
              int _y = 0,
              int _xBearing = 0,
              int _yBearing = 0,
              int _width = 0,
              int _height = 0,
              int _xAdvance = 0,
              int _yAdvance = 0) :
    fileName(_fileName),
    textureFileWidth(_textureFileWidth),
    textureFileHeight(_textureFileHeight),
    origin(_x, _y),
    metrics(_xBearing,
            _yBearing,
            _width,
            _height,
            _xAdvance,
            _yAdvance)
    {}
    
    TextInfo(const TextInfo &copy) :
    fileName(copy.fileName),
    textureFileWidth(copy.textureFileWidth),
    textureFileHeight(copy.textureFileHeight),
    origin(copy.origin),
    metrics(copy.metrics)
    {}
    
    TextInfo& operator=(const TextInfo &rhs)
    {
        if(this != &rhs)
        {
            fileName = rhs.fileName;
            textureFileWidth = rhs.textureFileWidth;
            textureFileHeight = rhs.textureFileHeight;
            origin = rhs.origin;
            metrics = rhs.metrics;
        }
        return *this;
    }
};
    
struct BaseTextViewInfo
{
    IDType m_shaderFactoryID;
    //LocalizedTextViewObjectType m_textViewObjectType;
    
    
    BaseTextViewInfo(IDType shaderFactoryID) :
    m_shaderFactoryID(shaderFactoryID)
    {
        
    }
//    BaseTextViewInfo(IDType shaderFactoryID,
//                      LocalizedTextViewObjectType textViewObjectType) :
//    m_shaderFactoryID(shaderFactoryID),
//    m_textViewObjectType(textViewObjectType)
//    {
//        
//    }
};

#endif
