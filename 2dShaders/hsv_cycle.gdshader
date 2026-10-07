shader_type canvas_item;

uniform float h: hint_range(0,1) = 1;
uniform float s: hint_range(0,1) = 1;
uniform float v: hint_range(0,1) = 1;

vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
	vec3 hsv = rgb2hsv(COLOR.rgb);
	hsv.x = hsv.x + sin(TIME) * h;
	hsv.y = hsv.y + sin(TIME/2.0) * s;
	hsv.z = hsv.z + sin(TIME/3.0) * v;
	if (hsv.x > 1.)
	{
		hsv.x -= 1.;
	}
	else if (hsv.x < 0.)
	{
		hsv.x += 1.;
	}
	if (hsv.y > 1.)
	{
		hsv.y -= 1.;
	}
	else if (hsv.y < 0.)
	{
		hsv.y += 1.;
	}
	if (hsv.z > 1.)
	{
		hsv.z -= 1.;
	}
	else if (hsv.z < 0.)
	{
		hsv.z += 1.;
	}
	COLOR.rgb = hsv2rgb(hsv);
}
