shader_type spatial;
/*
	Cloud Shadow Shader by Yui Kinomoto @arlez80
	MIT License
*/
render_mode cull_back, depth_draw_alpha_prepass, shadow_to_opacity;

const float noise_scale = 0.005;

uniform float bias = -0.4;
uniform float scale = 0.0001;
uniform float seed = -1000.0;
uniform vec2 speed = vec2( 20.0, 20.0 );
uniform vec2 transform_speed = vec2( 0.0, 0.01 );

varying vec3 VERTEX_WORLD;

highp float random( vec2 pos )
{
	highp float a = 12.9898;
	highp float b = 78.233;
	highp float c = 43758.5453;
	highp float dt = dot( pos, vec2( a, b ) );
	highp float sn = mod( dt, 3.14 );
	return fract( sin(sn) * c );
	//return fract(sin(dot(pos, vec2(12.9898,78.233))) * 43758.5453);
}

float value_noise( vec2 pos )
{
	vec2 p = floor( pos );
	vec2 f = fract( pos );

	float v00 = random( p + vec2( 0.0, 0.0 ) );
	float v10 = random( p + vec2( 1.0, 0.0 ) );
	float v01 = random( p + vec2( 0.0, 1.0 ) );
	float v11 = random( p + vec2( 1.0, 1.0 ) );

	vec2 u = smoothstep( 0.0, 1.0, f );//f * f * ( 3.0 - 2.0 * f );

	return mix( mix( v00, v10, u.x ), mix( v01, v11, u.x ), u.y );
}

vec2 rotate(vec2 v, vec2 o, float a) 
{
	float s=sin(a);
	float c=cos(a);
	mat2 m=mat2(vec2(c,-s),vec2(s,c));
	return o+(v-o)*m;
}

float leaves(vec2 fragCoord, float s, float r)
{
    vec2 map=fragCoord/iResolution.xy;
    float t=cos(iTime*.5+r);
    vec2 f=vec2(1,iResolution.y/iResolution.x)*(1.+r);
    vec2 m = rotate(map*f,vec2(2.-r*2.)*f,cos (t)*cos(t*.5));
    float sh=smoothstep(.31+.1*(1.-r),r*.3,texture (iChannel0, m).x);
    return min(s,sh);
}



void vertex( )
{
	VERTEX_WORLD = ( WORLD_MATRIX * vec4( VERTEX, 1.0 ) ).xyz;
}

void fragment( )
{
	vec3 p = VERTEX_WORLD * scale;

	// 雲の色を計算
	vec2 pos_a = ( vec2( p.x, p.z + seed ) + ( TIME * speed ) ) * noise_scale;
	vec2 pos_b = pos_a + transform_speed * TIME*100.0;

	float h = (
		value_noise( pos_a )			* 8.0
	+	value_noise( pos_a * 4.2 )		* 8.0
	+	value_noise( pos_a * 8.4 )		* 8.0
	+	value_noise( pos_a * 17.6 )		* 8.0
	+	value_noise( pos_a * 61.8 )		* 4.0
	+	value_noise( pos_b * 90.1 )		* 4.0
	+	value_noise( pos_b * 110.1 )	* 2.0
	+	value_noise( pos_b * 220.0 )	* 2.0
	) / 35.0;

	ALPHA = max( h - bias, 0.0 );
	//ALPHA = 1.0-ALPHA;
}
