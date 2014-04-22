//
//  RestitutionDebugVariable.h
//  BaseProject
//
//  Created by library on 10/7/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __BaseProject__RestitutionDebugVariable__
#define __BaseProject__RestitutionDebugVariable__

#include "DebugVariable.h"

class RigidEntity;

struct RestitutionDebugVariableInfo : public DebugVariableInfo
{
    RestitutionDebugVariableInfo():
    DebugVariableInfo(DebugVariableTypes_Restitution)
    {}
    
    RigidEntity *pRigidEntity;
};

class RestitutionDebugVariable : public DebugVariable
{
public:
    RestitutionDebugVariable(const RestitutionDebugVariableInfo &rhs);
    virtual ~RestitutionDebugVariable();
    
    virtual float getMaxValue();
    virtual float getMinValue();
    virtual float getValue()const;
    virtual bool setValue(const float val);
    
private:
    RigidEntity *m_pRigidEntity;
};

#endif /* defined(__BaseProject__RestitutionDebugVariable__) */
