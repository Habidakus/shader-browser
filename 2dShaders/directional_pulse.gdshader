shader_type canvas_item;

uniform vec2 direction = vec2(1.0, 0.0);
uniform float speed = 0.5;
uniform vec4 color : source_color = vec4(1,1,1,1);

void fragment() {
	float fraction = fract(speed * TIME);
    vec2 vec_from_center = UV - vec2(0.5, 0.5) - (fraction - 0.5) * direction;
    float closeness_to_center = (0.5 - length(vec_from_center));
    float closeness_measure = closeness_to_center + abs(closeness_to_center);
    vec2 norm_from_center = normalize(vec_from_center);
    vec2 perp_vec_from_center = vec2(vec_from_center.y, 0.0 - vec_from_center.x);
    vec2 norm_perp = normalize(perp_vec_from_center);
    vec2 norm_dir = normalize(direction);
    float is_space_in_middle = abs(dot(norm_perp, norm_dir));
    float is_time_in_middle = 10.0 * ((fraction - 0.4) + abs(fraction - 0.4)) / 2.0;
    float alpha = is_space_in_middle * is_space_in_middle *is_space_in_middle * is_time_in_middle * closeness_measure; 
	float fade = 1.0 - fraction;
	alpha *= fade * fade;
	vec4 texture_color = texture(TEXTURE, UV);
	vec4 final_color = vec4(color.r, color.g, color.b, texture_color.a);
    COLOR.rgba = mix(texture_color, final_color, max(0.0, min(1.0, alpha)));
}
