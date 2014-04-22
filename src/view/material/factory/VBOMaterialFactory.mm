//
//  VBOMaterialFactory.cpp
//  MazeADay
//
//  Created by James Folk on 3/30/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#include "VBOMaterialFactory.h"

VBOMaterial *VBOMaterialFactory::ctor(VBOMaterialInfo *constructionInfo)
{
    return new VBOMaterial(*constructionInfo);
}
VBOMaterial *VBOMaterialFactory::ctor(int type)
{
    return new VBOMaterial();
}
void VBOMaterialFactory::dtor(VBOMaterial *object)
{
    delete object;
    object = NULL;
}