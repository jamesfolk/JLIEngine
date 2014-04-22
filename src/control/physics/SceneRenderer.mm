//
//  SceneRenderer.cpp
//  GameAsteroids
//
//  Created by James Folk on 4/22/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "SceneRenderer.h"

#include "OcclusionBuffer.h"
#include "BaseEntity.h"
#include "RigidEntity.h"
#include "EntityFactory.h"
#include "BaseViewObject.h"
#include "VertexBufferObject.h"

SceneRenderer::SceneRenderer() :
m_drawn(0),
m_ocb(NULL)
{
}
bool	SceneRenderer::Descent(const btDbvtNode* node)
{
    if(m_ocb)
        return (m_ocb->queryOccluder(node->volume.Center(),node->volume.Extents()));
    return false;
}
void	SceneRenderer::Process(const btDbvtNode* node,btScalar depth)
{
    Process(node);
}
void	SceneRenderer::Process(const btDbvtNode* leaf)
{
    btBroadphaseProxy *proxy = static_cast<btBroadphaseProxy*>(leaf->data);
    btCollisionObject *co = static_cast<btCollisionObject*>(proxy->m_clientObject);
    BaseEntity *entity = static_cast<RigidEntity*>(co->getUserPointer());
    
    if(entity->getVertexBufferObject() &&
       entity->getVertexBufferObject()->hasAlphaTexture())
    {
        BaseCamera *camera = CameraFactory::getInstance()->getCurrentCamera();
        
        btScalar distance = btDistance(entity->getOrigin(), camera->getOrigin());
        
        m_TranslucentEntities.insert(Pair(distance, entity));
    }
    else
    {
        if(entity->getVertexBufferObject())
            m_OpaqueEntities.push_back(entity);
    }
    
    if(m_ocb)
    {
        static btVector3 aabbMin;
        static btVector3 aabbMax;
        co->getCollisionShape()->getAabb(btTransform::getIdentity(),aabbMin,aabbMax);   // Actually here I should get the MINIMAL aabb that can be nested INSIDE the shape (ie. only btBoxShapes work)
        m_ocb->appendOccluder((aabbMax-aabbMin)*btScalar(0.5f),co->getWorldTransform());   // Note that only a btVector3 (the inner box shape half extent) seems to be needed...
    }
}

int SceneRenderer::getNumObjectsDrawn()const
{
    return m_drawn;
}

void SceneRenderer::render()
{
//    BaseCamera *camera = CameraFactory::getInstance()->getCurrentCamera();
    
    m_drawn = m_TranslucentEntities.size() + m_OpaqueEntities.size();
    
    for (MultiMap::reverse_iterator iter = m_TranslucentEntities.rbegin();
         iter != m_TranslucentEntities.rend();
         ++iter)
    {
        iter->second->render();
    }
    m_TranslucentEntities.clear();
    
    for(int i = 0; i < m_OpaqueEntities.size(); ++i)
    {
        m_OpaqueEntities[i]->render();
    }
    m_OpaqueEntities.clear();
}
