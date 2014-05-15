//a basic vertex shader.

//#undefine USING_SHADERIFIC

attribute vec3 position;
attribute vec4 color;
attribute vec3 normal;
attribute vec2 texture;
attribute mat4 transformMatrix;

uniform mediump mat4 projectionMatrix;
uniform mediump mat4 modelViewMatrix;
uniform mat3 normalMatrix;

varying vec4 destinationColor;
//varying vec2 texCoordOut0;

varying vec3 eyespaceNormal;
varying vec4 eyespacePosition;
varying vec3 objectspacePosition;


mat3 mat3_emu(mat4 m4) {
    return mat3(
                m4[0][0], m4[0][1], m4[0][2],
                m4[1][0], m4[1][1], m4[1][2],
                m4[2][0], m4[2][1], m4[2][2]);
}

void main(void)
{
    destinationColor = color;
//    texCoordOut0 = texture;
    
    mat3 _normalMatrix = mat3(transformMatrix);
    eyespaceNormal = _normalMatrix * normal;
    
//    eyespaceNormal = normalMatrix * normal;
    eyespacePosition = modelViewMatrix * vec4(position, 1.0);
    objectspacePosition = position.xyz;
    
    mat4 mvp = projectionMatrix * modelViewMatrix * transformMatrix;
    gl_Position = mvp * vec4(position, 1.0);
    
    
    
}
