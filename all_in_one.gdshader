shader_type canvas_item;

// Outline color.
uniform vec4 color: source_color = vec4(1.0);
// Outline thickness.
uniform float thickness: hint_range(0.0, 100.0) = 1.0;
// Used to compensate for alpha values.
uniform float tolerance: hint_range(0.0, 0.999) = 0.0;
// If on will draw at diagonals. Off is mainly for pixel art but you do you.
uniform bool diagonals = true;
// If diagonals are checked will check for half pixels so it rounds the outline a bit more.
uniform bool rounded = true;

// Compensate UV for outline.
void vertex() {
	VERTEX = vec2(VERTEX.x * (1.0 + TEXTURE_PIXEL_SIZE.x * thickness * 2.0), VERTEX.y * (1.0 + TEXTURE_PIXEL_SIZE.y * thickness * 2.0));
}

// Checks a fragment for the edge of an uv.
bool border(vec2 uv) {
	vec2 uvBorder = abs(uv - vec2(0.5));
	return max(step(0.5, uvBorder.x), step(0.5, uvBorder.y)) > 0.0;
}

// Gets alpha of given fragment if not near the edge.
float get_alpha(sampler2D tex, vec2 uv){
	float res = 0.0;
	if (!border(uv)) {
		res = texture(tex, uv).a;
	}
	return res;
}

// Checks for neighboring pixels.
float in_range(vec2 size, sampler2D tex, vec2 uv) {
	float res = 0.0;
	for (float i = -1.0; i < 2.0; i += 2.0) {
		res += get_alpha(tex, uv + vec2(i * size.x, 0.0));
		res += get_alpha(tex, uv + vec2(0.0, i * size.y));
		if (diagonals) {
			for (float j = -1.0; j < 2.0; j += 2.0) {
				res += get_alpha(tex, uv + vec2(i * size.x, j * size.y));
				if (rounded) {
					res += get_alpha(tex, uv + vec2(i * size.x, j * size.y * 0.5));
				}
			}
		}
	}
	return res;
}
uniform float amount = 0.0;

uniform sampler2D vertical_gradient; // Used to set alpha values
uniform sampler2D color_gradient; // Sets the effect color
uniform float size_effect: hint_range(1.0, 10.0, 1.0) = 1.0; // Size of the effect in pixel units
uniform float speed = 1; // Effect speed
uniform float highlight_strength: hint_range(-4.0, 4.0, 0.05) = 0.5; // Strength of the highlight
uniform bool color_mode_toggle = false; // Toggle for color gradient application
uniform bool is_horizontal = false; // Switches effect direction
uniform float pause_duration = 0.5; // Pause duration between cycles
uniform vec2 texture_size = vec2(16, 16); // Texture size in pixels (e.g., vec2(16.0, 16.0) for a 16x16 texture)
uniform bool highlight=true;
void fragment() {
	// Correct image size to for outline in frame.
		vec2 uv = UV;
		uv -= vec2(0.5);
		float edge = TEXTURE_PIXEL_SIZE.x * thickness * 2.0;
		uv = uv + uv * edge;
		uv += vec2(0.5);
		vec4 finalColor;
		// Apply outline.
		vec4 newColor = COLOR;
		if (newColor.a == 0.0 || border(uv)) {
			float outline = in_range(TEXTURE_PIXEL_SIZE * thickness, TEXTURE, uv);
			 finalColor = step(1.0 - tolerance, outline) * color;
			newColor = finalColor;
		}
		COLOR = newColor;
		
	
		if (amount != 0.0) {
		float newAmount = amount/3.338;
		vec2 pixelSize = vec2(newAmount);
		
		vec2 correction = TEXTURE_PIXEL_SIZE * vec2(float(pixelSize.x), float(pixelSize.y)) / vec2(2.0);
		vec2 uv = UV;
		uv -= vec2(0.5);
		float edge = TEXTURE_PIXEL_SIZE.x*5.0 * thickness * 2.0;
		uv = uv + uv * edge;
		uv += vec2(0.5);
		vec2 texture_uv = floor(uv / TEXTURE_PIXEL_SIZE);
		vec2 offset = vec2(mod(texture_uv.x, pixelSize.x), mod(texture_uv.y, pixelSize.y));
		vec2 target = (texture_uv - offset) * TEXTURE_PIXEL_SIZE;
		
		COLOR = textureLod(TEXTURE, target + correction, 0.0);
	}
	
	 // Set up base parameters
    vec4 old_color = COLOR;
    float time = TIME * abs(speed); // Absolute time for both positive and negative speeds
    float effect_cycle_duration = 1.0 + pause_duration; // Total time for one cycle and pause
    float mod_time = mod(time, effect_cycle_duration); // Current time within the cycle

    // Handle the pause
    float progress = mod_time / 1.0; // Normalize mod_time for active duration only

    if (mod_time > 1.0) {
        progress = 1.0; // Hold the highlight at the last position during the pause
    }

    // Reverse the direction if speed is negative
    if (speed < 0.0) {
        progress = 1.0 - progress; // Reverse progress when speed is negative
    }
	if (highlight){
    // Convert the size_effect from pixels to UV space based on the texture size
    float pixel_to_uv = size_effect / ((is_horizontal) ? texture_size.x : texture_size.y);

    // Calculate the current position of the highlight in UV space
    float current_position = mix(0.0, 1.0, progress);

    // Set the lower and upper bounds for the highlight effect
    float effect_lower_bound = current_position - (pixel_to_uv / 2.0);
    float effect_upper_bound = current_position + (pixel_to_uv / 2.0);

    // Snap the UV coordinates to the pixel grid
    vec2 pixel_size_uv = vec2(1.0) / texture_size;
    vec2 snapped_uv = floor(UV / pixel_size_uv) * pixel_size_uv;

    // Get the position of the pixel in the effect (either horizontal or vertical)
    float position_value = (is_horizontal) ? snapped_uv.x : snapped_uv.y;

    // Use step to create crisp boundaries for the effect
    float effect_distance = step(effect_lower_bound, position_value) - step(effect_upper_bound, position_value);

    // Get the position of the pixel within the inner gradient
    float inner_effect_position = step(effect_lower_bound, position_value) * step(position_value, effect_upper_bound);
    vec2 color_position = (color_mode_toggle) ? vec2(UV.x, inner_effect_position) : vec2(progress);

    // Sample the new color from the color gradient
    vec4 new_color = texture(color_gradient, color_position);

    // Sample the vertical gradient and mix it with the new color
    new_color = mix(old_color, new_color, texture(vertical_gradient, vec2(progress)));

    // Apply the highlight effect using the calculated effect_distance
    COLOR.rgb = mix(old_color.rgb, new_color.rgb, vec3(effect_distance * highlight_strength));}
	
}