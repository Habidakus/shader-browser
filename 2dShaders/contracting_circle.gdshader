shader_type canvas_item;

uniform float speed = 0.33;
uniform vec4 color : source_color = vec4(1,1,1,1);

void fragment() {
    vec2 vec_from_center = UV - vec2(0.5, 0.5);
    float closeness_to_center = (0.5 - length(vec_from_center));
    float closeness_measure = closeness_to_center + abs(closeness_to_center);
	float fraction = fract(TIME * speed);
    float far_from_fraction = 0.1 - abs(fraction - closeness_measure);
    float abs_fff = 10.0 * (far_from_fraction + abs(far_from_fraction)) * sqrt(closeness_to_center);
    float alpha = abs_fff * abs_fff;
    COLOR.rgba = mix(texture(TEXTURE, UV), color, max(0.0, min(1.0, alpha)));
}
