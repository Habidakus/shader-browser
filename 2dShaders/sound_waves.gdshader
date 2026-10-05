shader_type canvas_item;

uniform float sections = 5;
uniform float speed = 0.3;
uniform float gauge = 10;
uniform sampler3D noiseImage;
//uniform vec4 darkColor : source_color = vec4(0,0,0,1);
uniform vec4 lightColor : source_color = vec4(1,1,1,1);

void vertex() {
	// Called for every vertex the material is visible on.
}

float getStrength(float dist) {
	dist *= gauge;
	dist -= floor(dist);
	dist *= 2.0;
	dist -= 1.0;
	dist = dist * dist;
	return dist;
}

void fragment() {
	vec2 offset = UV * sections;
	vec2 iOf = vec2(floor(offset.x), floor(offset.y));
	offset = offset - iOf;

	float fx = 1.0 - offset.x;
	float fy = 1.0 - offset.y;
	float dcx = offset.x * offset.x;
	float dcy = offset.y * offset.y;
	float dfx = fx * fx;
	float dfy = fy * fy;
	float squl = dcx + dcy;
	float squr = dfx + dcy;
	float sqll = dcx + dfy;
	float sqlr = dfx + dfy;

	vec2 nuv_ul = iOf / sections;
	vec2 nuv_ur = (iOf + vec2(1, 0)) / sections;
	vec2 nuv_ll = (iOf + vec2(0, 1)) / sections;
	vec2 nuv_lr = (iOf + vec2(1, 1)) / sections;
	
	float tul = texture(noiseImage, vec3(nuv_ul, 0)).r;
	float tur = texture(noiseImage, vec3(nuv_ur, 0)).r;
	float tll = texture(noiseImage, vec3(nuv_ll, 0)).r;
	float tlr = texture(noiseImage, vec3(nuv_lr, 0)).r;
	float zul = abs(cos(TIME * speed * (2.0 + tul)));
	float zur = abs(cos(TIME * speed * (2.0 + tur)));
	float zll = abs(cos(TIME * speed * (2.0 + tll)));
	float zlr = abs(cos(TIME * speed * (2.0 + tlr)));

	float nul = texture(noiseImage, vec3(nuv_ul, zul)).r;
	float nur = texture(noiseImage, vec3(nuv_ur, zur)).r;
	float nll = texture(noiseImage, vec3(nuv_ll, zll)).r;
	float nlr = texture(noiseImage, vec3(nuv_lr, zlr)).r;

	float v_ul = getStrength(sqrt(squl) * nul);
	float v_ur = getStrength(sqrt(squr) * nur);
	float v_ll = getStrength(sqrt(sqll) * nll);
	float v_lr = getStrength(sqrt(sqlr) * nlr);
		
	float value = fx * fy * v_ul + offset.x * fy * v_ur + fx * offset.y * v_ll + offset.x * offset.y * v_lr; 
	
	vec4 darkColor = texture(TEXTURE, UV);
	COLOR = mix(darkColor, lightColor, value);
}
