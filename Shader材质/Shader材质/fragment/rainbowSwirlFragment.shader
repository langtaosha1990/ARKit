
vec2 coord = fract(_surface.diffuseTexcoord);

vec3 color = vec3(0.0);

float angle = atan((-coord.y + 0.25)/(coord.x - 0.5)) * 0.1;
float len = length(coord - vec2(0.5, 0.25));

color.r += sin(len * 40.0 + angle * 40.0 + u_time);
color.g += cos(len * 30.0 + angle * 60.0 - u_time);
color.b += sin(len * 50.0 + angle * 40.0 + u_time);

_output.color.rgb = color;
