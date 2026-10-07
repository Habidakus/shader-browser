shader_type canvas_item;
uniform sampler2D noise;


void fragment() {
	// Called for every pixel the material is visible on.
	if (COLOR.a > 0.5)
	{
		float v = texture(noise, UV).r;
		COLOR.rg = texture(TEXTURE, UV).rg * v * v;
	}
}
