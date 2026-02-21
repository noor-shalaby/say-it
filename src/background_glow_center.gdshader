shader_type canvas_item;

uniform vec4 center_color : source_color = vec4(0.13, 0.13, 0.15, 1.0);
uniform vec4 edge_color : source_color = vec4(0.11, 0.11, 0.12, 1.0);

void fragment() {
    vec2 uv = UV - vec2(0.5);
    float dist = length(uv) * 1.5;
    float gradient = smoothstep(0.0, 1.0, dist);
    COLOR = mix(center_color, edge_color, gradient);
}