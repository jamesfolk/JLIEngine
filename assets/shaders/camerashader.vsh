attribute vec4 position;
attribute vec2 textureCoord0;

varying vec2 texCoordVarying;

void main()
{
    gl_Position = position;
    texCoordVarying = textureCoord0;
}
