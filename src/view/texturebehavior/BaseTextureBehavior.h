//
//  BaseTextureBehavior.h
//  GameAsteroids
//
//  Created by James Folk on 6/19/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__BaseTextureBehavior__
#define __GameAsteroids__BaseTextureBehavior__

#include "AbstractFactory.h"
#include "AbstractBehavior.h"
#include "TextureBehaviorFactoryIncludes.h"
#include "btActionInterface.h"
#include "TextureBehaviorFactory.h"

class BaseViewObject;
class btVector2;

class BaseTextureBehavior :
public btActionInterface,
public AbstractFactoryObject,
public AbstractBehavior<BaseViewObject>
{
    friend class TextureBehaviorFactory;
protected:
    BaseTextureBehavior(const TextureBehaviorInfo& constructionInfo);
    virtual ~BaseTextureBehavior();
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
    
    
    virtual void operator() (int i, btVector2 &to, const btVector2 &from);
    
    virtual void operator() (int i, const btVector2 &vertice);
    
    virtual void load();
    
    virtual void updateAction( btCollisionWorld* collisionWorld, btScalar deltaTimeStep);
    
	virtual void debugDraw(btIDebugDraw* debugDrawer);
    
    
    
    
    
    
    void setWidthOfSubTexture(const unsigned int width);
    void setHeightOfSubTexture(const unsigned int height);
    void setXOffset(const unsigned int x);
    void setYOffset(const unsigned int y);
    
    unsigned int getWidthOfSubTexture()const;
    unsigned int getHeightOfSubTexture()const;
    unsigned int getXOffset()const;
    unsigned int getYOffset()const;
    
    float getLeftOfSubTextureOffset()const;
    float getRightOfSubTextureOffset()const;
    float getTopOfSubTextureOffset()const;
    float getBottomOfSubTextureOffset()const;
    unsigned int getWidthOfTexture()const;
    unsigned int getHeightOfTexture()const;
    void setWidthOfTexture(unsigned int width);
    void setHeightOfTexture(unsigned int height);
    
    void setTextureOffset(const unsigned int index);
    unsigned int getTextureOffset()const;
protected:
    btAlignedObjectArray<btVector2> m_TextureCoordinates;
private:
    unsigned int m_WidthTexture;
    unsigned int m_HeightTexture;
    float m_WidthSubSprite;
    float m_HeightSubSprite;
    float m_XOffsetOnTexture;//uv x offset in texture
    float m_YOffsetOnTexture;//uv y ofset in texture
    
    bool m_IsDirty;
    
    unsigned int m_TextureIndex;
    
    void validate()const;
    
    struct TextureCoordinates
    {
        void operator() (int i, const btVector2 &vertice);
        
        btAlignedObjectArray<btVector2> m_TextureCoordinates;
    };
    
    TextureCoordinates m_StartTextureCoordinates;
};

#endif /* defined(__GameAsteroids__BaseTextureBehavior__) */
