//
//  MazeDebugVariable.cpp
//  BaseProject
//
//  Created by library on 10/15/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "MazeDebugVariable2.h"

#include "MazeGameState.h"

MazeDebugVariable2::MazeDebugVariable2(const MazeDebugVariable2Info &rhs) :
DebugVariable(rhs),
m_pMazeGameState(rhs.pMazeGameState)
{
    
}
MazeDebugVariable2::~MazeDebugVariable2()
{
    
}
float MazeDebugVariable2::getMaxValue()
{
    return 300.0;
}
float MazeDebugVariable2::getMinValue()
{
    return 1.;
}
float MazeDebugVariable2::getValue()const
{
    //return m_pMazeGameState->getMaxTouchDistance();
}
bool MazeDebugVariable2::setValue(const float val)
{
    //m_pMazeGameState->setMaxTouchDistance(val);
    return true;
}