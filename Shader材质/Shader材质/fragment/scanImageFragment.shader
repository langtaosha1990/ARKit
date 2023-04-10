
#pragma transparent
#pragma arguments
texture2d<float, access::sample> texture;
#pragma body

float size = 6.0;
float speed = -3.0;

constexpr sampler smp(filter::linear, address::repeat);
float4 color = texture.sample(smp, _surface.diffuseTexcoord);
color.a = sin(floor(_surface.diffuseTexcoord.x * size) - scn_frame.time * speed);
_output.color.rgba = color;

