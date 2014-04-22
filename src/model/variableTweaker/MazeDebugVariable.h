//
//  MazeDebugVariable.h
//  BaseProject
//
//  Created by library on 10/7/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __BaseProject__MazeDebugVariable__
#define __BaseProject__MazeDebugVariable__

#include "DebugVariable.h"

class MazeGameState;

struct MazeDebugVariableInfo : public DebugVariableInfo
{
    MazeDebugVariableInfo():
    DebugVariableInfo(DebugVariableTypes_Maze)
    {}
    
    MazeGameState *pMazeGameState;
};

class MazeDebugVariable : public DebugVariable
{
public:
    MazeDebugVariable(const MazeDebugVariableInfo &rhs);
    virtual ~MazeDebugVariable();
    
    virtual float getMaxValue();
    virtual float getMinValue();
    virtual float getValue()const;
    virtual bool setValue(const float val);
    
private:
    MazeGameState *m_pMazeGameState;
};

#endif /* defined(__BaseProject__MazeDebugVariable__) */
