

vec2 coord = 6.0 * _surface.diffuseTexcoord;

for(int n = 1; n < 10; n++) {
float i = float(n);
coord += vec2(0.7 / i * sin(i * coord.y + u_time + 0.3 * i) + 0.8, 0.4 / i * sin(coord.x + u_time + 0.3 * i) + 1.6);
}
// coord *= vec2(0.7 / sin(coord.y + u_time + 0.3) + 0.8, 0.4 / sin(coord.x + u_time + 0.3) + 1.6);

vec3 color = vec3(0.5 * sin(coord.x) + 0.5, 0.5 * sin(coord.y) + 0.5, sin(coord.x + coord.y));
gl_FragColor = vec4(color, 1.0);

