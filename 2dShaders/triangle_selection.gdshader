shader_type canvas_item;

uniform float band_width = 0.07;
uniform vec4 band_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
	if (UV.y < (1.0 - UV.x)) {
		discard;
	}
	
	if ((UV.y - band_width) < (1.0 - UV.x)) {
		COLOR = band_color;
	}
	else
	{
		float edge = 1.0 - band_width / sqrt(2.0);
		if (UV.x > edge)
		{
			COLOR = band_color;
		}
		else if (UV.y > edge)
		{
			COLOR = band_color;
		}
	}
}
