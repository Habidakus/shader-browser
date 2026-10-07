shader_type canvas_item;

uniform sampler2D noiseTexture;
uniform float speed: hint_range (0.0,5.0);
uniform float threshold: hint_range (-1.0,1.0);

void fragment(){
	COLOR = texture(TEXTURE, UV);
	float diff = abs(COLOR.g - COLOR.r) + abs(COLOR.g - COLOR.b) + abs(COLOR.r - COLOR.b);
	if (threshold > 0.0)
	{
		if (diff > 2.0 * threshold) discard;
	}
	else
	{
		if (diff < (-2.0 * threshold)) discard;
	}

	float offset = sin(speed * TIME / 6.0) / (2.0 * TAU);
	vec2 noise_uv = (UV / 4.0) + vec2(0.5 + offset, 0.5 - offset);
	float noise_sample = texture(noiseTexture, noise_uv).r;
	COLOR.a = COLOR.a * noise_sample * noise_sample * noise_sample;
}
