//
//  TextureBehaviorFactoryIncludes.h
//  GameAsteroids
//
//  Created by James Folk on 6/19/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef GameAsteroids_TextureBehaviorFactoryIncludes_h
#define GameAsteroids_TextureBehaviorFactoryIncludes_h

struct TextureBehaviorInfo
{
    int m_WidthTexture;
    int m_HeightTexture;
    float m_WidthSubSprite;
    float m_HeightSubSprite;
    float m_XOffsetOnTexture;//uv x offset in texture
    float m_YOffsetOnTexture;//uv y ofset in texture
    IDType m_ViewObjectFactoryID;
    unsigned int m_textureIndex;
public:
    TextureBehaviorInfo(int widthSpriteSheet = 2048,
                       int heightSpriteSheet = 2048,
                       float widthSprite = 128,
                       float heightSprite = 128,
                       float xOffsetOnSheet = 0,
                       float yOffsetOnSheet = 0,
                        unsigned int textureIndex = 0):
    m_WidthTexture(widthSpriteSheet),
    m_HeightTexture(heightSpriteSheet),
    m_WidthSubSprite(widthSprite),
    m_HeightSubSprite(heightSprite),
    m_XOffsetOnTexture(xOffsetOnSheet),
    m_YOffsetOnTexture(yOffsetOnSheet),
    m_ViewObjectFactoryID(0),
    m_textureIndex(textureIndex)
    {}
private:
    TextureBehaviorInfo(const TextureBehaviorInfo&rhs);
    TextureBehaviorInfo &operator=(const TextureBehaviorInfo &rhs);
};

#endif
