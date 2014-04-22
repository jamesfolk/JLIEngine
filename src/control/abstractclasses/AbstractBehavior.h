//
//  AbstractBehavior.h
//  GameAsteroids
//
//  Created by James Folk on 6/20/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef GameAsteroids_AbstractBehavior_h
#define GameAsteroids_AbstractBehavior_h

#include "btBulletCollisionCommon.h"

template <class T>
class AbstractBehavior
{
public:
    AbstractBehavior(T *owner):
    m_pOwner(owner){}
    virtual ~AbstractBehavior(){}
    
    virtual SIMD_FORCE_INLINE T*	getOwner()
    {
        return m_pOwner;
    }
    virtual SIMD_FORCE_INLINE const T*	getOwner() const
    {
        return m_pOwner;
    }
    virtual SIMD_FORCE_INLINE void	setOwner(T* owner)
    {
        m_pOwner = owner;
    }
private:
    T *m_pOwner;
};


#endif
