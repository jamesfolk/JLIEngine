//
//  VBOMaterialFactory.h
//  MazeADay
//
//  Created by James Folk on 3/30/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#ifndef __MazeADay__VBOMaterialFactory__
#define __MazeADay__VBOMaterialFactory__

#include "AbstractFactory.h"

class VBOMaterialFactory;

#include "VBOMaterialFactoryIncludes.h"
#include "VBOMaterial.h"


class VBOMaterialFactory :
public AbstractFactory<VBOMaterialFactory, VBOMaterialInfo, VBOMaterial>
{
    friend class AbstractSingleton;
    
    VBOMaterialFactory(){}
    virtual ~VBOMaterialFactory(){}
    
protected:
    virtual VBOMaterial *ctor(VBOMaterialInfo *constructionInfo);
    virtual VBOMaterial *ctor(int type = 0);
    virtual void dtor(VBOMaterial *object);
};

#endif /* defined(__MazeADay__VBOMaterialFactory__) */
