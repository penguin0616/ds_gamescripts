	   debug_tri      MatrixP                                                                                MatrixV                                                                                MatrixW                                                                                SAMPLER    +         debug_tri.vs?  uniform mat4 MatrixP;
uniform mat4 MatrixV;
uniform mat4 MatrixW;

attribute vec3 POSITION;
attribute vec4 DIFFUSE;
attribute vec2 TEXCOORD0;

varying vec2 PS_TEXCOORD;
varying vec4 PS_COLOUR;

void main()
{
	mat4 mtxPVW = MatrixP * MatrixV * MatrixW;

	gl_Position = mtxPVW * vec4( POSITION.xyz, 1.0 );

	PS_TEXCOORD = TEXCOORD0;
	PS_COLOUR.rgba = vec4( DIFFUSE.rgb * DIFFUSE.a, DIFFUSE.a ); // premultiplied alpha
}

    debug_tri.ps?   #if defined( GL_ES )
precision mediump float;
#endif

uniform sampler2D SAMPLER[1];

varying vec2 PS_TEXCOORD;
varying vec4 PS_COLOUR;

void main()
{
	gl_FragColor = PS_COLOUR * texture2D( SAMPLER[0], PS_TEXCOORD.xy );
}
                    