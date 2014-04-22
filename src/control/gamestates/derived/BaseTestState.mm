//
//  BaseTestState.mm
//  GameAsteroids
//
//  Created by James Folk on 4/2/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "BaseTestState.h"

#include "RigidEntity.h"
 
#include "ViewObjectFactory.h"
#include "GLDebugDrawer.h"
#include "BaseViewObject.h"

#include "CameraFactory.h"
#include "CameraPhysicsEntity.h"
#include "CameraEntity.h"

#include "WorldPhysics.h"
#include "ShaderFactory.h"
//#include "TextureFactory.h"
#include "CollisionShapeFactory.h"
#include "AnimationControllerFactory.h"
#include "SteeringBehaviorFactory.h"
#include "EntityStateMachineFactory.h"
#include "FrameCounter.h"
//#include "PlayerInput.h"

#include "GameStateMachine.h"


#include "MazeCreator.h"
#include "SteeringEntity.h"
#include "CameraSteeringEntity.h"

#include "EntityFactory.h"

#include "TextureBehaviorFactory.h"
#include "ParticleEmitterBehaviorFactory.h"
#include "CollisionResponseBehaviorFactory.h"
//#include "UpdateBehaviorFactory.h"
//#include "CollisionFilterBehaviorFactory.h"
#include "TextureFactory.h"

BaseTestState::BaseTestState() :
m_image_bricks(0),
m_image_spritetest(0),
m_image_tarsier(0),
m_mesh_cone(0),
m_mesh_cube(0),
m_mesh_cylinder(0),
m_mesh_icosphere(0),
m_mesh_mazeblock(0),
m_mesh_mazewall(0),
m_mesh_plane(0),
m_mesh_sphere(0),
m_mesh_sprite(0),
m_shape_cone(0),
m_shape_cube(0),
m_shape_cylinder(0),
m_shape_plane(0),
m_shape_sphere(0)
{
}

BaseTestState::~BaseTestState()
{
}

void BaseTestState::enter(void*)
{
//    //GLDebugDrawer::createInstance();
//    CollisionFilterBehaviorFactory::createInstance();
//    UpdateBehaviorFactory::createInstance();
//    CollisionResponseBehaviorFactory::createInstance();
//    TextureBehaviorFactory::createInstance();
//    ParticleEmitterBehaviorFactory::createInstance();
//    EntityFactory::createInstance();
//    ViewObjectFactory::createInstance();
//    TextViewObjectFactory::createInstance();
//    ShaderFactory::createInstance();
//    CollisionShapeFactory::createInstance();
//    AnimationControllerFactory::createInstance();
//    SteeringBehaviorFactory::createInstance();
//    EntityStateMachineFactory::createInstance();
    
//    [sharedSoundManager loadBGMWithKey:@"game" fileName:@"menu" fileExt:@"mp3"];
//	[sharedSoundManager playBGMWithKey:@"game" timesToRepeat:-1 fadeIn:NO];
//    [sharedSoundManager setBGMVolume:0.0f];
//    
//    [[SingletonSoundManager sharedSoundManager] loadSFXWithKey:@"laser" fileName:@"laser" fileExt:@"caf" frequency:22050];
    
    FrameCounter::getInstance()->reset();
    FrameCounter::getInstance()->start();
    
    
    CameraEntityInfo *constructionInfo = new CameraEntityInfo(true);
    m_pOrthoCamera = createCameraEntity(constructionInfo);
    delete constructionInfo;
    
    CameraFactory::getInstance()->setOrthoCamera(m_pOrthoCamera);
    
    m_pOrthoCamera->setOrigin(btVector3(0, 0, 100));
    m_pOrthoCamera->hide();
    
    
    m_image_bricks = TextureFactory::createTextureFromData("bricks");
    m_image_spritetest = TextureFactory::createTextureFromData("spritetest");
    m_image_tarsier = TextureFactory::createTextureFromData("tarsier");
    
    m_image_skybox = TextureFactory::createTextureFromData("j");
    
//    m_image_px = TextureFactory::createTextureFromData("px");
//    m_image_py = TextureFactory::createTextureFromData("py");
//    m_image_pz = TextureFactory::createTextureFromData("pz");
//    m_image_nx = TextureFactory::createTextureFromData("nx");
//    m_image_ny = TextureFactory::createTextureFromData("ny");
//    m_image_nz = TextureFactory::createTextureFromData("nz");
//    
//    m_image_posx = TextureFactory::createTextureFromData("posx");
//    m_image_posy = TextureFactory::createTextureFromData("posy");
//    m_image_posz = TextureFactory::createTextureFromData("posz");
//    m_image_negx = TextureFactory::createTextureFromData("negx");
//    m_image_negy = TextureFactory::createTextureFromData("negy");
//    m_image_negz = TextureFactory::createTextureFromData("negz");
    
    m_mesh_cone = ViewObjectFactory::createViewObject("cone", &m_image_bricks);
    m_mesh_cube = ViewObjectFactory::createViewObject("cube", &m_image_bricks);
    m_mesh_cylinder = ViewObjectFactory::createViewObject("cylinder", &m_image_bricks);
    m_mesh_icosphere = ViewObjectFactory::createViewObject("icosphere", &m_image_bricks);
    m_mesh_mazeblock = ViewObjectFactory::createViewObject("mazeblock", &m_image_bricks);
    m_mesh_mazewall = ViewObjectFactory::createViewObject("mazewall", &m_image_bricks);
    m_mesh_plane = ViewObjectFactory::createViewObject("plane", &m_image_tarsier);
    m_mesh_sphere = ViewObjectFactory::createViewObject("sphere", &m_image_bricks);
    m_mesh_sprite = ViewObjectFactory::createViewObject("sprite", &m_image_bricks);
    
    m_mesh_skybox = ViewObjectFactory::createViewObject("skybox", &m_image_skybox);
    
//    m_mesh_px = ViewObjectFactory::createViewObject("plane_positive_x", &m_image_posx);
//    m_mesh_py = ViewObjectFactory::createViewObject("plane_positive_y", &m_image_posy);
//    m_mesh_pz = ViewObjectFactory::createViewObject("plane_positive_z", &m_image_posz);
//    m_mesh_nx = ViewObjectFactory::createViewObject("plane_negative_x", &m_image_negx);
//    m_mesh_ny = ViewObjectFactory::createViewObject("plane_negative_y", &m_image_negy);
//    m_mesh_nz = ViewObjectFactory::createViewObject("plane_negative_z", &m_image_negz);
    
    m_shape_cone = CollisionShapeFactory::createShape(m_mesh_cone, CollisionShapeType_ConeY);
    m_shape_cube = CollisionShapeFactory::createShape(m_mesh_cube, CollisionShapeType_Cube);
    m_shape_cylinder = CollisionShapeFactory::createShape(m_mesh_cylinder, CollisionShapeType_CylinderY);
    m_shape_plane = CollisionShapeFactory::createShape(m_mesh_plane, CollisionShapeType_TriangleMesh);
    m_shape_sphere = CollisionShapeFactory::createShape(m_mesh_sphere, CollisionShapeType_Sphere);
    
    enter_specific();
    
    
}

//this is the states normal update function
void BaseTestState::update(void*, btScalar deltaTimeStep)
{
    m_pOrthoCamera->lookAt(btVector3(0,0,0));
    
    update_specific(deltaTimeStep);
    
}

//call this to update the FSM
void  BaseTestState::render()
{
    render_specific();
    
}

//this will execute when the state is exited.
void BaseTestState::exit(void*)
{
    exit_specific();
    
    EntityFactory::getInstance()->destroyAll();
    CameraFactory::getInstance()->destroyAll();
    ParticleEmitterBehaviorFactory::getInstance()->destroyAll();
    ViewObjectFactory::getInstance()->destroyAll();
    CollisionShapeFactory::getInstance()->destroyAll();
    AnimationControllerFactory::getInstance()->destroyAll();
    SteeringBehaviorFactory::getInstance()->destroyAll();
    EntityStateMachineFactory::getInstance()->destroyAll();
    //ShaderFactory::getInstance()->destroyAll();
    TextureBehaviorFactory::getInstance()->destroyAll();
    CollisionResponseBehaviorFactory::getInstance()->destroyAll();
    //UpdateBehaviorFactory::getInstance()->destroyAll();
    //CollisionFilterBehaviorFactory::getInstance()->destroyAll();
    //TextureFactory::getInstance()->destroyAll();
    
    
    
//    EntityFactory::destroyInstance();
//    GLDebugDrawer::destroyInstance();
//    ParticleEmitterBehaviorFactory::destroyInstance();
//    ViewObjectFactory::destroyInstance();
//    CollisionShapeFactory::destroyInstance();
//    AnimationControllerFactory::destroyInstance();
//    SteeringBehaviorFactory::destroyInstance();
//    EntityStateMachineFactory::destroyInstance();
//    ShaderFactory::destroyInstance();
//    TextureBehaviorFactory::destroyInstance();
//    CollisionResponseBehaviorFactory::destroyInstance();
//    UpdateBehaviorFactory::destroyInstance();
//    CollisionFilterBehaviorFactory::destroyInstance();
    
    
    
    
    
//    [[SingletonSoundManager sharedSoundManager] unLoadSFXWithKey:@"laser"];
//    [sharedSoundManager stopBGMWithKey:@"game" fadeOut:YES];
    
    
}

//this executes if the agent receives a message from the
//message dispatcher
bool BaseTestState::onMessage(void*, const Telegram&)
{
    return false;
}

CameraEntity *BaseTestState::createCameraEntity(CameraEntityInfo *constructionInfo)
{
    if(constructionInfo->m_IsOrthographicCamera)
    {
        constructionInfo->m_nearZ = -1024;
        constructionInfo->m_farZ = 1024;
    }
    return dynamic_cast<CameraEntity*>(CameraFactory::getInstance()->get(CameraFactory::getInstance()->create(constructionInfo)));
}

CameraEntity *BaseTestState::createCamera()
{
    CameraEntityInfo *info = new CameraEntityInfo();
    info->m_nearZ = 0.01f;
    info->m_farZ = 2000.0f;
    CameraEntity *p = CameraFactory::createCameraEntity<CameraEntity, CameraEntityInfo>(info);
    delete info;
    return p;
    
}
RigidEntity *BaseTestState::createPlane()
{
    RigidEntityInfo *cInfo = new RigidEntityInfo(m_mesh_plane,
                                                 0,
                                                 0,
                                                 false,
                                                 m_shape_plane,
                                                 0);
    RigidEntity *p = EntityFactory::createEntity<RigidEntity, RigidEntityInfo>(cInfo);
    delete cInfo;
    
    return p;
}

RigidEntity *BaseTestState::createBox()
{
    RigidEntity *pSkybox = NULL;
    RigidEntityInfo *cInfo = NULL;
    btTransform initialTransform;
    
    
    
    
    
    
    initialTransform.setRotation(btQuaternion(DEGREES_TO_RADIANS(0.0f),
                                                 DEGREES_TO_RADIANS(0.0f),
                                                 DEGREES_TO_RADIANS(0.0f)));
    initialTransform.setOrigin(btVector3(0, 0, 0));
    cInfo = new RigidEntityInfo(m_mesh_skybox,
                                 0,
                                 0,
                                 false,
                                 m_shape_plane,
                                 0);
    pSkybox = EntityFactory::createEntity<RigidEntity, RigidEntityInfo>(cInfo);
    pSkybox->setKinematicPhysics();
    pSkybox->setWorldTransform(initialTransform);
    delete cInfo;
    
    return pSkybox;
}

RigidEntity *BaseTestState::createSphere()
{
    RigidEntityInfo *cInfo = new RigidEntityInfo(m_mesh_icosphere,
                                                 0,
                                                 0,
                                                 false,
                                                 m_shape_sphere,
                                                 0);
    RigidEntity *p = EntityFactory::createEntity<RigidEntity, RigidEntityInfo>(cInfo);
    p->setKinematicPhysics();
    delete cInfo;
    return p;
}
