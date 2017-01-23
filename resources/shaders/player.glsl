/*
 * player.glsl
 * Handles player shading
*/

extern vec3 second;

vec4 effect (vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec4 current = Texel (texture, texture_coords);
    vec3 set = vec3 (current.r, current.g, current.b);

    //if (set.r > 0.9 && set.g < 0.1 && set.b < 0.1) {
    if (set.r == 1.0) {
        set.r = color.r;
        set.g = color.g;
        set.b = color.b;
    }

    //if (set.g > 0.9 && set.r < 0.1 && set.b < 0.1) {
    if (set.g == 1.0) {
        set.r = second.r;
        set.g = second.g;
        set.b = second.b;
    }

    return vec4 ( set.r, set.g, set.b, current.a );
    //return vec4 (second.r, 0.0, 1.0, 1.0);
}
