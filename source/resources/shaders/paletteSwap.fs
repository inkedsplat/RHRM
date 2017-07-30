uniform vec4 _colors[4];

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    int x = int(Texel(texture, texture_coords).r*3.0);
    return _colors[x]; 
}