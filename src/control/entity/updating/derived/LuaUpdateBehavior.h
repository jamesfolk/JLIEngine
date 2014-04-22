//
//  LuaUpdateBehavior.h
//  MazeADay
//
//  Created by James Folk on 2/19/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#ifndef __MazeADay__LuaUpdateBehavior__
#define __MazeADay__LuaUpdateBehavior__

#include "BaseUpdateBehavior.h"
#include <string>

class LuaUpdateBehavior :
public BaseUpdateBehavior
{
    friend class UpdateBehaviorFactory;
protected:
    LuaUpdateBehavior();
    LuaUpdateBehavior(const LuaUpdateBehaviorInfo& constructionInfo);
    virtual ~LuaUpdateBehavior();
public:
    virtual void update(BaseEntity *owner, btCollisionWorld* collisionWorld, btScalar deltaTimeStep);
    
    virtual SIMD_FORCE_INLINE void	setOwner(BaseEntity* owner)
    {
        BaseUpdateBehavior::setOwner(owner);
        
        setName(getOwner()->getName() + std::string("UpdateBehavior"));
    }
//    void setLuaFunctionName(const std::string &functionName);
//private:
//    std::string m_LuaFunctionName;
};

#endif /* defined(__MazeADay__LuaUpdateBehavior__) */
