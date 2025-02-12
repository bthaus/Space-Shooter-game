shader_type canvas_item;
// adapted from: https://godotshaders.com/shader/spatial-pixelation/
uniform float pixelation : hint_range(0.001, 0.1) = 0.01;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float opacity : hint_range(0.0, 1.0) = 1.0;



void fragment() {
    // Calculate pixel dimensions with screen aspect correction
    float aspect = 2.0;
    vec2 pixel_size = vec2(pixelation / aspect, pixelation);

    // Calculate grid aligned UV coordinates
    vec2 coord = SCREEN_UV;

    // Round to nearest pixel boundary to prevent edge shimmer
    coord = (floor(coord / pixel_size) + 0.5) * pixel_size;

    // Add small edge tolerance
    float edge_tolerance = 0.001;
    coord = clamp(coord, pixel_size * 0.5 + edge_tolerance, 1.0 - pixel_size * 0.5 - edge_tolerance);

    // Sample with explicit LOD to prevent mipmap shimmer
    vec4 color = textureLod(SCREEN_TEXTURE, coord, 0.0);

    // Apply anti-alias at edges
    vec2 uv_delta = fwidth(SCREEN_UV);
    vec2 edge_dist = smoothstep(vec2(0.0), uv_delta * 2.0, SCREEN_UV) *
                     smoothstep(vec2(0.0), uv_delta * 2.0, vec2(1.0) - SCREEN_UV);
    float edge_factor = edge_dist.x * edge_dist.y;

    COLOR=color;
}