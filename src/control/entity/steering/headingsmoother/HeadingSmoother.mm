//
//  HeadingSmoother.mm
//  BaseProject
//
//  Created by library on 9/22/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "HeadingSmoother.h"


HeadingSmoother::HeadingSmoother(const btVector3 &startHeading)
{
}
HeadingSmoother::~HeadingSmoother()
{
    for (int i = 0; i < m_SmoothedHeadings.size(); i++)
    {
        btVector3 *v = *m_SmoothedHeadings.getAtIndex(i);
        delete v;
        v = NULL;
    }
    m_SmoothedHeadings.clear();
}


btVector3 HeadingSmoother::getHeadingVector(IDType entityFactoryID)const
{
    btVector3 *average_heading = getHeading(entityFactoryID);
    
    return average_heading->normalized();
}
void HeadingSmoother::addHeading(IDType entityFactoryID, const btVector3 &heading)
{
    btVector3 *average_heading = getHeading(entityFactoryID);
    if(average_heading)
    {
        (*average_heading) += heading.normalized();
        //(*average_heading) *= 0.5f;
        
        //average_heading->normalize();
    }
    else
    {
        m_SmoothedHeadings.insert(btHashInt(entityFactoryID), new btVector3(heading));
    }
}

void HeadingSmoother::removeHeading(IDType entityFactoryID)
{
    btVector3 *object = getHeading(entityFactoryID);
    
    if(object)
    {
        delete object;
        m_SmoothedHeadings.remove(btHashInt(entityFactoryID));
    }
}

btVector3 *HeadingSmoother::getHeading(IDType entityFactoryID)const
{
    btVector3 *const*object = m_SmoothedHeadings.find(btHashInt(entityFactoryID));
    if(object)
        return *object;
    return NULL;
}