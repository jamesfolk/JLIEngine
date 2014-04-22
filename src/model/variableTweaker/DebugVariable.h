//
//  DebugVariable.h
//  BaseProject
//
//  Created by library on 10/7/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __BaseProject__DebugVariable__
#define __BaseProject__DebugVariable__

#include "DebugVariableFactoryIncludes.h"
#include "AbstractFactory.h"
#include <string>
//#include "DebugVariableFactory.h"

class DebugVariable :
public AbstractFactoryObject
{
    friend class DebugVariableFactory;
protected:
    DebugVariable(const DebugVariableInfo &info) :
    m_Label(info.m_Label)
    {
    }
    virtual ~DebugVariable(){}
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
    
    
    
    virtual std::string getLabel()
    {
        return m_Label;
    }
    virtual float getStepperStepValue()
    {
        return (getMaxValue() - getMinValue()) / 100.0f;
    }
    virtual float getMaxValue() = 0;
    virtual float getMinValue() = 0;
    virtual float getValue()const = 0;
    virtual bool setValue(const float val) = 0;
private:
    DebugVariable(const DebugVariable &rhs);
    DebugVariable &operator=(const DebugVariable &rhs);
    std::string m_Label;
};

#endif /* defined(__BaseProject__DebugVariable__) */
