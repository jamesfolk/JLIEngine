//
//  TextureShader.fsh
//  created with Shaderific
//

uniform sampler2D texture0;
uniform samplerCube textureCube0;

varying mediump vec4 DestinationColor;
varying highp vec2 FragmentTexCoordColor;
varying mediump vec3 ReflectDir;

uniform bool enableTexture0;
uniform bool enableVertexColor;

uniform mediump mat4 pointCoordMatrix;
uniform bool enablePointCoord;

uniform bool enableTextureCube0;

#extension GL_EXT_shader_framebuffer_fetch : require

void main(void)
{
    highp vec4 color = vec4(1.0, 1.0, 1.0, 1.0);
    
    if(enableTexture0)
    {
        if(enablePointCoord)
        {
            highp vec4 tc = pointCoordMatrix * vec4(gl_PointCoord, 1, 1);
            
            color *= texture2D( texture0, tc.xy );
        }
        else
        {
            if(enableTextureCube0)
            {
                color *= texture2D(texture0, FragmentTexCoordColor );
            }
            else
            {
                color *= texture2D(texture0, FragmentTexCoordColor );
            }
        }
    }
    
    if(enableVertexColor)
    {
        color *= DestinationColor;
    }
    
    gl_FragColor = color;
    
//    if (gl_FragColor.a == 0.0)
    // alpha value less than user-specified threshold?
//    {
        //discard; // yes: discard this fragment
//    }
}