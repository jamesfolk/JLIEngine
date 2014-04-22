//
//  VBOTransformQueue.h
//  MazeADay
//
//  Created by James Folk on 3/30/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#ifndef __MazeADay__VBOTransformQueue__
#define __MazeADay__VBOTransformQueue__

#include <queue>
#include "btHashMap.h"
#include "btAlignedObjectArray.h"
#include "jliTransform.h"

class BaseEntity;
class btTransform;

class VBOTransformQueue
{
    //The queue to hold the Transform Attribute Index
    std::queue<unsigned int> m_TransformQueue;
    unsigned int m_Capacity;
    
    //hash table to hold the relationship between the transform attribute index and entity id
    //Entity IDType is key, transform attribute index is value
    typedef btHashMap<btHashInt, unsigned int> TransformAttributeHashMap;
    TransformAttributeHashMap m_TransformAttributeHashMap;
    
    btAlignedObjectArray<jliTransform> m_TransformArray;
    
    VBOTransformQueue(const VBOTransformQueue &rhs);
    VBOTransformQueue &operator=(const VBOTransformQueue &rhs);
public:
    VBOTransformQueue();
    virtual ~VBOTransformQueue();
    
    void init(unsigned int capacity);
    void unInit();
    
    bool registerEntity(BaseEntity *entity);
    bool unRegisterEntity(BaseEntity *entity);
    
    bool render(BaseEntity *entity);
    
    unsigned int capacity()const;
    
    SIMD_FORCE_INLINE const jliTransform& operator[](int n) const
    {
        btAssert(n>=0);
        btAssert(n<m_TransformArray.size());
        return m_TransformArray[n];
    }
    
    SIMD_FORCE_INLINE jliTransform& operator[](int n)
    {
        btAssert(n>=0);
        btAssert(n<m_TransformArray.size());
        return m_TransformArray[n];
    }
    
    const btTransform& operator[](BaseEntity *e) const;
};

#endif /* defined(__MazeADay__VBOTransformQueue__) */
