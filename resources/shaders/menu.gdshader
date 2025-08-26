shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D tex_frg_2;



void fragment() {
// Input:5
	vec2 n_out5p0 = UV;


// VectorOp:7
	vec2 n_in7p1 = vec2(0.00000, 0.00000);
	vec2 n_out7p0 = n_out5p0 + n_in7p1;


// Texture2D:2
	vec4 n_out2p0 = texture(tex_frg_2, n_out7p0);


// Output:0
	COLOR = texture(tex_frg_2, vec2(UV.x + 0.15, UV.y));


}
