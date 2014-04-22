/* File: jli.i */

#define SWIG_RUNTIME_VERSION
#define SWIG_TYPE_TABLE "_JLIENGINE_"

%module jli

%include <lua/factory.i>
%include <lua/stl.i>
%include <lua/lua_fnptr.i>

%ignore operator std::string;

%ignore DeviceTapGesture::DeviceTapGesture(UITapGestureRecognizer *sender);
%ignore DevicePinchGesture::DevicePinchGesture(UIPinchGestureRecognizer *sender);
%ignore DevicePanGesture::DevicePanGesture(UIPanGestureRecognizer *sender);
%ignore DeviceSwipeGesture::DeviceSwipeGesture(UISwipeGestureRecognizer *sender);
%ignore DeviceRotationGesture::DeviceRotationGesture(UIRotationGestureRecognizer *sender);
%ignore DeviceLongPressGesture::DeviceLongPressGesture(UILongPressGestureRecognizer *sender);
%ignore DeviceAccelerometer::DeviceAccelerometer(CMAccelerometerData *data);
%ignore DeviceAttitude::DeviceAttitude(CMAttitude *attitude);
%ignore DeviceMotion::DeviceMotion(CMDeviceMotion *data);
%ignore DeviceGyro::DeviceGyro(CMGyroData *data);
%ignore DeviceMagnetometer::DeviceMagnetometer(CMMagnetometerData *data);
%ignore DeviceTouch::DeviceTouch(UITouch *touch, int n, int N);

//%import "AbstractLuaFactoryObject.i"
%import "AbstractSingleton.i"
%import "AbstractFactory.i"
%import "AbstractBehavior.i"
%import "AbstractState.i"
%import "AbstractStateMachine.i"

%{
    #include "JLIEngineCommon.h"
%}

%template(TheDeviceInputSingleton) AbstractSingleton<DeviceInput>;
//%template(TheFacebookSingletonSingleton) AbstractSingleton<FacebookSingleton>;
%template(TheHeadingSmootherSingleton) AbstractSingleton<HeadingSmoother>;
//%template(TheDeviceInputSingletonSingleton) AbstractSingleton<IcoSphereCreator<VERTEX_ATTRIBUTE> >;
%template(TheLocalizedTextLoaderSingleton) AbstractSingleton<LocalizedTextLoader>;
%template(TheMazeCreatorSingleton) AbstractSingleton<MazeCreator>;
%template(TheMessageDispatcherSingleton) AbstractSingleton<MessageDispatcher>;
%template(TheUserSettingsSingletonSingleton) AbstractSingleton<UserSettingsSingleton>;
//%template(TheVertexAttributeLoaderSingleton) AbstractSingleton<VertexAttributeLoader>;
//%template(TheZipFileResourceLoaderSingleton) AbstractSingleton<ZipFileResourceLoader>;
%template(TheLuaVMSingleton) AbstractSingleton< LuaVM >;
%template(TheGLDebugDrawerSingleton) AbstractSingleton< GLDebugDrawer >;




%template(TheViewObjectFactorySingleton) AbstractSingleton<ViewObjectFactory>;
%template(TheViewObjectFactory) AbstractFactory< ViewObjectFactory,BaseViewObjectInfo,BaseViewObject >;

//

%template(TheVertexBufferObjectFactorySingleton) AbstractSingleton<VertexBufferObjectFactory>;
%template(TheVertexBufferObjectFactory) AbstractFactory< VertexBufferObjectFactory,VertexBufferObjectInfo,VertexBufferObject >;

%template(TheVBOMaterialFactorySingleton) AbstractSingleton<VBOMaterialFactory>;
%template(TheVBOMaterialFactory) AbstractFactory< VBOMaterialFactory,VBOMaterialInfo,VBOMaterial >;




%template(TheTextureFactorySingleton) AbstractSingleton<TextureFactory>;
%template(TheTextureFactory) AbstractFactory< TextureFactory,TextureFactoryInfo,GLKTextureInfoWrapper >;

%template(TheAnimationControllerFactorySingleton) AbstractSingleton<AnimationControllerFactory>;
%template(TheAnimationControllerFactory) AbstractFactory< AnimationControllerFactory,AnimationControllerInfo,BaseEntityAnimationController >;

%template(TheCameraFactorySingleton) AbstractSingleton<CameraFactory>;
%template(TheCameraFactory) AbstractFactory< CameraFactory,BaseCameraInfo,BaseCamera >;

//%template(TheCollisionFilterBehaviorFactorySingleton) AbstractSingleton<CollisionFilterBehaviorFactory>;
//%template(TheCollisionFilterBehaviorFactory) AbstractFactory< CollisionFilterBehaviorFactory,CollisionFilterBehaviorInfo,BaseCollisionFilterBehavior >;

%template(TheCollisionResponseBehaviorFactorySingleton) AbstractSingleton<CollisionResponseBehaviorFactory>;
%template(TheCollisionResponseBehaviorFactory) AbstractFactory< CollisionResponseBehaviorFactory,BaseCollisionResponseBehaviorInfo,BaseCollisionResponseBehavior >;

%template(TheCollisionShapeFactorySingleton) AbstractSingleton<CollisionShapeFactory>;
%template(TheCollisionShapeFactory) AbstractFactory< CollisionShapeFactory,CollisionShapeInfo,btCollisionShapeWrapper >;

%template(TheDebugVariableFactorySingleton) AbstractSingleton<DebugVariableFactory>;
%template(TheDebugVariableFactory) AbstractFactory< DebugVariableFactory,DebugVariableInfo,DebugVariable >;

%template(TheEntityFactorySingleton) AbstractSingleton<EntityFactory>;
%template(TheEntityFactory) AbstractFactory<EntityFactory, BaseEntityInfo, BaseEntity>;

%template(TheEntityStateFactorySingleton) AbstractSingleton<EntityStateFactory>;
%template(TheEntityStateFactory) AbstractFactory< EntityStateFactory,BaseEntityStateInfo,BaseEntityState >;

%template(TheEntityStateMachineFactorySingleton) AbstractSingleton<EntityStateMachineFactory>;
%template(TheEntityStateMachineFactory) AbstractFactory< EntityStateMachineFactory,EntityStateMachineInfo,EntityStateMachine >;

%template(TheFrameCounterSingleton) AbstractSingleton<FrameCounter>;
%template(TheFrameCounterFactory) AbstractFactory< FrameCounter,TimerInfo,BaseTimer >;

%template(TheGameStateFactorySingleton) AbstractSingleton<GameStateFactory>;
%template(TheGameStateFactory) AbstractFactory< GameStateFactory,BaseGameStateInfo,BaseGameState >;

%template(TheParticleEmitterBehaviorFactorySingleton) AbstractSingleton<ParticleEmitterBehaviorFactory>;
%template(TheParticleEmitterBehaviorFactory) AbstractFactory< ParticleEmitterBehaviorFactory,ParticleEmitterBehaviorInfo,BaseParticleEmitterBehavior >;

%template(TheShaderFactorySingleton) AbstractSingleton<ShaderFactory>;
%template(TheShaderFactory) AbstractFactory< ShaderFactory,ShaderFactoryKey,ShaderProgramHandleWrapper >;

%template(TheSteeringBehaviorFactorySingleton) AbstractSingleton<SteeringBehaviorFactory>;
%template(TheSteeringBehaviorFactory) AbstractFactory< SteeringBehaviorFactory,SteeringBehaviorInfo,BaseEntitySteeringBehavior >;

%template(TheTextureBehaviorFactorySingleton) AbstractSingleton<TextureBehaviorFactory>;
%template(TheTextureBehaviorFactory) AbstractFactory< TextureBehaviorFactory,TextureBehaviorInfo,BaseTextureBehavior >;

%template(TheTextureBufferObjectFactorySingleton) AbstractSingleton<TextureBufferObjectFactory>;
%template(TheTextureBufferObjectFactory) AbstractFactory< TextureBufferObjectFactory,TextureBufferObjectFactoryInfo,BaseTextureBufferObject >;

%template(TheTextViewObjectFactorySingleton) AbstractSingleton<TextViewObjectFactory>;
%template(TheTextViewObjectFactory) AbstractFactory< TextViewObjectFactory,BaseTextViewInfo,BaseTextViewObject >;

//%template(TheUpdateBehaviorFactorySingleton) AbstractSingleton<UpdateBehaviorFactory>;
//%template(TheUpdateBehaviorFactory) AbstractFactory< UpdateBehaviorFactory,UpdateBehaviorInfo,BaseUpdateBehavior >;

%template(VoidAbstractBehavior)  AbstractBehavior< void >;
%template(BaseEntityAbstractBehavior)  AbstractBehavior<BaseEntity>;
%template(SteeringEntityAbstractBehavior)  AbstractBehavior<SteeringEntity>;
%template(BaseViewObjectAbstractBehavior)  AbstractBehavior<BaseViewObject>;
%template(VertexBufferObjectAbstractBehavior)  AbstractBehavior< VertexBufferObject >;

%template(BaseEntityAbstractState)  AbstractState< BaseEntity >;
%template(VoidAbstractState)  AbstractState< void >;

%template(BaseEntityAbstractStateMachine) AbstractStateMachine< BaseEntity >;
%template(TheGameStateMachine) AbstractSingleton< GameStateMachine >;
%template(VoidAbstractStateMachine) AbstractStateMachine< void >;






//%include <typemaps/swigmacros.swg>
//
//%define %_factory_dispatch(Type)
//if (!dcast) {
//    Type *dobj = dynamic_cast<Type *>($1);
//    if (dobj) {
//        dcast = 1;
//        SWIG_NewPointerObj(L, dobj, $descriptor(Type *), $owner); SWIG_arg++;
//    }
//}%enddef
//
//%define %factory(Method,Types...)
//%typemap(out) Method {
//    int dcast = 0;
//    %formacro(%_factory_dispatch, Types)
//    if (!dcast) {
//        SWIG_NewPointerObj(L, $1, $descriptor, $owner); SWIG_arg++;
//    }
//}%enddef






%define %_convert_dispatch(Type)
if (!dcast)
{
    Type *dobj = dynamic_cast<Type *>($1);
    if (dobj)
    {
        //%_convert_dispatch
        dcast = 1;
        SWIG_NewPointerObj(L, dobj, $descriptor(Type *), $owner);
        SWIG_arg++;
    }
}%enddef

%define %convert(Method,Types...)
%typemap(out) Method
{
    int dcast = 0;
    %formacro(%_convert_dispatch, Types)
    if (!dcast)
    {
        //%convert
        
        SWIG_NewPointerObj(L, $1, $descriptor, $owner);
        SWIG_arg++;
    }
}%enddef


%newobject CameraEntity::create;
%delobject CameraEntity::destroy;
%factory(BaseCamera *CameraEntity::create, CameraEntity, CameraSteeringEntity, CameraPhysicsEntity);
%convert(BaseCamera *CameraEntity::get, CameraEntity, CameraSteeringEntity, CameraPhysicsEntity);



%newobject BaseEntity::create;
%delobject BaseEntity::destroy;
%factory(BaseEntity *BaseEntity::create, SteeringEntity, RigidEntity, GhostEntity, SoftEntity);
%convert(BaseEntity *BaseEntity::get, SteeringEntity, RigidEntity, GhostEntity, SoftEntity);


%convert(BaseCollisionResponseBehavior *BaseEntity::getCollisionResponseBehavior(), LuaCollisionResponseBehavior);
%convert(const BaseCollisionResponseBehavior *BaseEntity::getCollisionResponseBehavior(), LuaCollisionResponseBehavior);

//%convert(BaseUpdateBehavior *BaseEntity::getUpdateBehavior(), LuaUpdateBehavior);
//%convert(const BaseUpdateBehavior *BaseEntity::getUpdateBehavior(), LuaUpdateBehavior);





%newobject BaseCollisionResponseBehavior::create;
%delobject BaseCollisionResponseBehavior::destroy;
%factory(BaseCollisionResponseBehavior *BaseCollisionResponseBehavior::create, LuaCollisionResponseBehavior);
%convert(BaseCollisionResponseBehavior *BaseCollisionResponseBehavior::get, LuaCollisionResponseBehavior);

//%newobject BaseUpdateBehavior::create;
//%delobject BaseUpdateBehavior::destroy;
//%factory(BaseUpdateBehavior *BaseUpdateBehavior::create, LuaUpdateBehavior);
//%convert(BaseUpdateBehavior *BaseUpdateBehavior::get, LuaUpdateBehavior);


%newobject EntityStateMachine::create;
%delobject EntityStateMachine::destroy;
//%factory(EntityStateMachine *EntityStateMachine::create);
//%convert(EntityStateMachine *EntityStateMachine::get);


%newobject BaseEntityState::create;
%delobject BaseEntityState::destroy;
%factory(BaseEntityState *BaseEntityState::create, LuaEntityState);
%convert(BaseEntityState *BaseEntityState::get, LuaEntityState);


//%template(LuaCameraEntity) AbstractLuaFactoryObject< CameraEntity, CameraFactory>;
//%template(LuaBaseEntity) AbstractLuaFactoryObject< BaseEntity, EntityFactory>;
//%template(LuaBaseCollisionResponseBehavior) AbstractLuaFactoryObject< BaseCollisionResponseBehavior, CollisionResponseBehaviorFactory>;


//
%newobject BaseEntitySteeringBehavior::create;
%delobject BaseEntitySteeringBehavior::destroy;
%factory(BaseEntitySteeringBehavior *BaseEntitySteeringBehavior::create, WeightedSteeringBehavior);
%convert(BaseEntitySteeringBehavior *BaseEntitySteeringBehavior::get, WeightedSteeringBehavior);
#include "JLIEngineCommon.h"

%extend BaseEntity
{
    const char *__str__()
    {
        static char tmp[1024];
        sprintf(tmp,"BaseEntity %d", self->getID());
        return tmp;
    }
};

%extend RigidEntity
{
    const char *__str__()
    {
        static char tmp[1024];
        sprintf(tmp,"RigidEntity %d", self->getID());
        return tmp;
    }
};

%extend SteeringEntity
{
    const char *__str__()
    {
        static char tmp[1024];
        sprintf(tmp,"SteeringEntity %d", self->getID());
        return tmp;
    }
};

%extend GhostEntity
{
    const char *__str__()
    {
        static char tmp[1024];
        sprintf(tmp,"GhostEntity %d", self->getID());
        return tmp;
    }
};

%extend SoftEntity
{
    const char *__str__()
    {
        static char tmp[1024];
        sprintf(tmp,"SoftEntity %d", self->getID());
        return tmp;
    }
};











%extend DeviceTouch
{
    const char *__str__()
    {
        std::string s(*self);
        static char tmp[1024];
        sprintf(tmp,"%s", s.c_str());
        return tmp;
    }
};
%extend DeviceTapGesture
{
    const char *__str__()
    {
        std::string s(*self);
        static char tmp[1024];
        sprintf(tmp,"%s", s.c_str());
        return tmp;
    }
};
%extend DevicePinchGesture
{
    const char *__str__()
    {
        std::string s(*self);
        static char tmp[1024];
        sprintf(tmp,"%s", s.c_str());
        return tmp;
    }
};
%extend DevicePanGesture
{
    const char *__str__()
    {
        std::string s(*self);
        static char tmp[1024];
        sprintf(tmp,"%s", s.c_str());
        return tmp;
    }
};
%extend DeviceSwipeGesture
{
    const char *__str__()
    {
        std::string s(*self);
        static char tmp[1024];
        sprintf(tmp,"%s", s.c_str());
        return tmp;
    }
};
%extend DeviceRotationGesture
{
    const char *__str__()
    {
        std::string s(*self);
        static char tmp[1024];
        sprintf(tmp,"%s", s.c_str());
        return tmp;
    }
};
%extend DeviceLongPressGesture
{
    const char *__str__()
    {
        std::string s(*self);
        static char tmp[1024];
        sprintf(tmp,"%s", s.c_str());
        return tmp;
    }
};
%extend DeviceAccelerometer
{
    const char *__str__()
    {
        std::string s(*self);
        static char tmp[1024];
        sprintf(tmp,"%s", s.c_str());
        return tmp;
    }
};
%extend DeviceMotion
{
    const char *__str__()
    {
        std::string s(*self);
        static char tmp[1024];
        sprintf(tmp,"%s", s.c_str());
        return tmp;
    }
};
%extend DeviceGyro
{
    const char *__str__()
    {
        std::string s(*self);
        static char tmp[1024];
        sprintf(tmp,"%s", s.c_str());
        return tmp;
    }
};
%extend DeviceMagnetometer
{
    const char *__str__()
    {
        std::string s(*self);
        static char tmp[1024];
        sprintf(tmp,"%s", s.c_str());
        return tmp;
    }
};

%extend BaseCollisionResponseBehavior
{
    const char *__str__()
    {
        static char tmp[1024];
        sprintf(tmp,"%s", "BaseCollisionResponseBehavior");
        return tmp;
    }
}

%extend LuaCollisionResponseBehavior
{
    const char *__str__()
    {
        static char tmp[1024];
        sprintf(tmp,"%s", "LuaCollisionResponseBehavior");
        return tmp;
    }
}

%typemap(memberin) TextViewObjectStruct [ANY] {
    int i;
    for (i = 0; i < $1_dim0; i++) {
        $1[i] = $input[i];
    }
}


extern char *BUNDLE_PATH;

//
//%module jli
//%{
//#include "JLIEngineCommon.h"
//    %}
//
//#include "JLIEngineCommon.h"
//
//%ignore DeviceTapGesture::DeviceTapGesture(UITapGestureRecognizer *sender);
//%ignore DevicePinchGesture::DevicePinchGesture(UIPinchGestureRecognizer *sender);
//%ignore DevicePanGesture::DevicePanGesture(UIPanGestureRecognizer *sender);
//%ignore DeviceSwipeGesture::DeviceSwipeGesture(UISwipeGestureRecognizer *sender);
//%ignore DeviceRotationGesture::DeviceRotationGesture(UIRotationGestureRecognizer *sender);
//%ignore DeviceLongPressGesture::DeviceLongPressGesture(UILongPressGestureRecognizer *sender);
//%ignore DeviceAccelerometer::DeviceAccelerometer(CMAccelerometerData *data);
//%ignore DeviceAttitude::DeviceAttitude(CMAttitude *attitude);
//%ignore DeviceMotion::DeviceMotion(CMDeviceMotion *data);
//%ignore DeviceGyro::DeviceGyro(CMGyroData *data);
//%ignore DeviceMagnetometer::DeviceMagnetometer(CMMagnetometerData *data);
//%ignore DeviceTouch::DeviceTouch(UITouch *touch, int n, int N);
//
//%{
//    typedef char s8;
//    typedef unsigned char u8;
//    typedef short s16;
//    typedef unsigned short u16;
//    typedef int s32;
//    typedef unsigned int u32;
//    typedef signed long long s64;
//    typedef unsigned long long u64;
//    
//    typedef SteeringEntity::WallAvoidanceFunction WallAvoidanceFunction;
//    
//    //typedef btDbvtNode::ICollide ICollide;
//    %}
//
//%typemap(memberin) TextViewObjectStruct [ANY] {
//    int i;
//    for (i = 0; i < $1_dim0; i++) {
//        $1[i] = $input[i];
//    }
//}
//
////All c++ classes should be recreated as c# classes including polymorphism
//%feature("director");
//
//%import "control/lua/interfaces/AbstractSingleton.i"
//%import "control/lua/interfaces/AbstractFactory.i"
//%import "control/lua/interfaces/AbstractBehavior.i"
//%import "control/lua/interfaces/AbstractState.i"
//%import "control/lua/interfaces/AbstractStateMachine.i"
//%import "control/lua/interfaces/baseentity.i"
//
//
//%template(FrameCounter_Singleton) AbstractFactory<FrameCounter, TimerInfo, BaseTimer>;
//
//%template(EntityFactory_Factory) AbstractFactory<EntityFactory, BaseEntityInfo, BaseEntity>;
//%template(AnimationControllerFactory_Factory) AbstractFactory<AnimationControllerFactory, AnimationControllerInfo, BaseEntityAnimationController>;
//%template(CameraFactory_Factory) AbstractFactory<CameraFactory, BaseCameraInfo, BaseCamera>;
//%template(CollisionFilterBehaviorFactory_Factory) AbstractFactory<CollisionFilterBehaviorFactory, CollisionFilterBehaviorInfo, BaseCollisionFilterBehavior>;
//%template(CollisionResponseBehaviorFactory_Factory) AbstractFactory<CollisionResponseBehaviorFactory, BaseCollisionResponseBehaviorInfo, BaseCollisionResponseBehavior>;
//%template(CollisionShapeFactory_Factory) AbstractFactory<CollisionShapeFactory, CollisionShapeInfo, btCollisionShapeWrapper>;
//%template(EntityStateMachineFactory_Factory) AbstractFactory<EntityStateMachineFactory, EntityStateMachineInfo, EntityStateMachine>;
//%template(ParticleEmitterBehaviorFactory_Factory) AbstractFactory<ParticleEmitterBehaviorFactory, ParticleEmitterBehaviorInfo, BaseParticleEmitterBehavior>;
//%template(ShaderFactory_Factory) AbstractFactory<ShaderFactory, ShaderFactoryKey, ShaderProgramHandleWrapper>;
//%template(SteeringBehaviorFactory_Factory) AbstractFactory<SteeringBehaviorFactory, SteeringBehaviorInfo, BaseEntitySteeringBehavior>;
//%template(TextureBehaviorFactory_Factory) AbstractFactory<TextureBehaviorFactory, TextureBehaviorInfo, BaseTextureBehavior>;
////%template(TextureFactorySingleton_Factory) AbstractFactory<TextureFactory, TextureFactoryInfo, GLKTextureInfoWrapper>;
//%template(TextViewObjectFactory_Factory) AbstractFactory<TextViewObjectFactory, BaseTextViewInfo, BaseTextViewObject>;
//%template(UpdateBehaviorFactory_Factory) AbstractFactory<UpdateBehaviorFactory, UpdateBehaviorInfo, BaseUpdateBehavior>;
////%template(ViewObjectFactory_Factory) AbstractFactory<ViewObjectFactory, BaseViewObjectInfo, BaseViewObject>;
//
////%template(EntityStateMachine_StateMachine) AbstractStateMachine<BaseEntity>;
//%template(BaseGameState_State) AbstractState<void>;
//%template(State_State) AbstractState<BaseEntity>;
//
//%template(BaseCollisionFilterBehavior_Behavior) AbstractBehavior<BaseEntity>;
//%template(BaseCollisionResponseBehavior_Behavior) AbstractBehavior<BaseEntity>;
//%template(BaseEntityAnimationController_Behavior) AbstractBehavior<BaseEntity>;
//%template(BaseEntitySteeringBehavior_Behavior) AbstractBehavior<SteeringEntity>;
//%template(BaseParticleEmitterBehavior_Behavior) AbstractBehavior<BaseEntity>;
//%template(BaseTextureBehavior_Behavior) AbstractBehavior<BaseViewObject>;
//%template(BaseUpdateBehavior_Behavior) AbstractBehavior<BaseEntity>;
//
//
//%template(MazeCreator_Singleton) AbstractSingleton<MazeCreator>;
////%template(PlayerInput_Singleton) AbstractSingleton<PlayerInput>;
//%template(MessageDispatcher_Singleton) AbstractSingleton<MessageDispatcher>;
//%template(LuaVM_Singleton) AbstractSingleton<LuaVM>;
//%template(GLDebugDrawer_Singleton) AbstractSingleton<GLDebugDrawer>;
//
//
//
//
//class WallAvoidanceFunction
//{
//public:
//    WallAvoidanceFunction() :
//    m_From(),
//    m_To(),
//    m_DistToClosestIP(std::numeric_limits<btScalar>::max()),
//    m_ClosestWall(NULL),
//    m_ClosestPoint(std::numeric_limits<btScalar>::max(),
//                   std::numeric_limits<btScalar>::max(),
//                   std::numeric_limits<btScalar>::max())
//    {
//    }
//    ~WallAvoidanceFunction()
//    {
//    }
//    
//    void SetFrom(const btVector3 &from)
//    {
//        m_From = from;
//    }
//    void SetTo(const btVector3 &to)
//    {
//        m_To = to;
//    }
//    void Set(const btVector3 &from, const btVector3 &to)
//    {
//        SetFrom(from);
//        SetTo(to);
//    }
//    
//    void operator() (BaseEntity *plane)
//    {
//        //	btVector3 point;
//        //
//        //	if(planeLineIntersection(plane->getOrigin(), plane->getNormalVector(), m_From, m_To, &point))
//        //	{
//        //		btScalar DistToThisIP = m_From.distance(point);
//        //
//        //		if (DistToThisIP < m_DistToClosestIP)
//        //		{
//        //			m_DistToClosestIP = DistToThisIP;
//        //
//        //			m_ClosestWall = plane;
//        //
//        //			m_ClosestPoint = point;
//        //		}
//        //	}
//    }
//    
//    btVector3 GetClosestPoint()
//    {
//        return m_ClosestPoint;
//    }
//    const BaseEntity *GetClosestWall()
//    {
//        return m_ClosestWall;
//    }
//    
//private:
//    btVector3 m_From;
//    btVector3 m_To;
//    btScalar m_DistToClosestIP;
//    BaseEntity *m_ClosestWall;
//    btVector3 m_ClosestPoint;
//};
