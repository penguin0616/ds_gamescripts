
   ui_anim_cc      MatrixP                                                                                MatrixV                                                                                MatrixW                                                                                SAMPLER    +      	   TINT_MULT                                IMAGE_PARAMS                                anim.vs_  #ifdef SKINNED
uniform mat4 pv;
uniform mat4 fastanim_xform;
uniform vec4 fastanim_bones[64];
#else
uniform mat4 MatrixP;
uniform mat4 MatrixV;
uniform mat4 MatrixW;
#endif

attribute vec3 POSITION;
attribute vec3 TEXCOORD0;

varying vec3 PS_TEXCOORD;
varying vec3 PS_POS;
varying vec3 PS_SPOS;

#if defined( FADE_OUT )
    uniform mat4 STATIC_WORLD_MATRIX;
    varying vec2 FADE_UV;
#endif

void main()
{
#ifdef SKINNED
	int matrix_index = int(POSITION.z + 0.5);
	float _a = fastanim_bones[matrix_index*2].x;
	float _b = fastanim_bones[matrix_index*2].y;
	float _c = fastanim_bones[matrix_index*2].z;
	float _d = fastanim_bones[matrix_index*2].w;
	float tx = fastanim_bones[matrix_index*2+1].x;
	float ty = fastanim_bones[matrix_index*2+1].y;

	mat4 matWorld = mat4(_a,_b, 0, 0,
						 _c,_d, 0, 0,
						 0, 0, 1, 0,
						 tx, ty, 0, 1); // Column-major!

	mat4 mat = fastanim_xform * matWorld;
	mat4 pvw = pv * mat;

	vec3 _aPosition = vec3(POSITION.x,POSITION.y,0.0);	
	gl_Position = pvw * vec4(_aPosition, 1.0); 

	vec4 world_pos = mat * vec4( _aPosition, 1.0 );

	PS_TEXCOORD = TEXCOORD0;
	PS_POS = world_pos.xyz;
	PS_SPOS = gl_Position.xyz;
#else
	mat4 mtxPVW = MatrixP * MatrixV * MatrixW;
	gl_Position = mtxPVW * vec4( POSITION.xyz, 1.0 );

	vec4 world_pos = MatrixW * vec4( POSITION.xyz, 1.0 );

	PS_TEXCOORD = TEXCOORD0;
	PS_POS = world_pos.xyz;
	PS_SPOS = gl_Position.xyz;
#endif

#if defined( FADE_OUT )
	vec4 static_world_pos = STATIC_WORLD_MATRIX * vec4( POSITION.xyz, 1.0 );
    vec3 forward = normalize( vec3( MatrixV[2][0], 0.0, MatrixV[2][2] ) );
    float d = dot( static_world_pos.xyz, forward );
    vec3 pos = static_world_pos.xyz + ( forward * -d );
    vec3 left = cross( forward, vec3( 0.0, 1.0, 0.0 ) );

    FADE_UV = vec2( dot( pos, left ) / 4.0, static_world_pos.y / 8.0 );
#endif
}

    ui_anim_cc.ps5
  #if defined( GL_ES )
precision mediump float;
#endif

uniform sampler2D SAMPLER[2];

varying vec3 PS_TEXCOORD;

uniform vec4 TINT_ADD;
uniform vec4 TINT_MULT;

uniform vec4 IMAGE_PARAMS;

#define COLOUR_CUBE      SAMPLER[1]

#define CUBE_DIMENSION 32.0
#define CUBE_WIDTH  ( CUBE_DIMENSION * CUBE_DIMENSION )
#define CUBE_HEIGHT ( CUBE_DIMENSION )

#define TEXEL_WIDTH   ( 1.0 / CUBE_WIDTH )
#define TEXEL_HEIGHT  ( 1.0 / CUBE_HEIGHT)
#define HALF_TEXEL_WIDTH  ( TEXEL_WIDTH  * 0.5 )
#define HALF_TEXEL_HEIGHT ( TEXEL_HEIGHT * 0.5 )

vec2 GetCCUV( vec3 colour )
{
    vec3 intermediate = colour.rgb * vec3( CUBE_DIMENSION - 1.0, CUBE_DIMENSION, CUBE_DIMENSION - 1.0 / CUBE_WIDTH ); // rgb all 0:31 - cube space
	vec2 uv = vec2( ( min( intermediate.r + 0.5, 31.0 ) + floor( intermediate.b ) * CUBE_DIMENSION ) / CUBE_WIDTH,
                          1.0 - ( min( intermediate.g, 31.0 ) / CUBE_HEIGHT ) );

	return uv;
}

vec3 texture2DBilinear( sampler2D textureSampler, vec2 uv )
{
    // in vertex shaders you should use texture2DLod instead of texture2D
    vec3 tl = texture2D(textureSampler, uv).rgb;
    vec3 tr = texture2D(textureSampler, uv + vec2(TEXEL_WIDTH,	0			)).rgb;
    vec3 bl = texture2D(textureSampler, uv + vec2(0,			TEXEL_HEIGHT)).rgb;
    vec3 br = texture2D(textureSampler, uv + vec2(TEXEL_WIDTH , TEXEL_HEIGHT)).rgb;
    vec2 f = fract( uv.xy * vec2(CUBE_WIDTH,CUBE_HEIGHT) ); // get the decimal part
    vec3 tA = mix( tl, tr, f.x ); // will interpolate the red dot in the image
    vec3 tB = mix( bl, br, f.x ); // will interpolate the blue dot in the image
    return mix( tA, tB, f.y ); // will interpolate the green dot in the image
}


void main()
{
    vec4 colour;
    
	if( PS_TEXCOORD.z < 1.5 )
	{
		if( PS_TEXCOORD.z < 0.5 )
		{
			colour.rgba = texture2D( SAMPLER[0], PS_TEXCOORD.xy );
		}
		else
		{
			colour.rgba = texture2D( SAMPLER[1], PS_TEXCOORD.xy );
		}
	}
	
//	gl_FragColor = vec4( colour.rgb * TINT_MULT.rgb * TINT_MULT.a, colour.a * TINT_MULT.a );
	colour.rgba *= IMAGE_PARAMS.rgba;
	// 0:1 - uv space
    	vec2 base_cc_uv = GetCCUV( colour.rgb );
	
    	//Manually apply bilinear filtering to the colour cube, to prevent anistropic "red outline" filtering bug
    	vec3 cc = texture2DBilinear( COLOUR_CUBE, base_cc_uv.xy - vec2(HALF_TEXEL_WIDTH, HALF_TEXEL_HEIGHT)).rgb;
    
    	//cc *= INTENSITY_MODIFIER;
	if (colour.a <= 0.01)
		discard;
	else
	{
		vec4 col = vec4( cc.rgb, colour.a );		
		gl_FragColor = vec4( col.rgb * TINT_MULT.rgb * TINT_MULT.a, col.a * TINT_MULT.a );
	}
}

                          