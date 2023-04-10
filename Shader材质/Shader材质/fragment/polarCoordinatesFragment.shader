

vec2 coord = _surface.diffuseTexcoord;
vec4 color = vec4(0.0);
vec2 pos = vec2(0.5) - coord;

float r = length(pos) * 2.0;
float a = atan(pos.y / pos.x);

float f = cos(a * 6.0);

color = vec4(1.0 - smoothstep(f, f + 0.01, r));

gl_FragColor = color;


