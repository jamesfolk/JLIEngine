//
//  SceneRenderer.h
//  GameAsteroids
//
//  Created by James Folk on 4/22/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__SceneRenderer__
#define __GameAsteroids__SceneRenderer__

//#include "btBulletDynamicsCommon.h"

#include <map>
#include "BulletCollision/BroadphaseCollision/btDbvt.h"

class BaseEntity;
class OcclusionBuffer;


class	SceneRenderer : public btDbvt::ICollide
{
    int									m_drawn;
    OcclusionBuffer*					m_ocb;
    
    typedef std::pair<btScalar, BaseEntity*> Pair;
    typedef std::multimap<btScalar, BaseEntity*> MultiMap;
    typedef btAlignedObjectArray<BaseEntity*> Array;
    
    MultiMap m_TranslucentEntities;
    Array m_OpaqueEntities;
    
public:
    SceneRenderer();
    
    bool	Descent(const btDbvtNode* node);
    void	Process(const btDbvtNode* node,btScalar depth);
    void	Process(const btDbvtNode* leaf);
    
    virtual SIMD_FORCE_INLINE OcclusionBuffer*	getOcclusionBuffer()
    {
        btAssert(m_ocb);
        return m_ocb;
    }
    virtual SIMD_FORCE_INLINE const OcclusionBuffer*	getOcclusionBuffer() const
    {
        btAssert(m_ocb);
        return m_ocb;
    }
    virtual SIMD_FORCE_INLINE void	setOcclusionBuffer(OcclusionBuffer* ocb)
    {
        m_ocb = ocb;
    }
    
    int getNumObjectsDrawn()const;
    
    void render();
};

#endif /* defined(__GameAsteroids__SceneRenderer__) */
