//
//  ViewObjectFactoryIncludes.h
//  GameAsteroids
//
//  Created by James Folk on 3/26/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef GameAsteroids_ViewObjectFactoryIncludes_h
#define GameAsteroids_ViewObjectFactoryIncludes_h

#include "AbstractFactoryIncludes.h"
//#include "MazeViewObjectTypes.h"
#include "CollisionShapeFactoryIncludes.h"

#include "ShaderFactoryIncludes.h"

#include <string>

#include "btVector2.h"
#include "btTransform.h"

//typedef unsigned long long int ViewObjectID;

class BaseSpriteViewInfo
{
    int m_WidthSpriteSheet;
    int m_HeightSpriteSheet;
    float m_WidthSprite;
    float m_HeightSprite;
    float m_XOffsetOnSheet;//uv x offset in texture
    float m_YOffsetOnSheet;//uv y ofset in texture
    //std::string m_TextureFileName;
    //SpriteTypes m_SpriteTypes;
    
    void validate()const
    {
        btAssert(m_WidthSpriteSheet >= 0.0f);
        btAssert(m_HeightSpriteSheet >= 0.0f);
        btAssert(m_WidthSpriteSheet <= (GL_MAX_TEXTURE_SIZE));
        btAssert(m_HeightSpriteSheet <= (GL_MAX_TEXTURE_SIZE));
        
        btAssert(m_XOffsetOnSheet >= 0.0f);
        btAssert(m_YOffsetOnSheet >= 0.0f);
        btAssert(m_XOffsetOnSheet <= (m_WidthSpriteSheet));
        btAssert(m_YOffsetOnSheet <= (m_HeightSpriteSheet));
        
        btAssert(m_WidthSprite >= 0.0f);
        btAssert(m_HeightSprite >= 0.0f);
        btAssert(m_WidthSprite <= (m_WidthSpriteSheet));
        btAssert(m_HeightSprite <= (m_HeightSpriteSheet));
    }
public:
    BaseSpriteViewInfo(int widthSpriteSheet = 2048,
                       int heightSpriteSheet = 2048,
                       float widthSprite = 128,
                       float heightSprite = 128,
                       float xOffsetOnSheet = 0,
                       float yOffsetOnSheet = 0):
    m_WidthSpriteSheet(widthSpriteSheet),
    m_HeightSpriteSheet(heightSpriteSheet),
    m_WidthSprite(widthSprite),
    m_HeightSprite(heightSprite),
    m_XOffsetOnSheet(xOffsetOnSheet),
    m_YOffsetOnSheet(yOffsetOnSheet)//,
    //m_TextureFileName(textureFileName)//,
    //m_SpriteTypes(type)
    {}
    
    BaseSpriteViewInfo &operator=(const BaseSpriteViewInfo &rhs)
    {
        if(this != &rhs)
        {
            m_WidthSpriteSheet = rhs.m_WidthSpriteSheet;
            m_HeightSpriteSheet = rhs.m_HeightSpriteSheet;
            m_WidthSprite = rhs.m_WidthSprite;
            m_HeightSprite = rhs.m_HeightSprite;
            m_XOffsetOnSheet = rhs.m_XOffsetOnSheet;
            m_YOffsetOnSheet = rhs.m_YOffsetOnSheet;
            //m_TextureFileName = rhs.m_TextureFileName;
            //m_SpriteTypes = rhs.m_SpriteTypes;
        }
        return *this;
    }
    
    void setWidth(const float width)
    {
        m_WidthSprite = width;
        validate();
    }
    void setHeight(const float height)
    {
        m_HeightSprite = height;
        validate();
    }
    void setXOffset(const float x)
    {
        m_XOffsetOnSheet = x;
        validate();
    }
    void setYOffset(const float y)
    {
        m_YOffsetOnSheet = y;
        validate();
    }
    
    float getWidth()const
    {
        return m_WidthSprite;
    }
    float getHeight()const
    {
        return m_HeightSprite;
    }
    float getXOffset()const
    {
        return m_XOffsetOnSheet;
    }
    float getYOffset()const
    {
        return m_YOffsetOnSheet;
    }
    
    float getLeftTextureOffset()const
    {
        return (m_XOffsetOnSheet / m_WidthSpriteSheet);
    }
    float getRightTextureOffset()const
    {
        return ((m_WidthSpriteSheet - (m_XOffsetOnSheet + m_WidthSprite)) / m_WidthSpriteSheet);
    }
    float getTopTextureOffset()const
    {
        return ((m_HeightSpriteSheet - (m_YOffsetOnSheet + m_HeightSprite)) / m_HeightSpriteSheet);
    }
    float getBottomTextureOffset()const
    {
        return (m_YOffsetOnSheet / m_HeightSpriteSheet);
    }
    
    int getTextureWidth()const
    {
        return m_WidthSpriteSheet;
    }
    
    int getTextureHeight()const
    {
        return m_HeightSpriteSheet;
    }
    
    void setTextureWidth(int width)
    {
        m_WidthSpriteSheet = width;
    }
    
    void setTextureHeight(int height)
    {
        m_HeightSpriteSheet = height;
    }
};

//enum ViewObjectType
//{
//    ViewObjectType_NONE,
//    ViewObjectType_BaseSpriteView,
//    ViewObjectType_VertexNormalTexture,
//    ViewObjectType_VertexTexture,
//    ViewObjectType_VertexNormalColorTexture,
//    ViewObjectType_VertexColor,
//    //ViewObjectTypesEnum
//    
//    ViewObjectType_MAX
//};

//struct ViewObjectData
//{
//    btVector3 m_HalfExtends;
//    btAlignedObjectArray<btVector3> m_NormalList;
//    btAlignedObjectArray<btVector4> m_ColorList;
//    btAlignedObjectArray<btVector3> m_VerticeList;
//    btAlignedObjectArray<btVector2> m_UVList[32];
//    //btAlignedObjectArray<btVector2> m_UV0List;
//    //btAlignedObjectArray<btVector2> m_UV1List;
//    btTransform m_WorldTransform;
//    btAlignedObjectArray<GLushort> m_IndiceList;
//    std::string m_UV0ImageName;
//    std::string m_UV1ImageName;
//    std::string m_ViewObjectName;
//    btAlignedObjectArray<btVector3> m_ControlPoints;
//};

struct BaseViewObjectInfo
{
    //IDType m_shaderFactoryID;
    std::string m_viewObjectName;
    IDType m_textureFactoryIDs[32];
    IDType m_textureBehaviorFactoryIDs[32];
    //IDType m_texture0FactoryID;
    //IDType m_texture1FactoryID;
    //IDType m_texture0BehaviorID;
    
    BaseViewObjectInfo(IDType shaderFactoryID = 0,
                       std::string viewObjectName = "NONE",
                       IDType *textureFactoryIDs = NULL,
                       const unsigned int num_textures = 0,
                       IDType *textureBehaviorFactoryIDs = NULL,
                       const unsigned int num_texture_behaviors = 0):
//                       IDType texture0FactoryID = 0,
//                       IDType texture1FactoryID = 0,
//                       IDType texture0BehaviorID = 0):
    //m_shaderFactoryID(shaderFactoryID),
    m_viewObjectName(viewObjectName)//,
    //m_texture0FactoryID(texture0FactoryID),
    //m_texture1FactoryID(texture1FactoryID),
    //m_texture0BehaviorID(texture0BehaviorID)
    {
        memset(m_textureFactoryIDs, 0, sizeof(IDType) * 32);
        memset(m_textureBehaviorFactoryIDs, 0, sizeof(IDType) * 32);
        
        memcpy(m_textureFactoryIDs, textureFactoryIDs, sizeof(IDType) * num_textures);
        memcpy(m_textureBehaviorFactoryIDs, textureBehaviorFactoryIDs, sizeof(IDType) * num_texture_behaviors);
    }
    
    BaseViewObjectInfo(const BaseViewObjectInfo &rhs):
    //m_shaderFactoryID(rhs.m_shaderFactoryID),
    m_viewObjectName(rhs.m_viewObjectName)//,
    //m_texture0FactoryID(rhs.m_texture0FactoryID),
    //m_texture1FactoryID(rhs.m_texture1FactoryID),
    //m_texture0BehaviorID(rhs.m_texture0BehaviorID)
    {
        memcpy(m_textureFactoryIDs, rhs.m_textureFactoryIDs, sizeof(IDType) * 32);
        memcpy(m_textureBehaviorFactoryIDs, rhs.m_textureBehaviorFactoryIDs, sizeof(IDType) * 32);
    }
    
    BaseViewObjectInfo &operator=(const BaseViewObjectInfo &rhs)
    {
        if(this != &rhs)
        {
            //m_shaderFactoryID = rhs.m_shaderFactoryID;
            m_viewObjectName = rhs.m_viewObjectName;
            
            memcpy(m_textureFactoryIDs, rhs.m_textureFactoryIDs, sizeof(IDType) * 32);
            memcpy(m_textureBehaviorFactoryIDs, rhs.m_textureBehaviorFactoryIDs, sizeof(IDType) * 32);
            
            //m_texture0FactoryID = rhs.m_texture0FactoryID;
            //m_texture1FactoryID = rhs.m_texture1FactoryID;
            //m_texture0BehaviorID = rhs.m_texture0BehaviorID;
        }
        return *this;
    }
};

#endif
