//
//  EntityFactory.h
//  GameAsteroids
//
//  Created by James Folk on 4/18/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__EntityFactory__
#define __GameAsteroids__EntityFactory__

#include "AbstractFactory.h"
#include "EntityFactoryIncludes.h"
#include "BaseEntity.h"

class EntityFactory :
public AbstractFactory<EntityFactory, BaseEntityInfo, BaseEntity>
{
    friend class AbstractSingleton;
    friend class BaseEntity;
    
    BaseEntity *createEntity(BaseEntityInfo *constructionInfo);
    
    EntityFactory(){}
    virtual ~EntityFactory(){}
    
//    btAlignedObjectArray<BaseEntity*> m_OrthographicEntities;
//    btAlignedObjectArray<BaseEntity*> m_PerspectiveEntities;
    
protected:
    virtual BaseEntity *ctor(BaseEntityInfo *constructionInfo);
    virtual BaseEntity *ctor(int type = 0);
    virtual void dtor(BaseEntity *object);
public:
    
//    void render();
    
    template <class T, class TInfo>
    static T *createEntity(TInfo *constructionInfo, IDType *ID = NULL)
    {
        IDType _ID = EntityFactory::getInstance()->create(constructionInfo);
        
        if(ID)
            *ID = _ID;
        
        return dynamic_cast<T*>(EntityFactory::getInstance()->get(_ID));
    }
    
    template <class T>
    static T *getEntity(IDType ID)
    {
        return dynamic_cast<T*>(EntityFactory::getInstance()->get(ID));
    }
};

#endif /* defined(__GameAsteroids__EntityFactory__) */
