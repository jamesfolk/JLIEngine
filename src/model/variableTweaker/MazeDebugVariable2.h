//
//  MazeDebugVariable2.h
//  BaseProject
//
//  Created by library on 10/15/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __BaseProject__MazeDebugVariable2__
#define __BaseProject__MazeDebugVariable2__

#include "DebugVariable.h"

class MazeGameState;

struct MazeDebugVariable2Info : public DebugVariableInfo
{
    MazeDebugVariable2Info():
    DebugVariableInfo(DebugVariableTypes_Maze2)
    {}
    
    MazeGameState *pMazeGameState;
};

class MazeDebugVariable2 : public DebugVariable
{
public:
    MazeDebugVariable2(const MazeDebugVariable2Info &rhs);
    virtual ~MazeDebugVariable2();
    
    virtual float getMaxValue();
    virtual float getMinValue();
    virtual float getValue()const;
    virtual bool setValue(const float val);
    
private:
    MazeGameState *m_pMazeGameState;
};

#endif /* defined(__BaseProject__MazeDebugVariable2__) */
