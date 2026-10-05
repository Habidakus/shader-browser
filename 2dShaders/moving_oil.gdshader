shader_type canvas_item;

uniform float zoom = 1;
uniform float timeScale = 1;
uniform sampler3D noiseImage;
uniform vec3 primary_tint : source_color = vec3(0.666667,1,1);
uniform vec3 secondary_tint : source_color = vec3(0,0,0.164706);
uniform vec3 color_a : source_color = vec3(0.101961,0.619608,0.666667);
uniform vec3 color_b : source_color = vec3(0.666667,0.666667,0.498039);

float fbm (in vec2 _st) {
	vec2 dummy;
	vec2 m = modf(_st, dummy);
	float tul = texture(noiseImage, vec3(m, 0)).r;
	return tul;
}

void fragment() {
    vec2 st = UV.xy/zoom;

    vec2 q = vec2(fbm(st), fbm(st + vec2(0,1)));

	float dt = 0.15 * timeScale * TIME;
	
    vec2 r = vec2(0.);
    r.x = fbm( st + q + vec2(1.7,9.2) + dt);
    r.y = fbm( st + q + vec2(8.3,2.8) + dt);

    float f = fbm(st+r);

    vec3 color = mix(color_a, color_b, clamp((f*f)*4.0,0.0,1.0));
    color = mix(color, secondary_tint, clamp(length(q),0.0,1.0));
    color = mix(color, primary_tint, clamp(length(r.x),0.0,1.0));
    COLOR = vec4((f*f*f+.6*f*f+.5*f)*color,1.);
}
