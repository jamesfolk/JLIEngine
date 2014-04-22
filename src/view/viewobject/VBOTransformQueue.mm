//
//  VBOTransformQueue.cpp
//  MazeADay
//
//  Created by James Folk on 3/30/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#include "VBOTransformQueue.h"
#include "BaseEntity.h"

VBOTransformQueue::VBOTransformQueue() :
m_Capacity(0)
{
    
}

VBOTransformQueue::~VBOTransformQueue()
{
    
}

void VBOTransformQueue::init(unsigned int capacity)
{
    unInit();
    
//    btVector3 origin(std::numeric_limits<btScalar>::max(),
//                     std::numeric_limits<btScalar>::max(),
//                     std::numeric_limits<btScalar>::max());
    
    btVector3 origin(0,0,0);
    
    btTransform transform(btTransform::getIdentity());
    transform.setOrigin(origin);
    
    m_Capacity = capacity;
    
    for (int i = 0; i < m_Capacity; ++i)
    {
        m_TransformQueue.push(i);
        m_TransformArray.push_back(transform);
    }
}

void VBOTransformQueue::unInit()
{
    while(!m_TransformQueue.empty())
        m_TransformQueue.pop();
    m_TransformArray.clear();
    m_TransformAttributeHashMap.clear();
}

bool VBOTransformQueue::registerEntity(BaseEntity *entity)
{
    unsigned int currentIndex = - 1;
    
    if(NULL != entity &&
       !m_TransformQueue.empty())
    {
        currentIndex = m_TransformQueue.front();
        m_TransformQueue.pop();
        
        m_TransformAttributeHashMap.insert(btHashInt(entity->getID()), currentIndex);
        
        return true;
    }
    return false;
}

bool VBOTransformQueue::unRegisterEntity(BaseEntity *entity)
{
    if(NULL != entity)
    {
        unsigned int *currentIndex = m_TransformAttributeHashMap.find(btHashInt(entity->getID()));
        if(NULL != currentIndex)
        {
            m_TransformQueue.push(*currentIndex);
            return true;
        }
    }
    return false;
}

bool VBOTransformQueue::render(BaseEntity *entity)
{
    if(NULL != entity)
    {
        unsigned int *currentIndex = m_TransformAttributeHashMap.find(btHashInt(entity->getID()));
        
        if(NULL != currentIndex)
        {
            m_TransformArray[*currentIndex] = entity->getWorldTransform();
            
            return true;
        }
    }
    return false;
}

unsigned int VBOTransformQueue::capacity()const
{
    return m_Capacity;
}

const btTransform& VBOTransformQueue::operator[](BaseEntity *entity) const
{
    if(NULL != entity)
    {
        const unsigned int *currentIndex = m_TransformAttributeHashMap.find(btHashInt(entity->getID()));
        
        if(NULL != currentIndex)
        {
            return this->operator[](*currentIndex);
        }
    }
    return btTransform::getIdentity();
}
