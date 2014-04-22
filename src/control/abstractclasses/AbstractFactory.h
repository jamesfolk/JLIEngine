//
//  AbstractFactory.h
//  GameAsteroids
//
//  Created by James Folk on 5/28/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__AbstractFactory__
#define __GameAsteroids__AbstractFactory__

#include "btHashMap.h"
#include "AbstractFactoryIncludes.h"
#include "AbstractSingleton.h"
#include <string>

template <class SINGLETONS_TYPE, class CONSTRUCTION, class OBJECT>
class AbstractFactory :
public AbstractSingleton<SINGLETONS_TYPE>
{
    friend class AbstractFactoryObject;
protected:
    typedef btHashMap<btHashInt, OBJECT*> ObjectHashMap;
    typedef btHashMap<btHashPtr, IDType> ObjectReverseHashMap;
    
public:
    
    virtual IDType create(CONSTRUCTION*);
    virtual OBJECT *createObject(int type);
    virtual OBJECT *get(IDType)const;
    virtual IDType get(OBJECT*)const;
    virtual bool destroy(IDType&);
    virtual void destroyAll();
    virtual int size()const;
    virtual void get(btAlignedObjectArray<OBJECT*> &objects)const;
protected:
    
    AbstractFactory();
    virtual ~AbstractFactory();
    
    virtual OBJECT *ctor(CONSTRUCTION*) = 0;
    virtual OBJECT *ctor(int = 0) = 0;
    virtual void dtor(OBJECT*) = 0;

    IDType createID(){return ++m_CurrentID;}
    IDType getCurrentID(){return m_CurrentID;}
    
    void add_Internal(IDType, OBJECT*);
    void remove_Internal(IDType);
    OBJECT *get_Internal(IDType)const;
    IDType get_reverse_Internal(OBJECT*)const;
private:    
    ObjectHashMap m_ObjectMap;
    ObjectReverseHashMap m_ObjectReverseMap;
    IDType m_CurrentID;
};

template <class SINGLETONS_TYPE, class CONSTRUCTION, class OBJECT>
AbstractFactory<SINGLETONS_TYPE, CONSTRUCTION, OBJECT>::AbstractFactory():
m_CurrentID(0)
{
    
}

template <class SINGLETONS_TYPE, class CONSTRUCTION, class OBJECT>
AbstractFactory<SINGLETONS_TYPE, CONSTRUCTION, OBJECT>::~AbstractFactory()
{
    int size = m_ObjectMap.size();
    btAssert(size == 0);
}

template <class SINGLETONS_TYPE, class CONSTRUCTION, class OBJECT>
IDType AbstractFactory<SINGLETONS_TYPE, CONSTRUCTION, OBJECT>::create(CONSTRUCTION *constructionInfo)
{
    OBJECT *object = ctor(constructionInfo);
    
    if(object)
    {
        IDType _id = createID();
        
        add_Internal(_id, object);
        
        return _id;
    }
    return 0;
}

template <class SINGLETONS_TYPE, class CONSTRUCTION, class OBJECT>
OBJECT *AbstractFactory<SINGLETONS_TYPE, CONSTRUCTION, OBJECT>::createObject(int type)
{
    OBJECT *object = ctor(type);
    
    if(object)
    {
        IDType _id = createID();
        
        add_Internal(_id, object);
        
        return object;
    }
    return NULL;
}

template <class SINGLETONS_TYPE, class CONSTRUCTION, class OBJECT>
OBJECT *AbstractFactory<SINGLETONS_TYPE, CONSTRUCTION, OBJECT>::get(IDType ID)const
{
    return get_Internal(ID);
}

template <class SINGLETONS_TYPE, class CONSTRUCTION, class OBJECT>
IDType AbstractFactory<SINGLETONS_TYPE, CONSTRUCTION, OBJECT>::get(OBJECT *object)const
{
    return get_reverse_Internal(object);
}

template <class SINGLETONS_TYPE, class CONSTRUCTION, class OBJECT>
bool AbstractFactory<SINGLETONS_TYPE, CONSTRUCTION, OBJECT>::destroy(IDType &ID)
{
    OBJECT *object = get_Internal(ID);
    if(NULL != object)
    {
        remove_Internal(ID);
        object->setID(0);
        
        dtor(object);
        
        ID = 0;
        return true;
    }
    return false;
    
}

template <class SINGLETONS_TYPE, class CONSTRUCTION, class OBJECT>
void AbstractFactory<SINGLETONS_TYPE, CONSTRUCTION, OBJECT>::destroyAll()
{
    OBJECT *obj = NULL;
    for(int i = 0; i < m_ObjectMap.size(); i++)
    {
        obj = *m_ObjectMap.getAtIndex(i);
        dtor(obj);
    }
    m_ObjectMap.clear();
}

template <class SINGLETONS_TYPE, class CONSTRUCTION, class OBJECT>
int AbstractFactory<SINGLETONS_TYPE, CONSTRUCTION, OBJECT>::size()const
{
    return m_ObjectMap.size();
}

template <class SINGLETONS_TYPE, class CONSTRUCTION, class OBJECT>
void AbstractFactory<SINGLETONS_TYPE, CONSTRUCTION, OBJECT>::get(btAlignedObjectArray<OBJECT*> &objects)const
{
    objects.clear();
    for(int i = 0; i < m_ObjectMap.size(); i++)
    {
        objects.push_back(*m_ObjectMap.getAtIndex(i));
    }
}

template <class SINGLETONS_TYPE, class CONSTRUCTION, class OBJECT>
void AbstractFactory<SINGLETONS_TYPE, CONSTRUCTION, OBJECT>::add_Internal(IDType ID, OBJECT *object)
{
    btAssert(NULL != object);
    
    object->setID(ID);
    
    m_ObjectMap.insert(btHashInt(ID), object);
    m_ObjectReverseMap.insert(btHashPtr(object), ID);
}

template <class SINGLETONS_TYPE, class CONSTRUCTION, class OBJECT>
void AbstractFactory<SINGLETONS_TYPE, CONSTRUCTION, OBJECT>::remove_Internal(IDType ID)
{
    OBJECT *object = get_Internal(ID);
    
    m_ObjectMap.remove(btHashInt(ID));
    m_ObjectReverseMap.remove(btHashPtr(object));
}

template <class SINGLETONS_TYPE, class CONSTRUCTION, class OBJECT>
OBJECT *AbstractFactory<SINGLETONS_TYPE, CONSTRUCTION, OBJECT>::get_Internal(IDType ID)const
{
    OBJECT *const*object = m_ObjectMap.find(btHashInt(ID));
    if(object)
        return *object;
    return NULL;
}

template <class SINGLETONS_TYPE, class CONSTRUCTION, class OBJECT>
IDType AbstractFactory<SINGLETONS_TYPE, CONSTRUCTION, OBJECT>::get_reverse_Internal(OBJECT *object)const
{
    const IDType *ID = m_ObjectReverseMap.find(btHashPtr(object));
    if(ID)
        return *ID;
    return 0;
}

class AbstractFactoryObject
{
    IDType m_ID;
    std::string m_Name;
    
protected:
    AbstractFactoryObject():
    m_ID(0)
    {}
    
public:
    void setID(const IDType ID)
    {
        m_ID = ID;
    }
    
    IDType getID()const
    {
        return m_ID;
    }
    
    void setName(const std::string &name)
    {
        m_Name = name;
    }
    
    const std::string &getName()const
    {
        return m_Name;
    }
};

#endif /* defined(__GameAsteroids__AbstractFactory__) */
