float random2d(vec2 coord)
{
return fract(sin(dot(coord.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

#pragma transparent
#pragma arguments

#pragma body

vec2 coord = (_surface.diffuseTexcoord / vec2(0.2));

coord -= u_time + vec2(sin(coord.y), cos(coord.x));
vec3 color = vec3(0.0);

float rand01 = fract(random2d(floor(coord)) + u_time / 60.0);
float rand02 = fract(random2d(floor(coord)) + u_time / 40.0);

rand01 *= 0.4 - length(fract(coord));
_output.color.rgb = vec3(rand01 * 4.0, rand02 * rand01 * 4.0, 0.0);

