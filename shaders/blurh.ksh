   blurh      SAMPLER    +      
   PIXEL_SIZE                     ndc.vs?   attribute vec3 POSITION;
attribute vec2 TEXCOORD0;

varying vec2 PS_TEXCOORD;

void main()
{
	gl_Position = vec4( POSITION.xyz, 1.0 );
	PS_TEXCOORD.xy = TEXCOORD0.xy;
}

    blurh.ps-  #if defined( GL_ES )
precision mediump float;
#endif

uniform sampler2D SAMPLER[1];
uniform float PIXEL_SIZE; // 1 / IMAGE_WIDTH 

varying vec2 PS_TEXCOORD;

void main()
{
	vec4 sum = vec4( 0, 0, 0, 0 );

	sum += texture2D(SAMPLER[0], vec2(PS_TEXCOORD.x - 4.0 * PIXEL_SIZE,	PS_TEXCOORD.y)) * 0.05;
	sum += texture2D(SAMPLER[0], vec2(PS_TEXCOORD.x - 3.0 * PIXEL_SIZE,	PS_TEXCOORD.y)) * 0.09;
	sum += texture2D(SAMPLER[0], vec2(PS_TEXCOORD.x - 2.0 * PIXEL_SIZE,	PS_TEXCOORD.y)) * 0.12;
	sum += texture2D(SAMPLER[0], vec2(PS_TEXCOORD.x - PIXEL_SIZE,		PS_TEXCOORD.y)) * 0.15;
	sum += texture2D(SAMPLER[0], vec2(PS_TEXCOORD.x,					PS_TEXCOORD.y)) * 0.16;
	sum += texture2D(SAMPLER[0], vec2(PS_TEXCOORD.x + PIXEL_SIZE,		PS_TEXCOORD.y)) * 0.15;
	sum += texture2D(SAMPLER[0], vec2(PS_TEXCOORD.x + 2.0 * PIXEL_SIZE,	PS_TEXCOORD.y)) * 0.12;
	sum += texture2D(SAMPLER[0], vec2(PS_TEXCOORD.x + 3.0 * PIXEL_SIZE,	PS_TEXCOORD.y)) * 0.09;
	sum += texture2D(SAMPLER[0], vec2(PS_TEXCOORD.x + 4.0 * PIXEL_SIZE,	PS_TEXCOORD.y)) * 0.05;

	gl_FragColor = sum;
}

               