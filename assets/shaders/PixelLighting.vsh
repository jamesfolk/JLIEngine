//a basic vertex shader.

attribute vec3 position;
attribute vec4 sourceColor;
//attribute vec4 normal;
attribute mat4 transformmatrix;
attribute mediump vec2 textureCoord0;
//attribute mediump vec2 textureCoord1;
//attribute mediump vec2 textureCoord2;
//attribute mediump vec2 textureCoord3;
//attribute mediump vec2 textureCoord4;
//attribute mediump vec2 textureCoord5;
//attribute mediump vec2 textureCoord6;
//attribute mediump vec2 textureCoord7;

uniform mediump mat4 modelViewMatrix;
uniform mediump mat4 projectionMatrix;

varying vec4 destinationColor;
varying vec2 texCoordOut0;

void main(void)
{
    destinationColor = sourceColor;
    
    mat4 mvp = projectionMatrix * modelViewMatrix * transformmatrix;
    
    gl_Position = mvp * vec4(position, 1.0);
    
    texCoordOut0 = textureCoord0;
}
