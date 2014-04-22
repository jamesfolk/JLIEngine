attribute vec3 position;
attribute vec4 sourceColor;
//attribute vec4 normal;
attribute mat4 transformmatrix;
//attribute mediump vec2 textureCoord0;
//attribute mediump vec2 textureCoord1;
//attribute mediump vec2 textureCoord2;
//attribute mediump vec2 textureCoord3;
//attribute mediump vec2 textureCoord4;
//attribute mediump vec2 textureCoord5;
//attribute mediump vec2 textureCoord6;
//attribute mediump vec2 textureCoord7;

//uniform mat4 projection;
uniform mediump mat4 modelViewMatrix;
uniform mediump mat4 projectionMatrix;
//uniform mediump mat4 modelMatrix;

varying vec4 destinationColor;

void main(void)
{
    mat4 m = mat4(1.0);
    
    destinationColor = sourceColor;
    
    mat4 mvp = projectionMatrix * modelViewMatrix * transformmatrix;
    gl_Position = mvp * vec4(position, 1.0);
    
//    gl_Position = projection * modelview * position;
}