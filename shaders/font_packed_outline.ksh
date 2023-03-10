   font_packed_outline      MatrixP                                                                                MatrixV                                                                                MatrixW                                                                                SAMPLER    +         font.vs}  #if defined(HLS)
#define mat4 float4x4
#define vec2 float2
#define vec3 float3
#define vec4 float4
#endif
uniform mat4 MatrixP;
uniform mat4 MatrixV;
uniform mat4 MatrixW;

attribute vec3 POSITION;
attribute vec4 DIFFUSE;
attribute vec2 TEXCOORD0;
attribute vec4 TEXCOORD1;

varying vec2 PS_TEXCOORD;
varying vec4 PS_COLOUR;
varying vec4 PS_TEXCOORD1;

void main()
{
	mat4 mtxPVW = MatrixP * MatrixV * MatrixW;

	gl_Position = mtxPVW * vec4( POSITION.xyz, 1.0 );

	PS_TEXCOORD.xy = TEXCOORD0.xy;
	PS_COLOUR = vec4( DIFFUSE.rgb * DIFFUSE.a, DIFFUSE.a ); // premultiplied alpha
	PS_TEXCOORD1 = TEXCOORD1;
}

    font_packed_outline.ps?  //#include "common.h"

#if defined( GL_ES )
precision mediump float;
#endif

uniform sampler2D SAMPLER[1];

varying vec2 PS_TEXCOORD;
varying vec4 PS_COLOUR;
varying vec4 PS_TEXCOORD1;

void main()
{
	vec4 pixel = texture2D( SAMPLER[0], PS_TEXCOORD );

	float val = dot(pixel, PS_TEXCOORD1);
	float glyph = val > 0.5 ? 2.0*val-1.0 : 0.0;
	pixel.rgb = vec3(glyph, glyph, glyph);
	pixel.a   = val > 0.5 ? 1.0 : 2.0*val;
	gl_FragColor = pixel * PS_COLOUR;
}

                    