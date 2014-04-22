//
//  GameplayDebugVariable.cpp
//  BaseProject
//
//  Created by library on 10/7/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "MazeDebugVariable.h"

#include "MazeGameState.h"

MazeDebugVariable::MazeDebugVariable(const MazeDebugVariableInfo &rhs) :
DebugVariable(rhs),
m_pMazeGameState(rhs.pMazeGameState)
{
    
}
MazeDebugVariable::~MazeDebugVariable()
{
    
}
float MazeDebugVariable::getMaxValue()
{
    return 100000.0f;
}
float MazeDebugVariable::getMinValue()
{
    return 0.f;
}
float MazeDebugVariable::getValue()const
{
    //return m_pMazeGameState->getImpulseConstant();
}
bool MazeDebugVariable::setValue(const float val)
{
    //m_pMazeGameState->setImpulseConstant(val);
    return true;
}