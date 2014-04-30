//
//  EntityFactory.cpp
//  GameAsteroids
//
//  Created by James Folk on 4/18/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "EntityFactory.h"

#include "BaseEntity.h"
#include "RigidEntity.h"
#include "SteeringEntity.h"
#include "GhostEntity.h"
#include "SoftEntity.h"

#include "CameraFactory.h"

#include "GLDebugDrawer.h"

BaseEntity *EntityFactory::createEntity(BaseEntityInfo *constructionInfo)
{
    BaseEntity *pBaseEntity = NULL;
    
    switch(constructionInfo->m_EntityType)
    {
        case EntityTypes_BaseEntity:
        {
            pBaseEntity = new BaseEntity(*constructionInfo);
        }
            break;
        case EntityTypes_RigidEntity:
        {
            RigidEntityInfo *info = dynamic_cast<RigidEntityInfo*>(constructionInfo);
            RigidEntity *pEntity = new RigidEntity(*info);
            pBaseEntity = pEntity;
        }
            break;
        case EntityTypes_SteeringEntity:
        {
            SteeringEntityInfo *info = dynamic_cast<SteeringEntityInfo*>(constructionInfo);
            SteeringEntity *pEntity = new SteeringEntity(*info);
            pBaseEntity = pEntity;
        }
            break;
        case EntityTypes_GhostEntity:
        {
            GhostEntityInfo *info = dynamic_cast<GhostEntityInfo*>(constructionInfo);
            GhostEntity *pEntity = new GhostEntity(*info);
            pBaseEntity = pEntity;
        }
            break;
        case EntityTypes_SoftEntity:
        {
            SoftEntityInfo *info = dynamic_cast<SoftEntityInfo*>(constructionInfo);
            SoftEntity *pEntity = new SoftEntity(*info);
            pBaseEntity = pEntity;
        }
            break;
        default:
            btAssert(true);
            break;
    }
    
//    if(constructionInfo->m_IsOrthographicEntity)
//        m_OrthographicEntities.push_back(pBaseEntity);
//    else
//        m_PerspectiveEntities.push_back(pBaseEntity);
    
    return pBaseEntity;
}

BaseEntity *EntityFactory::ctor(BaseEntityInfo *constructionInfo)
{
    return createEntity(constructionInfo);
}
BaseEntity *EntityFactory::ctor(int type)
{
    BaseEntity *pEntity = NULL;
    
    switch (type)
    {
        default:case EntityTypes_BaseEntity:
            pEntity = new BaseEntity();
            break;
        case EntityTypes_GhostEntity:
            pEntity = new GhostEntity();
            break;
        case EntityTypes_RigidEntity:
            pEntity = new RigidEntity();
            break;
        case EntityTypes_SteeringEntity:
            pEntity = new SteeringEntity();
            break;
        case EntityTypes_SoftEntity:
            pEntity = new SoftEntity();
            break;
    }
    
//    m_PerspectiveEntities.push_back(pEntity);
    
    return pEntity;
}
void EntityFactory::dtor(BaseEntity *object)
{
//    if(m_OrthographicEntities.size() != m_OrthographicEntities.findLinearSearch(object))
//        m_OrthographicEntities.remove(object);
//    else if(m_PerspectiveEntities.size() != m_PerspectiveEntities.findLinearSearch(object))
//        m_PerspectiveEntities.remove(object);
    
    delete object;
}


//void EntityFactory::render()
//{
//    for (int i = 0; i < m_PerspectiveEntities.size(); ++i)
//    {
//        m_PerspectiveEntities[i]->renderInstancing();
//    }
//    for(int i = 0; i < m_OrthographicEntities.size(); ++i)
//    {
////        m_OrthographicEntities[i]->render(CameraFactory::getInstance()->getOrthoCamera());
//    }
//}
