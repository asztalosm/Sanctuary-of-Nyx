shader_type canvas_item;

uniform bool inarea = false;
//this shader shit too hard fml


//void vertex() {
//}

void fragment() {
	if (inarea) {
		COLOR.r = 1.0;
		COLOR.b = 1.0;
		COLOR.g = 1.0;
		if (COLOR.a != 0.0) {
			COLOR.a = 1.0;
		}
	}
	else {
		COLOR.a = 0.0;
	}
}
//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
