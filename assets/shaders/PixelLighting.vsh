//a basic vertex shader.

//#undefine USING_SHADERIFIC

attribute vec3 position;
attribute vec4 color;
attribute vec4 normal;
attribute mat4 transformMatrix;
attribute mediump vec2 texture;

#ifdef USING_SHADERIFIC

#else
uniform mediump mat4 projectionMatrix;
#endif

uniform mediump mat4 modelViewProjectionMatrix;
uniform mediump mat4 modelViewMatrix;

varying vec4 destinationColor;
varying vec2 texCoordOut0;

void main(void)
{
    destinationColor = color;
    texCoordOut0 = texture;
    
#ifdef USING_SHADERIFIC
    gl_Position = modelViewProjectionMatrix * vec4(position, 1.0);
#else
    mat4 mvp = projectionMatrix * modelViewMatrix * transformMatrix;
    gl_Position = mvp * vec4(position, 1.0);
#endif
    
    
    
}
