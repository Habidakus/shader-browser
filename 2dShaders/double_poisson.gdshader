shader_type canvas_item;

uniform sampler2D noise_x;
uniform sampler2D noise_y;
uniform float zoom_a = 5.0;
uniform float zoom_b = 31.0;
uniform vec4 color_a : source_color = vec4(0.101961,0.619608,0.666667, 1);
uniform vec4 color_b : source_color = vec4(0.666667,0.666667,0.498039, 1);
uniform bool perform_diff = false;
uniform float a_dominance = 0.5;

vec2 get_point_in_cell(int x, int y, float zoom)
{
	float fx = float(x);
	float fy = float(y);
	float cx = (fx + 1.0) / (zoom + 2.0);
	float cy = (fy + 1.0) / (zoom + 2.0);
	float nx = texture(noise_x, vec2(cx, cy)).r;
	float ny = texture(noise_y, vec2(cx, cy)).r;
	float rx = (fx + nx);
	float ry = (fy + ny);
	return vec2(rx, ry);
}

float get_distance(vec2 uv, float zoom)
{
	vec2 map_coord = uv * zoom;
	int floor_x = int(floor(map_coord.x));
	int floor_y = int(floor(map_coord.y));
	float max_dist = zoom * zoom;
	for (int sx = floor_x - 1; sx <= floor_x + 1; ++sx)
	{
		for (int sy = floor_y - 1; sy <= floor_y + 1; ++sy)
		{
			vec2 point_in_cell = get_point_in_cell(sx, sy, zoom);
			vec2 diff = map_coord - point_in_cell;
			// dot is the same as diff.x * diff.x + diff.y * diff.y
			float dist = dot(diff, diff);
			if (max_dist > dist)
			{
				max_dist = dist;
			}
		}
	}
	
	return sqrt(max_dist) / 1.5;
}

void fragment() {
	float fraction_1 = get_distance(UV, zoom_a);
	float fraction_2 = get_distance(UV, zoom_b);
	//float v = (fraction_1 > fraction_2) ? fraction_1  : fraction_2 ;
	float v;
	if (perform_diff)
	{
		v = 1.0 - abs(fraction_1 - fraction_2);
	}
	else
	{
		v = (fraction_1 > fraction_2) ? fraction_1 + fraction_2 * fraction_2 : fraction_2 + fraction_1 * fraction_1;
	}
	v = pow(v, a_dominance);
	COLOR = mix(color_a, color_b, clamp(v, 0.0, 1.0));
}
