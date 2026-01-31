shader_type spatial;
render_mode blend_mix, depth_draw_opaque;

uniform vec3 target_bottom;
uniform vec3 target_top;
uniform float radius = 1.0;
uniform float softness = 0.25;
uniform bool fade_enabled = false;

varying vec3 world_pos;

void vertex() {
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

float dist_to_segment(vec3 p, vec3 a, vec3 b) {
    vec3 ab = b - a;
    float t = dot(p - a, ab) / dot(ab, ab);
    t = clamp(t, 0.0, 1.0);
    vec3 closest = a + ab * t;
    return distance(p, closest);
}

void fragment() {
	if (fade_enabled) {
		vec3 camera_dir = CAMERA_DIRECTION_WORLD;
		vec3 camera_pos = CAMERA_POSITION_WORLD;
		float d1 = dist_to_segment(world_pos, camera_pos, target_top);
		float d2 = dist_to_segment(world_pos, camera_pos, target_bottom);
		
		float dist = dot(d1, d2);
		
		float mask = smoothstep(radius, radius - softness, 1.0 - dist);
		ALPHA = mask;
	}
}
