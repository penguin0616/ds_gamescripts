
   wall_bloom      MatrixP                                                                                MatrixV                                                                                MatrixW                                                                                wall_bloom.vs'  uniform mat4 MatrixP;
uniform mat4 MatrixV;
uniform mat4 MatrixW;

attribute vec3 POSITION;
attribute vec4 DIFFUSE;

varying vec4 PS_COLOUR;

void main()
{
	mat4 mtxPVW = MatrixP * MatrixV * MatrixW;
	gl_Position = mtxPVW * vec4( POSITION.xyz, 1.0 );

	PS_COLOUR = DIFFUSE;
}

    wall_bloom.ps?   #if defined( GL_ES )
precision mediump float;
#endif

varying vec4 PS_COLOUR;

void main()
{
    gl_FragColor.rgba = vec4( 0, 0, 0, PS_COLOUR.a );
}

                  