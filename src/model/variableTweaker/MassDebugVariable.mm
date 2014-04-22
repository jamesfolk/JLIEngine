//
//  MassDebugVariable.cpp
//  BaseProject
//
//  Created by library on 10/7/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "MassDebugVariable.h"

#include "RigidEntity.h"

MassDebugVariable::MassDebugVariable(const MassDebugVariableInfo &rhs) :
DebugVariable(rhs),
m_pRigidEntity(rhs.pRigidEntity)
{
    btAssert(m_pRigidEntity);
}

MassDebugVariable::~MassDebugVariable()
{
    
}

float MassDebugVariable::getMaxValue()
{
    return 5000.f;
}

float MassDebugVariable::getMinValue()
{
    return 0.0001;
}

float MassDebugVariable::getValue()const
{
    return m_pRigidEntity->getMass();
}

bool MassDebugVariable::setValue(const float val)
{
    m_pRigidEntity->setMass(val);
    return true;
}
