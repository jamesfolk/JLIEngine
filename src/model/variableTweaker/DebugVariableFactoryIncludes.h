//
//  DebugVariableFactoryIncludes.h
//  BaseProject
//
//  Created by library on 10/7/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef BaseProject_DebugVariableFactoryIncludes_h
#define BaseProject_DebugVariableFactoryIncludes_h

#include <string>

enum DebugVariableTypes
{
    DebugVariableTypes_NONE,
    
    DebugVariableTypes_Friction,
    DebugVariableTypes_Restitution,
    DebugVariableTypes_Mass,
    DebugVariableTypes_Maze,
    DebugVariableTypes_Maze2,
    DebugVariableTypes_AngularDamping,
    DebugVariableTypes_LinearDamping,
    
    DebugVariableTypes_MAX
};

struct DebugVariableInfo
{
    DebugVariableTypes m_Type;
    std::string m_Label;
    
    DebugVariableInfo(DebugVariableTypes type = DebugVariableTypes_NONE) : m_Type(type){}
    virtual ~DebugVariableInfo(){}
};

#endif
