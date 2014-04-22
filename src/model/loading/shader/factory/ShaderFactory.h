//
//  ShaderFactory.h
//  GameAsteroids
//
//  Created by James Folk on 3/15/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#ifndef __GameAsteroids__ShaderFactory__
#define __GameAsteroids__ShaderFactory__

#include "AbstractFactory.h"
#include "ShaderFactoryIncludes.h"


//class ShaderFactory;

class ShaderFactory :
public AbstractFactory<ShaderFactory, ShaderFactoryKey, ShaderProgramHandleWrapper>
{
    friend class AbstractSingleton;
    
    static GLuint loadShader(ShaderFactoryKey *vertex_fragment_shaders);
    static bool validateProgram(GLuint programHandle);
    static bool linkProgram(GLuint programHandle);
    static bool compileShader(GLuint &shaderHandle, GLenum type, std::string file);
    
    ShaderFactory():m_CurrentShaderID(0){}
    virtual ~ShaderFactory(){}
public:
    IDType getCurrentShaderID()const
    {
        return m_CurrentShaderID;
    }
protected:
    virtual ShaderProgramHandleWrapper *ctor(ShaderFactoryKey *constructionInfo);
    virtual ShaderProgramHandleWrapper *ctor(int type = 0);
    virtual void dtor(ShaderProgramHandleWrapper *object);
    
private:
    IDType m_CurrentShaderID;
};

#endif /* defined(__GameAsteroids__ShaderFactory__) */
