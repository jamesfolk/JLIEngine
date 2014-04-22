//
//  RestitutionDebugVariable.cpp
//  BaseProject
//
//  Created by library on 10/7/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "RestitutionDebugVariable.h"

#include "RigidEntity.h"

RestitutionDebugVariable::RestitutionDebugVariable(const RestitutionDebugVariableInfo &rhs) :
DebugVariable(rhs),
m_pRigidEntity(rhs.pRigidEntity)
{
    btAssert(m_pRigidEntity);
}

RestitutionDebugVariable::~RestitutionDebugVariable()
{
    
}

float RestitutionDebugVariable::getMaxValue()
{
    return 1.0f;
}

float RestitutionDebugVariable::getMinValue()
{
    return 0.0f;
}

float RestitutionDebugVariable::getValue()const
{
    return m_pRigidEntity->getRigidBody()->getRestitution();
}

bool RestitutionDebugVariable::setValue(const float val)
{
    m_pRigidEntity->getRigidBody()->setRestitution(val);
    return true;
}