shader_type spatial;

uniform sampler2D noise_texture;
uniform sampler3D noise_volume;
uniform float edge_steepness = 0.5;
uniform float noise_strength = 0.5;
uniform float noise_scale = 1.0;

varying vec3 v_view_normal;

// The polygon's signed distance field (SDF).
// A helper function to create a normal based on distance.
vec3 get_sdf_normal(vec2 uv, sampler2D input_texture) {
    // This is the core of the edge steepness.
    // It samples multiple points to calculate the gradient.
    float d = texture(input_texture, uv).r;
    float dx = texture(input_texture, uv + vec2(0.005, 0.0)).r - d;
    float dy = texture(input_texture, uv + vec2(0.0, 0.005)).r - d;
    
    // The Z component is always 1 for a 2D normal.
    return normalize(vec3(dx, dy, edge_steepness));
}

float noise3d(vec3 pos) {
	return texture(noise_volume, pos * noise_scale).r;
    //vec2 uv_x = pos.zy * noise_scale;
    //vec2 uv_y = pos.xz * noise_scale;
    //vec2 uv_z = pos.xy * noise_scale;
    //
    //float h_x = texture(noise_volume, uv_x).r;
    //float h_y = texture(noise_volume, uv_y).r;
    //float h_z = texture(noise_volume, uv_z).r;
    //
    //// Blend the three samples together based on the surface direction
    //return h_x * blend.x + h_y * blend.y + h_z * blend.z;
}

// A helper function to get a normal from a noise texture.
vec3 get_noise_normal(vec2 uv) {
    // We sample the noise texture to get the height information.
    vec2 scaled_uv = uv * noise_scale;
    float d = texture(noise_texture, scaled_uv).r;
    float dx = texture(noise_texture, scaled_uv + vec2(0.005, 0.0)).r - d;
    float dy = texture(noise_texture, scaled_uv + vec2(0.0, 0.005)).r - d;

    return normalize(vec3(dx, dy, 1.0));
}

float get_noise_height_triplanar(vec3 pos, vec3 blend) {
    vec2 uv_x = pos.zy * noise_scale;
    vec2 uv_y = pos.xz * noise_scale;
    vec2 uv_z = pos.xy * noise_scale;
    
    float h_x = texture(noise_texture, uv_x).r;
    float h_y = texture(noise_texture, uv_y).r;
    float h_z = texture(noise_texture, uv_z).r;
    
    // Blend the three samples together based on the surface direction
    return h_x * blend.x + h_y * blend.y + h_z * blend.z;
}

vec3 get_noise_normal_3d_via_base(vec3 pos, vec3 base_normal) {
    float eps = 0.005;
    
    // Calculate blending weights based on the original geometric normal
    vec3 blend = abs(base_normal);
    blend /= (blend.x + blend.y + blend.z); // Normalize weights
    
    // Sample the center height
    float h = get_noise_height_triplanar(pos, blend);
    
    // Sample offsets on all three 3D axes
    float dx = get_noise_height_triplanar(pos + vec3(eps, 0.0, 0.0), blend) - h;
    float dy = get_noise_height_triplanar(pos + vec3(0.0, eps, 0.0), blend) - h;
    float dz = get_noise_height_triplanar(pos + vec3(0.0, 0.0, eps), blend) - h;
    
    // Reconstruct the surface normal gradient
    return normalize(vec3(dx, dy, dz));
}

vec3 get_noise_normal_3d(vec3 pos)
{
    float eps = 0.005;
    float d = noise3d(pos);
    float dx = noise3d(pos + vec3(eps, 0.0, 0.0)) - d;
    float dy = noise3d(pos + vec3(0.0, eps, 0.0)) - d;
    float dz = noise3d(pos + vec3(0.0, 0.0, eps)) - d;
    return normalize(vec3(dx, dy, dz));
}

void vertex() {
    
    // Get the base normal from the polygon's distance field.
    //vec3 sdf_normal = get_sdf_normal(UV, TEXTURE);
    
    // Sample the noise texture to get the bumpy detail normal.
	//vec3 local_normal = INV_VIEW_MATRIX == mat4(0.0) ? NORMAL : mat3(INV_VIEW_MATRIX) * NORMAL;
    vec3 bumpy_normal = get_noise_normal_3d(VERTEX); //, normalize(local_normal));
    
    // Mix the two normals. We use the distance from the polygon's edge to determine the mix.
    //float dist = texture(TEXTURE, UV).r;
    //float mix_factor = clamp(dist * 10.0, 0.0, 1.0);
    
    // Mix the normals based on the mix_factor.
    // This makes the edges use the smooth sdf_normal and the interior use the bumpy_normal.
    //vec3 final_normal = mix(sdf_normal, bumpy_normal, mix_factor * noise_strength);
    
    //NORMAL = final_normal;
	// NORMAL = bumpy_normal;
	v_view_normal = normalize(mat3(MODELVIEW_MATRIX) * bumpy_normal);
    //COLOR = texture(TEXTURE, UV);
}

void fragment() {
	NORMAL = v_view_normal;
	//COLOR = vec4(1, 1, 0, 1);
}