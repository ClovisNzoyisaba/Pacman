shader_type canvas_item;

uniform float progress: hint_range(0.0, 1.0, 0.001);
uniform float gridSize: hint_range(1.0, 20.0, 1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	float gridX = ceil(UV.x * gridSize);
	float gridY = ceil(UV.y * gridSize);

	float gridProgress = (progress / (gridX + gridY)) * gridSize * 2.;

	float shade = step(max(fract(UV.x), fract(UV.y)), gridProgress);

	vec4 gradiant = mix(vec4(1.0,1.0,0.0,1.0), vec4(0.0,0.0,0.0,1.0), gridProgress);

	vec4 finalColor = mix(vec4(0,0,0,0), gradiant, shade);

	COLOR = vec4(finalColor);
}
