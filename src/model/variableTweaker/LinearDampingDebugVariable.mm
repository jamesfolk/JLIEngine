//
//  LinearDampingDebugVariable.cpp
//  BaseProject
//
//  Created by library on 10/7/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "LinearDampingDebugVariable.h"

#include "RigidEntity.h"

LinearDampingDebugVariable::LinearDampingDebugVariable(const LinearDampingDebugVariableInfo &rhs) :
DebugVariable(rhs),
m_pRigidEntity(rhs.pRigidEntity)
{
    btAssert(m_pRigidEntity);
}

LinearDampingDebugVariable::~LinearDampingDebugVariable()
{
    
}

float LinearDampingDebugVariable::getMaxValue()
{
    return 1.0f;
}

float LinearDampingDebugVariable::getMinValue()
{
    return 0.0f;
}

float LinearDampingDebugVariable::getValue()const
{
    return m_pRigidEntity->getRigidBody()->getLinearDamping();
}

bool LinearDampingDebugVariable::setValue(const float val)
{
    m_pRigidEntity->getRigidBody()->setDamping(val, m_pRigidEntity->getRigidBody()->getAngularDamping());
    return true;
}