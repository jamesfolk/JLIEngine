//
//  LuaVM.cpp
//  GameAsteroids
//
//  Created by James Folk on 8/12/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "LuaVM.h"
#include "FrameCounter.h"

#include "fmod.hpp"
#include "fmod_errors.h"

char *BUNDLE_PATH;

//#include "swigluarun.h"
//#include "bullet_swig.h"
//#include "jli_swig.h"

#include "jli_engine_swig.h"


void LuaVM::touchRespond(DeviceTouch *input){}
void LuaVM::tapGestureRespond(DeviceTapGesture input){}
void LuaVM::pinchGestureRespond(DevicePinchGesture *input){}
void LuaVM::panGestureRespond(DevicePanGesture *input){}
void LuaVM::swipeGestureRespond(DeviceSwipeGesture *input){}
void LuaVM::rotationGestureRespond(DeviceRotationGesture *input){}
void LuaVM::longPressGestureRespond(DeviceLongPressGesture *input){}
void LuaVM::accelerometerRespond(DeviceAccelerometer *input){}
void LuaVM::motionRespond(DeviceMotion *input){}
void LuaVM::gyroRespond(DeviceGyro *input){}
void LuaVM::magnetometerRespond(DeviceMagnetometer *input){}

//void LuaVM::scalar(const char *function, btScalar s)
//{
//    /* the function name */
//	lua_getglobal(m_lua_State, function);
//    
//	/* the first argument */
//	lua_pushnumber(m_lua_State, s);
//    
//	/* the second argument */
//	//lua_pushnumber(L, y);
//    
//	/* call the function with 2 arguments, return 1 result */
//	lua_call(m_lua_State, 1, 1);
//    
//	/* get the result */
//	//sum = (int)lua_tointeger(L, -1);
//	//lua_pop(m_lua_State, 1);
//}
static void printMethods(const char* name)
{
    //this touches the SWIG internals, please be careful:
    for (int i = 0; swig_types[i]; i++)
    {
        if (swig_types[i]->clientdata)
        {
            swig_lua_class* ptr=(swig_lua_class*)(swig_types[i]->clientdata);
            
            if (strcmp(name,ptr->name)==0)
            {
                for(int j=0;ptr->methods[j].name;j++)
                {
                    printf("%s::%s()\n",ptr->name,ptr->methods[j].name);
                }
            }
        }
    }
}

static void printWrappedClasses()
{
    //this touches the SWIG internals, please be careful:
    for (int i = 0; swig_types[i]; i++)
    {
        if (swig_types[i]->clientdata)
        {
            swig_lua_class* ptr=(swig_lua_class*)(swig_types[i]->clientdata);
            printMethods(ptr->name);
        }
    }
}


LuaVM::LuaVM() :
m_lua_State(NULL)
{
    std::string bundle([[[NSBundle mainBundle] pathForResource:@"main" ofType:@"lua"] UTF8String]);
    
    size_t marker = bundle.find_last_of("/");
    bundle = bundle.substr(0, marker).c_str();
    
    BUNDLE_PATH = new char[bundle.length() + 1];
    BUNDLE_PATH = strcpy(BUNDLE_PATH, bundle.c_str());
    
    printf("%s\n", BUNDLE_PATH);
    init();
}

LuaVM::~LuaVM()
{
    delete [] BUNDLE_PATH;
    unInit();
}

void LuaVM::init()
{
    NSLog(@"LUA_VENDOR: Lua.org" );
	NSLog(@"LUA_VERSION: %s", LUA_VERSION );
	NSLog(@"LUA_MODULE:" );
    
    
	m_lua_State = lua_open();
	luaL_Reg *lib = ( luaL_Reg * )luaL_openlibs( m_lua_State );
    
	while( lib->func )
	{
        if(strlen(lib->name))
        {
            NSLog(@"%s", lib->name);
        }
        else
        {
            NSLog(@"DEFAULT");
        }
		
		++lib;
	}

    luaopen_jli(m_lua_State);
    //luaopen_bullet(m_lua_State);
    //luaopen_jli(m_lua_State);
    NSLog(@"%s\n", SWIG_name );
    
    printWrappedClasses();
}

bool LuaVM::execute(const std::string &code)
{
    
//    int error_code = luaL_dostring( m_lua_State, code );
//
//    if( error_code )
//	{
//		getError(error_code);
//		return false;
//	}
//
//    return true;

    /* the function name */
	lua_getglobal(m_lua_State, code.c_str());

    int error_code = lua_pcall(m_lua_State, 0, 0, 0);
    if(error_code)
    {
        getError(error_code);
        return false;
    }
    
    return true;
}

bool LuaVM::execute(const std::string &code, btScalar _btScalar)
{
//    lua_getglobal(m_lua_State, code);
//    
//    lua_pushnumber(m_lua_State, _btScalar);
//    
//    int error_code = luaL_dostring( m_lua_State, code );
//    
//    if( error_code )
//	{
//		getError(error_code);
//		//return false;
//	}
//    
//    //return true;
    
    /* the function name */
	lua_getglobal(m_lua_State, code.c_str());
    
	/* the first argument */
	lua_pushnumber(m_lua_State, _btScalar);
    
	/* the second argument */
	//lua_pushnumber(L, y);
    
	/* call the function with 1 arguments, return 0 result */
	//lua_call(m_lua_State, 1, 0);
    int error_code = lua_pcall(m_lua_State, 1, 0, 0);
    if(error_code)
    {
        getError(error_code);
        return false;
    }
    
    return true;
    
	/* get the result */
	//sum = (int)lua_tointeger(L, -1);
	//lua_pop(m_lua_State, 1);
}

bool LuaVM::execute(const std::string &code, BaseEntity *pEntity, BaseEntity *pOtherEntity, const btManifoldPoint &_btManifoldPoint)
{
    /* the function name */
	lua_getglobal(m_lua_State, code.c_str());
    
    SWIG_NewPointerObj(m_lua_State,(void *) pEntity,SWIGTYPE_p_BaseEntity,0);
    SWIG_NewPointerObj(m_lua_State,(void *) pOtherEntity,SWIGTYPE_p_BaseEntity,0);
    SWIG_NewPointerObj(m_lua_State,(void *) &_btManifoldPoint,SWIGTYPE_p_btManifoldPoint,0);
    
    //lua_call(m_lua_State, 2, 0);
    int error_code = lua_pcall(m_lua_State, 3, 0, 0);
    if(error_code)
    {
        getError(error_code);
        return false;
    }
    
    return true;
}

bool LuaVM::execute(const std::string &code, const DeviceTouch &input)
{
    /* the function name */
	lua_getglobal(m_lua_State, code.c_str());
    
    SWIG_NewPointerObj(m_lua_State,(void *) &input,SWIGTYPE_p_DeviceTouch,0);
    
    //lua_call(m_lua_State, 1, 0);
    int error_code = lua_pcall(m_lua_State, 1, 0, 0);
    if(error_code)
    {
        getError(error_code);
        return false;
    }
    
    return true;
}
bool LuaVM::execute(const std::string &code, const DeviceTapGesture &input)
{
    /* the function name */
	lua_getglobal(m_lua_State, code.c_str());
    
    SWIG_NewPointerObj(m_lua_State,(void *) &input,SWIGTYPE_p_DeviceTapGesture,0);
    
    //lua_call(m_lua_State, 1, 0);
    int error_code = lua_pcall(m_lua_State, 1, 0, 0);
    if(error_code)
    {
        getError(error_code);
        return false;
    }
    
    return true;
}
bool LuaVM::execute(const std::string &code, const DevicePinchGesture &input)
{
    /* the function name */
	lua_getglobal(m_lua_State, code.c_str());
    
    SWIG_NewPointerObj(m_lua_State,(void *) &input,SWIGTYPE_p_DevicePinchGesture,0);
    
    //lua_call(m_lua_State, 1, 0);
    int error_code = lua_pcall(m_lua_State, 1, 0, 0);
    if(error_code)
    {
        getError(error_code);
        return false;
    }
    
    return true;
}
bool LuaVM::execute(const std::string &code, const DevicePanGesture &input)
{
    /* the function name */
	lua_getglobal(m_lua_State, code.c_str());
    
    SWIG_NewPointerObj(m_lua_State,(void *) &input,SWIGTYPE_p_DevicePanGesture,0);
    
    //lua_call(m_lua_State, 1, 0);
    int error_code = lua_pcall(m_lua_State, 1, 0, 0);
    if(error_code)
    {
        getError(error_code);
        return false;
    }
    
    return true;
}
bool LuaVM::execute(const std::string &code, const DeviceSwipeGesture &input)
{
    /* the function name */
	lua_getglobal(m_lua_State, code.c_str());
    
    SWIG_NewPointerObj(m_lua_State,(void *) &input,SWIGTYPE_p_DeviceSwipeGesture,0);
    
    //lua_call(m_lua_State, 1, 0);
    int error_code = lua_pcall(m_lua_State, 1, 0, 0);
    if(error_code)
    {
        getError(error_code);
        return false;
    }
    
    return true;
}
bool LuaVM::execute(const std::string &code, const DeviceRotationGesture &input)
{
    /* the function name */
	lua_getglobal(m_lua_State, code.c_str());
    
    SWIG_NewPointerObj(m_lua_State,(void *) &input,SWIGTYPE_p_DeviceRotationGesture,0);
    
    //lua_call(m_lua_State, 1, 0);
    int error_code = lua_pcall(m_lua_State, 1, 0, 0);
    if(error_code)
    {
        getError(error_code);
        return false;
    }
    
    return true;
}
bool LuaVM::execute(const std::string &code, const DeviceLongPressGesture &input)
{
    /* the function name */
	lua_getglobal(m_lua_State, code.c_str());
    
    SWIG_NewPointerObj(m_lua_State,(void *) &input,SWIGTYPE_p_DeviceLongPressGesture,0);
    
    //lua_call(m_lua_State, 1, 0);
    int error_code = lua_pcall(m_lua_State, 1, 0, 0);
    if(error_code)
    {
        getError(error_code);
        return false;
    }
    
    return true;
}
bool LuaVM::execute(const std::string &code, const DeviceAccelerometer &input)
{
    /* the function name */
	lua_getglobal(m_lua_State, code.c_str());
    
    SWIG_NewPointerObj(m_lua_State,(void *) &input,SWIGTYPE_p_DeviceAccelerometer,0);
    
    //lua_call(m_lua_State, 1, 0);
    int error_code = lua_pcall(m_lua_State, 1, 0, 0);
    if(error_code)
    {
        getError(error_code);
        return false;
    }
    
    return true;
}
bool LuaVM::execute(const std::string &code, const DeviceMotion &input)
{
    /* the function name */
	lua_getglobal(m_lua_State, code.c_str());
    
    SWIG_NewPointerObj(m_lua_State,(void *) &input,SWIGTYPE_p_DeviceMotion,0);
    
    //lua_call(m_lua_State, 1, 0);
    int error_code = lua_pcall(m_lua_State, 1, 0, 0);
    if(error_code)
    {
        getError(error_code);
        return false;
    }
    
    return true;
}
bool LuaVM::execute(const std::string &code, const DeviceGyro &input)
{
    /* the function name */
	lua_getglobal(m_lua_State, code.c_str());
    
    SWIG_NewPointerObj(m_lua_State,(void *) &input,SWIGTYPE_p_DeviceGyro,0);
    
    //lua_call(m_lua_State, 1, 0);
    int error_code = lua_pcall(m_lua_State, 1, 0, 0);
    if(error_code)
    {
        getError(error_code);
        return false;
    }
    
    return true;
}
bool LuaVM::execute(const std::string &code, const DeviceMagnetometer &input)
{
    /* the function name */
	lua_getglobal(m_lua_State, code.c_str());
    
    SWIG_NewPointerObj(m_lua_State,(void *) &input,SWIGTYPE_p_DeviceMagnetometer,0);
    
    //lua_call(m_lua_State, 1, 0);
    int error_code = lua_pcall(m_lua_State, 1, 0, 0);
    if(error_code)
    {
        getError(error_code);
        return false;
    }
    
    return true;
}

bool LuaVM::execute(const std::string &code, BaseEntity *pEntity, btCollisionWorld* _btCollisionWorld, btScalar _btScalar)
{
    /* the function name */
	lua_getglobal(m_lua_State, code.c_str());
    
    SWIG_NewPointerObj(m_lua_State,(void *) pEntity,SWIGTYPE_p_BaseEntity,0);
    SWIG_NewPointerObj(m_lua_State,(void *) _btCollisionWorld,SWIGTYPE_p_btCollisionWorld,0);
    lua_pushnumber(m_lua_State, _btScalar);
    
    //lua_call(m_lua_State, 2, 0);
    int error_code = lua_pcall(m_lua_State, 3, 0, 0);
    if(error_code)
    {
        getError(error_code);
        return false;
    }
    
    return true;
}

bool LuaVM::execute(const std::string &code, BaseEntity *pEntity)
{
    /* the function name */
	lua_getglobal(m_lua_State, code.c_str());
    
    SWIG_NewPointerObj(m_lua_State,(void *) pEntity,SWIGTYPE_p_BaseEntity,0);
    
    //lua_call(m_lua_State, 2, 0);
    int error_code = lua_pcall(m_lua_State, 1, 0, 0);
    if(error_code)
    {
        getError(error_code);
        return false;
    }
    
    return true;
}

bool LuaVM::execute(const std::string &code, BaseEntity *pEntity, btScalar _btScalar)
{
    /* the function name */
	lua_getglobal(m_lua_State, code.c_str());
    
    SWIG_NewPointerObj(m_lua_State,(void *) pEntity,SWIGTYPE_p_BaseEntity,0);
    lua_pushnumber(m_lua_State, _btScalar);
    
    //lua_call(m_lua_State, 2, 0);
    int error_code = lua_pcall(m_lua_State, 2, 0, 0);
    if(error_code)
    {
        getError(error_code);
        return false;
    }
    
    return true;
}

bool LuaVM::execute(const std::string &code, BaseEntity *pEntity, const Telegram &telegram, bool &returnValue)
{
    /* the function name */
	lua_getglobal(m_lua_State, code.c_str());
    
    SWIG_NewPointerObj(m_lua_State,(void *) pEntity,SWIGTYPE_p_BaseEntity,0);
    SWIG_NewPointerObj(m_lua_State,(void *) &telegram,SWIGTYPE_p_Telegram,0);
    
    //lua_call(m_lua_State, 2, 0);
    int error_code = lua_pcall(m_lua_State, 2, 0, 0);
    if(error_code)
    {
        getError(error_code);
        return false;
    }
    
    returnValue = lua_toboolean(m_lua_State, -1);
    lua_pop(m_lua_State, 1);
    
    return true;
}

bool LuaVM::execute(const std::string &code, const Telegram &telegram, bool &returnValue)
{
    
    /* the function name */
	lua_getglobal(m_lua_State, code.c_str());
    
    SWIG_NewPointerObj(m_lua_State,(void *) &telegram,SWIGTYPE_p_Telegram,0);
    
    //lua_call(m_lua_State, 2, 0);
    int error_code = lua_pcall(m_lua_State, 1, 0, 0);
    if(error_code)
    {
        getError(error_code);
        return false;
    }
    
    returnValue = lua_toboolean(m_lua_State, -1);
    lua_pop(m_lua_State, 1);
    
    return true;
}

void LuaVM::unInit()
{
    if( m_lua_State )
    {
        lua_close( m_lua_State );
        m_lua_State = NULL;
    }
}

void LuaVM::reset()
{
    unInit();
    init();
}

bool LuaVM::loadFile(const std::string &file)
{
    size_t marker = file.find_last_of(".");
    NSString *fileName = [NSString stringWithUTF8String:file.substr(0, marker).c_str()];
    NSString *extension = [NSString stringWithUTF8String:file.substr(marker + 1).c_str()];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:extension];
    
    NSError* error;
    NSString *shaderString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    return loadString(std::string([shaderString UTF8String]));
}

bool LuaVM::loadString(const std::string &str)
{
    int error_code = luaL_loadstring(m_lua_State,
                                     static_cast<const char *>(str.c_str()));
    
	if( error_code )
	{
		getError(error_code);
		return false;
	}
	
	return compile();
}

void LuaVM::getError(int error_code)
{
    NSLog(@"[ LuaVM ERROR %d: %s.",
          error_code,
          lua_tostring( m_lua_State, -1 ));
	
	lua_pop( m_lua_State, 1 );
}

bool LuaVM::compile()
{
    int error_code = lua_pcall( m_lua_State, 0, LUA_MULTRET, 0 );
    
	if( error_code )
	{
		getError(error_code);
		return false;
	}
	
	return true;
}