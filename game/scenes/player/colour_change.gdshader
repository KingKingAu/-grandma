shader_type canvas_item;

uniform bool apply = false;
uniform vec4 target_colour : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 replace_colour : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float tolerance = 0.05;

void fragment() {
	vec4 tex_colour = texture(TEXTURE, UV);
	if (apply && distance(tex_colour.rgb, target_colour.rgb) <= tolerance) {
		COLOR = vec4(replace_colour.rgb, tex_colour.a);
	} else {
		COLOR = tex_colour;
	}
}
