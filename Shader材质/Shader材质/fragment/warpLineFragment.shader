
vec2 coord = vec2(1.0) - _surface.diffuseTexcoord;
float color = 0.0;

color += sin(coord.x * 50.0 + cos(u_time + coord.y * 10.0 + sin(coord.x * 50.0 + u_time))) * 2.0;
color += cos(coord.x * 20.0 + sin(u_time + coord.y * 10.0 + cos(coord.x * 50.0 + u_time))) * 2.0;
color += sin(coord.x * 30.0 + cos(u_time + coord.y * 10.0 + sin(coord.x * 50.0 + u_time))) * 2.0;
color += cos(coord.x * 10.0 + sin(u_time + coord.y * 10.0 + cos(coord.x * 50.0 + u_time))) * 2.0;

_output.color.rgb = vec3(color + coord.y, color + coord.x, color);



