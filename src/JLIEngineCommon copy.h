//
//  JLIEngineCommon.h
//  BaseProject
//
//  Created by library on 8/21/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#ifndef BaseProject_JLIEngineCommon_h
#define BaseProject_JLIEngineCommon_h

typedef char s8;
typedef unsigned char u8;
typedef short s16;
typedef unsigned short u16;
typedef int s32;
typedef unsigned int u32;
typedef signed long long s64;
typedef unsigned long long u64;

//TODO: Implement
//#include "control/abstractclasses/AbstractCounter.h"
//#include "control/abstractclasses/AbstractSharedFactory.h"


//TODO fix headers for swig
//#include "model/loading/texture/TextureFactory.h"
//#include "model/loading/texture/TextureFactoryIncludes.h"
//#include "view/viewobject/BaseViewObject.h"
//#include "model/loading/sound/BackgroundMusicPlayer.h"
//#include "model/loading/sound/SingletonSoundManager.h"
//#include "control/input/PlayerInput.h"

#include "control/input/DeviceInput.h"

#include "control/gamestates/factory/GameStateMachine.h"
#include "control/entity/statemachine/EntityStateMachine.h"
#include "control/entity/entity/BaseEntity.h"
#include "control/entity/entity/GhostEntity.h"
#include "control/entity/entity/RigidEntity.h"
#include "control/entity/entity/SoftEntity.h"
#include "control/entity/entity/SteeringEntity.h"
//
#include "control/entity/camera/BaseCamera.h"
#include "control/entity/camera/CameraEntity.h"
#include "control/entity/camera/CameraPhysicsEntity.h"
#include "control/entity/camera/CameraSteeringEntity.h"
//
//
////Factories
#include "control/entity/entity/factory/EntityFactory.h"
#include "control/entity/animation/factory/AnimationControllerFactory.h"
#include "control/entity/camera/factory/CameraFactory.h"
#include "control/entity/statemachine/factory/EntityStateMachineFactory.h"
#include "view/particles/factory/ParticleEmitterBehaviorFactory.h"
#include "control/entity/steering/factory/SteeringBehaviorFactory.h"
#include "view/texturebehavior/factory/TextureBehaviorFactory.h"
#include "view/text/factory/TextViewObjectFactory.h"
#include "control/entity/updating/factory/UpdateBehaviorFactory.h"
//#include "view/viewobject/factory/ViewObjectFactory.h"
#include "control/entity/collisionfilter/factory/CollisionFilterBehaviorFactory.h"
#include "control/entity/collisionresponse/factory/CollisionResponseBehaviorFactory.h"
#include "control/physics/collisionshape/factory/CollisionShapeFactory.h"
#include "model/loading/shader/factory/ShaderFactory.h"
//
//
//
//Factory includes...
#include "control/abstractclasses/AbstractFactoryIncludes.h"
#include "control/entity/entity/factory/EntityFactoryIncludes.h"
#include "control/entity/statemachine/factory/EntityStateMachineFactoryIncludes.h"
#include "control/entity/animation/factory/AnimationControllerFactoryIncludes.h"
#include "view/particles/factory/ParticleEmitterBehaviorFactoryIncludes.h"
#include "control/entity/steering/factory/SteeringBehaviorFactoryIncludes.h"
#include "control/entity/updating/factory/UpdateBehaviorFactoryIncludes.h"
#include "control/entity/camera/factory/CameraFactoryIncludes.h"
#include "view/text/factory/TextViewObjectFactoryIncludes.h"
#include "view/texturebehavior/factory/TextureBehaviorFactoryIncludes.h"
#include "view/viewobject/factory/ViewObjectFactoryIncludes.h"
#include "control/entity/collisionfilter/factory/CollisionFilterBehaviorFactoryIncludes.h"
#include "control/entity/collisionresponse/factory/CollisionResponseBehaviorFactoryIncludes.h"
#include "control/physics/collisionshape/factory/CollisionShapeFactoryIncludes.h"
#include "model/loading/shader/factory/ShaderFactoryIncludes.h"
//
//
//Base Behaviors
#include "control/entity/steering/BaseEntitySteeringBehavior.h"
#include "control/entity/collisionfilter/BaseCollisionFilterBehavior.h"
#include "control/entity/collisionresponse/BaseCollisionResponseBehavior.h"
#include "control/entity/animation/BaseEntityAnimationController.h"
#include "view/particles/BaseParticleEmitterBehavior.h"
#include "view/texturebehavior/BaseTextureBehavior.h"
#include "control/entity/updating/BaseUpdateBehavior.h"
//
//
#include "control/framecounter/FrameCounter.h"
#include "control/entity/statemachine/Messaging/Telegram.h"
#include "control/mazegenerator/MazeCreator.h"
#include "control/mazegenerator/MeshMazeCreator.h"
#include "control/physics/OcclusionBuffer.h"
#include "control/physics/SceneRenderer.h"
#include "control/physics/WorldPhysics.h"
#include "include/UtilityFunctions.h"
#include "control/entity/steering/derived/WeightedSteeringBehavior.h"
#include "control/entity/steering/Path.h"
#include "control/entity/animation/factory/AnimationController2DTest.h"
#include "control/entity/statemachine/Messaging/MessageDispatcher.h"
#include "control/gamestates/BaseGameState.h"
#include "view/text/BaseTextViewObject.h"
#include "view/text/LocalizedTextViewObjectTypes.h"
#include "view/text/TextViewObjectTypes.h"
#include "control/lua/LuaVM.h"
#include "view/debug/GLDebugDrawer.h"
#include "control/entity/statemachine/BaseEntityState.h"




//#include "control/entity/_collisionfilter/derived/FinishLevelCollisionFilterBehavior.h"
//#include "control/entity/_collisionfilter/derived/MazePickupCollisionFilterBehavior.h"
//#include "control/entity/_collisionfilter/derived/PlayerCollisionFilterBehavior.h"
//#include "control/entity/_collisionresponse/derived/FinishLevelCollisionResponseBehavior.h"
//#include "control/entity/_collisionresponse/derived/MazePickupCollisionResponseBehavior.h"
//#include "control/entity/_collisionresponse/derived/PlayerCollisionResponseBehavior.h"
//#include "control/entity/_updating/derived/PlayerUpdateBehavior.h"
//#include "control/gamestates/derived/BaseTestState.h"
//#include "control/gamestates/derived/CameraAndControlTestState.h"
//#include "control/gamestates/derived/FontTestState.h"
//#include "control/gamestates/derived/MazeGameState.h"
//#include "control/gamestates/derived/MazeTestState.h"
//#include "control/gamestates/derived/PathTestState.h"
//#include "control/gamestates/derived/PhysicsEntityTestState.h"
//#include "control/gamestates/derived/SpriteTestState.h"
//#include "control/gamestates/derived/SteeringBehaviorTestState.h"
//#include "control/gamestates/derived/ViewEntityTestState.h"


//#include "model/loading/VertexAttributeLoader.h"






#endif
