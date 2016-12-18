extern number timeVal;
extern bool fill;

vec4 effect (vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    //if (fill || mod (screen_coords.x, 16) == 0 || mod (screen_coords.y, 16) == 0) {
    //if (texture_coords.x < 0.2 || texture_coords.x > 0.8 || screen_coords.x < 256) {
    if (fill || mod (screen_coords.x, 16) < 1 || mod (screen_coords.y, 16) < 1) {
        float valX = 0.5 - (screen_coords.x / love_ScreenSize.x);
        if (valX < 0)
            valX *= -1;
        
        float valY = 0.5 - (screen_coords.y / love_ScreenSize.y);
        if (valY < 0)
            valY *= -1;

        vec4 current = Texel (texture, texture_coords);
        return vec4 (valX * timeVal + valY, valX + valY * timeVal, (valX + valY) * timeVal, 1.0 * current.a);
    }
    return vec4 (0.0, 0.0, 0.0, 1.0);
}
