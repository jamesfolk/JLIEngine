//
//  ShaderFactory.cpp
//  GameAsteroids
//
//  Created by James Folk on 3/15/13.
//  Copyright (c) 2013 James Folk. All rights reserved.
//

#include "ShaderFactory.h"
#include "FileLoader.h"

GLuint ShaderFactory::loadShader(ShaderFactoryKey *vertex_fragment_shaders)
{
    GLuint vertShader, fragShader;
    // Create shader program.
    GLuint programHandle = glCreateProgram();
    // Create and compile vertex shader.
//    if(!compileShader(vertShader, GL_VERTEX_SHADER, vertex_fragment_shaders->first))
    if(!compileShader(vertShader, GL_VERTEX_SHADER, vertex_fragment_shaders->vertexShader))
    {
        NSLog(@"Failed to compile vertex shader");
        glDeleteProgram(programHandle);
        return -1;
    }
//    if(!compileShader(fragShader, GL_FRAGMENT_SHADER, vertex_fragment_shaders->second))
    if(!compileShader(fragShader, GL_FRAGMENT_SHADER, vertex_fragment_shaders->fragmentShader))
    {
        NSLog(@"Failed to compile vertex shader");
        glDeleteProgram(programHandle);
        return -1;
    }
    
    // Attach vertex shader to program.
    glAttachShader(programHandle, vertShader);
    // Attach fragment shader to program.
    glAttachShader(programHandle, fragShader);
    
    // Link program.
    if (!linkProgram(programHandle))
    {
        NSLog(@"Failed to link program: %d", programHandle);
        if (vertShader)
        {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader)
        {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (programHandle)
        {
            glDeleteProgram(programHandle);
            programHandle = 0;
        }
        return -1;
    }
    
    if (vertShader)
    {
        glDetachShader(programHandle, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader)
    {
        glDetachShader(programHandle, fragShader);
        glDeleteShader(fragShader);
    }
    
    return programHandle;
}
bool ShaderFactory::validateProgram(GLuint programHandle)
{
    GLint logLength, status;
    glValidateProgram(programHandle);
    glGetProgramiv(programHandle, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        //GLchar *log = (GLchar *)malloc(logLength);
        GLchar *log = new GLchar[logLength];
        glGetProgramInfoLog(programHandle, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        delete [] log;
        //free(log);
    }
    glGetProgramiv(programHandle, GL_VALIDATE_STATUS, &status);
    if (status == 0)
    {
        return NO;
    }
    return YES;
}
bool ShaderFactory::linkProgram(GLuint programHandle)
{
    GLint status;
    glLinkProgram(programHandle);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(programHandle, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        //GLchar *log = (GLchar *)malloc(logLength);
        GLchar *log = new GLchar[logLength];
        glGetProgramInfoLog(programHandle, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        delete [] log;
        //free(log);
    }
#endif
    
    glGetProgramiv(programHandle, GL_LINK_STATUS, &status);
    
    if (status == 0)
    {
        return false;
    }
    return true;
}
bool ShaderFactory::compileShader(GLuint &shaderHandle, GLenum type, std::string file)
{
    GLint status;
    const GLchar *source = FileLoader::getInstance()->getFileContents(file).c_str();
    
    shaderHandle = glCreateShader(type);
    glShaderSource(shaderHandle, 1, &source, NULL);
    glCompileShader(shaderHandle);

#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(shaderHandle, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        //GLchar *log = (GLchar *)malloc(logLength);
        GLchar *log = new GLchar[logLength];
        glGetShaderInfoLog(shaderHandle, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        //free(log);
        delete [] log;
    }
#endif

    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &status);
    if (status == 0)
    {
        glDeleteShader(shaderHandle);
        return false;
    }

    return true;
}

ShaderProgramHandleWrapper *ShaderFactory::ctor(ShaderFactoryKey *constructionInfo)
{
    ShaderProgramHandleWrapper *shaderHandle = new ShaderProgramHandleWrapper();
    shaderHandle->m_ShaderProgramHandle = loadShader(constructionInfo);
    
    m_CurrentShaderID = shaderHandle->m_ShaderProgramHandle;
    glUseProgram(ShaderFactory::getInstance()->getCurrentShaderID());
    return shaderHandle;
}

ShaderProgramHandleWrapper *ShaderFactory::ctor(int type)
{
    return NULL;
}

void ShaderFactory::dtor(ShaderProgramHandleWrapper *object)
{
    if(object->m_ShaderProgramHandle == m_CurrentShaderID)
        m_CurrentShaderID = 0;
    
    glDeleteProgram(object->m_ShaderProgramHandle);
    delete object;
}
