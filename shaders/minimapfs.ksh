	   minimapfs      MatrixP                                                                                MatrixV                                                                                MatrixW                                                                                SAMPLER    +         PosUV.vs3  uniform mat4 MatrixP;
uniform mat4 MatrixV;
uniform mat4 MatrixW;

attribute vec3 POSITION;
attribute vec2 TEXCOORD0;

varying vec2 PS_TEXCOORD;

void main()
{
	mat4 mtxPVW = MatrixP * MatrixV * MatrixW;
	gl_Position = mtxPVW * vec4( POSITION.xyz, 1.0 );
	PS_TEXCOORD.xy = TEXCOORD0.xy;
}

    tex.ps?   #if defined( GL_ES )
precision mediump float;
#endif

uniform sampler2D SAMPLER[1];
varying vec2 PS_TEXCOORD;

void main()
{
    gl_FragColor.rgba = texture2D( SAMPLER[0], PS_TEXCOORD.xy );
}

                    