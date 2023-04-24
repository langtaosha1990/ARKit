
uniform float audioValue;

#pragma transparent | opaque

#pragma body
         
vec2 coord = fract(_surface.diffuseTexcoord);

vec2 st = coord - 0.5;
float len = length(st);
float a = 0.0;
if(len < audioValue + 0.1) {
    a = 1.0;
}

_output.color.rgba = vec4(vec3(1.0), a);

