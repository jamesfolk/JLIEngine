uniform sampler2D texture0;

varying lowp vec4 destinationColor;
varying lowp vec2 texCoordOut0;

void main(void)
{
    gl_FragColor = destinationColor * texture2D(texture0, texCoordOut0);
}
