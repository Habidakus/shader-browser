shader_type canvas_item;

uniform float ul_speed = 0.33;
uniform float ur_speed = 0.5;
uniform vec4 color : source_color = vec4(1.,1.,1.,1.);
uniform float line_thickness : hint_range(0.03, 10.0, 0.01);

void fragment() {
	vec2 pixel_loc = 132.0 * SCREEN_UV;
	float dist_ul = (pixel_loc.x + pixel_loc.y + TIME * ul_speed) / 4.0;
	float dist_ur = (pixel_loc.x - pixel_loc.y + TIME * ur_speed) / 4.0;
	float mult = 1. + line_thickness;
	float b = floor(abs(dist_ul - floor(dist_ul)) * mult);
	float c = floor(abs(dist_ur - floor(dist_ur)) * mult);
	float a = max(b, c);
	COLOR = mix(texture(TEXTURE, UV), vec4(color.r, color.g, color.b, 1.0), a);
}
