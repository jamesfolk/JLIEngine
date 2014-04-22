//
//  DebugVariableFactory.mm
//  BaseProject
//
//  Created by library on 10/7/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "DebugVariableFactory.h"
#include "FrictionDebugVariable.h"
#include "MassDebugVariable.h"
#include "MazeDebugVariable.h"
#include "MazeDebugVariable2.h"
#include "RestitutionDebugVariable.h"
#include "AngularDampingDebugVariable.h"
#include "LinearDampingDebugVariable.h"

DebugVariable *DebugVariableFactory::ctor(DebugVariableInfo *constructionInfo)
{
    DebugVariable *pDebugVariable = NULL;
    
    switch (constructionInfo->m_Type) {
        case DebugVariableTypes_Friction:
        {
            FrictionDebugVariableInfo *info = dynamic_cast<FrictionDebugVariableInfo*>(constructionInfo);
            FrictionDebugVariable *pVar = new FrictionDebugVariable(*info);
            pDebugVariable = pVar;
        }
            break;
        case DebugVariableTypes_Restitution:
        {
            RestitutionDebugVariableInfo *info = dynamic_cast<RestitutionDebugVariableInfo*>(constructionInfo);
            RestitutionDebugVariable *pVar = new RestitutionDebugVariable(*info);
            pDebugVariable = pVar;
        }
            break;
        case DebugVariableTypes_Mass:
        {
            MassDebugVariableInfo *info = dynamic_cast<MassDebugVariableInfo*>(constructionInfo);
            MassDebugVariable *pVar = new MassDebugVariable(*info);
            pDebugVariable = pVar;
        }
            break;
        case DebugVariableTypes_Maze:
        {
            MazeDebugVariableInfo *info = dynamic_cast<MazeDebugVariableInfo*>(constructionInfo);
            MazeDebugVariable *pVar = new MazeDebugVariable(*info);
            pDebugVariable = pVar;
        }
            break;

        case DebugVariableTypes_Maze2:
        {
            MazeDebugVariable2Info *info = dynamic_cast<MazeDebugVariable2Info*>(constructionInfo);
            MazeDebugVariable2 *pVar = new MazeDebugVariable2(*info);
            pDebugVariable = pVar;
        }
            break;
        case DebugVariableTypes_AngularDamping:
        {
            AngularDampingDebugVariableInfo *info = dynamic_cast<AngularDampingDebugVariableInfo*>(constructionInfo);
            AngularDampingDebugVariable *pVar = new AngularDampingDebugVariable(*info);
            pDebugVariable = pVar;
        }
            break;
        case DebugVariableTypes_LinearDamping:
        {
            LinearDampingDebugVariableInfo *info = dynamic_cast<LinearDampingDebugVariableInfo*>(constructionInfo);
            LinearDampingDebugVariable *pVar = new LinearDampingDebugVariable(*info);
            pDebugVariable = pVar;
        }
            break;
        default:
            break;
    }
    return pDebugVariable;
}

DebugVariable *DebugVariableFactory::ctor(int type)
{
    return NULL;
}

void DebugVariableFactory::dtor(DebugVariable *object)
{
    
}