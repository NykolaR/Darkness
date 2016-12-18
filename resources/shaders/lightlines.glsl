/*
 * lightlines.glsl
 * Handles lightlines shading
*/

extern vec3 second;

vec4 effect (vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    float valX = 0.5 - (screen_coords.x / love_ScreenSize.x);
    if (valX < 0)
        valX *= -1;

    float valY = 0.5 - ((screen_coords.y - 130) / love_ScreenSize.y);
    if (valY < 0)
        valY *= -1;

    return vec4 ( ((valX + valY) * second.r) + ((1 - valX - valY) * color.r), ((valX + valY) * second.g) + ((1 - valX - valY) * color.g), ((valX + valY) * second.b) + ((1 - valX - valY) * color.b), color.a);
}
