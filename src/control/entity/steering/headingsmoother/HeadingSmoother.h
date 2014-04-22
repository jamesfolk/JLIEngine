//
//  HeadingSmoother.h
//  BaseProject
//
//  Created by library on 9/22/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef __BaseProject__HeadingSmoother__
#define __BaseProject__HeadingSmoother__

#include "btVector3.h"
#include "btScalar.h"
#include "AbstractSingleton.h"
#include "UtilityFunctions.h"
#include "btHashMap.h"
#include "AbstractFactoryIncludes.h"

class HeadingSmoother : public AbstractSingleton<HeadingSmoother>
{
public:
    HeadingSmoother(const btVector3 &startHeading = g_vHeadingVector);
    virtual ~HeadingSmoother();
    
    
    btVector3 getHeadingVector(IDType entityFactoryID)const;
    void addHeading(IDType entityFactoryID, const btVector3 &heading);
    void removeHeading(IDType entityFactoryID);
private:
    btVector3 *getHeading(IDType entityFactoryID)const;
    
    btHashMap<btHashInt, btVector3*> m_SmoothedHeadings;
};

#endif /* defined(__BaseProject__HeadingSmoother__) */
