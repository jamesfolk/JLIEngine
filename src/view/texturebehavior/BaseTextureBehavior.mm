//
//  BaseTextureBehavior.cpp
//  GameAsteroids
//
//  Created by James Folk on 6/19/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "BaseTextureBehavior.h"
#include "BaseViewObject.h"
#include "btVector2.h"


void BaseTextureBehavior::operator() (int i, btVector2 &to, const btVector2 &from)
{
    btAssert(i < m_TextureCoordinates.size());
    
    float xoffset = 0.0f;
    float yoffset = 0.0f;
    
    switch (i)
    {
        case 0: case 4://0.0, 0.0 left  bottom
            xoffset = getLeftOfSubTextureOffset();
            yoffset = -getTopOfSubTextureOffset();
            break;
        case 1: //1.0, 0.0 right bottom
            xoffset = -getRightOfSubTextureOffset();
            yoffset = -getTopOfSubTextureOffset();
            break;
        case 2: case 5://1.0, 1.0 right top
            xoffset = -getRightOfSubTextureOffset();
            yoffset = getBottomOfSubTextureOffset();
            
            break;
        case 3: //0.0, 1.0 left  top
            xoffset = getLeftOfSubTextureOffset();
            yoffset = getBottomOfSubTextureOffset();
            break;
    }
    
    to.setX(m_TextureCoordinates[i].x() + xoffset);
    to.setY(m_TextureCoordinates[i].y() + yoffset);
}

void BaseTextureBehavior::operator() (int i, const btVector2 &vertice)
{
    btAssert(i < m_TextureCoordinates.size());
    
    m_TextureCoordinates[i] = vertice;
}

void BaseTextureBehavior::load()
{
    btAssert(getOwner()->isLoaded());
    
    if(m_TextureCoordinates.size() == 0)
    {
        m_StartTextureCoordinates.m_TextureCoordinates.resize(getOwner()->getNumVertices());
        
        size_t offset_tex = reinterpret_cast<size_t>(getOwner()->getTextureOffset(m_TextureIndex));
        
        getOwner()->get_each_attribute<TextureCoordinates, btVector2>(m_StartTextureCoordinates, offset_tex);
        
    }
    m_TextureCoordinates.copyFromArray(m_StartTextureCoordinates.m_TextureCoordinates);
}

void BaseTextureBehavior::updateAction( btCollisionWorld* collisionWorld, btScalar deltaTimeStep)
{
    if(m_IsDirty)
    {
        BaseViewObject *pOwner = getOwner();
        if(pOwner)
        {
            btAssert(m_TextureCoordinates.size() != 0);
            
            size_t offset_tex = reinterpret_cast<size_t>(pOwner->getTextureOffset(m_TextureIndex));
            pOwner->set_each_attribute<BaseTextureBehavior, btVector2>(*this, offset_tex);
        }
        
        m_IsDirty = false;
    }
}

void BaseTextureBehavior::debugDraw(btIDebugDraw* debugDrawer)
{
    
}

BaseTextureBehavior::BaseTextureBehavior(const TextureBehaviorInfo& constructionInfo):
AbstractBehavior<BaseViewObject>(NULL),
m_WidthTexture(constructionInfo.m_WidthTexture),
m_HeightTexture(constructionInfo.m_HeightTexture),
m_WidthSubSprite(constructionInfo.m_WidthSubSprite),
m_HeightSubSprite(constructionInfo.m_HeightSubSprite),
m_XOffsetOnTexture(constructionInfo.m_XOffsetOnTexture),
m_YOffsetOnTexture(constructionInfo.m_YOffsetOnTexture),
m_IsDirty(true),
m_TextureIndex(constructionInfo.m_textureIndex)
{
    validate();
    WorldPhysics::getInstance()->addActionObject(this);
}
BaseTextureBehavior::~BaseTextureBehavior()
{
    WorldPhysics::getInstance()->removeActionObject(this);
    
//    if(getOwner())
//        getOwner()->setTextureBehavior(<#unsigned int index#>, 0);
}

void BaseTextureBehavior::setWidthOfSubTexture(const unsigned int width)
{
    m_WidthSubSprite = width;
    validate();
    m_IsDirty = true;
}
void BaseTextureBehavior::setHeightOfSubTexture(const unsigned int height)
{
    m_HeightSubSprite = height;
    validate();
    m_IsDirty = true;
}
void BaseTextureBehavior::setXOffset(const unsigned int x)
{
    m_XOffsetOnTexture = x;
    validate();
    m_IsDirty = true;
}
void BaseTextureBehavior::setYOffset(const unsigned int y)
{
    m_YOffsetOnTexture = y;
    validate();
    m_IsDirty = true;
}

unsigned int BaseTextureBehavior::getWidthOfSubTexture()const
{
    return m_WidthSubSprite;
}
unsigned int BaseTextureBehavior::getHeightOfSubTexture()const
{
    return m_HeightSubSprite;
}
unsigned int BaseTextureBehavior::getXOffset()const
{
    return m_XOffsetOnTexture;
}
unsigned int BaseTextureBehavior::getYOffset()const
{
    return m_YOffsetOnTexture;
}

float BaseTextureBehavior::getLeftOfSubTextureOffset()const
{
    return (m_XOffsetOnTexture / m_WidthTexture);
}
float BaseTextureBehavior::getRightOfSubTextureOffset()const
{
    return ((m_WidthTexture - (m_XOffsetOnTexture + m_WidthSubSprite)) / m_WidthTexture);
}
float BaseTextureBehavior::getTopOfSubTextureOffset()const
{
    return ((m_HeightTexture - (m_YOffsetOnTexture + m_HeightSubSprite)) / m_HeightTexture);
}
float BaseTextureBehavior::getBottomOfSubTextureOffset()const
{
    return (m_YOffsetOnTexture / m_HeightTexture);
}

unsigned int BaseTextureBehavior::getWidthOfTexture()const
{
    return m_WidthTexture;
}

unsigned int BaseTextureBehavior::getHeightOfTexture()const
{
    return m_HeightTexture;
}

void BaseTextureBehavior::setWidthOfTexture(unsigned int width)
{
    m_WidthTexture = width;
}

void BaseTextureBehavior::setHeightOfTexture(unsigned int height)
{
    m_HeightTexture = height;
}

void BaseTextureBehavior::setTextureOffset(const unsigned int index)
{
    btAssert(index < 8);
    
    m_TextureIndex = index;
}

unsigned int BaseTextureBehavior::getTextureOffset()const
{
    return m_TextureIndex;
}

void BaseTextureBehavior::validate()const
{
    btAssert(m_WidthTexture >= 0);
    btAssert(m_HeightTexture >= 0);
    btAssert(m_WidthTexture <= (GL_MAX_TEXTURE_SIZE));
    btAssert(m_HeightTexture <= (GL_MAX_TEXTURE_SIZE));
    
    btAssert(m_XOffsetOnTexture >= 0.0f);
    btAssert(m_YOffsetOnTexture >= 0.0f);
    btAssert(m_XOffsetOnTexture <= (m_WidthTexture));
    btAssert(m_YOffsetOnTexture <= (m_HeightTexture));
    
    btAssert(m_WidthSubSprite >= 0.0f);
    btAssert(m_HeightSubSprite >= 0.0f);
    btAssert(m_WidthSubSprite <= (m_WidthTexture));
    btAssert(m_HeightSubSprite <= (m_HeightTexture));
}

void BaseTextureBehavior::TextureCoordinates::operator() (int i, const btVector2 &vertice)
{
    m_TextureCoordinates[i] = vertice;
}
