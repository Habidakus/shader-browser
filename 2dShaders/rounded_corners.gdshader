shader_type canvas_item;


uniform float pixels = 10;
uniform vec2 texture_size = vec2(71, 53);


void fragment() {
	vec2 dxy = UV;

	dxy.x = dxy.x > 0.5 ? (1.0 - dxy.x) : dxy.x;
	dxy.y = dxy.y > 0.5 ? (1.0 - dxy.y) : dxy.y;
	dxy *= texture_size;
	
	if (dxy.x <= pixels && dxy.y <= pixels)
	{
		dxy -= vec2(pixels, pixels);
		dxy /= pixels;
		float d = dxy.x * dxy.x + dxy.y * dxy.y;
		d *= pixels;
		if (d > pixels + 1.0)
		{
			COLOR.a = 0.0;
		}
		else if (d > pixels)
		{
			COLOR.a = smoothstep(1.0, 0.0, d - pixels);
		}
	}
}
