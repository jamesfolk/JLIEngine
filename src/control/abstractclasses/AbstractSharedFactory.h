//
//  AbstractSharedFactory.h
//  GameAsteroids
//
//  Created by James Folk on 5/28/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef GameAsteroids_AbstractSharedFactory_h
#define GameAsteroids_AbstractSharedFactory_h

#include "AbstractFactory.h"
#include "AbstractCounter.h"

#include "btHashMap.h"
#include "AbstractFactoryIncludes.h"
#include "ConstructionInfoFactory.h"

template <class CONSTRUCTION, class OBJECT>
class AbstractSharedFactory:
public AbstractFactory<CONSTRUCTION, OBJECT>,
public AbstractCounter<IDType>
{
public:
    virtual IDType create(IDType);
    virtual bool destroy(IDType);
protected:
    
    AbstractSharedFactory();
    virtual ~AbstractSharedFactory();
    
    virtual OBJECT *ctor(CONSTRUCTION*) = 0;
    virtual void dtor(OBJECT*) = 0;
};

template <class CONSTRUCTION, class OBJECT>
AbstractSharedFactory<CONSTRUCTION, OBJECT>::AbstractSharedFactory()
{
}

template <class CONSTRUCTION, class OBJECT>
AbstractSharedFactory<CONSTRUCTION, OBJECT>::~AbstractSharedFactory()
{
}

template <class CONSTRUCTION, class OBJECT>
IDType AbstractSharedFactory<CONSTRUCTION, OBJECT>::create(IDType ID)
{
    if(get(ID))
    {
        AbstractCounter<CONSTRUCTION>::accumulate(ID);
        return ID;
    }
    return 0;
}


template <class CONSTRUCTION, class OBJECT>
bool AbstractSharedFactory<CONSTRUCTION, OBJECT>::destroy(IDType ID)
{
    AbstractCounter<CONSTRUCTION>::decumulate(ID);
    
    if(!AbstractCounter<CONSTRUCTION>::hasObject(ID))
    {
        return AbstractFactory<CONSTRUCTION, OBJECT>::destroy(ID);
    }
    return false;
}

#endif
