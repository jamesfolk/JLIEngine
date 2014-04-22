//
//  AngularDampingDebugVariable.h
//  BaseProject
//
//  Created by library on 10/7/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __BaseProject__AngularDampingDebugVariable__
#define __BaseProject__AngularDampingDebugVariable__

#include "DebugVariable.h"

class RigidEntity;

struct AngularDampingDebugVariableInfo : public DebugVariableInfo
{
    AngularDampingDebugVariableInfo():
    DebugVariableInfo(DebugVariableTypes_AngularDamping)
    {}
    
    RigidEntity *pRigidEntity;
};

class AngularDampingDebugVariable : public DebugVariable
{
public:
    AngularDampingDebugVariable(const AngularDampingDebugVariableInfo &rhs);
    virtual ~AngularDampingDebugVariable();
    
    virtual float getMaxValue();
    virtual float getMinValue();
    virtual float getValue()const;
    virtual bool setValue(const float val);
    
private:
    RigidEntity *m_pRigidEntity;
};

#endif /* defined(__BaseProject__AngularDampingDebugVariable__) */
