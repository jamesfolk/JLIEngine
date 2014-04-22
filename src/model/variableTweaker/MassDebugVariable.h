//
//  MassDebugVariable.h
//  BaseProject
//
//  Created by library on 10/7/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __BaseProject__MassDebugVariable__
#define __BaseProject__MassDebugVariable__

#include "DebugVariable.h"

class RigidEntity;

struct MassDebugVariableInfo : public DebugVariableInfo
{
    MassDebugVariableInfo():
    DebugVariableInfo(DebugVariableTypes_Mass)
    {}
    
    RigidEntity *pRigidEntity;
};

class MassDebugVariable : public DebugVariable
{
public:
    MassDebugVariable(const MassDebugVariableInfo &rhs);
    virtual ~MassDebugVariable();
    
    virtual float getMaxValue();
    virtual float getMinValue();
    virtual float getValue()const;
    virtual bool setValue(const float val);
    
private:
    RigidEntity *m_pRigidEntity;
};

#endif /* defined(__BaseProject__MassDebugVariable__) */
