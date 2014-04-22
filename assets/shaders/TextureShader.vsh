//
//  TextureShader.vsh
//  created with Shaderific
//

uniform mediump mat4 modelViewMatrix;
uniform mediump mat4 projectionMatrix;
uniform mediump mat4 modelMatrix;

uniform vec3  eyePosition;


uniform mediump mat3 normalMatrix;
uniform mediump vec4 lightPosition;
uniform mediump mat4 textureMatrix;
uniform mediump float pointSize;
uniform bool enableNormal;
uniform bool enableTextureCube0;

attribute mat4 transformmatrix;
attribute mediump vec3 position;
attribute lowp vec3 normal;
attribute mediump vec2 textureCoord0;
attribute highp vec4 color;

varying mediump vec4 DestinationColor;
varying highp vec2 FragmentTexCoordColor;
varying mediump vec3 ReflectDir;

//uniform bool enableTexture0;
//uniform bool enableTexture1;
//uniform bool enableVertexColor;

void main(void)
{
    gl_PointSize = pointSize;
    
    DestinationColor = color;
    
    highp vec4 tc = textureMatrix * vec4(textureCoord0, 1, 1);
    FragmentTexCoordColor = tc.xy;
    
    mat4 _jim = transformmatrix;
    
    mat4 mvp = projectionMatrix * modelViewMatrix * modelMatrix;
    gl_Position = mvp * vec4(position, 1.0);
    
//    gl_Position = projectionMatrix * (modelViewMatrix * vec4(position, 1.0));
    
//    ReflectDir = (modelMatrix * vec4(position, 1.0)).xyz;
//    if(enableNormal)
//    {
//        // Compute eye direction in object space:
//        mediump vec3 eyeDir = normalize(position.xyz - eyePosition);
//
//        // Reflect eye direction over normal and transform to world space:
//        ReflectDir = (modelMatrix * vec4(reflect(eyeDir, normal), 1.0)).xyz;
//        //  ReflectDir = (modelMatrix * vec4(position, 1.0)).xyz;   // Keep this: it's a good way to test with unit sphere
//    }
}