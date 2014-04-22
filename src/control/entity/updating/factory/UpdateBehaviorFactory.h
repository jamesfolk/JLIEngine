//
//  UpdateBehaviorFactory.h
//  GameAsteroids
//
//  Created by James Folk on 7/16/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__UpdateBehaviorFactory__
#define __GameAsteroids__UpdateBehaviorFactory__

#include "AbstractFactory.h"
#include "UpdateBehaviorFactoryIncludes.h"
//#include "BaseUpdateBehavior.h"
#include "BaseEntity.h"

//class BaseUpdateBehavior;
class UpdateBehaviorFactory;

class UpdateBehaviorFactory :
public AbstractFactory<UpdateBehaviorFactory, UpdateBehaviorInfo, BaseUpdateBehavior>
{
    friend class AbstractSingleton;
    
    UpdateBehaviorFactory(){}//:m_pCurrentLuaEntity(NULL){}
    virtual ~UpdateBehaviorFactory(){}//{}
protected:
    virtual BaseUpdateBehavior *ctor(UpdateBehaviorInfo *constructionInfo);
    virtual BaseUpdateBehavior *ctor(int type = 0);
    virtual void dtor(BaseUpdateBehavior *object);
//public:
//    void	setCurrentLuaEntity(BaseEntity* entity);
//    const BaseEntity*	getCurrentLuaEntity() const;
//private:
//    BaseEntity *m_pCurrentLuaEntity;
};

#endif /* defined(__GameAsteroids__UpdateBehaviorFactory__) */
