shader_type canvas_item;

uniform bool is_x_threshold;
uniform float threshold_x = 0.0;
uniform bool is_y_threshold;
uniform float threshold_y = 0.0;
uniform vec4 colour1 : source_color;
uniform vec4 colour2 : source_color;

varying vec2 world;

void vertex() {
	world.x = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).x;
	world.y = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).y;
}

void fragment() {
	vec4 applied_colour;
	
	if (is_x_threshold == true) {
		if (world.x <= threshold_x) {
			applied_colour = colour1;
		}
		else {
			applied_colour = colour2;
		}
	}
	
	if (is_y_threshold == true) {
		if (world.y <= threshold_y) {
			applied_colour = colour1;
		}
		else {
			applied_colour = colour2;
		}
	}
	
	COLOR *= applied_colour;
}
