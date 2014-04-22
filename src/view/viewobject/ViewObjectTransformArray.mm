//
//  ViewObjectTransformArray.cpp
//  MazeADay
//
//  Created by James Folk on 3/18/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#include "ViewObjectTransformArray.h"
#include "BaseEntity.h"
#include "ShaderFactory.h"
#include "BaseViewObject.h"

#define check_gl_error() _check_gl_error(__FILE__,__LINE__,__FUNCTION__);


void ViewObjectTransformArray::operator() (int i, btTransform &to, const btTransform &from)
{
    to = transformData[i];
}

ViewObjectTransformArray::ViewObjectTransformArray(const unsigned int capacity):
m_IsDirty(true),
m_CurrentIndex(0)
{
    transformData.reserve(capacity);
}
ViewObjectTransformArray::ViewObjectTransformArray(const ViewObjectTransformArray &rhs)
{
    m_IsDirty = true;
    m_CurrentIndex = rhs.m_CurrentIndex;
    transformData.copyFromArray(rhs.transformData);
}

ViewObjectTransformArray &ViewObjectTransformArray::operator=(const ViewObjectTransformArray &rhs)
{
    if(this != &rhs)
    {
        transformData.copyFromArray(rhs.transformData);
        m_IsDirty = true;
        m_CurrentIndex = rhs.m_CurrentIndex;
    }
    return *this;
}

void ViewObjectTransformArray::render(BaseViewObject *pViewObject)
{
    size_t offset_position = reinterpret_cast<size_t>(pViewObject->getPositionOffset());
    pViewObject->set_each_attribute<ViewObjectTransformArray, btTransform>(*this, offset_position);
}


bool ViewObjectTransformArray::registerEntity(BaseEntity *entity)
{
    if(m_CurrentIndex < transformData.capacity() &&
       entity->getViewObjectTransformArrayIndex() < 0)
    {
        entity->setViewObjectTransformArrayIndex(m_CurrentIndex);
        m_CurrentIndex++;
        
        return true;
    }
    return false;
}

void ViewObjectTransformArray::setWorldTransform(BaseEntity *entity)
{
    btAssert(entity->getViewObjectTransformArrayIndex() >= 0);
    
    transformData[entity->getViewObjectTransformArrayIndex()] = entity->getWorldTransform();
}