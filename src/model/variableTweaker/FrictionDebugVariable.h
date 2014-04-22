//
//  FrictionDebugVariable.h
//  BaseProject
//
//  Created by library on 10/7/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __BaseProject__FrictionDebugVariable__
#define __BaseProject__FrictionDebugVariable__

#include "DebugVariable.h"

class RigidEntity;


struct FrictionDebugVariableInfo : public DebugVariableInfo
{
    FrictionDebugVariableInfo():
    DebugVariableInfo(DebugVariableTypes_Friction)
    {}
    
    RigidEntity *pRigidEntity;
};

class FrictionDebugVariable : public DebugVariable
{
public:
    FrictionDebugVariable(const FrictionDebugVariableInfo &rhs);
    virtual ~FrictionDebugVariable();
    
    virtual float getMaxValue();
    virtual float getMinValue();
    virtual float getValue()const;
    virtual bool setValue(const float val);
    
private:
    RigidEntity *m_pRigidEntity;
};

#endif /* defined(__BaseProject__FrictionDebugVariable__) */
