//
//  AbstractLuaFactoryObject.h
//  MazeADay
//
//  Created by James Folk on 2/18/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#ifndef MazeADay_AbstractLuaFactoryObject_h
#define MazeADay_AbstractLuaFactoryObject_h

#include "AbstractFactoryIncludes.h"

template <class OBJECT_TYPE, class OBJECT_TYPE_FACTORY>
class AbstractLuaFactoryObject
{
public:
    static OBJECT_TYPE *create(int type = 0);
    static bool destroy(IDType &_id);
    static bool destroy(OBJECT_TYPE *entity);
    static OBJECT_TYPE *get(IDType _id);
};

template <class OBJECT_TYPE, class OBJECT_TYPE_FACTORY>
OBJECT_TYPE *AbstractLuaFactoryObject<OBJECT_TYPE, OBJECT_TYPE_FACTORY>::create(int type)
{
    return dynamic_cast<OBJECT_TYPE*>(OBJECT_TYPE_FACTORY::getInstance()->createObject(type));
}

template <class OBJECT_TYPE, class OBJECT_TYPE_FACTORY>
bool AbstractLuaFactoryObject<OBJECT_TYPE, OBJECT_TYPE_FACTORY>::destroy(IDType &_id)
{
    return OBJECT_TYPE_FACTORY::getInstance()->destroy(_id);
}

template <class OBJECT_TYPE, class OBJECT_TYPE_FACTORY>
bool AbstractLuaFactoryObject<OBJECT_TYPE, OBJECT_TYPE_FACTORY>::destroy(OBJECT_TYPE *entity)
{
    bool ret = false;
    if(entity)
    {
        IDType _id = entity->getID();
        ret = AbstractLuaFactoryObject::destroy(_id);
    }
    entity = NULL;
    return ret;
}

template <class OBJECT_TYPE, class OBJECT_TYPE_FACTORY>
OBJECT_TYPE *AbstractLuaFactoryObject<OBJECT_TYPE, OBJECT_TYPE_FACTORY>::get(IDType _id)
{
    return dynamic_cast<OBJECT_TYPE*>(OBJECT_TYPE_FACTORY::getInstance()->get(_id));
}

#endif
