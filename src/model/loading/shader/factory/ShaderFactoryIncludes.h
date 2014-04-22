//
//  ShaderFactoryIncludes.h
//  GameAsteroids
//
//  Created by James Folk on 3/15/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef GameAsteroids_ShaderFactoryIncludes_h
#define GameAsteroids_ShaderFactoryIncludes_h

#include <string>

#include "AbstractFactory.h"
//#include "ShaderFactory.h"

//typedef std::pair<std::string, std::string> ShaderFactoryKey;
struct ShaderFactoryKey
{
    ShaderFactoryKey(const std::string &vertex_shader, const std::string &fragment_shader):
    vertexShader(vertex_shader),
    fragmentShader(fragment_shader)
    {
    }
    std::string vertexShader;
    std::string fragmentShader;
};

class ShaderProgramHandleWrapper :
public AbstractFactoryObject
{
    friend class ShaderFactory;
protected:
    ShaderProgramHandleWrapper():m_ShaderProgramHandle(GL_INVALID_VALUE){}
    virtual ~ShaderProgramHandleWrapper(){}
public:
    SIMD_FORCE_INLINE IDType getID()const
    {
        return AbstractFactoryObject::getID();
    }
    
    SIMD_FORCE_INLINE const std::string &getName()const
    {
        return AbstractFactoryObject::getName();
    }
    
    SIMD_FORCE_INLINE void setName(const std::string &name)
    {
        AbstractFactoryObject::setName(name);
    }
    
    
    //BT_DECLARE_ALIGNED_ALLOCATOR();
    
    GLuint m_ShaderProgramHandle;
};

#endif
