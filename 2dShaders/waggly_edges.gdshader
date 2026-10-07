shader_type canvas_item;

uniform sampler2D noise;
uniform float speed = 5;
uniform float mult = 5;

void vertex() {
	vec2 dxy = texture(noise, vec2(sin(TIME * speed), cos(TIME * speed)) * 0.3 + UV / 8.0 + vec2(0.5, 0.5)).rg;
	VERTEX.y += mult * sin(dxy.r * 4.0 * PI);
	VERTEX.x += mult * cos(dxy.g * 4.0 * PI);
}
