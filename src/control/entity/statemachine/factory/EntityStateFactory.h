//
//  EntityStateFactory.h
//  MazeADay
//
//  Created by James Folk on 1/26/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#ifndef __MazeADay__EntityStateFactory__
#define __MazeADay__EntityStateFactory__

#include "BaseEntityState.h"
#include "AbstractFactory.h"

enum EntityStateType_e
{
    EntityStateType_NONE,

    EntityStateType_Lua,
    
//    EntityStateType_ObjectFallState,
//    EntityStateType_PursueState,
//    EntityStateType_EvadeState,
    
    EntityStateType_MAX
};

struct BaseEntityStateInfo
{
    EntityStateType_e gametype;
};

class EntityStateFactory :
public AbstractFactory<EntityStateFactory, BaseEntityStateInfo, BaseEntityState>
{
    friend class AbstractSingleton;
    friend class BaseEntityState;
    
    EntityStateFactory(){}
    virtual ~EntityStateFactory(){}
    
protected:
    virtual BaseEntityState *ctor(BaseEntityStateInfo *constructionInfo);
    virtual BaseEntityState *ctor(int type = 0);
    virtual void dtor(BaseEntityState *object);
};

#endif /* defined(__MazeADay__EntityStateFactory__) */
