   texture   	   MatrixPVW                                                                                MatrixW                                                                                SAMPLER    +         LIGHTMAP_WORLD_EXTENTS                                TINT_ADD                             	   TINT_MULT                                PosUV_WorldPos.vs_  uniform mat4 MatrixPVW;
uniform mat4 MatrixW;

attribute vec3 POSITION;
attribute vec2 TEXCOORD0;

varying vec2 PS_TEXCOORD;
varying vec3 PS_POS;

void main()
{
	gl_Position = MatrixPVW * vec4( POSITION.xyz, 1.0 );
	PS_TEXCOORD.xy = TEXCOORD0;

	vec4 world_pos = MatrixW * vec4( POSITION.xyz, 1.0 );
	PS_POS.xyz = world_pos.xyz;
}

 	   TexLit.ps:  #if defined( GL_ES )
precision mediump float;
#endif

uniform sampler2D SAMPLER[4];
#ifndef LIGHTING_H
#define LIGHTING_H

// Lighting
varying vec3 PS_POS;

// xy = min, zw = max
uniform vec4 LIGHTMAP_WORLD_EXTENTS;

#define LIGHTMAP_TEXTURE SAMPLER[3]

#ifndef LIGHTMAP_TEXTURE
	#error If you use lighting, you must #define the sampler that the lightmap belongs to
#endif

vec3 CalculateLightingContribution()
{
	vec2 uv = ( PS_POS.xz - LIGHTMAP_WORLD_EXTENTS.xy ) * LIGHTMAP_WORLD_EXTENTS.zw;

	vec3 colour = texture2D( LIGHTMAP_TEXTURE, uv.xy ).rgb;

	return clamp( colour.rgb, vec3( 0, 0, 0 ), vec3( 1, 1, 1 ) );
}

vec3 CalculateLightingContribution( vec3 normal )
{
	return vec3( 1, 1, 1 );
}

#endif //LIGHTING.h


uniform vec4 TINT_ADD;
uniform vec4 TINT_MULT;

varying vec2 PS_TEXCOORD;

// Already defined by lighting.h
// varying vec3 PS_POS

void main()
{
	vec4 base_colour = texture2D( SAMPLER[0], PS_TEXCOORD.xy );
    gl_FragColor.rgba = base_colour;

	gl_FragColor.rgb *= (TINT_MULT.rgb * TINT_MULT.a);
	gl_FragColor.a *= TINT_MULT.a;
	gl_FragColor.rgb += (TINT_ADD.rgb * base_colour.a * TINT_ADD.a);
	gl_FragColor.rgb = clamp(gl_FragColor.rgb, 0.0, 1.0);		// or the light override may bring back detail!

	gl_FragColor.rgb *= CalculateLightingContribution();
}

                          