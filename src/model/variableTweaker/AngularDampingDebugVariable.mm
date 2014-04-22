//
//  AngularDampingDebugVariable.cpp
//  BaseProject
//
//  Created by library on 10/7/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "AngularDampingDebugVariable.h"

#include "RigidEntity.h"

AngularDampingDebugVariable::AngularDampingDebugVariable(const AngularDampingDebugVariableInfo &rhs) :
DebugVariable(rhs),
m_pRigidEntity(rhs.pRigidEntity)
{
    btAssert(m_pRigidEntity);
}

AngularDampingDebugVariable::~AngularDampingDebugVariable()
{
    
}

float AngularDampingDebugVariable::getMaxValue()
{
    return 1.0f;
}

float AngularDampingDebugVariable::getMinValue()
{
    return 0.0f;
}

float AngularDampingDebugVariable::getValue()const
{
    return m_pRigidEntity->getRigidBody()->getAngularDamping();
}

bool AngularDampingDebugVariable::setValue(const float val)
{
    m_pRigidEntity->getRigidBody()->setDamping(m_pRigidEntity->getRigidBody()->getLinearDamping(), val);
    return true;
}