//
//  FrictionDebugVariable.cpp
//  BaseProject
//
//  Created by library on 10/7/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "FrictionDebugVariable.h"

#include "RigidEntity.h"

FrictionDebugVariable::FrictionDebugVariable(const FrictionDebugVariableInfo &rhs) :
DebugVariable(rhs),
m_pRigidEntity(rhs.pRigidEntity)
{
    btAssert(m_pRigidEntity);
}

FrictionDebugVariable::~FrictionDebugVariable()
{
    
}

float FrictionDebugVariable::getMaxValue()
{
    return WorldPhysics::getFrictionAbs();
}

float FrictionDebugVariable::getMinValue()
{
    return 0.0f;
}

float FrictionDebugVariable::getValue()const
{
    return m_pRigidEntity->getRigidBody()->getFriction();
}

bool FrictionDebugVariable::setValue(const float val)
{
    m_pRigidEntity->getRigidBody()->setFriction(val);
    return true;
}
