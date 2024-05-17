shader_type canvas_item;

uniform float blur : hint_range(0.0, 5.0) = 1.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR.xyz = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur).xyz;
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
