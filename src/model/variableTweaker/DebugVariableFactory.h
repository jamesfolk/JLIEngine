//
//  DebugVariableFactory.h
//  BaseProject
//
//  Created by library on 10/7/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __BaseProject__VariableTweaker__
#define __BaseProject__VariableTweaker__

#include "AbstractFactory.h"
#include "DebugVariableFactoryIncludes.h"
#include "DebugVariable.h"

class DebugVariableFactory;

class DebugVariableFactory :
public AbstractFactory<DebugVariableFactory, DebugVariableInfo, DebugVariable>
{
    friend class AbstractSingleton;
    
    DebugVariableFactory(){}
    virtual ~DebugVariableFactory(){}
protected:
    virtual DebugVariable *ctor(DebugVariableInfo *constructionInfo);
    virtual DebugVariable *ctor(int type = 0);
    virtual void dtor(DebugVariable *object);
};


#endif /* defined(__BaseProject__VariableTweaker__) */
