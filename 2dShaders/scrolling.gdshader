shader_type canvas_item;


uniform float horz_speed = 1;
uniform float vert_speed = 1;


void fragment() {
	vec2 newuv = UV;
	float deltaX = fract(TIME * horz_speed);
	float deltaY = fract(TIME * vert_speed);
	newuv.x = fract(1.0 + newuv.x - deltaX);
	newuv.y = fract(1.0 + newuv.y - deltaY);
	vec4 c = texture(TEXTURE, newuv);
	COLOR = c;
}
