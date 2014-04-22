//
//  BaseTextViewObject.h
//  GameAsteroids
//
//  Created by James Folk on 6/24/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__BaseTextViewObject__
#define __GameAsteroids__BaseTextViewObject__

#include "TextViewObjectFactoryIncludes.h"
#include <string>
#include "btHashMap.h"
#include "btTransform.h"
#include "ViewObjectFactory.h"
#include "AbstractFactory.h"
//#include "TextViewObjectFactory.h"

class BaseViewObject;
class btVector3;


struct VertexTransform
{
    VertexTransform():
    pTextInfo(NULL)
    {}
    ~VertexTransform(){}
    
    btAlignedObjectArray<btVector3> m_Vertices;
    TextInfo *pTextInfo;
    
    SIMD_FORCE_INLINE const TextInfo*	getTextInfo() const
    {
		return (pTextInfo);
	}
    
	SIMD_FORCE_INLINE TextInfo*	getTextInfo()
    {
		return (pTextInfo);
	}
    
    SIMD_FORCE_INLINE void setTextInfo(TextInfo *info)
    {
        (pTextInfo) = info;
    }
    
    void operator() (int i, btVector3 &to, const btVector3 &from)const
    {   
        if(pTextInfo)
        {
            const btVector3 vertice(m_Vertices[i]);
            
            to = btVector3(vertice.x() * getTextInfo()->metrics.width,
                           vertice.y() * getTextInfo()->metrics.height,
                           vertice.z());
        }
        else
        {
            to = from;
        }
    }
    void operator() (int i, const btVector3 &vertice)
    {
        m_Vertices[i] = vertice;
    }
};


class BaseTextViewObject :
public btActionInterface,
public AbstractFactoryObject
{
    friend class TextViewObjectFactory;
protected:
    BaseTextViewObject(const BaseTextViewInfo &info);
    virtual ~BaseTextViewObject();
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
    
    
    virtual void updateAction( btCollisionWorld* collisionWorld, btScalar deltaTimeStep);
	virtual void debugDraw(btIDebugDraw* debugDrawer);
    
    SIMD_FORCE_INLINE bool isHidden()const
    {
        return m_hidden;
    }
    virtual void show()
    {
        m_hidden = false;
    }
    virtual void hide()
    {
        m_hidden = true;
    }
    
    void SIMD_FORCE_INLINE setPosition(const btVector3 &pos)
    {
        btVector3 offset((m_VertexTransform->getTextInfo()->metrics.width) * 0.5f,
                         (m_VertexTransform->getTextInfo()->metrics.height) * 0.5f,
                         0.0f);
        
        btTransform _btTransform(getWorldTransform());
        btVector3 position(pos.x() + offset.x(), pos.y() + offset.y(), pos.z());
        _btTransform.setOrigin(position);
        setWorldTransform(_btTransform);
    }
    
    void SIMD_FORCE_INLINE setOrigin(const btVector3 &pos)
    {
        btTransform _btTransform(getWorldTransform());
        _btTransform.setOrigin(pos);
        setWorldTransform(_btTransform);
    }
    const SIMD_FORCE_INLINE btVector3 &getOrigin()const
    {
        return getWorldTransform().getOrigin();
    }
    
    virtual SIMD_FORCE_INLINE btQuaternion getRotation()const
    {
        return getWorldTransform().getRotation();
    }
    virtual SIMD_FORCE_INLINE void setRotation(const btQuaternion &rot)
    {
        btTransform _btTransform(getWorldTransform());
        _btTransform.setRotation(rot);
        setWorldTransform(_btTransform);
    }
    
    virtual btTransform getWorldTransform() const
    {
        return m_WorldTransform;
    }
    virtual void setWorldTransform(const btTransform& worldTrans)
    {
        m_WorldTransform = worldTrans;
    }
    
    //btVector3 getPositionOffset()const;
    
    void setTextKey(const std::string &localized_key, LocalizedTextViewObjectType type);
    const std::string &getTextKey()const;
    
    
    
    virtual void render();
    
    SIMD_FORCE_INLINE const TextInfo*	getTextInfo() const
    {
		return m_VertexTransform->getTextInfo();
	}
    
protected:
    SIMD_FORCE_INLINE const BaseViewObject*	getVBO() const
    {
		return ViewObjectFactory::getInstance()->get(m_viewObjectFactoryID);
	}
    
	SIMD_FORCE_INLINE BaseViewObject*	getVBO()
    {
        return ViewObjectFactory::getInstance()->get(m_viewObjectFactoryID);
	}
private:
    std::string m_LocalizedKey;
    btTransform m_WorldTransform;
    VertexTransform *m_VertexTransform;
    IDType m_viewObjectFactoryID;
    IDType m_textureBehaviorFactoryID;
    IDType m_spriteFactoryID;
    bool m_hidden;
    IDType m_currentTextureFactoryID;
};

#endif /* defined(__GameAsteroids__BaseTextViewObject__) */
