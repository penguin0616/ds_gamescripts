   combine_colour_cubes      POST_PARAMS                            SAMPLER    +         ndc.vs?   attribute vec3 POSITION;
attribute vec2 TEXCOORD0;

varying vec2 PS_TEXCOORD;

void main()
{
	gl_Position = vec4( POSITION.xyz, 1.0 );
	PS_TEXCOORD.xy = TEXCOORD0.xy;
}

    combine_colour_cubes.ps	  #if defined( GL_ES )
precision highp float;
#endif

uniform vec3 POST_PARAMS;
#define CC_LERP				POST_PARAMS.y
#define CC_LERP2			POST_PARAMS.z

uniform sampler2D SAMPLER[4];

#define COLOUR_CUBE_SRC		SAMPLER[0]
#define COLOUR_CUBE_DEST	SAMPLER[1]
#define COLOUR_CUBE_SRC2	SAMPLER[2]
#define COLOUR_CUBE_DEST2	SAMPLER[3]

varying vec2 PS_TEXCOORD;

#define CUBE_DIMENSION 32.0
#define CUBE_WIDTH ( CUBE_DIMENSION * CUBE_DIMENSION )
#define CUBE_HEIGHT ( CUBE_DIMENSION )

void main()
{
    // 0:1 - uv space
	vec2 base_cc_uv = PS_TEXCOORD.xy;

	vec3 cc_src = texture2D( COLOUR_CUBE_SRC, base_cc_uv.xy ).rgb;
	vec3 cc_dest = texture2D( COLOUR_CUBE_DEST, base_cc_uv.xy ).rgb;

	vec3 insane_cc_src = texture2D( COLOUR_CUBE_SRC2, base_cc_uv.xy ).rgb;
	vec3 insane_cc_dest = texture2D( COLOUR_CUBE_DEST2, base_cc_uv.xy ).rgb;

	cc_src = mix( cc_src, insane_cc_src, CC_LERP2 );
	cc_dest = mix( cc_dest, insane_cc_dest, CC_LERP2 );

    gl_FragColor = vec4( mix( cc_src, cc_dest, CC_LERP ), 1.0 );
}

               