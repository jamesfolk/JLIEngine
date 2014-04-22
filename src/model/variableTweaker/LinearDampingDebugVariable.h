//
//  LinearDampingDebugVariable.h
//  BaseProject
//
//  Created by library on 10/7/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __BaseProject__LinearDampingDebugVariable__
#define __BaseProject__LinearDampingDebugVariable__

#include "DebugVariable.h"

class RigidEntity;

struct LinearDampingDebugVariableInfo : public DebugVariableInfo
{
    LinearDampingDebugVariableInfo():
    DebugVariableInfo(DebugVariableTypes_LinearDamping)
    {}
    
    RigidEntity *pRigidEntity;
};

class LinearDampingDebugVariable : public DebugVariable
{
public:
    LinearDampingDebugVariable(const LinearDampingDebugVariableInfo &rhs);
    virtual ~LinearDampingDebugVariable();
    
    virtual float getMaxValue();
    virtual float getMinValue();
    virtual float getValue()const;
    virtual bool setValue(const float val);
    
private:
    RigidEntity *m_pRigidEntity;
};

#endif /* defined(__BaseProject__LinearDampingDebugVariable__) */
