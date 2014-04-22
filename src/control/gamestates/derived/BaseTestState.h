//
//  BaseTestState.h
//  GameAsteroids
//
//  Created by James Folk on 4/2/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__BaseTestState__
#define __GameAsteroids__BaseTestState__

#include "BaseGameState.h"
#include "btAlignedObjectArray.h"

#include "CameraFactoryIncludes.h"
#include "ShaderFactoryIncludes.h"
#include "ViewObjectFactoryIncludes.h"
#include "SteeringBehaviorFactoryIncludes.h"
#include "EntityStateMachineFactoryIncludes.h"
#include "AnimationControllerFactoryIncludes.h"
#include "AbstractFactoryIncludes.h"
#include "TextureBehaviorFactoryIncludes.h"

#include "ViewObjectFactory.h"
#include "VertexAttributeLoader.h"
#include "TextViewObjectFactory.h"

class BaseEntity;
class RigidEntity;
class btVector3;
class BaseViewObject;
class BaseCamera;
class CameraPhysicsEntity;
class CameraEntity;
class SteeringEntity;
class CameraSteeringEntity;
class GhostEntity;

class BaseTestState : public BaseGameState
{
public:
    virtual void update_specific(btScalar deltaTimeStep) = 0;
    virtual void enter_specific() = 0;
    virtual void exit_specific() = 0;
    virtual void render_specific(){}
    
    BaseTestState();
    virtual ~BaseTestState();
    
    virtual void enter(void*);
    
    //this is the states normal update function
    virtual void update(void*, btScalar deltaTimeStep);
    
    //call this to update the FSM
    void  render();
    
    //this will execute when the state is exited.
    virtual void exit(void*);
    
    //this executes if the agent receives a message from the
    //message dispatcher
    virtual bool onMessage(void*, const Telegram&);
    
    static CameraEntity *createCameraEntity(CameraEntityInfo *constructionInfo);
    
    template<class VERTEX_ATTRIBUTE>
    static IDType createLoadViewObject(BaseViewObjectInfo *constructionInfo,
                                       const btAlignedObjectArray<VERTEX_ATTRIBUTE> &vertexData)
    {
        IDType viewObjectID = ViewObjectFactory::getInstance()->create(constructionInfo);
        
        BaseViewObject *vo = ViewObjectFactory::getInstance()->get(viewObjectID);
        VertexAttributeLoader::getInstance()->load(vo, vertexData);
        
        return viewObjectID;
    }
protected:
    CameraEntity *createCamera();
    RigidEntity *createPlane();
    RigidEntity *createBox();
    RigidEntity *createSphere();
    
    CameraEntity *m_pOrthoCamera;
    
    IDType m_image_bricks;
    IDType m_image_spritetest;
    IDType m_image_tarsier;
    
    IDType m_mesh_cone;
    IDType m_mesh_cube;
    IDType m_mesh_cylinder;
    IDType m_mesh_icosphere;
    IDType m_mesh_mazeblock;
    IDType m_mesh_mazewall;
    IDType m_mesh_plane;
    IDType m_mesh_sphere;
    IDType m_mesh_sprite;
    
    IDType m_shape_cone;
    IDType m_shape_cube;
    IDType m_shape_cylinder;
    IDType m_shape_plane;
    IDType m_shape_sphere;
    
    IDType m_image_skybox;
    IDType m_mesh_skybox;
    
//    IDType m_image_px;
//    IDType m_image_py;
//    IDType m_image_pz;
//    IDType m_image_nx;
//    IDType m_image_ny;
//    IDType m_image_nz;
//    IDType m_image_posx;
//    IDType m_image_posy;
//    IDType m_image_posz;
//    IDType m_image_negx;
//    IDType m_image_negy;
//    IDType m_image_negz;
//    IDType m_mesh_px;
//    IDType m_mesh_py;
//    IDType m_mesh_pz;
//    IDType m_mesh_nx;
//    IDType m_mesh_ny;
//    IDType m_mesh_nz;
};

#endif /* defined(__GameAsteroids__BaseTestState__) */
