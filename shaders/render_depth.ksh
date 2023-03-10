   render_depth      MatrixP                                                                                MatrixV                                                                                MatrixW                                                                                render_depth.vs?  uniform mat4 MatrixP;
uniform mat4 MatrixV;
uniform mat4 MatrixW;

attribute vec3 POSITION;
uniform vec3 PLAYER;

varying vec4 PS_DEPTH;
//varying vec4 PLAYER_POSITION;

void main ()
{
    mat4 mtxPVW = MatrixP * MatrixV * MatrixW;
    gl_Position = mtxPVW * vec4( POSITION.xyz, 1.0 );
    //
    //PLAYER_POSITION = mtxPVW * vec4( PLAYER.xyz, 1.0 );

    //PS_DEPTH = gl_Position.z / gl_Position.w; // Dark to bright
    //PS_DEPTH = float(1.0 - (gl_Position.z / gl_Position.w)); // Bright to dark
    // PS_DEPTH =  float(1.0-((gl_Position.z/gl_Position.w)));
    PS_DEPTH = gl_Position;

}

//return fract(sin(dot(uv.xy ,vec2(12.9898,78.233))) * 43758.5453);
 
// #version 150
// in vec4 gxl3d_Position;
// uniform mat4 gxl3d_ModelViewProjectionMatrix;
// out vec4 Vertex_UV;
// void main()
// {
//   gl_Position = gxl3d_ModelViewProjectionMatrix * gxl3d_Position;    


//     Vertex_UV = vec4(1-(gl_Position.z/gl_Position.w));
//     }













// #version 150 
// in vec4 gxl3d_Position;
// out float DEPTH; 
// uniform mat4 gxl3d_ModelViewProjectionMatrix;
// // cone size
// void main()
// {
//   gl_Position =  gxl3d_Position;    
 
// DEPTH =  float(1-((gl_Position.z/gl_Position.w)))/1.0;
// }
  

//     in float DEPTH;     

// void main()
// {

//  float amt = min(DEPTH,0.6);
//    gl_FragColor = vec4 (amt ,amt ,amt , 1.0f);
// }

        render_depth.ps  #if defined( GL_ES )
precision mediump float;
#endif

varying vec4 PS_DEPTH;

vec4 EncodeFloatRGBA( float v ) 
{
    vec4 enc = vec4(1.0, 255.0, 65025.0, 160581375.0) * v;
    enc = vec4(fract(enc));
    enc -= enc.yzww * vec4(1.0/255.0,1.0/255.0,1.0/255.0,0.0);
    return enc;
}

void main (void)
{
    float floatValue = float(1.0-((PS_DEPTH.z/PS_DEPTH.w)));
    vec4 stored_val = vec4(EncodeFloatRGBA(floatValue));
    gl_FragColor = stored_val;
} 

    // float amtr = PS_DEPTH;
    // float amtg = PS_DEPTH;//clamp(PS_DEPTH, 0.1, 0.5);
    // float amtb = PS_DEPTH;//clamp(PS_DEPTH, 0.3, 0.6);
    // // if (gl_FragCoord.y>500.0||gl_FragCoord.y<100.0)
    // {
    //     discard;
    // }
    // else
    // gl_FragColor = vec4 (amtr ,amtg ,amtb , 1.0);//vec4 (1.0 ,0.0 ,0.0 , 1.0);//


 

    // vec4 stored_val;   
    // const float toFixed = 255.0/256;
    // stored_val.r = frac(floatValue*toFixed*1);
    // stored_val.g = frac(floatValue*toFixed*255);
    // stored_val.b = frac(floatValue*toFixed*255*255);
    // stored_val.a = frac(floatValue*toFixed*255*255*255);

 
// #version 150/

// in vec4 Vertex_UV;
// out vec4 Out_Color;
// void main (void)
// {
//     Out_Color =  vec4 (Vertex_UV.xyz, 1.0f);
// }


//                       