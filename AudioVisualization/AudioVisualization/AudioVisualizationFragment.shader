
uniform float audioValue;

#pragma transparent | opaque

#pragma body
         
vec2 coord = fract(_surface.diffuseTexcoord);
vec3 color = vec3(0.0);
vec2 translate = vec2(-0.5);
coord += translate;

color.r += abs(0.1 + length(coord) - 0.6 * abs(sin(audioValue * 0.9 / 12.0)));
color.g += abs(0.1 + length(coord) - 0.6 * abs(sin(audioValue * 0.6 / 4.0)));
color.b += abs(0.1 + length(coord) - 0.6 * abs(sin(audioValue * 0.3 / 9.0)));

_output.color.rgba = vec4(0.1 / color, 1.0);

