shader_type canvas_item;
/*
so this shader is for controlling multiple effects on sprites
basically you only have to make the shader the material of the selected node
and then you can use either a script or an animationcontroller to change the 
desired effect on the node

STYLES:
[0] - Default
[1] - White blink
*/
uniform int shading_option = 0;
uniform float opacity_strength = 1.0;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if (shading_option == 0) { //this option [0] can be used to reset the material to not have any effect on the node
		color = texture(TEXTURE, UV);
	}
	else if (shading_option == 1) {
		color.rgb = vec3(1,1,1);
	}
	else if (shading_option == 2) {
		color.r = min(COLOR.r * opacity_strength, 1.0);
		color.g = min(COLOR.g * opacity_strength, 1.0);
	}
	COLOR = color;
}
