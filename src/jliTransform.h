//
//  jliTransform.h
//  MazeADay
//
//  Created by James Folk on 3/17/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#ifndef __MazeADay__jliTransform__
#define __MazeADay__jliTransform__

#include "btTransform.h"
#include <limits>

/**@brief The btTransform class supports rigid transforms with only translation and rotation and no scaling/shear.
 *It can be used in combination with btVector3, btQuaternion and btMatrix3x3 linear algebra classes. */
ATTRIBUTE_ALIGNED16(class) jliTransform
{
    union
    {
        btScalar m_Matrix[16];
        btTransform m_Transform;
    };

    SIMD_FORCE_INLINE void setTransfrom(const btTransform &rhs)
    {
        m_Transform = rhs;
    }
public:
    jliTransform() : m_Transform(btTransform::getIdentity())
    {
        m_Transform.setOrigin(btVector3(std::numeric_limits<btScalar>::min(),
                                        std::numeric_limits<btScalar>::min(),
                                        std::numeric_limits<btScalar>::min()));
    }

    jliTransform(const btTransform &transform)
    {
        setTransfrom(transform);
    }

    jliTransform(const btScalar *matrix)
    {
        btTransform t;
        t.setFromOpenGLMatrix(matrix);
        setTransfrom(t);
    }

    jliTransform(const jliTransform &rhs)
    {
        setTransfrom(rhs.m_Transform);
    }

    SIMD_FORCE_INLINE	operator       btScalar *()       { return &m_Matrix[0]; }
    SIMD_FORCE_INLINE	operator const btScalar *() const { return &m_Matrix[0]; }

    SIMD_FORCE_INLINE operator btTransform(){return m_Transform;}
    SIMD_FORCE_INLINE operator btTransform()const{return m_Transform;}

    // Assignment Operator
    SIMD_FORCE_INLINE jliTransform&
    operator=(const jliTransform& other)
    {
        if(this != &other)
        {
            setTransfrom(other.m_Transform);
        }
        
        return *this;
    }

    // Assignment Operator
    SIMD_FORCE_INLINE jliTransform&
    operator=(const btTransform& other)
    {
        setTransfrom(other);
        
        return *this;
    }
};


#endif /* defined(__MazeADay__jliTransform__) */
