shader_type spatial;
/*
	Cloud Shadow Shader by Yui Kinomoto @arlez80
	MIT License
*/
render_mode cull_back, depth_draw_alpha_prepass, shadow_to_opacity;
//render_mode unshaded;

uniform float noise_scale = 2.0;
uniform float speed = 20.0;
uniform sampler2D noise;
uniform float freqA = 1.0;
uniform float ampA = 1.0;
uniform float scaleA = 1.0;
uniform float freqB = 1.0;
uniform float ampB = 1.0; 
uniform float scaleB = 1.0;
uniform float freqC = 1.0;
uniform float ampC = 1.0; 
uniform float scaleC = 1.0;

varying vec3 VERTEX_WORLD;
varying vec2 iResolution;
varying float iTime;

vec2 rotate(vec2 v, vec2 o, float a) 
{
	float s=sin(a);
	float c=cos(a);
	mat2 m=mat2(vec2(c,-s),vec2(s,c));
	return o+(v-o)*m;
}
vec2 distort(vec2 v,float time)
{
	float M_2PI =  6.283185307;
	float M_6PI = 18.84955592;
	float d1 = mod(v.x + v.y, M_2PI);
    float d2 = mod((v.x + v.y + 0.25) * 1.3, M_6PI);
    d1 = time * 0.07 + d1;
    d2 = time * 0.5 + d2;
    vec2 dist = vec2(
    	sin(d1) * 0.15 + sin(d2) * 0.05,
    	cos(d1) * 0.15 + cos(d2) * 0.05
    );
	return dist+v;
}

float leaves(vec2 fragCoord, float s, float r,float freq,float amp,float scale)
{
    vec2 map=fragCoord/iResolution.xy;
    float t=cos(iTime*speed*freq+r)/amp;
    vec2 f=vec2(1,iResolution.y/iResolution.x)*(1.+r);
    //vec2 m = rotate(map*f,vec2(2.-r*2.)*f,cos (t)*cos(t*.5));
	vec2 m = distort(map*f,t);
    float sh=smoothstep(.31+.1*(1.-r),r*.3,texture (noise, m*noise_scale*scale).x);
    return min(s,sh);
}

float gaussian(vec2 fragCoord,float buffer)
{
    float Pi = 6.28318530718; // Pi*2
    
    // GAUSSIAN BLUR SETTINGS {{{
    float Directions = 16.0; // BLUR DIRECTIONS (Default 16.0 - More is better but slower)
    float Quality = 2.; // BLUR QUALITY (Default 4.0 - More is better but slower)
    float Size = 15.0; // BLUR SIZE (Radius)
    // GAUSSIAN BLUR SETTINGS }}}
   
    vec2 Radius = Size/iResolution.xy;
    
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    // Pixel colour
    float s = buffer;
    
    // Blur calculations
    for( float d=0.0; d<Pi; d+=Pi/Directions)
		for(float i=1.0/Quality; i<=1.0; i+=1.0/Quality)
			s += texture( noise, uv+vec2(cos(d),sin(d))*Radius*i).x;
    
    // Output to screen
    s /= Quality * Directions - 15.0;
    return s;
}

void vertex( )
{
	VERTEX_WORLD = ( WORLD_MATRIX * vec4( VERTEX, 1.0 ) ).xzy;
	//VERTEX_WORLD = (CAMERA_MATRIX * vec4(VERTEX, 1.0)).xyz;
	iResolution = VIEWPORT_SIZE;
	iTime = TIME;
}

void fragment( )
{
	float buffer = leaves(VERTEX_WORLD.xy, 0.5, 6.3,freqA,ampA,scaleA);
	buffer = leaves(VERTEX_WORLD.xy, gaussian(VERTEX_WORLD.xy,buffer), 0.1,freqB,ampB,scaleB)+buffer;
	ALBEDO = vec3(leaves(VERTEX_WORLD.xy, gaussian(VERTEX_WORLD.xy,buffer), 0.3,freqC,ampC,scaleC)+buffer);
	
	ALPHA = ALBEDO.x;
	// ALPHA = max( h - bias, 0.0 );

}
