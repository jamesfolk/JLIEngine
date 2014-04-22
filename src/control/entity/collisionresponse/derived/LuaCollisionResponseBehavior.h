//
//  LuaCollisionResponseBehavior.h
//  MazeADay
//
//  Created by James Folk on 2/17/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#ifndef __MazeADay__LuaCollisionResponseBehavior__
#define __MazeADay__LuaCollisionResponseBehavior__

#include "BaseCollisionResponseBehavior.h"

class LuaCollisionResponseBehavior :
public BaseCollisionResponseBehavior
{
    friend class CollisionResponseBehaviorFactory;
protected:
    LuaCollisionResponseBehavior();
    
    LuaCollisionResponseBehavior(const LuaCollisionResponseBehaviorInfo& constructionInfo);
    virtual ~LuaCollisionResponseBehavior();
public:
    
    //virtual void respond(BaseEntity *pOtherEntity, const btManifoldPoint &pt);
    virtual void respond(BaseEntity *owner, BaseEntity *pOtherEntity, const btManifoldPoint &pt);
    
    virtual SIMD_FORCE_INLINE void	setOwner(BaseEntity* owner)
    {
        BaseCollisionResponseBehavior::setOwner(owner);
        
        setName(getOwner()->getName() + std::string("CollisionResponse"));
    }
    
    //void setLuaFunctionName(const char *functionName);
    //void setLuaFunctionName(const std::string &functionName);
    
    
private:
    std::string m_LuaFunctionName;
    
};

#endif /* defined(__MazeADay__LuaCollisionResponseBehavior__) */
