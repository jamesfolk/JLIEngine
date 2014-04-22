//
//  AbstractCounter.h
//  GameAsteroids
//
//  Created by James Folk on 5/28/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__AbstractCounter__
#define __GameAsteroids__AbstractCounter__

template <class KEY>
class AbstractCounter
{
    typedef btHashMap<btHashPtr, int> ObjectMap;
    
    ObjectMap m_ObjectMap;
    
public:
    AbstractCounter(){}
    virtual ~AbstractCounter(){}
    
protected:
    int count(KEY *pObject)const;
    bool hasObject(KEY *pObject)const;
    
    virtual void accumulate(KEY *pObject);
    virtual void decumulate(KEY *pObject);
};

template <class KEY, class COMPARE>
int AbstractCounter<KEY, COMPARE>::count(KEY *pObject)const
{
    int *object = m_ObjectMap.find(btHashPtr(pObject));
    if(object)
        return *object;
    return 0;
}

template <class KEY, class COMPARE>
bool AbstractCounter<KEY, COMPARE>::hasObject(KEY *pObject)const
{
    return (NULL != m_ObjectMap.find(btHashPtr(pObject)));
}

template <class KEY, class COMPARE>
void AbstractCounter<KEY, COMPARE>::accumulate(KEY *pObject)
{
    if(!hasObject(pObject))
    {
        m_ObjectMap.insert(btHashPtr(pObject), 1);
    }
    else
    {
        m_ObjectMap[btHashPtr(pObject)]++;
    }
}

template <class KEY, class COMPARE>
void AbstractCounter<KEY, COMPARE>::decumulate(KEY *pObject)
{
    if(hasObject(pObject))
    {
        btHashPtr ptr = btHashPtr(pObject);
        
        m_ObjectMap[ptr]--;
        
        if(m_ObjectMap[ptr] == 0)
            m_ObjectMap.removeObject(ptr);
    }
}

#endif /* defined(__GameAsteroids__AbstractCounter__) */
